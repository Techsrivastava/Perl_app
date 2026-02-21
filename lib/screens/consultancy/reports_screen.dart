import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:educonnect/config/constants.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/services/report_service.dart';
import 'package:educonnect/services/commission_service.dart';
import 'package:educonnect/widgets/app_header.dart';

class ReportsScreen extends StatefulWidget {
  final String? consultancyId; // ✅ optional: show all or one consultancy
  // Accept consultancy object and extract ID
  final dynamic consultancy;

  const ReportsScreen({super.key, this.consultancyId, this.consultancy});

  String? get effectiveConsultancyId => consultancyId ?? consultancy?.id;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedReportType = 'All';
  bool _isLoading = true;
  List<dynamic> _transactions = [];
  Map<String, dynamic>? _reportData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch commission transactions
      final transactions = await CommissionService.getTransactions();

      // Fetch comprehensive report data
      final reportData = await ReportService.getCommissionReport();

      if (mounted) {
        setState(() {
          _transactions = transactions;
          _reportData = reportData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter transactions if consultancyId provided
    final filteredTransactions = widget.consultancyId == null
        ? _transactions
        : _transactions
              .where((t) => t['consultancy']?['_id'] == widget.consultancyId)
              .toList();

    // Further filter by status dropdown
    final displayTransactions = _selectedReportType == 'All'
        ? filteredTransactions
        : filteredTransactions
              .where((t) => t['status'] == _selectedReportType)
              .toList();

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: widget.consultancyId == null ? 'Reports' : 'Consultancy Reports',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReportData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadReportData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Filter Dropdown
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Report Type: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.charcoal,
                            ),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedReportType,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: ['All', 'PENDING', 'APPROVED', 'PAID'].map(
                                (type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedReportType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Summary from Report Data
                    if (_reportData != null) ...[
                      _buildInfoSection(
                        title: 'Commission Summary',
                        children: [
                          _buildStatRow(
                            'Total Commission',
                            '₹${NumberFormat('#,##0.00').format(_reportData!['totalCommission'] ?? 0)}',
                            AppTheme.primaryBlue,
                          ),
                          _buildStatRow(
                            'Pending',
                            '₹${NumberFormat('#,##0.00').format(_reportData!['pendingCommission'] ?? 0)}',
                            AppTheme.warning,
                          ),
                          _buildStatRow(
                            'Approved',
                            '₹${NumberFormat('#,##0.00').format(_reportData!['approvedCommission'] ?? 0)}',
                            AppTheme.success,
                          ),
                          _buildStatRow(
                            'Paid',
                            '₹${NumberFormat('#,##0.00').format(_reportData!['paidCommission'] ?? 0)}',
                            Colors.green,
                          ),
                        ],
                      ),
                    ],

                    // 🔹 Transactions List
                    _buildInfoSection(
                      title: 'Commission Transactions',
                      children: displayTransactions.isEmpty
                          ? [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'No transactions found',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.mediumGray,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : displayTransactions
                                .map(_buildTransactionCard)
                                .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // 🔹 Helpers
  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.mediumGray),
          ),
          Text(
            value,
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

  Widget _buildTransactionCard(dynamic t) {
    final studentName = t['admission']?['student']?['name'] ?? 'Unknown';
    final courseName = t['admission']?['course']?['name'] ?? 'Unknown Course';
    final amount = (t['amount'] ?? 0).toDouble();
    final status = t['status'] ?? 'PENDING';
    final createdAt = t['createdAt'] != null
        ? DateTime.parse(t['createdAt'])
        : DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.mediumGray.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoal,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            courseName,
            style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount: ₹${NumberFormat('#,##0.00').format(amount)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Date: ${DateFormat('MMM dd, yyyy').format(createdAt)}',
            style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'APPROVED':
        return AppTheme.success;
      case 'PENDING':
        return AppTheme.warning;
      case 'REJECTED':
        return AppTheme.error;
      default:
        return AppTheme.mediumGray;
    }
  }
}
