import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/status_badge.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:university_app_2/screens/courses/add_course_screen.dart';
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
  String _searchQuery = '';
  String _selectedDepartment = 'All';

  @override
  Widget build(BuildContext context) {
    final courses = mockData.courses;
    final filteredCourses = courses.where((course) {
      final matchesSearch =
          course.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
              true ||
          course.code?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
              true;
      final matchesDepartment =
          _selectedDepartment == 'All' ||
          course.department == _selectedDepartment;
      return matchesSearch && matchesDepartment;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryBlue.withOpacity(0.15),
                      AppTheme.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      AppHeader(
                        title: 'Courses',
                        showBackButton: false,
                        showDrawer: true,
                        scaffoldKey: widget.scaffoldKey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.defaultPadding / 1.5,
                        ),
                        child: Column(
                          children: [
                            // Modern Search Bar with shadow
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search courses...',
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: AppTheme.mediumGray,
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear,
                                            color: AppTheme.mediumGray,
                                          ),
                                          onPressed: () =>
                                              setState(() => _searchQuery = ''),
                                        )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: AppTheme.primaryBlue,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Department Filter as Chips with icons
                            SizedBox(
                              height: 36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: ['All', ...AppConstants.indianDepartments]
                                    .map((dept) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6,
                                        ),
                                        child: FilterChip(
                                          label: Text(
                                            dept,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          selected: _selectedDepartment == dept,
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedDepartment = selected
                                                  ? dept
                                                  : 'All';
                                            });
                                          },
                                          selectedColor: AppTheme.primaryBlue
                                              .withOpacity(0.3),
                                          backgroundColor: AppTheme.lightGray,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                          avatar: dept == 'All'
                                              ? const Icon(
                                                  Icons.apps_rounded,
                                                  size: 14,
                                                  color: AppTheme.primaryBlue,
                                                )
                                              : null,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (filteredCourses.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty_rounded,
                          size: 48,
                          color: AppTheme.mediumGray,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No courses found',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final course = filteredCourses[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCourseCard(context, course),
                );
              },
              childCount: filteredCourses.isEmpty ? 1 : filteredCourses.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourseScreen()),
          );
        },
        backgroundColor: AppTheme.primaryBlue,
        elevation: 6,
        shape: const CircleBorder(),
        mini: true,
        child: const Icon(Icons.add_rounded, color: AppTheme.white, size: 20),
      ),
    );
  }

  //Data base aquirr space for multiple item

  Widget _buildCourseCard(BuildContext context, Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding / 1.5,
        vertical: 6,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsScreen(course: course),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      course.name ?? 'Untitled Course',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.charcoal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  StatusBadge(
                    status: (course.isActive ?? true) ? 'Active' : 'Inactive',
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${course.code ?? 'N/A'} • ${course.department ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGray,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildInfoChip(
                    Icons.timelapse_rounded,
                    course.duration ?? 'N/A',
                  ),
                  _buildInfoChip(
                    Icons.school_rounded,
                    course.degreeType ?? 'N/A',
                  ),
                  _buildInfoChip(
                    Icons.people_alt_rounded,
                    '${course.availableSeats ?? 0}/${course.totalSeats ?? 0} seats',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "\$${NumberFormat('#,##0').format(course.fees ?? 0)}/year",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (course.scholarshipAvailable == true)
                        const Icon(
                          Icons.card_giftcard_rounded,
                          color: AppTheme.warning,
                          size: 18,
                        ),
                      const SizedBox(width: 6),
                      if (course.placementSupport == true)
                        const Icon(
                          Icons.work_rounded,
                          color: AppTheme.success,
                          size: 18,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 6,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsScreen(course: course),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  CustomButton(
                    label: 'Edit',
                    variant: ButtonVariant.secondary,
                    onPressed: () {
                      // Navigate to edit course
                    },
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryBlue),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: AppTheme.charcoal),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
