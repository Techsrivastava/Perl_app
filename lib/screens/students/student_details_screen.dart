import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/config/constants.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/custom_button.dart';
import 'package:university_app_2/widgets/status_badge.dart';
import 'package:university_app_2/models/student_model.dart';
import 'package:intl/intl.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: const AppHeader(title: 'Student Details'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Header Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.charcoal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.email,
                                      style: const TextStyle(
                                        fontSize: 14,
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
                            spacing: 8,
                            children: [
                              _buildInfoChip(Icons.phone, student.phone),
                              _buildInfoChip(
                                Icons.calendar_today,
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(student.appliedDate),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Course Information
                  _buildInfoSection(
                    title: 'Course Information',
                    children: [
                      _buildInfoListTile(
                        'Course',
                        student.courseName,
                        Icons.school,
                      ),
                      _buildInfoListTile(
                        'Consultancy',
                        student.consultancyName,
                        Icons.business,
                      ),
                      _buildInfoListTile(
                        'Applied Date',
                        DateFormat('MMMM dd, yyyy').format(student.appliedDate),
                        Icons.calendar_month,
                      ),
                      _buildInfoListTile('Status', student.status, Icons.info),
                    ],
                  ),

                  // Contact Information
                  _buildInfoSection(
                    title: 'Contact Information',
                    children: [
                      _buildInfoListTile('Email', student.email, Icons.email),
                      _buildInfoListTile('Phone', student.phone, Icons.phone),
                    ],
                  ),

                  // Documents Section
                  _buildInfoSection(
                    title: 'Documents',
                    children: [
                      if (student.documents.isEmpty)
                        const ListTile(
                          title: Text(
                            'No documents uploaded',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.mediumGray,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      else
                        ...student.documents.map(
                          (doc) => ListTile(
                            leading: const Icon(
                              Icons.description,
                              color: AppTheme.primaryBlue,
                              size: 16,
                            ),
                            title: Text(
                              doc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.charcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                // Handle document download
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Downloading $doc...'),
                                    backgroundColor: AppTheme.primaryBlue,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.download,
                                color: AppTheme.primaryBlue,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Action Buttons
                  const SizedBox(height: 16),

                  if (student.status == AppConstants.statusPending)
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              _showStatusUpdateDialog(
                                context,
                                AppConstants.statusRejected,
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              _showStatusUpdateDialog(
                                context,
                                AppConstants.statusApproved,
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.success,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Approve'),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Navigate to edit student
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppTheme.primaryBlue,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              // Handle send email
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email sent successfully'),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Email'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 14, color: AppTheme.mediumGray),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.mediumGray,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      backgroundColor: AppTheme.lightGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoListTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.mediumGray,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.charcoal,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      dense: true,
    );
  }

  void _showStatusUpdateDialog(BuildContext context, String newStatus) {
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
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Update student status (in real app, this would be done through a service)
                // student.status = newStatus;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Application ${newStatus.toLowerCase()} successfully',
                    ),
                    backgroundColor: newStatus == AppConstants.statusApproved
                        ? AppTheme.success
                        : AppTheme.error,
                  ),
                );
                // Navigate back to students list
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: newStatus == AppConstants.statusApproved
                    ? AppTheme.success
                    : AppTheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                newStatus == AppConstants.statusApproved ? 'Approve' : 'Reject',
              ),
            ),
          ],
        );
      },
    );
  }
}
