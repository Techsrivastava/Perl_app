import 'dart:async';
import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/status_badge.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/screens/courses/comprehensive_add_course_screen.dart';
import 'package:university_app_2/screens/courses/course_details_screen.dart';
import 'package:intl/intl.dart';

class CoursesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const CoursesScreen({super.key, this.scaffoldKey});
  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final mockData = MockDataService(); 
  late List<Course> _allCourses;
  List<Course> _filteredCourses = [];

  String _searchQuery = '';
  String _selectedDepartment = 'All';

  // Debounce search
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _allCourses = mockData.courses;
    _filterCourses();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _filterCourses() {
    final query = _searchQuery.toLowerCase();
    final filtered = _allCourses.where((course) {
      final matchesSearch = course.name?.toLowerCase().contains(query) == true ||
          course.code?.toLowerCase().contains(query) == true;
      final matchesDept = _selectedDepartment == 'All' || course.department == _selectedDepartment;
      return matchesSearch && matchesDept;
    }).toList();

    setState(() => _filteredCourses = filtered);
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _filterCourses);
  }

  void _onDepartmentChanged(String dept) {
    _selectedDepartment = dept;
    _filterCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredCourses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding / 1.5,
                        vertical: 6,
                      ),
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        return _buildCourseCard(_filteredCourses[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComprehensiveAddCourseScreen())),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: AppTheme.white, size: 20),
        label: const Text('Add Course', style: TextStyle(color: AppTheme.white)),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding / 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue.withOpacity(0.15), AppTheme.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          AppHeader(
            title: 'Courses',
            showBackButton: false,
            showDrawer: true,
            scaffoldKey: widget.scaffoldKey,
          ),
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildDepartmentFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courses...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.mediumGray),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.mediumGray),
                  onPressed: () {
                    _searchQuery = '';
                    _filterCourses();
                  },
                )
              : null,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildDepartmentFilter() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ['All', ...AppConstants.indianDepartments].map((dept) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(dept, style: const TextStyle(fontSize: 13)),
              selected: _selectedDepartment == dept,
              onSelected: (_) => _onDepartmentChanged(dept),
              selectedColor: AppTheme.primaryBlue.withOpacity(0.3),
              backgroundColor: AppTheme.lightGray,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              avatar: dept == 'All' ? const Icon(Icons.apps_rounded, size: 14, color: AppTheme.primaryBlue) : null,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty_rounded, size: 48, color: AppTheme.mediumGray),
          SizedBox(height: 12),
          Text('No courses found', style: TextStyle(fontSize: 16, color: AppTheme.mediumGray)),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailsScreen(course: course))),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      course.name ?? 'Untitled Course',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.charcoal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(status: (course.isActive ?? true) ? 'Active' : 'Inactive'),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${course.code ?? 'N/A'} • ${course.department ?? 'N/A'}',
                style: const TextStyle(fontSize: 12, color: AppTheme.mediumGray),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildInfoChip(Icons.timelapse_rounded, course.duration ?? 'N/A'),
                  _buildInfoChip(Icons.school_rounded, course.degreeType ?? 'N/A'),
                  _buildInfoChip(Icons.people_alt_rounded, '${course.availableSeats ?? 0}/${course.totalSeats ?? 0} seats'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "\$${NumberFormat('#,##0').format(course.fees ?? 0)}/year",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (course.scholarshipAvailable == true)
                        const Padding(padding: EdgeInsets.only(right: 6), child: Icon(Icons.card_giftcard_rounded, color: AppTheme.warning, size: 18)),
                      if (course.placementSupport == true)
                        const Icon(Icons.work_rounded, color: AppTheme.success, size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailsScreen(course: course))),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('View Details', style: TextStyle(fontSize: 13)),
                  ),
                  const SizedBox(width: 4),
                  // FIXED: No `size` param
                  CustomButton(
                    label: 'Edit',
                    variant: ButtonVariant.secondary,
                    onPressed: () {},
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lightGray.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryBlue),
          const SizedBox(width: 4),
          Flexible(child: Text(text, style: const TextStyle(fontSize: 11, color: AppTheme.charcoal), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}