import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/models/stream_model.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  List<Course> _courses = [];
  Course? _selectedCourse;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data with streams
    final courses = [
      Course(
        id: '1',
        name: 'Bachelor of Technology',
        abbreviation: 'B.Tech',
        code: 'BTECH01',
        status: 'published',
        department: 'Engineering',
        duration: '4 years',
        totalSeats: 120,
        availableSeats: 45,
        streams: [
          CourseStream(
            id: 's1',
            courseId: '1',
            name: 'Computer Science Engineering',
            abbreviation: 'CSE',
            totalSeats: 60,
            availableSeats: 20,
            status: 'published',
            subjects: ['Data Structures', 'Algorithms', 'Database Systems'],
          ),
          CourseStream(
            id: 's2',
            courseId: '1',
            name: 'Mechanical Engineering',
            abbreviation: 'ME',
            totalSeats: 60,
            availableSeats: 25,
            status: 'draft',
            subjects: ['Thermodynamics', 'Fluid Mechanics', 'Machine Design'],
          ),
        ],
      ),
      Course(
        id: '2',
        name: 'Master of Business Administration',
        abbreviation: 'MBA',
        code: 'MBA01',
        status: 'draft',
        department: 'Business',
        duration: '2 years',
        totalSeats: 60,
        availableSeats: 30,
        streams: [
          CourseStream(
            id: 's3',
            courseId: '2',
            name: 'Finance',
            abbreviation: 'FIN',
            totalSeats: 30,
            availableSeats: 15,
            status: 'published',
            subjects: ['Financial Management', 'Investment Analysis'],
          ),
          CourseStream(
            id: 's4',
            courseId: '2',
            name: 'Marketing',
            abbreviation: 'MKT',
            totalSeats: 30,
            availableSeats: 15,
            status: 'published',
            subjects: ['Digital Marketing', 'Brand Management'],
          ),
        ],
      ),
      Course(
        id: '3',
        name: 'Bachelor of Computer Applications',
        abbreviation: 'BCA',
        code: 'BCA01',
        status: 'published',
        department: 'Computer Science',
        duration: '3 years',
        totalSeats: 90,
        availableSeats: 35,
        streams: [],
      ),
    ];
    
    setState(() {
      _courses = courses;
      _isLoading = false;
    });
  }

  void _toggleCourseStatus(Course course) {
    setState(() {
      final index = _courses.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        _courses[index] = course.isDraft ? course.publish() : course.saveToDraft();
        if (_selectedCourse?.id == course.id) {
          _selectedCourse = _courses[index];
        }
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(course.isDraft ? 'Course published successfully!' : 'Course saved as draft'),
        backgroundColor: course.isDraft ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleStreamStatus(CourseStream stream) {
    setState(() {
      if (_selectedCourse != null) {
        final updatedStreams = _selectedCourse!.streams?.map((s) {
          if (s.id == stream.id) {
            return stream.copyWith(
              status: stream.isDraft ? 'published' : 'draft',
            );
          }
          return s;
        }).toList();
        
        final courseIndex = _courses.indexWhere((c) => c.id == _selectedCourse!.id);
        if (courseIndex != -1) {
          _courses[courseIndex] = _courses[courseIndex].copyWith(streams: updatedStreams);
          _selectedCourse = _courses[courseIndex];
        }
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(stream.isDraft ? 'Stream published successfully!' : 'Stream saved as draft'),
        backgroundColor: stream.isDraft ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editCourse(Course course) {
    // Navigate to course edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course edit screen - Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editStream(CourseStream stream) {
    // Navigate to stream edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stream edit screen - Coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Course Management'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add new course - Coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Add Course',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Left Panel - Course List
                Expanded(
                  flex: 2,
                  child: _buildCourseList(),
                ),
                
                // Divider
                const VerticalDivider(width: 1, thickness: 1),
                
                // Right Panel - Stream List
                Expanded(
                  flex: 3,
                  child: _buildStreamPanel(),
                ),
              ],
            ),
    );
  }

  Widget _buildCourseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Courses (${_courses.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              final course = _courses[index];
              final isSelected = _selectedCourse?.id == course.id;
              
              return _buildCourseCard(course, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(Course course, bool isSelected) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCourse = _selectedCourse?.id == course.id ? null : course;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course name with abbreviation
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      course.abbreviation ?? course.code ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      course.name ?? 'Unnamed Course',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Status and streams count
              Row(
                children: [
                  _buildStatusBadge(course.status ?? 'draft'),
                  const SizedBox(width: 8),
                  if (course.streams != null && course.streams!.isNotEmpty) ...[
                    Icon(Icons.category, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${course.streams!.length} ${course.streams!.length == 1 ? 'Stream' : 'Streams'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editCourse(course),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: AppTheme.primaryBlue),
                        foregroundColor: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleCourseStatus(course),
                      icon: Icon(
                        course.isDraft ? Icons.publish : Icons.drafts,
                        size: 16,
                      ),
                      label: Text(
                        course.isDraft ? 'Publish' : 'Draft',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: course.isDraft ? Colors.green : Colors.orange,
                        foregroundColor: Colors.white,
                      ),
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

  Widget _buildStreamPanel() {
    if (_selectedCourse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Select a course to view its streams',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    final streams = _selectedCourse!.streams ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCourse!.name ?? 'Course',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Streams (${streams.length})',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryBlue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add new stream - Coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                tooltip: 'Add Stream',
              ),
            ],
          ),
        ),
        
        Expanded(
          child: streams.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No streams available',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add new stream - Coming soon!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Stream'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: streams.length,
                  itemBuilder: (context, index) {
                    return _buildStreamCard(streams[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStreamCard(CourseStream stream) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              stream.isPublished ? Colors.green.shade50 : Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with abbreviation and status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    stream.abbreviation,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(stream.status),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Stream name
            Text(
              stream.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.charcoal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            // Seats info
            Row(
              children: [
                Icon(Icons.event_seat, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${stream.availableSeats}/${stream.totalSeats}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _editStream(stream),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: BorderSide(color: AppTheme.primaryBlue),
                      foregroundColor: AppTheme.primaryBlue,
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleStreamStatus(stream),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      backgroundColor: stream.isDraft ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      stream.isDraft ? 'Publish' : 'Draft',
                      style: const TextStyle(fontSize: 11),
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

  Widget _buildStatusBadge(String status) {
    final isDraft = status == 'draft';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDraft ? Colors.orange.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDraft ? Icons.edit_note : Icons.check_circle,
            size: 12,
            color: isDraft ? Colors.orange.shade700 : Colors.green.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isDraft ? 'Draft' : 'Published',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDraft ? Colors.orange.shade700 : Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
