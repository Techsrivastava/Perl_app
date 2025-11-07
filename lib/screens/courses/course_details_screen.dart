import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/status_badge.dart';
import 'package:university_app_2/models/course_model.dart';
import 'package:intl/intl.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course? course;

  const CourseDetailsScreen({Key? key, this.course}) : super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.course?.isActive ?? true;
  }

  void _toggleActiveStatus() {
    setState(() {
      _isActive = !_isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isActive ? 'Course activated successfully' : 'Course deactivated successfully',
          style: const TextStyle(fontSize: 12),
        ),
        backgroundColor: _isActive ? AppTheme.success : AppTheme.warning,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    // ✅ Handle null course (prevent crash)
    if (widget.course == null) {
      return Scaffold(
        backgroundColor: AppTheme.lightGray,
        appBar: const AppHeader(title: "Course Details"),
        body: const Center(
          child: Text(
            "No course data found.\nPlease go back and select a course.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: "Course Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.white, AppTheme.lightGray.withAlpha(100)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.course!.name ?? "Course Name",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.charcoal,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.course!.code ?? "NA"} • ${widget.course!.department ?? "NA"}',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11 : 13,
                                  color: AppTheme.mediumGray,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            StatusBadge(
                              status: widget.course!.status ?? "Draft",
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _isActive ? Colors.green.shade50 : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _isActive ? Colors.green : Colors.orange,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _isActive ? Colors.green.shade700 : Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        buildInfoChip(
                          Icons.timelapse_rounded,
                          widget.course!.duration ?? "NA",
                          isSmallScreen,
                        ),
                        buildInfoChip(
                          Icons.school_rounded,
                          widget.course!.degreeType ?? "NA",
                          isSmallScreen,
                        ),
                        buildInfoChip(
                          Icons.people_alt_rounded,
                          "${widget.course!.availableSeats ?? 0}/${widget.course!.totalSeats ?? 0} seats",
                          isSmallScreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "\$${NumberFormat("#,0").format(widget.course!.fees ?? 0)}/year",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Wrap(
                          spacing: 4,
                          children: [
                            if (widget.course!.scholarshipAvailable ?? false)
                              buildTag(
                                "Scholarship",
                                AppTheme.warning,
                                Icons.card_giftcard_rounded,
                              ),
                            if (widget.course!.placementSupport ?? false)
                              buildTag(
                                "Placement",
                                AppTheme.success,
                                Icons.work_rounded,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Active/Inactive Toggle Card
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 100),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Course Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.charcoal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isActive ? 'Currently Active' : 'Currently Inactive',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isActive ? AppTheme.success : AppTheme.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.9,
                        child: Switch(
                          value: _isActive,
                          onChanged: (value) => _toggleActiveStatus(),
                          activeColor: AppTheme.success,
                          inactiveThumbColor: AppTheme.warning,
                          inactiveTrackColor: AppTheme.warning.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 200),
              child: buildInfoSection(
                title: "Course Information",
                isSmallScreen: isSmallScreen,
                children: [
                  buildInfoRow("Mode of Study", widget.course!.modeOfStudy ?? "NA"),
                  buildInfoRow("Level", widget.course!.level ?? "NA"),
                  buildInfoRow(
                    "Total Seats",
                    (widget.course!.totalSeats ?? 0).toString(),
                  ),
                  buildInfoRow(
                    "Available Seats",
                    (widget.course!.availableSeats ?? 0).toString(),
                  ),
                  buildInfoRow(
                    "Status",
                    (widget.course!.isActive ?? false) ? "Active" : "Inactive",
                  ),
                ],
              ),
            ),
            if (widget.course!.description != null && widget.course!.description!.isNotEmpty)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 300),
                child: buildInfoSection(
                  title: "Description",
                  isSmallScreen: isSmallScreen,
                  children: [
                    Text(
                      widget.course!.description!,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: AppTheme.charcoal,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.course!.eligibility != null && widget.course!.eligibility!.isNotEmpty)
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 400),
                child: buildInfoSection(
                  title: "Eligibility Criteria",
                  isSmallScreen: isSmallScreen,
                  children: widget.course!.eligibility!
                      .map(
                        (criteria) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppTheme.success,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  criteria,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 11 : 12,
                                    color: AppTheme.charcoal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 500),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: isSmallScreen ? 150 : 160,
                      child: CustomButton(
                        label: "Edit",
                        variant: ButtonVariant.secondary,
                        onPressed: () {},
                        icon: Icons.edit_rounded,
                      ),
                    ),
                    SizedBox(
                      width: isSmallScreen ? 150 : 160,
                      child: CustomButton(
                        label: "Delete",
                        variant: ButtonVariant.danger,
                        onPressed: () {
                          showDeleteConfirmation(context);
                        },
                        icon: Icons.delete_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildInfoChip(IconData icon, String text, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightGray.withAlpha(180),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 10 : 12,
            color: AppTheme.primaryBlue,
          ),
          SizedBox(width: isSmallScreen ? 2 : 3),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallScreen ? 9 : 10,
                color: AppTheme.charcoal,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTag(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 3),
          Text(
            text,
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

  void showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Course"),
        content: const Text(
          "Are you sure you want to delete this course? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Course deleted successfully"),
                  backgroundColor: Colors.green.shade400,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget buildInfoSection({
    required String title,
    required List<Widget> children,
    required bool isSmallScreen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.charcoal,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          ...children,
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.charcoal,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}