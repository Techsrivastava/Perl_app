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

          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
            color: AppTheme.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search students...',
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
                      vertical: 8,
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

                const SizedBox(height: 8),

                // Filters Row
                Row(
                  children: [
                    // Status Filter
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedStatus,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: const TextStyle(fontSize: 12, color: AppTheme.charcoal),
                              items: [
                                'All',
                                AppConstants.statusPending,
                                AppConstants.statusApproved,
                                AppConstants.statusRejected,
                              ].map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Year Filter
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Year',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.mediumGray.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedYear,
                              isExpanded: true,
                              underline: const SizedBox(),
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
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Date Range Filter
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'From Date',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
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
                                        ? DateFormat('MMM dd, yyyy').format(_startDate!)
                                        : 'Select date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _startDate != null ? AppTheme.charcoal : AppTheme.mediumGray,
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'To Date',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
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
                                        ? DateFormat('MMM dd, yyyy').format(_endDate!)
                                        : 'Select date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _endDate != null ? AppTheme.charcoal : AppTheme.mediumGray,
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
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Clear Filters Button
                if (_selectedStatus != 'All' || _selectedYear != 'All Years' || _startDate != null || _endDate != null)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text('Clear All Filters', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
}
