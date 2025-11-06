import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/consultancy_model.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/status_badge.dart';

class ReportsScreen extends StatefulWidget {
  final Consultancy? consultancy; // ✅ optional: show all or one consultancy

  // ❌ removed `const` to make hot reload safe
  ReportsScreen({super.key, this.consultancy});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final mockData = MockDataService();
  String _selectedReportType = 'All';

  @override
  Widget build(BuildContext context) {
    final allTransactions = mockData.commissionTransactions;

    // ✅ Filter for selected consultancy if passed
    final transactions = widget.consultancy == null
        ? allTransactions
        : allTransactions
              .where((t) => t.consultancyId == widget.consultancy!.id)
              .toList();

    final consultancies = widget.consultancy == null
        ? mockData.consultancies
        : [widget.consultancy!];

    final students = mockData.students
        .where(
          (s) =>
              widget.consultancy == null ||
              s.consultancyId == widget.consultancy!.id,
        )
        .toList();

    // 🔹 Stats
    final totalStudents = students.length;
    final pendingStudents = students
        .where((s) => s.status == AppConstants.statusPending)
        .length;
    final approvedStudents = students
        .where((s) => s.status == AppConstants.statusApproved)
        .length;
    final rejectedStudents = students
        .where((s) => s.status == AppConstants.statusRejected)
        .length;

    final totalConsultancies = consultancies.length;
    final activeConsultancies = consultancies
        .where((c) => c.status == AppConstants.statusActive)
        .length;
    final totalStudentsEnrolled = consultancies.fold(
      0,
      (sum, c) => sum + c.studentsCount,
    );
    final totalCommission = consultancies.fold(
      0.0,
      (sum, c) => sum + c.totalCommission,
    );

    // 🔹 Filter by status (dropdown)
    final filteredTransactions = _selectedReportType == 'All'
        ? transactions
        : transactions.where((t) => t.status == _selectedReportType).toList();

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: widget.consultancy == null
            ? 'Reports'
            : '${widget.consultancy!.name} Reports',
      ),
      body: SingleChildScrollView(
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
                    color: Colors.black.withOpacity(0.05),
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
                    child: DropdownMenu<String>(
                      initialSelection: _selectedReportType,
                      expandedInsets: EdgeInsets.zero,
                      textStyle: const TextStyle(fontSize: 12),
                      dropdownMenuEntries:
                          [
                            'All',
                            AppConstants.statusPending,
                            AppConstants.statusApproved,
                            AppConstants.statusRejected,
                          ].map((type) {
                            return DropdownMenuEntry<String>(
                              value: type,
                              label: type,
                            );
                          }).toList(),
                      onSelected: (value) {
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

            // 🔹 Student Summary
            _buildInfoSection(
              title: 'Student Summary',
              children: [
                _buildStatRow(
                  'Total Students',
                  totalStudents.toString(),
                  AppTheme.primaryBlue,
                ),
                _buildStatRow(
                  'Pending',
                  pendingStudents.toString(),
                  AppTheme.warning,
                ),
                _buildStatRow(
                  'Approved',
                  approvedStudents.toString(),
                  AppTheme.success,
                ),
                _buildStatRow(
                  'Rejected',
                  rejectedStudents.toString(),
                  AppTheme.error,
                ),
              ],
            ),

            // 🔹 Consultancy Summary
            _buildInfoSection(
              title: 'Consultancy Summary',
              children: [
                _buildStatRow(
                  'Total Consultancies',
                  totalConsultancies.toString(),
                  AppTheme.primaryBlue,
                ),
                _buildStatRow(
                  'Active Consultancies',
                  activeConsultancies.toString(),
                  AppTheme.success,
                ),
                _buildStatRow(
                  'Students Enrolled',
                  totalStudentsEnrolled.toString(),
                  AppTheme.warning,
                ),
                _buildStatRow(
                  'Total Commission',
                  '\$${NumberFormat('#,##0.00').format(totalCommission)}',
                  AppTheme.error,
                ),
              ],
            ),

            // 🔹 Consultancy-Wise Breakdown
            _buildInfoSection(
              title: 'Consultancy-Wise Summary',
              children: consultancies.map((consultancy) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              consultancy.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.charcoal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Students: ${consultancy.studentsCount} | Commission: \$${NumberFormat('#,##0.00').format(consultancy.totalCommission)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: consultancy.status),
                    ],
                  ),
                );
              }).toList(),
            ),

            // 🔹 Transactions List
            _buildInfoSection(
              title: 'Commission Transactions',
              children: filteredTransactions.isEmpty
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
                  : filteredTransactions.map(_buildTransactionCard).toList(),
            ),
          ],
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

  Widget _buildTransactionCard(CommissionTransaction t) {
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
                  t.studentName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoal,
                  ),
                ),
              ),
              StatusBadge(status: t.status, isSmall: true),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            t.courseName,
            style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fees: \$${NumberFormat('#,##0').format(t.courseFees)}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.mediumGray,
                ),
              ),
              Text(
                'Comm: \$${NumberFormat('#,##0.00').format(t.calculatedCommission)}',
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
            'Date: ${DateFormat('MMM dd, yyyy').format(t.transactionDate)}',
            style: const TextStyle(fontSize: 9, color: AppTheme.mediumGray),
          ),
        ],
      ),
    );
  }
}
