import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/widgets/app_header.dart';
import 'package:educonnect/services/report_service.dart';
import 'package:intl/intl.dart';

class ConsultantShareReportScreen extends StatefulWidget {
  const ConsultantShareReportScreen({super.key});

  @override
  State<ConsultantShareReportScreen> createState() =>
      _ConsultantShareReportScreenState();
}

class _ConsultantShareReportScreenState
    extends State<ConsultantShareReportScreen> {
  // Search and Filter
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'Recent Updates';

  // State
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _shareRecords = [];

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
      final data = await ReportService.getConsultantShareReport(
        startDate: _startDate != null
            ? DateFormat('yyyy-MM-dd').format(_startDate!)
            : null,
        endDate: _endDate != null
            ? DateFormat('yyyy-MM-dd').format(_endDate!)
            : null,
      );
      if (mounted) {
        setState(() {
          _shareRecords = data['records'] ?? [];
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> get _filteredRecords {
    var records = List<dynamic>.from(_shareRecords);

    // Search filter
    if (_searchQuery.isNotEmpty) {
      records = records.where((record) {
        return record['consultantName'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            record['courseName'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            record['consultantId'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // Date range filter
    if (_startDate != null && _endDate != null) {
      records = records.where((record) {
        final date = record['lastUpdated'] as DateTime;
        return date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            date.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'Highest Share':
        records.sort(
          (a, b) => (b['consultantShare'] as double).compareTo(
            a['consultantShare'] as double,
          ),
        );
        break;
      case 'Lowest Share':
        records.sort(
          (a, b) => (a['consultantShare'] as double).compareTo(
            b['consultantShare'] as double,
          ),
        );
        break;
      case 'Recent Updates':
      default:
        records.sort(
          (a, b) => (b['lastUpdated'] as DateTime).compareTo(
            a['lastUpdated'] as DateTime,
          ),
        );
        break;
    }

    return records;
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _startDate = null;
      _endDate = null;
      _sortBy = 'Recent Updates';
    });
  }

  void _exportReport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📄 Exporting report as $format...'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords = _filteredRecords;

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: '📊 Consultant Share Reports'),
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
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReportData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Filters Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by consultant, course, or ID...',
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: AppTheme.lightGray.withValues(alpha: 0.3),
                        ),
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),

                      const SizedBox(height: 12),

                      // Date Range and Sort
                      Row(
                        children: [
                          // Start Date
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.mediumGray.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _startDate != null
                                          ? DateFormat(
                                              'MMM dd',
                                            ).format(_startDate!)
                                          : 'Start Date',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _startDate != null
                                            ? AppTheme.charcoal
                                            : AppTheme.mediumGray,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: AppTheme.mediumGray,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // End Date
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme.mediumGray.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _endDate != null
                                          ? DateFormat(
                                              'MMM dd',
                                            ).format(_endDate!)
                                          : 'End Date',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _endDate != null
                                            ? AppTheme.charcoal
                                            : AppTheme.mediumGray,
                                      ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: AppTheme.mediumGray,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Sort
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _sortBy,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                isDense: true,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.charcoal,
                              ),
                              items:
                                  [
                                    'Recent Updates',
                                    'Highest Share',
                                    'Lowest Share',
                                  ].map((sort) {
                                    return DropdownMenuItem(
                                      value: sort,
                                      child: Text(sort),
                                    );
                                  }).toList(),
                              onChanged: (value) =>
                                  setState(() => _sortBy = value!),
                            ),
                          ),
                        ],
                      ),

                      // Clear Filters Button
                      if (_searchQuery.isNotEmpty ||
                          _startDate != null ||
                          _endDate != null ||
                          _sortBy != 'Recent Updates')
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextButton.icon(
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.clear_all, size: 16),
                            label: const Text(
                              'Clear All Filters',
                              style: TextStyle(fontSize: 11),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Stats Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Total Records',
                        filteredRecords.length.toString(),
                        Icons.list_alt,
                        AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Total Share',
                        '₹${NumberFormat('#,##,###').format(filteredRecords.fold(0.0, (sum, r) => sum + r['consultantShare']))}',
                        Icons.money,
                        AppTheme.warning,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Uni. Profit',
                        '₹${NumberFormat('#,##,###').format(filteredRecords.fold(0.0, (sum, r) => sum + r['universityProfit']))}',
                        Icons.account_balance,
                        AppTheme.success,
                      ),
                    ],
                  ),
                ),

                // Records List
                Expanded(
                  child: filteredRecords.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppTheme.mediumGray.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No records found',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.mediumGray,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRecords.length,
                          itemBuilder: (context, index) {
                            final record = filteredRecords[index];
                            return _buildRecordCard(record);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
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
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['consultantName'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.charcoal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record['consultantId'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.mediumGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                    color: _getShareTypeColor(
                      record['shareType'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    record['shareType'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getShareTypeColor(record['shareType']),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Course Name
            Row(
              children: [
                const Icon(Icons.school, size: 14, color: AppTheme.mediumGray),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    record['courseName'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.charcoal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),

            const Divider(height: 20),

            // Financial Details
            Row(
              children: [
                Expanded(
                  child: _buildDetailColumn(
                    'Total Fee',
                    '₹${NumberFormat('#,##,###').format(record['totalFee'])}',
                    AppTheme.charcoal,
                  ),
                ),
                Expanded(
                  child: _buildDetailColumn(
                    'Consultant Share',
                    '₹${NumberFormat('#,##,###').format(record['consultantShare'])}',
                    AppTheme.warning,
                  ),
                ),
                Expanded(
                  child: _buildDetailColumn(
                    'Uni. Profit',
                    '₹${NumberFormat('#,##,###').format(record['universityProfit'])}',
                    AppTheme.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Footer
            Text(
              'Updated: ${DateFormat('MMM dd, yyyy').format(record['lastUpdated'])}',
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.mediumGray,
                fontStyle: FontStyle.italic,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Color _getShareTypeColor(String type) {
    switch (type) {
      case 'Percentage':
        return AppTheme.primaryBlue;
      case 'Flat':
        return AppTheme.warning;
      case 'One-Time':
        return AppTheme.success;
      default:
        return AppTheme.mediumGray;
    }
  }
}
