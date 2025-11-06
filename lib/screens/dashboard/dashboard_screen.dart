import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/services/mock_data_service.dart';

class DashboardScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DashboardScreen({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final mockData = MockDataService();
    final stats = mockData.dashboardStats;
    final recentActivity = mockData.recentActivity;

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'Dashboard',
        showBackButton: false,
        showDrawer: true,
        scaffoldKey: scaffoldKey,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isSmallPhone = screenWidth < 375;
            final isMobile = screenWidth < 600;
            final isTablet = screenWidth >= 600;
            final isLandscape = screenHeight < screenWidth;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallPhone ? 10 : (isMobile ? 12 : 24),
                vertical: isSmallPhone ? 10 : (isMobile ? 12 : 20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCreativeWelcomeCard(
                    isSmallPhone,
                    isMobile,
                    isTablet,
                    isLandscape,
                  ),
                  SizedBox(height: isSmallPhone ? 12 : (isMobile ? 14 : 20)),
                  _buildCreativeStatsSection(
                    isSmallPhone,
                    isMobile,
                    isTablet,
                    isLandscape,
                  ),
                  SizedBox(height: isSmallPhone ? 12 : (isMobile ? 14 : 20)),
                  _buildModernQuickActions(isSmallPhone, isMobile, isTablet),
                  SizedBox(height: isSmallPhone ? 12 : (isMobile ? 14 : 20)),
                  _buildTimelineActivity(
                    recentActivity,
                    isSmallPhone,
                    isMobile,
                    isTablet,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCreativeWelcomeCard(
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
    bool isLandscape,
  ) {
    double padding = isSmallPhone ? 12 : (isMobile ? 14 : 24);
    double fontSize = isSmallPhone ? 16 : (isMobile ? 22 : 28);
    double subtitleSize = isSmallPhone ? 12 : (isMobile ? 14 : 18);
    double iconSize = isSmallPhone ? 18 : (isMobile ? 22 : 32);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            AppTheme.darkBlue,
            const Color(0xFF0A1628),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: isSmallPhone ? 50 : (isMobile ? 70 : 120),
              height: isSmallPhone ? 50 : (isMobile ? 70 : 120),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -40,
            child: Container(
              width: isSmallPhone ? 35 : (isMobile ? 50 : 100),
              height: isSmallPhone ? 35 : (isMobile ? 50 : 100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.waving_hand, color: Colors.amber, size: iconSize),
                  SizedBox(width: isSmallPhone ? 6 : 10),
                  Flexible(
                    child: Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallPhone ? 4 : 8),
              Text(
                'Stanford University',
                style: TextStyle(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber.shade300,
                ),
              ),
              SizedBox(height: isSmallPhone ? 6 : 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallPhone ? 8 : 10,
                    vertical: isSmallPhone ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppTheme.white,
                        size: isSmallPhone ? 12 : 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Everything looks great!',
                        style: TextStyle(
                          fontSize: isSmallPhone ? 10 : 12,
                          color: AppTheme.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeStatsSection(
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
    bool isLandscape,
  ) {
    final spacing = (isSmallPhone ? 6 : (isMobile ? 8 : 16)).toDouble();

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        _buildModernStatCard(
          title: 'Courses',
          value: '3',
          subtitle: 'Active',
          color: const Color(0xFF1E3A8A),
          icon: Icons.menu_book_rounded,
          gradientColor: const Color(0xFF3B82F6),
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: 'Students',
          value: '5',
          subtitle: 'Enrolled',
          color: const Color(0xFF059669),
          icon: Icons.groups_rounded,
          gradientColor: const Color(0xFF10B981),
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: 'Consult.',
          value: '4',
          subtitle: 'In progress',
          color: const Color(0xFFD97706),
          icon: Icons.business_center_rounded,
          gradientColor: const Color(0xFFF59E0B),
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: 'Apps',
          value: '2',
          subtitle: 'Pending',
          color: const Color(0xFFDC2626),
          icon: Icons.pending_actions_rounded,
          gradientColor: const Color(0xFFEF4444),
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildModernStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    required Color gradientColor,
    required bool isSmallPhone,
    required bool isMobile,
    required bool isTablet,
  }) {
    double padding = isSmallPhone ? 10 : (isMobile ? 12 : 18);
    double fontSize = isSmallPhone ? 20 : (isMobile ? 26 : 36);
    double titleSize = isSmallPhone ? 11 : (isMobile ? 12 : 15);
    double iconSize = isSmallPhone ? 16 : (isMobile ? 20 : 26);

    return Container(
      width: isTablet
          ? 200
          : (isMobile ? 160 : 140), // Adjust width for better wrapping
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, gradientColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallPhone ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: iconSize),
                ),
                SizedBox(width: isSmallPhone ? 4 : 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 0.9,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isSmallPhone ? 9 : 11,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white.withValues(alpha: 0.5),
            size: isSmallPhone ? 10 : 14,
          ),
        ],
      ),
    );
  }

  Widget _buildModernQuickActions(
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
  ) {
    final spacing = (isSmallPhone ? 6 : (isMobile ? 8 : 16)).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: isSmallPhone ? 18 : 22,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: isSmallPhone ? 14 : (isMobile ? 16 : 20),
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallPhone ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'View Apps',
                'Check pending',
                Icons.description_rounded,
                Colors.blue,
                isSmallPhone,
                isMobile,
              ),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: _buildActionCard(
                'Reports',
                'Export analytics',
                Icons.assessment_rounded,
                Colors.green,
                isSmallPhone,
                isMobile,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isSmallPhone,
    bool isMobile,
  ) {
    double padding = isSmallPhone ? 10 : (isMobile ? 12 : 16);
    double titleSize = isSmallPhone ? 12 : (isMobile ? 13 : 15);
    double subtitleSize = isSmallPhone ? 10 : (isMobile ? 11 : 12);
    double iconSize = isSmallPhone ? 18 : (isMobile ? 20 : 24);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallPhone ? 8 : 10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: iconSize),
                ),
                SizedBox(width: isSmallPhone ? 8 : 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.charcoal,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: AppTheme.mediumGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: isSmallPhone ? 12 : 14,
                  color: AppTheme.mediumGray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineActivity(
    List<Map<String, dynamic>> activities,
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: isSmallPhone ? 18 : 22,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: isSmallPhone ? 14 : (isMobile ? 16 : 20),
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallPhone ? 8 : 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: isSmallPhone ? 6 : 8),
          itemBuilder: (context, index) {
            return _buildTimelineCard(
              activities[index],
              isSmallPhone,
              isMobile,
              isTablet,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimelineCard(
    Map<String, dynamic> activity,
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
  ) {
    double padding = isSmallPhone ? 8 : (isMobile ? 10 : 16);
    double containerSize = isSmallPhone ? 36 : (isMobile ? 40 : 48);
    double titleSize = isSmallPhone ? 12 : (isMobile ? 13 : 15);
    double descSize = isSmallPhone ? 10 : (isMobile ? 11 : 13);
    double timeSize = isSmallPhone ? 9 : (isMobile ? 10 : 11);
    double iconSize = isSmallPhone ? 16 : (isMobile ? 18 : 24);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
        border: Border.all(
          color: AppTheme.lightGray.withValues(alpha: 0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.15),
                  AppTheme.primaryBlue.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: AppTheme.primaryBlue,
              size: iconSize,
            ),
          ),
          SizedBox(width: isSmallPhone ? 8 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  activity['description'] as String,
                  style: TextStyle(
                    fontSize: descSize,
                    color: AppTheme.mediumGray,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 4),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallPhone ? 4 : 6,
              vertical: isSmallPhone ? 2 : 3,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightGray.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _formatTime(activity['time'] as DateTime),
              style: TextStyle(
                fontSize: timeSize,
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}
