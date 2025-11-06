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
      return matchesSearch && matchesStatus;
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

                // Status Filter
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.charcoal,
                      ),
                    ),
                    Expanded(
                      child: DropdownMenu<String>(
                        initialSelection: _selectedStatus,
                        expandedInsets: EdgeInsets.zero,
                        textStyle: const TextStyle(fontSize: 12),
                        dropdownMenuEntries:
                            [
                              'All',
                              AppConstants.statusPending,
                              AppConstants.statusApproved,
                              AppConstants.statusRejected,
                            ].map((status) {
                              return DropdownMenuEntry<String>(
                                value: status,
                                label: status,
                              );
                            }).toList(),
                        onSelected: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
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
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailsScreen(student: student),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.charcoal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          student.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.mediumGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: student.status),
                ],
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildInfoChip(Icons.school, student.courseName),
                  _buildInfoChip(Icons.business, student.consultancyName),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Applied: ${DateFormat('MMM dd, yyyy').format(student.appliedDate)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.mediumGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Documents: ${student.documents.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.mediumGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (student.status == AppConstants.statusPending)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showStatusUpdateDialog(
                          student,
                          AppConstants.statusRejected,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(fontSize: 12),
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.mediumGray),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 10, color: AppTheme.mediumGray),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.lightGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
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
