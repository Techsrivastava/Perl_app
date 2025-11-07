import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/status_badge.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/screens/students/student_details_screen.dart';
import 'package:intl/intl.dart';

class StudentsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const StudentsScreen({super.key, this.scaffoldKey});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final mockData = MockDataService();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedYear = 'All Years';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showAdvancedFilters = false;

  @override
  Widget build(BuildContext context) {
    final students = mockData.students;
    final filteredStudents = students.where((student) {
      final matchesSearch =
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.courseName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _selectedStatus == 'All' || student.status == _selectedStatus;
      
      // Year filter
      final matchesYear = _selectedYear == 'All Years' || 
          student.appliedDate.year.toString() == _selectedYear;
      
      // Date range filter
      final matchesDateRange = (_startDate == null && _endDate == null) ||
          (_startDate != null && _endDate != null &&
              student.appliedDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
              student.appliedDate.isBefore(_endDate!.add(const Duration(days: 1)))) ||
          (_startDate != null && _endDate == null &&
              student.appliedDate.isAfter(_startDate!.subtract(const Duration(days: 1)))) ||
          (_startDate == null && _endDate != null &&
              student.appliedDate.isBefore(_endDate!.add(const Duration(days: 1))));
      
      return matchesSearch && matchesStatus && matchesYear && matchesDateRange;
    }).toList();

    // Calculate statistics
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

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'Students',
        showBackButton: false,
        showDrawer: true,
        scaffoldKey: widget.scaffoldKey,
      ),
      body: Column(
        children: [
          // Statistics Section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
            color: AppTheme.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Student Statistics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                        'Total',
                        totalStudents.toString(),
                        AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        'Pending',
                        pendingStudents.toString(),
                        AppTheme.warning,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        'Approved',
                        approvedStudents.toString(),
                        AppTheme.success,
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        'Rejected',
                        rejectedStudents.toString(),
                        AppTheme.error,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Compact Search and Filter Section
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.white,
            child: Column(
              children: [
                // Search Bar with Filter Toggle
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by name, email, course...',
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppTheme.primaryBlue,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          filled: true,
                          fillColor: AppTheme.lightGray,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter Toggle Button
                    Material(
                      color: _showAdvancedFilters ? AppTheme.primaryBlue : AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showAdvancedFilters = !_showAdvancedFilters;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Badge(
                            label: Text(_getActiveFilterCount().toString()),
                            isLabelVisible: _getActiveFilterCount() > 0,
                            child: Icon(
                              Icons.tune,
                              color: _showAdvancedFilters ? Colors.white : AppTheme.charcoal,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Quick Status Filter Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildStatusChip('All', 'All'),
                    _buildStatusChip(AppConstants.statusPending, AppConstants.statusPending),
                    _buildStatusChip(AppConstants.statusApproved, AppConstants.statusApproved),
                    _buildStatusChip(AppConstants.statusRejected, AppConstants.statusRejected),
                    _buildStatusChip('Reverted', 'Reverted'),
                  ],
                ),

                // Advanced Filters (Collapsible)
                if (_showAdvancedFilters) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.filter_list, size: 16, color: AppTheme.primaryBlue),
                            const SizedBox(width: 6),
                            const Text(
                              'Advanced Filters',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                            ),
                            const Spacer(),
                            if (_getActiveFilterCount() > 0)
                              TextButton(
                                onPressed: _clearFilters,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Clear All', style: TextStyle(fontSize: 11)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // Year Filter
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 14, color: AppTheme.mediumGray),
                            const SizedBox(width: 6),
                            const Text('Year:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedYear,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  isDense: true,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.charcoal),
                                  items: _getYearList().map((year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedYear = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Date Range
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 14, color: AppTheme.mediumGray),
                            const SizedBox(width: 6),
                            const Text('Date Range:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _startDate != null
                                            ? DateFormat('dd MMM').format(_startDate!)
                                            : 'From',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _startDate != null ? AppTheme.charcoal : AppTheme.mediumGray,
                                        ),
                                      ),
                                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(Icons.arrow_forward, size: 12, color: AppTheme.mediumGray),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _endDate != null
                                            ? DateFormat('dd MMM').format(_endDate!)
                                            : 'To',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _endDate != null ? AppTheme.charcoal : AppTheme.mediumGray,
                                        ),
                                      ),
                                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Students List
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: AppTheme.mediumGray,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No students found',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(
                      AppConstants.defaultPadding / 2,
                    ),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return _buildStudentCard(student);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<String> _getYearList() {
    final currentYear = DateTime.now().year;
    final years = <String>['All Years'];
    for (int i = currentYear; i >= currentYear - 5; i--) {
      years.add(i.toString());
    }
    return years;
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
      _selectedStatus = 'All';
      _selectedYear = 'All Years';
      _startDate = null;
      _endDate = null;
    });
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    final isSelected = _selectedStatus == value;
    Color chipColor;
    
    if (value == 'All') {
      chipColor = AppTheme.primaryBlue;
    } else if (value == AppConstants.statusPending) {
      chipColor = Colors.orange;
    } else if (value == AppConstants.statusApproved) {
      chipColor = AppTheme.success;
    } else if (value == AppConstants.statusRejected) {
      chipColor = AppTheme.error;
    } else {
      chipColor = Colors.purple;
    }

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : chipColor,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = value;
        });
      },
      backgroundColor: chipColor.withOpacity(0.1),
      selectedColor: chipColor,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: chipColor.withOpacity(0.5),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: EdgeInsets.zero,
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedStatus != 'All') count++;
    if (_selectedYear != 'All Years') count++;
    if (_startDate != null) count++;
    if (_endDate != null) count++;
    return count;
  }

  Widget _buildStudentCard(dynamic student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailsScreen(student: student),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  // Profile Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        student.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Name & Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.charcoal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 12, color: AppTheme.mediumGray),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                student.email,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.mediumGray,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 12, color: AppTheme.mediumGray),
                            const SizedBox(width: 4),
                            Text(
                              student.phone,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  StatusBadge(status: student.status),
                ],
              ),

              const Divider(height: 20, thickness: 1),

              // Course & Consultant Info
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.school, size: 12, color: AppTheme.primaryBlue),
                              SizedBox(width: 4),
                              Text(
                                'Course',
                                style: TextStyle(fontSize: 9, color: AppTheme.mediumGray, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            student.courseName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.charcoal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.success.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.business, size: 12, color: AppTheme.success),
                              SizedBox(width: 4),
                              Text(
                                'Consultant',
                                style: TextStyle(fontSize: 9, color: AppTheme.mediumGray, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            student.consultancyName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.charcoal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Additional Details Grid
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildDetailItem('📅 Applied', DateFormat('dd MMM yyyy').format(student.appliedDate))),
                        Expanded(child: _buildDetailItem('📄 Documents', '${student.documents.length} files')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildDetailItem('📧 Email', student.email)),
                        Expanded(child: _buildDetailItem('📞 Phone', student.phone)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildDetailItem('🆔 Student ID', student.id)),
                        Expanded(child: _buildDetailItem('🕐 Updated', DateFormat('dd MMM').format(student.updatedAt))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Action Buttons
              if (student.status == AppConstants.statusPending)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showStatusUpdateDialog(
                                student,
                                AppConstants.statusApproved,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.success,
                              foregroundColor: AppTheme.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.check_circle, size: 16),
                            label: const Text('Approve', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showStatusUpdateDialog(
                                student,
                                AppConstants.statusRejected,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.error,
                              side: const BorderSide(color: AppTheme.error),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.cancel, size: 16),
                            label: const Text('Reject', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showRevertDialog(student);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.replay_outlined, size: 16),
                        label: const Text('Revert to Consultant', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: student),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility, size: 14),
                      label: const Text('View Full Details', style: TextStyle(fontSize: 11)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      onPressed: () {
                        _showStatusUpdateDialog(
                          student,
                          AppConstants.statusApproved,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: AppTheme.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppTheme.mediumGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.charcoal,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showStatusUpdateDialog(dynamic student, String newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${newStatus == AppConstants.statusApproved ? 'Approve' : 'Reject'} Application',
            style: const TextStyle(fontSize: 16),
          ),
          content: Text(
            'Are you sure you want to ${newStatus.toLowerCase()} ${student.name}\'s application?',
            style: const TextStyle(fontSize: 14),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  // Update student status in mock data
                  student.status = newStatus;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Application ${newStatus.toLowerCase()} successfully',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: newStatus == AppConstants.statusApproved
                        ? AppTheme.success
                        : AppTheme.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: newStatus == AppConstants.statusApproved
                    ? AppTheme.success
                    : AppTheme.error,
                foregroundColor: AppTheme.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
              child: Text(
                newStatus == AppConstants.statusApproved ? 'Approve' : 'Reject',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRevertDialog(dynamic student) {
    final TextEditingController remarksController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String selectedIssueType = 'Document Issue';
    
    final List<String> issueTypes = [
      'Document Issue',
      'Incomplete Information',
      'Invalid Data',
      'Payment Issue',
      'Eligibility Concern',
      'Technical Error',
      'Other',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.orange.shade700],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.replay_outlined, color: Colors.white, size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Revert Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 2),
                                Text('Send back to consultant for correction', style: TextStyle(fontSize: 11, color: Colors.white70)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Student Info Card
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          student.name.substring(0, 1).toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            student.courseName,
                                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Consultant Info
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.shade200),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.business, color: AppTheme.success, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Reverting to Consultant',
                                            style: TextStyle(fontSize: 10, color: AppTheme.mediumGray, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            student.consultancyName,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.success),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Issue Type Selector
                              const Text(
                                'Issue Type *',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.charcoal),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: selectedIssueType,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  items: issueTypes.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type, style: const TextStyle(fontSize: 13)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setDialogState(() {
                                      selectedIssueType = value!;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Remarks/Reason TextArea
                              const Text(
                                'Remarks / Reason for Revert *',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.charcoal),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: remarksController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Explain what needs to be corrected or resubmitted...',
                                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please provide remarks for reverting';
                                  }
                                  if (value.trim().length < 10) {
                                    return 'Remarks should be at least 10 characters';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 12),

                              // Info Note
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange.shade200),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'The consultant will receive a notification with your remarks and can resubmit the corrected application.',
                                        style: TextStyle(fontSize: 11, color: Colors.orange.shade900),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Footer Buttons
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  setState(() {
                                    student.status = 'Reverted';
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '✓ Application Reverted',
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Consultant: ${student.consultancyName}',
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                          Text(
                                            'Issue: $selectedIssueType',
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.orange,
                                      duration: const Duration(seconds: 4),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.replay_outlined, size: 16),
                              label: const Text('Revert Application', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
