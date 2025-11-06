import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/widgets/responsive_card.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/utils/responsive_utils.dart';

class DashboardScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DashboardScreen({super.key, this.scaffoldKey});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final MockDataService _mockData;
  late final Map<String, dynamic> _stats;
  late final List<Map<String, dynamic>> _recentActivity;
  
  @override
  void initState() {
    super.initState();
    _mockData = MockDataService();
    _stats = {
      'students': _mockData.students.length,
      'courses': _mockData.courses.length,
      'enrollments': _mockData.students.length, // Each student represents one enrollment
    };
    _recentActivity = [
      {
        'title': 'New Student Enrolled',
        'description': 'John Doe enrolled in Computer Science',
        'type': 'enrollment',
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
      },
      {
        'title': 'New Course Added',
        'description': 'Introduction to Artificial Intelligence',
        'type': 'course',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'title': 'Announcement',
        'description': 'Campus will be closed on Monday',
        'type': 'announcement',
        'time': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'Dashboard',
        showBackButton: false,
        showDrawer: true,
        scaffoldKey: widget.scaffoldKey,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallPhone = screenWidth < 375;
        final isMobile = screenWidth < 600;
        final isTablet = screenWidth < 1200;
        final padding = ResponsiveUtils.getScreenPadding(context);
        final spacing = isSmallPhone ? 12.0 : (isMobile ? 16.0 : 20.0);

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  SizedBox(height: spacing),
                  _buildStatsSection(isSmallPhone, isMobile, isTablet),
                  SizedBox(height: spacing),
                  _buildQuickActions(isSmallPhone, isMobile, isTablet),
                  if (_recentActivity.isNotEmpty) ...[
                    SizedBox(height: spacing),
                    _buildActivitySection(isSmallPhone, isMobile, isTablet),
                  ],
                  SizedBox(height: spacing),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard() {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s what\'s happening with your university today.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isSmallPhone, bool isMobile, bool isTablet) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            _buildMobileStats()
          else
            _buildDesktopStats(),
        ],
      ),
    );
  }

  Widget _buildMobileStats() {
    return Column(
      children: [
        _buildStatItem('Students', _stats['students'] ?? 0, Icons.people),
        const Divider(),
        _buildStatItem('Courses', _stats['courses'] ?? 0, Icons.school),
        const Divider(),
        _buildStatItem('Enrollments', _stats['enrollments'] ?? 0, Icons.assignment),
      ],
    );
  }

  Widget _buildDesktopStats() {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Students', _stats['students'] ?? 0, Icons.people)),
        const VerticalDivider(),
        Expanded(child: _buildStatItem('Courses', _stats['courses'] ?? 0, Icons.school)),
        const VerticalDivider(),
        Expanded(child: _buildStatItem('Enrollments', _stats['enrollments'] ?? 0, Icons.assignment)),
      ],
    );
  }

  Widget _buildStatItem(String label, dynamic value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isSmallPhone, bool isMobile, bool isTablet) {
    final actions = [
      _buildQuickAction('Add Student', Icons.person_add, Colors.blue),
      _buildQuickAction('Create Course', Icons.add_circle, Colors.green),
      _buildQuickAction('Send Announcement', Icons.announcement, Colors.orange),
      _buildQuickAction('View Reports', Icons.bar_chart, Colors.purple),
    ];

    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          isMobile
              ? Column(children: actions)
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: actions,
                ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label tapped')),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection(bool isSmallPhone, bool isMobile, bool isTablet) {
    if (_recentActivity.isEmpty) {
      return const SizedBox.shrink();
    }

    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._recentActivity.take(5).map((activity) => _buildActivityItem(activity)).toList(),
          if (_recentActivity.length > 5)
            TextButton(
              onPressed: () {
                // Navigate to full activity log
              },
              child: const Text('View All Activities'),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActivityColor(activity['type']).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity['type']),
              color: _getActivityColor(activity['type']),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (activity['description'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    activity['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatTime(activity['time'] ?? DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'enrollment':
        return Colors.green;
      case 'course':
        return Colors.blue;
      case 'announcement':
        return Colors.orange;
      case 'payment':
        return Colors.purple;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getActivityIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'enrollment':
        return Icons.person_add;
      case 'course':
        return Icons.school;
      case 'announcement':
        return Icons.announcement;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
