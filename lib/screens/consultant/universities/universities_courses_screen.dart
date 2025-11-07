import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'course_details_screen.dart';

class UniversitiesCoursesScreen extends StatefulWidget {
  const UniversitiesCoursesScreen({super.key});

  @override
  State<UniversitiesCoursesScreen> createState() => _UniversitiesCoursesScreenState();
}

class _UniversitiesCoursesScreenState extends State<UniversitiesCoursesScreen> {
  String _selectedView = 'courses';
  String _searchQuery = '';
  final List<Map<String, dynamic>> _comparisonList = [];
  final List<int> _favoriteIds = [];

  // Sample courses data
  final List<Map<String, dynamic>> _courses = [
    {
      'id': 4101,
      'university_name': 'MIT University',
      'course_name': 'Bachelor of Computer Applications (BCA)',
      'mode': 'Regular',
      'duration': '3 Years',
      'total_fee': 150000,
      'consultant_share': '15%',
      'location': 'Mumbai, Maharashtra',
      'type': 'University',
      'verified': true,
    },
    {
      'id': 4102,
      'university_name': 'Excellence Education Agency',
      'course_name': 'Master of Business Administration (MBA)',
      'mode': 'Distance',
      'duration': '2 Years',
      'total_fee': 80000,
      'consultant_share': '₹5000',
      'location': 'Delhi, Delhi',
      'type': 'Agency',
      'verified': true,
    },
    {
      'id': 4103,
      'university_name': 'Global Tech University',
      'course_name': 'B.Sc in Data Science',
      'mode': 'Online',
      'duration': '3 Years',
      'total_fee': 120000,
      'consultant_share': '12%',
      'location': 'Bangalore, Karnataka',
      'type': 'University',
      'verified': true,
    },
    {
      'id': 4104,
      'university_name': 'Healthcare Education Hub',
      'course_name': 'Diploma in Nursing',
      'mode': 'Regular',
      'duration': '2 Years',
      'total_fee': 60000,
      'consultant_share': '₹3000',
      'location': 'Pune, Maharashtra',
      'type': 'Agency',
      'verified': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredCourses {
    return _courses.where((course) {
      return course['course_name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course['university_name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTabSelector(),
          if (_selectedView == 'courses') _buildSearchBar(),
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: _selectedView == 'comparison' && _comparisonList.length >= 2
          ? FloatingActionButton.extended(
              onPressed: _showComparisonDialog,
              backgroundColor: AppTheme.primaryBlue,
              icon: const Icon(Icons.compare_arrows),
              label: Text('Compare (${_comparisonList.length})'),
            )
          : null,
    );
  }

  String _getTitle() {
    switch (_selectedView) {
      case 'favorites':
        return 'Favorite Courses';
      case 'comparison':
        return 'Compare Courses';
      default:
        return 'University & Courses';
    }
  }

  Widget _buildTabSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildTab('Courses', 'courses', Icons.book),
          const SizedBox(width: 8),
          _buildTab('Favorites', 'favorites', Icons.favorite, badge: _favoriteIds.length),
          const SizedBox(width: 8),
          _buildTab('Compare', 'comparison', Icons.compare_arrows, badge: _comparisonList.length),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String value, IconData icon, {int? badge}) {
    bool isSelected = _selectedView == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedView = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: isSelected ? Colors.white : Colors.grey[600], size: 20),
                  if (badge != null && badge > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          badge.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search courses...',
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedView) {
      case 'favorites':
        return _buildFavoritesList();
      case 'comparison':
        return _buildComparisonList();
      default:
        return _buildCoursesList();
    }
  }

  Widget _buildCoursesList() {
    final courses = _filteredCourses;
    
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No courses found', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) => _buildCourseCard(courses[index]),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    bool isFavorite = _favoriteIds.contains(course['id']);
    bool inComparison = _comparisonList.any((c) => c['id'] == course['id']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  course['type'] == 'University' ? Icons.school : Icons.business,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['university_name'],
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: course['type'] == 'University' ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          course['type'],
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () => _toggleFavorite(course['id']),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['course_name'],
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Icon(Icons.play_lesson, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(course['mode'], style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                    const SizedBox(width: 16),
                    Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(course['duration'], style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        course['location'],
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Fee', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                            const SizedBox(height: 2),
                            Text(
                              '₹${course['total_fee']}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Share', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                            const SizedBox(height: 2),
                            Text(
                              course['consultant_share'],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewCourseDetails(course),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: AppTheme.primaryBlue),
                      foregroundColor: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _toggleComparison(course),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    side: BorderSide(color: inComparison ? Colors.orange : Colors.grey[300]!),
                    backgroundColor: inComparison ? Colors.orange.withValues(alpha: 0.1) : null,
                    foregroundColor: inComparison ? Colors.orange : Colors.grey[600],
                  ),
                  child: Icon(inComparison ? Icons.compare_arrows : Icons.add_chart, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    final favorites = _courses.where((c) => _favoriteIds.contains(c['id'])).toList();
    
    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No favorite courses yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _selectedView = 'courses'),
              child: const Text('Browse Courses'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) => _buildCourseCard(favorites[index]),
    );
  }

  Widget _buildComparisonList() {
    if (_comparisonList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.compare_arrows, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No courses added for comparison', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Add 2-3 courses to compare', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _selectedView = 'courses'),
              child: const Text('Browse Courses'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _comparisonList.length,
      itemBuilder: (context, index) {
        final course = _comparisonList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['course_name'],
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      course['university_name'],
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _comparisonList.removeAt(index)),
                icon: const Icon(Icons.close, size: 18, color: Colors.red),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
  }

  void _toggleComparison(Map<String, dynamic> course) {
    setState(() {
      if (_comparisonList.any((c) => c['id'] == course['id'])) {
        _comparisonList.removeWhere((c) => c['id'] == course['id']);
      } else {
        if (_comparisonList.length >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 3 courses can be compared')),
          );
        } else {
          _comparisonList.add(course);
        }
      }
    });
  }

  void _viewCourseDetails(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseDetailsScreen(course: course)),
    );
  }

  void _showComparisonDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Course Comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Field')),
                    for (var course in _comparisonList)
                      DataColumn(label: Text(course['course_name'].toString().split('(')[0], 
                        style: const TextStyle(fontSize: 11))),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('University')),
                      for (var course in _comparisonList)
                        DataCell(Text(course['university_name'], style: const TextStyle(fontSize: 11))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Mode')),
                      for (var course in _comparisonList)
                        DataCell(Text(course['mode'], style: const TextStyle(fontSize: 11))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Duration')),
                      for (var course in _comparisonList)
                        DataCell(Text(course['duration'], style: const TextStyle(fontSize: 11))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Fee')),
                      for (var course in _comparisonList)
                        DataCell(Text('₹${course['total_fee']}', style: const TextStyle(fontSize: 11))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Your Share')),
                      for (var course in _comparisonList)
                        DataCell(Text(course['consultant_share'], style: const TextStyle(fontSize: 11))),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
