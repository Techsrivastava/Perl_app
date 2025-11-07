import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:intl/intl.dart';

class ConsultantShareReportScreen extends StatefulWidget {
  const ConsultantShareReportScreen({Key? key}) : super(key: key);

  @override
  State<ConsultantShareReportScreen> createState() => _ConsultantShareReportScreenState();
}

class _ConsultantShareReportScreenState extends State<ConsultantShareReportScreen> {
  // Search and Filter
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'Recent Updates';
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Mock Data
  final List<Map<String, dynamic>> _shareRecords = [
    {
      'id': 'SR001',
      'consultantName': 'Rajesh Kumar',
      'consultantId': 'C001',
      'courseName': 'B.Tech Computer Science',
      'shareType': 'Percentage',
      'shareValue': 10.0,
      'totalFee': 50000.0,
      'consultantShare': 5000.0,
      'universityProfit': 45000.0,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 'SR002',
      'consultantName': 'Priya Sharma',
      'consultantId': 'C002',
      'courseName': 'MBA',
      'shareType': 'Flat',
      'shareValue': 8000.0,
      'totalFee': 80000.0,
      'consultantShare': 8000.0,
      'universityProfit': 72000.0,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 'SR003',
      'consultantName': 'Amit Patel',
      'consultantId': 'C003',
      'courseName': 'M.Tech AI/ML',
      'shareType': 'Percentage',
      'shareValue': 12.0,
      'totalFee': 60000.0,
      'consultantShare': 7200.0,
      'universityProfit': 52800.0,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 'SR004',
      'consultantName': 'Neha Singh',
      'consultantId': 'C004',
      'courseName': 'BBA',
      'shareType': 'One-Time',
      'shareValue': 5000.0,
      'totalFee': 40000.0,
      'consultantShare': 5000.0,
      'universityProfit': 35000.0,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'id': 'SR005',
      'consultantName': 'Sanjay Gupta',
      'consultantId': 'C005',
      'courseName': 'B.Sc Data Science',
      'shareType': 'Percentage',
      'shareValue': 15.0,
      'totalFee': 45000.0,
      'consultantShare': 6750.0,
      'universityProfit': 38250.0,
      'lastUpdated': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  List<Map<String, dynamic>> get _filteredRecords {
    var records = List<Map<String, dynamic>>.from(_shareRecords);
    
    // Search filter
    if (_searchQuery.isNotEmpty) {
      records = records.where((record) {
        return record['consultantName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               record['courseName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               record['consultantId'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
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
        records.sort((a, b) => (b['consultantShare'] as double).compareTo(a['consultantShare'] as double));
        break;
      case 'Lowest Share':
        records.sort((a, b) => (a['consultantShare'] as double).compareTo(b['consultantShare'] as double));
        break;
      case 'Recent Updates':
      default:
        records.sort((a, b) => (b['lastUpdated'] as DateTime).compareTo(a['lastUpdated'] as DateTime));
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
      body: Column(
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: AppTheme.lightGray.withOpacity(0.3),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _startDate != null
                                    ? DateFormat('MMM dd').format(_startDate!)
                                    : 'Start Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _startDate != null ? AppTheme.charcoal : AppTheme.mediumGray,
                                ),
                              ),
                              Icon(Icons.calendar_today, size: 14, color: AppTheme.mediumGray),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _endDate != null
                                    ? DateFormat('MMM dd').format(_endDate!)
                                    : 'End Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _endDate != null ? AppTheme.charcoal : AppTheme.mediumGray,
                                ),
                              ),
                              Icon(Icons.calendar_today, size: 14, color: AppTheme.mediumGray),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 11, color: AppTheme.charcoal),
                        items: ['Recent Updates', 'Highest Share', 'Lowest Share'].map((sort) {
                          return DropdownMenuItem(value: sort, child: Text(sort));
                        }).toList(),
                        onChanged: (value) => setState(() => _sortBy = value!),
                      ),
                    ),
                  ],
                ),
                
                // Clear Filters Button
                if (_searchQuery.isNotEmpty || _startDate != null || _endDate != null || _sortBy != 'Recent Updates')
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text('Clear All Filters', style: TextStyle(fontSize: 11)),
                      style: TextButton.styleFrom(foregroundColor: AppTheme.error),
                    ),
                  ),
              ],
            ),
          ),
          
          // Stats Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryBlue.withOpacity(0.05),
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
                        Icon(Icons.search_off, size: 64, color: AppTheme.mediumGray.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No records found',
                          style: TextStyle(fontSize: 14, color: AppTheme.mediumGray),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExportOptions(),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.download, color: AppTheme.white),
        label: const Text('Export', style: TextStyle(color: AppTheme.white)),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
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
                        style: const TextStyle(fontSize: 11, color: AppTheme.mediumGray),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getShareTypeColor(record['shareType']).withOpacity(0.1),
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
                    style: const TextStyle(fontSize: 12, color: AppTheme.charcoal),
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
              style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray, fontStyle: FontStyle.italic),
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
  
  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Export Report',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppTheme.error),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                _exportReport('PDF');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: AppTheme.success),
              title: const Text('Export as Excel'),
              onTap: () {
                Navigator.pop(context);
                _exportReport('Excel');
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppTheme.primaryBlue),
              title: const Text('Share Report'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('📤 Sharing report...'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
