import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import 'package:educonnect/services/admission_service.dart';
import 'package:educonnect/services/fee_service.dart';
import 'package:educonnect/services/commission_service.dart';
import 'package:intl/intl.dart';

// File: fee_payment_management_screen.dart - Complete Implementation
// 5-Tab Fee & Payment Management Module for Consultants

class FeePaymentManagementScreen extends StatefulWidget {
  const FeePaymentManagementScreen({super.key});

  @override
  State<FeePaymentManagementScreen> createState() =>
      _FeePaymentManagementScreenState();
}

class _FeePaymentManagementScreenState extends State<FeePaymentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<dynamic> _admissions = [];
  Map<String, List<dynamic>> _paymentsByAdmission = {};
  Map<String, dynamic> _commissionsByAdmission = {};

  // Form Controllers
  final _amountController = TextEditingController();
  final _utrController = TextEditingController();
  final _dateController = TextEditingController();
  final _remarksController = TextEditingController();

  String? _selectedAdmissionId;
  String? _selectedPaymentMode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final futures = await Future.wait([
        AdmissionService.getAdmissions(),
        FeeService.getPayments(),
        CommissionService.getTransactions(),
      ]);

      final admissions = futures[0];
      final payments = futures[1];
      final commissionTransactions = futures[2];

      // Map payments to admissions
      final Map<String, List<dynamic>> paymentsMap = {};
      for (var p in payments) {
        final adId = p['admission']?['_id'] ?? p['admission'];
        if (adId is String) {
          if (!paymentsMap.containsKey(adId)) paymentsMap[adId] = [];
          paymentsMap[adId]!.add(p);
        } else if (adId != null && adId is Map && adId['_id'] != null) {
          final idStr = adId['_id'];
          if (!paymentsMap.containsKey(idStr)) paymentsMap[idStr] = [];
          paymentsMap[idStr]!.add(p);
        }
      }

      // Map commissions to admissions
      final Map<String, dynamic> commissionsMap = {};
      for (var trans in commissionTransactions) {
        final adId = trans['admissionId'] ?? trans['admission']?['_id'];
        if (adId != null) {
          commissionsMap[adId] = trans;
        }
      }

      setState(() {
        _admissions = admissions;
        _paymentsByAdmission = paymentsMap;
        _commissionsByAdmission = commissionsMap;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, dynamic> _getFinancials(dynamic admission) {
    final course = admission['course'];
    final double displayFee = (course?['displayFee'] ?? 0).toDouble();
    final double studentFee = (course?['actualFee'] ?? 0).toDouble();
    final double margin = studentFee - displayFee;

    final String admissionId = admission['_id'];
    final payments = _paymentsByAdmission[admissionId] ?? [];

    final double paid = payments
        .where(
          (p) => p['status'] == 'SUCCESS' || p['status'] == 'Verified',
        ) // 'Verified' used in mock, 'SUCCESS' in API
        .fold(0.0, (sum, p) => sum + (p['amount'] ?? 0));

    final double pending = studentFee - paid;

    // Use real commission from ledger if available
    final commissionTrans = _commissionsByAdmission[admissionId];
    double marginUsed = 0;
    double consultantSharePercent = 0;

    if (commissionTrans != null) {
      marginUsed = (commissionTrans['consultantShare'] ?? 0).toDouble();
      consultantSharePercent = (commissionTrans['commissionPercentage'] ?? 0)
          .toDouble();
    } else {
      // Fallback: Default Consultant margin is 60% of the profit (Margin)
      marginUsed = margin * 0.6;
      consultantSharePercent = 60;
    }

    final double universityShare = paid - marginUsed;

    return {
      'total': studentFee,
      'display_fee': displayFee,
      'paid': paid,
      'pending': pending,
      'commission': marginUsed,
      'university': universityShare,
      'commissionPercent': consultantSharePercent,
      'margin': margin,
    };
  }

  // Getters for UI compatibility
  List<Map<String, dynamic>> get _feeRecords {
    return _admissions.map((admission) {
      final financials = _getFinancials(admission);
      final admissionId = admission['_id'];
      final payments = _paymentsByAdmission[admissionId] ?? [];

      final latestPayment = payments.isNotEmpty ? payments.first : null;

      return {
        'student_id': admission['student']?['_id'] ?? 'N/A',
        'student_name': admission['student']?['name'] ?? 'N/A',
        'university':
            admission['university']?['name'] ??
            (admission['course']?['university'] ?? 'N/A'),
        'course': admission['course']?['name'] ?? 'N/A',
        'total_fee': financials['total'],
        'display_fee': financials['display_fee'],
        'margin': financials['margin'],
        'amount_paid': financials['paid'],
        'pending_amount': financials['pending'],
        'status': financials['pending'] <= 0
            ? 'Verified'
            : (financials['paid'] > 0 ? 'Partially Paid' : 'Pending'),
        'payment_date': latestPayment != null
            ? DateFormat(
                'dd MMM yyyy',
              ).format(DateTime.parse(latestPayment['createdAt']))
            : 'N/A',
        'payment_mode': latestPayment?['paymentMethod'] ?? 'N/A',
        'utr': latestPayment?['transactionId'] ?? 'N/A',
        'agent': admission['agent']?['name'] ?? 'Self',
        'consultant_share_percent': financials['commissionPercent'],
        'consultant_share_amount': financials['commission'],
        'university_share': financials['university'],
        '_raw_admission': admission,
        '_id': admissionId,
      };
    }).toList();
  }

  Future<void> _verifyPayment(
    String paymentId,
    String status, [
    String? reason,
  ]) async {
    setState(() => _isLoading = true);
    try {
      await FeeService.confirmPayment(
        paymentId,
        status: status,
      ); // Backend uses confirmPayment

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment $status successfully'),
          backgroundColor: status == 'SUCCESS' ? Colors.green : Colors.red,
        ),
      );
      _fetchData(); // Refresh list
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Calculate totals
  double get _totalCollected =>
      _admissions.fold(0, (sum, a) => sum + _getFinancials(a)['paid']);
  double get _totalPending =>
      _admissions.fold(0, (sum, a) => sum + _getFinancials(a)['pending']);
  double get _myCommission => _admissions.fold(
    0,
    (sum, a) => sum + _getFinancials(a)['commission'],
  ); // rough estimate
  double get _universityShare =>
      _admissions.fold(0, (sum, a) => sum + _getFinancials(a)['university']);

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _utrController.dispose();
    _dateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    if (_selectedAdmissionId == null ||
        _amountController.text.isEmpty ||
        _selectedPaymentMode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FeeService.initiatePayment(
        admissionId: _selectedAdmissionId!,
        amount: double.tryParse(_amountController.text) ?? 0,
        mode: _selectedPaymentMode,
        transactionId: _utrController.text,
        remarks: _remarksController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _amountController.clear();
      _utrController.clear();
      _dateController.clear();
      _remarksController.clear();
      setState(() {
        _selectedAdmissionId = null;
        _selectedPaymentMode = null;
      });

      // Refresh data
      _fetchData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Calculate totals

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Fee & Payment Management'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryBlue,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => _tabController.animateTo(1),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Pay Fees'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryBlue,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long), text: 'All Fees'),
            Tab(icon: Icon(Icons.upload_file), text: 'Pay Fees'),
            Tab(icon: Icon(Icons.verified), text: 'Verifyed fees'),
            Tab(icon: Icon(Icons.account_balance_wallet), text: 'Ledger'),
            Tab(icon: Icon(Icons.analytics), text: 'Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllFeesTab(),
          _buildUploadTab(),
          _buildVerifyTab(),
          _buildLedgerTab(),
          _buildReportsTab(),
        ],
      ),
    );
  }

  // Tab 1: All Student Fee Records (Compact UI)
  Widget _buildAllFeesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Compact Summary Cards
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactSummaryCard(
                        'Total',
                        '₹${(_totalCollected / 1000).toStringAsFixed(1)}K',
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCompactSummaryCard(
                        'Pending',
                        '₹${(_totalPending / 1000).toStringAsFixed(1)}K',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactSummaryCard(
                        'Commission',
                        '₹${(_myCommission / 1000).toStringAsFixed(1)}K',
                        AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCompactSummaryCard(
                        'University',
                        '₹${(_universityShare / 1000).toStringAsFixed(1)}K',
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Compact Search Bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, size: 18),
                    onPressed: () {},
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          // Compact Fee Records List
          ..._feeRecords.map((record) => _buildCompactFeeRecordCard(record)),
        ],
      ),
    );
  }

  // Compact Summary Card Widget
  Widget _buildCompactSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Compact Fee Record Card Widget
  Widget _buildCompactFeeRecordCard(Map<String, dynamic> record) {
    Color statusColor = record['status'] == 'Verified'
        ? Colors.green
        : record['status'] == 'Pending'
        ? Colors.orange
        : record['status'] == 'Reverted'
        ? Colors.red
        : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['student_name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${record['student_id']} • ${record['agent']}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    record['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // University and course
            Text(
              record['university'],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              record['course'],
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            // Amount row
            Row(
              children: [
                Expanded(
                  child: _buildCompactAmountBox(
                    'Total',
                    '₹${record['total_fee']}',
                    AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildCompactAmountBox(
                    'Paid',
                    '₹${record['amount_paid']}',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildCompactAmountBox(
                    'Due',
                    '₹${record['pending_amount']}',
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Payment info row
            Row(
              children: [
                Icon(Icons.payment, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${record['payment_mode']} • ${record['utr']}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ),
                Text(
                  record['payment_date'],
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showFeeDetailsDialog(record),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: const Text('View', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _downloadReceipt(record),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Receipt',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Compact Amount Box Widget
  Widget _buildCompactAmountBox(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Tab 2: Upload Fee Receipt
  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.upload_file,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Upload student payment receipts and share supporting remarks. Supported formats: JPG, PNG, PDF (Max 5MB).',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildFormSection(
            title: 'Student & Payment Details',
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedAdmissionId,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: 'Select Student *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _admissions
                    .map(
                      (r) => DropdownMenuItem<String>(
                        value: r['_id'] as String,
                        child: Text(
                          '${r['student']?['name'] ?? 'Unknown'} (${r['course']?['name'] ?? 'Unknown'})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedAdmissionId = value),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                        labelText: 'Amount Paid *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedPaymentMode,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.payments_outlined,
                          size: 18,
                        ),
                        labelText: 'Mode *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: ['UPI', 'Bank Transfer', 'Cash', 'Demand Draft']
                          .map(
                            (mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(mode),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedPaymentMode = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _utrController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.receipt_long, size: 18),
                        labelText: 'UTR / Transaction #',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today, size: 18),
                        labelText: 'Payment Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _dateController.text = DateFormat(
                              'dd MMM yyyy',
                            ).format(picked);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFormSection(
            title: 'Supporting Documents',
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File picker would open here'),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 44,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap to attach receipt',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      Text(
                        'JPG / PNG / PDF up to 5MB',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _remarksController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.notes_outlined, size: 18),
                  labelText: 'Remarks (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment receipt saved as draft'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save Draft'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit for Verification'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 3: Verify/Approve Payments
  Widget _buildVerifyTab() {
    final pendingPayments = _feeRecords
        .where((r) => r['status'] == 'Pending')
        .toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.orange[50],
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${pendingPayments.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Payments pending verification',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: pendingPayments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No pending payments',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All payments have been verified',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingPayments.length,
                  itemBuilder: (context, index) {
                    final record = pendingPayments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.orange[100],
                                  child: Icon(
                                    Icons.pending_actions,
                                    color: Colors.orange[700],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        record['student_name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${record['course']} • ${record['university']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        '₹${record['amount_paid']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mode',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        record['payment_mode'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        record['payment_date'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.receipt,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'UTR: ${record['utr']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // Proof viewing logic (placeholder for now as no file URL)
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No proof document available',
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.visibility,
                                      size: 16,
                                    ),
                                    label: const Text('View Proof'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      _verifyPayment(
                                        record['_id'],
                                        'FAILED',
                                      ); // or REJECTED
                                    },
                                    icon: const Icon(Icons.close, size: 16),
                                    label: const Text('Reject'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _verifyPayment(record['_id'], 'SUCCESS');
                                    },
                                    icon: const Icon(Icons.check, size: 16),
                                    label: const Text('Approve'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Tab 4: Ledger (Consultant-University Share)
  Widget _buildLedgerTab() {
    final verifiedRecords = _feeRecords
        .where((r) => r['status'] == 'Verified')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Revenue Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.primaryBlue.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Total Revenue',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${(_totalCollected / 1000).toStringAsFixed(1)}K',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'My Commission',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${(_myCommission / 1000).toStringAsFixed(1)}K',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white30),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'University Share',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${(_universityShare / 1000).toStringAsFixed(1)}K',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Student-wise Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ledger exported successfully'),
                    ),
                  );
                },
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: verifiedRecords.length,
            itemBuilder: (context, index) {
              final record = verifiedRecords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Icon(Icons.check_circle, color: Colors.green[700]),
                  ),
                  title: Text(
                    record['student_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${record['course']} • ${record['university']}',
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildLedgerRow(
                            'Total Course Fee',
                            '₹${record['total_fee']}',
                            Colors.blue,
                          ),
                          const Divider(height: 24),
                          _buildLedgerRow(
                            'Consultant Commission (${record['consultant_share_percent']}%)',
                            '₹${record['consultant_share_amount']}',
                            Colors.green,
                          ),
                          const SizedBox(height: 8),
                          _buildLedgerRow(
                            'University Share',
                            '₹${record['university_share']}',
                            Colors.purple,
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Payment verified on ${record['payment_date']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerRow(String label, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Tab 5: Reports & Analytics
  Widget _buildReportsTab() {
    final reportTypes = [
      {
        'title': 'Student Fee Report',
        'icon': Icons.people,
        'color': Colors.blue,
      },
      {
        'title': 'Commission Report',
        'icon': Icons.account_balance_wallet,
        'color': Colors.green,
      },
      {
        'title': 'University Share Report',
        'icon': Icons.school,
        'color': Colors.purple,
      },
      {
        'title': 'Daily Transactions',
        'icon': Icons.calendar_today,
        'color': Colors.orange,
      },
      {
        'title': 'Pending Fee Report',
        'icon': Icons.pending_actions,
        'color': Colors.red,
      },
      {
        'title': 'Monthly Analysis',
        'icon': Icons.analytics,
        'color': Colors.teal,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: 0.1),
                  Colors.blue.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Generate and download various reports for fee management and analysis',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Filter Options',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.school),
                    labelText: 'University',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      [
                            'All Universities',
                            'Sunrise University',
                            'MIT University',
                            'DU University',
                          ]
                          .map(
                            (uni) => DropdownMenuItem<String>(
                              value: uni,
                              child: Text(uni),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.filter_alt),
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['All Status', 'Verified', 'Pending', 'Reverted']
                      .map(
                        (status) => DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelText: 'Start Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  readOnly: true,
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelText: 'End Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  readOnly: true,
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Available Reports',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: reportTypes.length,
            itemBuilder: (context, index) {
              final report = reportTypes[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    _showExportDialog(context, report['title'] as String);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: (report['color'] as Color).withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            report['icon'] as IconData,
                            color: report['color'] as Color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          report['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, String reportTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export $reportTitle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$reportTitle exported as PDF')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Export as Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$reportTitle exported as Excel')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFeeDetailsDialog(Map<String, dynamic> record) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${record['student_name']} (${record['student_id']})'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('University', record['university']),
              _buildInfoRow('Course', record['course']),
              const SizedBox(height: 12),
              _buildInfoRow('Actual Fee (Student)', '₹${record['total_fee']}'),
              _buildInfoRow(
                'Display Fee (Institute)',
                '₹${record['display_fee']}',
              ),
              _buildInfoRow('Margin (Profit)', '₹${record['margin']}'),
              const Divider(),
              _buildInfoRow('Amount Paid', '₹${record['amount_paid']}'),
              _buildInfoRow('Pending Amount', '₹${record['pending_amount']}'),
              const SizedBox(height: 12),
              _buildInfoRow('Payment Mode', record['payment_mode']),
              _buildInfoRow('UTR Number', record['utr']),
              _buildInfoRow('Payment Date', record['payment_date']),
              if (record['consultant_share_amount'] != null) ...[
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Consultant Share',
                  '₹${record['consultant_share_amount']} (${record['consultant_share_percent']}%)',
                ),
                _buildInfoRow(
                  'University Share',
                  '₹${record['university_share']}',
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _downloadReceipt(record);
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download Receipt'),
            ),
          ],
        );
      },
    );
  }

  void _downloadReceipt(Map<String, dynamic> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Receipt for ${record['student_name']} is being downloaded...',
        ),
        action: SnackBarAction(
          label: 'OPEN',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Receipt opened for ${record['student_name']}'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
