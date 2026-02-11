import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import '../../../../services/student_service.dart';
import '../../../../models/student_model.dart';

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  List<Student> _allStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final studentsData = await StudentService.getStudents();
      if (mounted) {
        setState(() {
          _allStudents = studentsData
              .map((data) => Student.fromJson(data))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load students: $e')));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _viewStudent(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _StudentDetailsView(student: student),
      ),
    );
  }

  void _editStudent(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _EditStudentForm(
          student: student,
          onSave: (updatedData) {
            setState(() {
              // Assuming updatedData is a Map<String, dynamic> and Student has a fromJson constructor
              // This might need more sophisticated merging if Student is immutable
              // For now, we'll just update the existing student object's properties
              // or reload students if the change is significant.
              // For simplicity, let's assume we update the properties directly if possible
              // or trigger a reload.
              // A better approach would be to pass a callback to update the specific student in _allStudents.
              // For this example, let's just trigger a reload for simplicity after edit.
              _loadStudents();
            });
          },
        ),
      ),
    );
  }

  void _deleteStudent(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Delete ${student.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _allStudents.remove(student));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _forwardToUniversity(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forward Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Forward this application to university for verification?',
            ),
            const SizedBox(height: 12),
            Text(
              'Student: ${student.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('University: ${student.universityName}'),
            Text('Course: ${student.courseName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Create a modified copy of the student with the new status
                final updatedStudent = student.copyWith(status: 'Applied');
                // Find the index of the student in the list
                final index = _allStudents.indexWhere(
                  (s) => s.id == student.id,
                );
                if (index != -1) {
                  _allStudents[index] = updatedStudent;
                }
              }); // Assuming status is mutable
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application forwarded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Forward'),
          ),
        ],
      ),
    );
  }

  void _trackApplication(Student student) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryBlue, Color(0xFF1565C0)],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.track_changes,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Track Application',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.id,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student Info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 20,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${student.courseName} - ${student.consultancyName}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Timeline
                      const Text(
                        'Application Timeline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildTimelineItem(
                        'Application Registered',
                        student.appliedDate.toIso8601String(),
                        'Student added to system',
                        Colors.blue,
                        true,
                      ),
                      _buildTimelineItem(
                        'Documents Uploaded',
                        '', // _getDocumentUploadDate(student),
                        '${student.documents.length} documents submitted',
                        student.documents.isNotEmpty
                            ? Colors.green
                            : Colors.grey,
                        student.documents.isNotEmpty,
                      ),
                      _buildTimelineItem(
                        'Application Submitted',
                        student.status == 'Applied' ||
                                student.status == 'Admission Approved' ||
                                student.status == 'Reverted'
                            ? student.appliedDate.toIso8601String()
                            : '',
                        'Forwarded to university',
                        student.status != 'Lead' ? Colors.orange : Colors.grey,
                        student.status != 'Lead',
                      ),
                      _buildTimelineItem(
                        'University Review',
                        student.status == 'Admission Approved' ||
                                student.status == 'Reverted' ||
                                student.status == 'Rejected'
                            ? student.appliedDate.toIso8601String()
                            : '',
                        'Under verification',
                        student.status == 'Admission Approved' ||
                                student.status == 'Reverted' ||
                                student.status == 'Rejected'
                            ? Colors.purple
                            : Colors.grey,
                        student.status == 'Admission Approved' ||
                            student.status == 'Reverted' ||
                            student.status == 'Rejected',
                      ),
                      _buildTimelineItem(
                        'Admission Approved',
                        student.status == 'Admission Approved'
                            ? student.appliedDate.toIso8601String()
                            : '',
                        'Admission confirmed',
                        student.status == 'Admission Approved'
                            ? Colors.green
                            : Colors.grey,
                        student.status == 'Admission Approved',
                        isLast: true,
                      ),

                      if (student.status == 'Reverted') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Action Required',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.universityRemarks ??
                                          'Please correct the application',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (student.status == 'Rejected') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[900]!.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[900]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Application Rejected',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.universityRemarks ??
                                          'Application declined',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String date,
    String description,
    Color color,
    bool isActive, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? color : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isActive ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isActive
                    ? color.withValues(alpha: 0.3)
                    : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? color : Colors.grey,
                ),
              ),
              if (date.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.grey[700] : Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Admission Approved':
        return Colors.green;
      case 'Applied':
        return Colors.orange;
      case 'Reverted':
        return Colors.red;
      case 'Rejected':
        return Colors.red[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget _buildMiniCard(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
          const SizedBox(height: 3),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getStatusCount(String status) {
    if (status == 'All') return _allStudents.length;
    return _allStudents.where((s) => s.status == status).length;
  }

  // Filter Logic
  List<Student> get _filteredStudents {
    return _allStudents.where((s) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.id.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_tabController.index == 0) return matchesSearch;

      String statusFilter = '';
      switch (_tabController.index) {
        case 1:
          statusFilter = 'Lead';
          break;
        case 2:
          statusFilter = 'Applied';
          break;
        case 3:
          statusFilter = 'Admission Approved';
          break;
        case 4:
          statusFilter = 'Rejected'; // Or Reverted, need to check tabs
          break;
      }

      // Tab 4 in original code was 'Rejected' & 'Reverted' in switch?
      // Checking tabs: All, Leads, Applied, Approved, Rejected.
      // So index 4 is Rejected.

      return s.status == statusFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, size: 16),
                  const SizedBox(width: 6),
                  Text('All (${_getStatusCount('All')})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.hourglass_empty, size: 16),
                  const SizedBox(width: 6),
                  Text('Applied (${_getStatusCount('Applied')})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Admission Approved (${_getStatusCount('Admission Approved')})',
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, size: 16),
                  const SizedBox(width: 6),
                  Text('Reverted (${_getStatusCount('Reverted')})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cancel, size: 16),
                  const SizedBox(width: 6),
                  Text('Rejected (${_getStatusCount('Rejected')})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    _allStudents.length.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Approved',
                    _getStatusCount('Admission Approved').toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Applied',
                    _getStatusCount('Applied').toString(),
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Reverted',
                    _getStatusCount('Reverted').toString(),
                    Icons.refresh,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by name, ID, or mobile...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(5, (_) => _buildStudentList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final students = _filteredStudents;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (students.isEmpty) {
      return const Center(child: Text('No students found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) => _buildStudentCard(students[index]),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(student.status).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(student.status).withValues(alpha: 0.1),
                  _getStatusColor(student.status).withValues(alpha: 0.03),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getStatusColor(student.status),
                        _getStatusColor(student.status).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.id,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getStatusColor(student.status).withValues(alpha: 0.15),
                        _getStatusColor(student.status).withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(
                        student.status,
                      ).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    student.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(student.status),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Info
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(student.mobile, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      student.registeredDate.toIso8601String().split(
                        'T',
                      )[0], // Display date only
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Course & University
                Row(
                  children: [
                    Icon(Icons.school, size: 14, color: AppTheme.primaryBlue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        student.courseName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        student.universityName ?? 'Unknown University',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Additional Info
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.book, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            student.mode ?? 'Regular',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            student.city ?? 'Unknown City',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              student.agentName ?? 'Direct',
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Fee Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniCard(
                        'Total',
                        '₹${(student.totalFee / 1000).toStringAsFixed(0)}K',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMiniCard(
                        'Paid',
                        '₹${(student.paidAmount / 1000).toStringAsFixed(0)}K',
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMiniCard(
                        'Pending',
                        '₹${(student.pendingAmount / 1000).toStringAsFixed(0)}K',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),

                // Documents Status
                if (student.documents.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.folder,
                        size: 14,
                        color: student.documentsVerified
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${student.documents.length} docs uploaded',
                        style: TextStyle(
                          fontSize: 11,
                          color: student.documentsVerified
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      if (student.documentsVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          size: 14,
                          color: Colors.green,
                        ),
                      ],
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                // Action Buttons Row 1
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewStudent(student),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text(
                          'View',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                          ),
                          foregroundColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _trackApplication(student),
                        icon: const Icon(Icons.track_changes, size: 16),
                        label: const Text(
                          'Track',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Action Buttons Row 2
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editStudent(student),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                          ),
                          foregroundColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (student.status == 'Lead')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _deleteStudent(student),
                          icon: const Icon(Icons.delete_outline, size: 16),
                          label: const Text(
                            'Delete',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (student.status == 'Applied' || student.status == 'Lead')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _forwardToUniversity(student),
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text(
                            'Forward',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    if (student.status == 'Admission Approved')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Downloading Admission Slip...'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text(
                            'Admission Slip',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
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
  }
}

// Student Details View Widget - Complete admission form view
class _StudentDetailsView extends StatelessWidget {
  final Student student;

  const _StudentDetailsView({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // University Remarks Banner (if any)
            if (student.universityRemarks?.isNotEmpty ?? false)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'University Remarks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            student.universityRemarks ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Student ID Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, Color(0xFF1565C0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.id,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.courseName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Basic Information
            _buildSection('Basic Information', Icons.person_outline, [
              _buildRow('Full Name', student.name),
              _buildRow('Father Name', student.fatherName ?? 'N/A'),
              _buildRow('Mother Name', student.motherName ?? 'N/A'),
              _buildRow('Mobile Number', student.mobile),
              _buildRow('Email', student.email),
              _buildRow('Date of Birth', student.dob ?? 'N/A'),
              _buildRow('Gender', student.gender ?? 'N/A'),
              _buildRow('Category', student.category ?? 'N/A'),
            ]),

            const SizedBox(height: 16),

            // Address
            _buildSection('Address Details', Icons.location_on_outlined, [
              _buildRow('Address', student.address ?? 'N/A'),
              _buildRow('City', student.city ?? 'N/A'),
              _buildRow('State', student.state ?? 'N/A'),
              _buildRow('Pincode', student.pincode ?? 'N/A'),
            ]),

            const SizedBox(height: 16),

            // Academic Details
            _buildSection('Academic Details', Icons.school_outlined, [
              const Text(
                '10th Standard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              _buildRow('Board/University', student.tenthBoard ?? 'N/A'),
              _buildRow('Marks/Percentage', student.tenthMarks ?? 'N/A'),
              _buildRow('Passing Year', student.tenthYear ?? 'N/A'),
              const Divider(height: 24),
              const Text(
                '12th Standard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              _buildRow('Board/University', student.twelfthBoard ?? 'N/A'),
              _buildRow('Marks/Percentage', student.twelfthMarks ?? 'N/A'),
              _buildRow('Passing Year', student.twelfthYear ?? 'N/A'),
            ]),

            const SizedBox(height: 16),

            // Course & University
            _buildSection('Course & University', Icons.business_outlined, [
              _buildRow('Course', student.courseName),
              _buildRow('University', student.universityName ?? 'N/A'),
              _buildRow('Mode', student.mode ?? 'N/A'),
              _buildRow('Duration', student.duration ?? 'N/A'),
              _buildRow('Added By', student.addedBy ?? 'N/A'),
              _buildRow('Agent', student.agentName ?? 'N/A'),
              _buildRow('Status', student.status),
              _buildRow(
                'Registered Date',
                student.registeredDate.toIso8601String().split('T')[0],
              ),
            ]),

            const SizedBox(height: 16),

            // Fee Management
            _buildSection(
              'Fee Management',
              Icons.account_balance_wallet_outlined,
              [
                Row(
                  children: [
                    Expanded(
                      child: _buildFeeCard(
                        'Total Fee',
                        '₹${student.totalFee}',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeeCard(
                        'Paid',
                        '₹${student.paidAmount}',
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeeCard(
                        'Pending',
                        '₹${student.pendingAmount}',
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeeCard(
                        'Commission',
                        '₹${student.consultantShare}',
                        AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
                if (student.utrNumber?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  _buildRow('UTR Number', student.utrNumber!),
                  _buildRow('Payment Status', student.paymentStatus ?? 'N/A'),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Documents
            _buildSection('Documents Submitted', Icons.upload_file, [
              _buildDocStatus(
                '10th Marksheet',
                student.documents.contains('10th'),
              ),
              _buildDocStatus(
                '12th Marksheet',
                student.documents.contains('12th'),
              ),
              _buildDocStatus(
                'Transfer Certificate',
                student.documents.contains('TC'),
              ),
              _buildDocStatus(
                'Aadhar Card',
                student.documents.contains('Aadhar'),
              ),
              _buildDocStatus(
                'Passport Photo',
                student.documents.contains('Photo'),
              ),
              _buildDocStatus(
                'Migration Certificate',
                student.documents.contains('Migration'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    student.documentsVerified ? Icons.verified : Icons.pending,
                    color: student.documentsVerified
                        ? Colors.green
                        : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    student.documentsVerified
                        ? 'All documents verified'
                        : 'Verification pending',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: student.documentsVerified
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 16),

            // Remarks
            _buildSection('Remarks', Icons.note_outlined, [
              Text(
                student.remarks ?? 'No remarks',
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            ]),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
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

  Widget _buildFeeCard(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(
            amount,
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

  Widget _buildDocStatus(String name, bool uploaded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            uploaded ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: uploaded ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: uploaded
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              uploaded ? 'Uploaded' : 'Missing',
              style: TextStyle(
                fontSize: 10,
                color: uploaded ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Edit Student Form Widget - Complete editable admission form
class _EditStudentForm extends StatefulWidget {
  final Student student;
  final Function(Map<String, dynamic>) onSave;

  const _EditStudentForm({required this.student, required this.onSave});

  @override
  State<_EditStudentForm> createState() => _EditStudentFormState();
}

class _EditStudentFormState extends State<_EditStudentForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _motherNameController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _tenthBoardController;
  late TextEditingController _tenthMarksController;
  late TextEditingController _tenthYearController;
  late TextEditingController _twelfthBoardController;
  late TextEditingController _twelfthMarksController;
  late TextEditingController _twelfthYearController;
  late TextEditingController _remarksController;

  String _gender = 'Male';
  String _category = 'General';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _fatherNameController = TextEditingController(
      text: widget.student.fatherName ?? '',
    );
    _motherNameController = TextEditingController(
      text: widget.student.motherName ?? '',
    );
    _mobileController = TextEditingController(text: widget.student.mobile);
    _emailController = TextEditingController(text: widget.student.email);
    _dobController = TextEditingController(text: widget.student.dob ?? '');
    _addressController = TextEditingController(
      text: widget.student.address ?? '',
    );
    _cityController = TextEditingController(text: widget.student.city ?? '');
    _stateController = TextEditingController(text: widget.student.state ?? '');
    _pincodeController = TextEditingController(
      text: widget.student.pincode ?? '',
    );
    _tenthBoardController = TextEditingController(
      text: widget.student.tenthBoard ?? '',
    );
    _tenthMarksController = TextEditingController(
      text: widget.student.tenthMarks?.toString() ?? '',
    );
    _tenthYearController = TextEditingController(
      text: widget.student.tenthYear?.toString() ?? '',
    );
    _twelfthBoardController = TextEditingController(
      text: widget.student.twelfthBoard ?? '',
    );
    _twelfthMarksController = TextEditingController(
      text: widget.student.twelfthMarks?.toString() ?? '',
    );
    _twelfthYearController = TextEditingController(
      text: widget.student.twelfthYear?.toString() ?? '',
    );
    _remarksController = TextEditingController(
      text: widget.student.remarks ?? '',
    );
    _gender = widget.student.gender ?? 'Male';
    _category = widget.student.category ?? 'General';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _tenthBoardController.dispose();
    _tenthMarksController.dispose();
    _tenthYearController.dispose();
    _twelfthBoardController.dispose();
    _twelfthMarksController.dispose();
    _twelfthYearController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Information Section
            _buildSectionTitle('Basic Information', Icons.person_outline),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Full Name *', Icons.person),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _fatherNameController,
              decoration: _inputDecoration('Father Name', Icons.person),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _motherNameController,
              decoration: _inputDecoration('Mother Name', Icons.person),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _mobileController,
              decoration: _inputDecoration('Mobile Number *', Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email', Icons.email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _dobController,
              decoration: _inputDecoration(
                'Date of Birth (DD/MM/YYYY)',
                Icons.calendar_today,
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: _inputDecoration('Gender', Icons.wc),
              items: [
                'Male',
                'Female',
                'Other',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: _inputDecoration('Category', Icons.category),
              items: [
                'General',
                'OBC',
                'SC',
                'ST',
                'EWS',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),

            const SizedBox(height: 24),

            // Address Section
            _buildSectionTitle('Address Details', Icons.location_on_outlined),
            const SizedBox(height: 12),

            TextFormField(
              controller: _addressController,
              decoration: _inputDecoration('Full Address', Icons.home),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _cityController,
              decoration: _inputDecoration('City', Icons.location_city),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _stateController,
              decoration: _inputDecoration('State', Icons.map),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _pincodeController,
              decoration: _inputDecoration('Pincode', Icons.pin_drop),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // Academic Details Section
            _buildSectionTitle('Academic Details', Icons.school_outlined),
            const SizedBox(height: 12),

            const Text(
              '10th Standard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _tenthBoardController,
              decoration: _inputDecoration('Board/University', Icons.school),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tenthMarksController,
                    decoration: _inputDecoration('Marks %', Icons.grade),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _tenthYearController,
                    decoration: _inputDecoration('Year', Icons.calendar_today),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              '12th Standard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _twelfthBoardController,
              decoration: _inputDecoration('Board/University', Icons.school),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _twelfthMarksController,
                    decoration: _inputDecoration('Marks %', Icons.grade),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _twelfthYearController,
                    decoration: _inputDecoration('Year', Icons.calendar_today),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Course Info (Read-only)
            _buildSectionTitle(
              'Course & University (Read-only)',
              Icons.business_outlined,
            ),
            const SizedBox(height: 12),

            _buildReadOnlyField('Course', widget.student.courseName),
            const SizedBox(height: 12),
            _buildReadOnlyField(
              'University',
              widget.student.universityName ?? 'N/A',
            ),
            const SizedBox(height: 12),
            _buildReadOnlyField('Status', widget.student.status),

            const SizedBox(height: 24),

            // Remarks
            _buildSectionTitle('Remarks', Icons.note_outlined),
            const SizedBox(height: 12),

            TextFormField(
              controller: _remarksController,
              decoration: _inputDecoration('Add Remarks', Icons.comment),
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Documents Status (Read-only)
            _buildSectionTitle('Documents Status', Icons.folder),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  _buildDocRow(
                    '10th Marksheet',
                    widget.student.documents.contains('10th'),
                  ),
                  _buildDocRow(
                    '12th Marksheet',
                    widget.student.documents.contains('12th'),
                  ),
                  _buildDocRow(
                    'Transfer Certificate',
                    widget.student.documents.contains('TC'),
                  ),
                  _buildDocRow(
                    'Aadhar Card',
                    widget.student.documents.contains('Aadhar'),
                  ),
                  _buildDocRow(
                    'Passport Photo',
                    widget.student.documents.contains('Photo'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave({
                    'name': _nameController.text,
                    'father_name': _fatherNameController.text,
                    'mother_name': _motherNameController.text,
                    'mobile': _mobileController.text,
                    'email': _emailController.text,
                    'dob': _dobController.text,
                    'gender': _gender,
                    'category': _category,
                    'address': _addressController.text,
                    'city': _cityController.text,
                    'state': _stateController.text,
                    'pincode': _pincodeController.text,
                    '10th_board': _tenthBoardController.text,
                    '10th_marks': _tenthMarksController.text,
                    '10th_year': _tenthYearController.text,
                    '12th_board': _twelfthBoardController.text,
                    '12th_marks': _twelfthMarksController.text,
                    '12th_year': _twelfthYearController.text,
                    'remarks': _remarksController.text,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Student updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save, size: 20),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: const OutlineInputBorder(),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDocRow(String name, bool uploaded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            uploaded ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: uploaded ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          Text(
            uploaded ? 'Uploaded' : 'Missing',
            style: TextStyle(
              fontSize: 10,
              color: uploaded ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
