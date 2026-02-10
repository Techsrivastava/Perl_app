import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/config/constants.dart';
import 'package:educonnect/screens/consultancy/edit_commission_screen.dart';
import 'package:educonnect/screens/consultancy/reports_screen.dart';
import 'package:educonnect/widgets/app_header.dart';
import 'package:educonnect/widgets/custom_button.dart';
import 'package:educonnect/widgets/commission_badge.dart';
import 'package:educonnect/widgets/status_badge.dart';
import 'package:educonnect/models/consultancy_model.dart';
import 'package:educonnect/services/commission_service.dart';

class CommissionConfigScreen extends StatefulWidget {
  final Consultancy consultancy;

  const CommissionConfigScreen({super.key, required this.consultancy});

  @override
  State<CommissionConfigScreen> createState() => _CommissionConfigScreenState();
}

class _CommissionConfigScreenState extends State<CommissionConfigScreen> {
  List<CommissionTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final transactions = await CommissionService.getTransactions();
      if (mounted) {
        setState(() {
          _transactions = List<CommissionTransaction>.from(
            transactions.map((t) => CommissionTransaction.fromJson(t)),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('Error loading transactions: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // transactions used below

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: 'Commission Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Consultancy Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.consultancy.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.charcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.consultancy.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.mediumGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: widget.consultancy.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildInfoChip(Icons.phone, widget.consultancy.phone),
                      _buildInfoChip(
                        Icons.people,
                        '${widget.consultancy.studentsCount} students',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Commission',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${NumberFormat('#,##0.00').format(widget.consultancy.totalCommission)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      CommissionBadge(
                        type: widget.consultancy.commissionType,
                        value: widget.consultancy.commissionValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Commission Info
            _buildInfoSection(
              title: 'Commission Information',
              children: [
                _buildInfoRow(
                  'Commission Type',
                  _getCommissionTypeString(widget.consultancy.commissionType),
                ),
                _buildInfoRow('Commission Rate', _getCommissionRateString()),
                _buildInfoRow(
                  'Students Enrolled',
                  widget.consultancy.studentsCount.toString(),
                ),
                _buildInfoRow(
                  'Total Commission',
                  '\$${NumberFormat('#,##0.00').format(widget.consultancy.totalCommission)}',
                ),
              ],
            ),

            // Transactions
            _buildInfoSection(
              title: 'Commission Transactions',
              children: [
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_transactions.isEmpty)
                  const Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.mediumGray,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  ..._transactions.map(_buildTransactionCard),
              ],
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Edit Commission',
                    variant: ButtonVariant.secondary,
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCommissionScreen(
                            consultancy: widget.consultancy,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    label: 'View Reports',
                    variant: ButtonVariant.primary,
                    icon: Icons.assessment,
                    onPressed: () {
                      // ✅ FIXED: Pass consultancy for filtered reports
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReportsScreen(consultancy: widget.consultancy),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helpers
  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.mediumGray),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.lightGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

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
            color: Colors.black.withOpacity(0.05),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(CommissionTransaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  transaction.studentName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoal,
                  ),
                ),
              ),
              StatusBadge(status: transaction.status, isSmall: true),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            transaction.courseName,
            style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fees: \$${NumberFormat('#,##0').format(transaction.courseFees)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.mediumGray,
                ),
              ),
              Text(
                'Comm: \$${NumberFormat('#,##0.00').format(transaction.calculatedCommission)}',
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
            'Date: ${DateFormat('MMM dd, yyyy').format(transaction.transactionDate)}',
            style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }

  String _getCommissionTypeString(CommissionType type) {
    switch (type) {
      case CommissionType.percentage:
        return 'Percentage-Based';
      case CommissionType.flat:
        return 'Flat Fee';
      case CommissionType.oneTime:
        return 'One-Time Payment';
    }
  }

  String _getCommissionRateString() {
    switch (widget.consultancy.commissionType) {
      case CommissionType.percentage:
        return '${widget.consultancy.commissionValue.toStringAsFixed(1)}% of course fees';
      case CommissionType.flat:
        return '\$${widget.consultancy.commissionValue.toStringAsFixed(0)} per student';
      case CommissionType.oneTime:
        return '\$${widget.consultancy.commissionValue.toStringAsFixed(0)} one-time payment';
    }
  }
}
