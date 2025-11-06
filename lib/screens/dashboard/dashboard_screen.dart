import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/widgets/app_header.dart';
import 'package:university_app_2/services/mock_data_service.dart';
import 'package:university_app_2/utils/responsive_utils.dart';

class DashboardScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DashboardScreen({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final mockData = MockDataService();
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
            final isMobile = ResponsiveUtils.isMobile(context);
            final isTablet = ResponsiveUtils.isTablet(context);
            final isSmallPhone = screenWidth < 375;

            final padding = ResponsiveUtils.getScreenPadding(context);

            return SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCreativeWelcomeCard(context, isSmallPhone, isMobile, isTablet),
                  SizedBox(height: isSmallPhone ? 12 : 16),
                  _buildCreativeStatsSection(isSmallPhone, isMobile, isTablet),
                  SizedBox(height: isSmallPhone ? 12 : 16),
                  _buildModernQuickActions(isSmallPhone, isMobile),
                  SizedBox(height: isSmallPhone ? 12 : 16),
                  _buildTimelineActivity(recentActivity, isSmallPhone, isMobile, isTablet),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // === Welcome Card (Fixed: Context passed correctly) ===
  Widget _buildCreativeWelcomeCard(BuildContext context, bool isSmallPhone, bool isMobile, bool isTablet) {
    final fontSize = ResponsiveUtils.getTitleFontSize(context);
    final subtitleSize = isSmallPhone ? 12.0 : (isMobile ? 14.0 : 18.0);
    final iconSize = isSmallPhone ? 18.0 : (isMobile ? 22.0 : 32.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallPhone ? 12 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.darkBlue, Color(0xFF0A1628)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 14),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildFloatingCircle(isSmallPhone, isMobile, isTablet, top: -30, right: -30, sizeFactor: 1.0),
          _buildFloatingCircle(isSmallPhone, isMobile, isTablet, bottom: -40, right: 20, sizeFactor: 0.7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.waving_hand, color: Colors.amber, size: iconSize),
                  const SizedBox(width: 10),
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
              const SizedBox(height: 8),
              Text(
                'Stanford University',
                style: TextStyle(
                  fontSize: subtitleSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber.shade300,
                ),
              ),
              const SizedBox(height: 10),
              _buildStatusChip(isSmallPhone),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCircle(bool isSmallPhone, bool isMobile, bool isTablet,
      {double? top, double? bottom, double? left, double? right, required double sizeFactor}) {
    final size = (isSmallPhone ? 50 : (isMobile ? 70 : 120)) * sizeFactor;
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08 * (sizeFactor + 0.3)),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isSmallPhone) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 8 : 10, vertical: isSmallPhone ? 4 : 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, color: AppTheme.white, size: isSmallPhone ? 12 : 16),
          const SizedBox(width: 4),
          Text(
            'Everything looks great!',
            style: TextStyle(
              fontSize: isSmallPhone ? 10 : 12,
              color: AppTheme.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // === Stats Section ===
  Widget _buildCreativeStatsSection(bool isSmallPhone, bool isMobile, bool isTablet) {
    final spacing = isSmallPhone ? 6.0 : (isMobile ? 8.0 : 16.0);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        _buildModernStatCard(
          title: 'Courses', value: '3', subtitle: 'Active',
          color: const Color(0xFF1E3A8A), gradientColor: const Color(0xFF3B82F6),
          icon: Icons.menu_book_rounded,
          isSmallPhone: isSmallPhone, isMobile: isMobile, isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: 'Students', value: '5', subtitle: 'Enrolled',
          color: const Color(0xFF059669), gradientColor: const Color(0xFF10B981),
          icon: Icons.groups_rounded,
          isSmallPhone: isSmallPhone, isMobile: isMobile, isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: 'Consult.', value: '4', subtitle: 'In progress',
          color: const Color(0xFFD97706), gradientColor: const Color(0xFFF59E0B),
          icon: Icons.business_center_rounded,
          isSmallPhone: isSmallPhone, isMobile: isMobile, isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: 'Apps', value: '2', subtitle: 'Pending',
          color: const Color(0xFFDC2626), gradientColor: const Color(0xFFEF4444),
          icon: Icons.pending_actions_rounded,
          isSmallPhone: isSmallPhone, isMobile: isMobile, isTablet: isTablet,
        ),
      ],
    );
  }

  Widget _buildModernStatCard({
    required String title, required String value, required String subtitle,
    required Color color, required Color gradientColor, required IconData icon,
    required bool isSmallPhone, required bool isMobile, required bool isTablet,
  }) {
    final width = isTablet ? 200.0 : (isMobile ? 160.0 : 140.0);
    final padding = isSmallPhone ? 10.0 : (isMobile ? 12.0 : 18.0);
    final fontSize = isSmallPhone ? 20.0 : (isMobile ? 26.0 : 36.0);
    final titleSize = isSmallPhone ? 11.0 : (isMobile ? 12.0 : 15.0);
    final iconSize = isSmallPhone ? 16.0 : (isMobile ? 20.0 : 26.0);

    return Container(
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, gradientColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 14),
        boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallPhone ? 6 : 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: Colors.white, size: iconSize),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(value, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white, height: 0.9)),
                          const SizedBox(width: 4),
                          Text(title, style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.95))),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(subtitle, style: TextStyle(fontSize: isSmallPhone ? 9 : 11, color: Colors.white.withOpacity(0.75))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.5), size: isSmallPhone ? 10 : 14),
        ],
      ),
    );
  }

  // === Quick Actions ===
  Widget _buildModernQuickActions(bool isSmallPhone, bool isMobile) {
    final spacing = isSmallPhone ? 6.0 : (isMobile ? 8.0 : 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Quick Actions', isSmallPhone, isMobile),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildActionCard('View Apps', 'Check pending', Icons.description_rounded, Colors.blue, isSmallPhone, isMobile)),
            SizedBox(width: spacing),
            Expanded(child: _buildActionCard('Reports', 'Export analytics', Icons.assessment_rounded, Colors.green, isSmallPhone, isMobile)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, bool isSmallPhone, bool isMobile) {
    final padding = isSmallPhone ? 10.0 : (isMobile ? 12.0 : 16.0);
    final titleSize = isSmallPhone ? 12.0 : (isMobile ? 13.0 : 15.0);
    final subtitleSize = isSmallPhone ? 10.0 : (isMobile ? 11.0 : 12.0);
    final iconSize = isSmallPhone ? 18.0 : (isMobile ? 20.0 : 24.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
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
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: iconSize),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600, color: AppTheme.charcoal)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: subtitleSize, color: AppTheme.mediumGray), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: isSmallPhone ? 12 : 14, color: AppTheme.mediumGray),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === Recent Activity (No overflow) ===
  Widget _buildTimelineActivity(List<Map<String, dynamic>> activities, bool isSmallPhone, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recent Activity', isSmallPhone, isMobile),
        const SizedBox(height: 12),
        ...activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == activities.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : (isSmallPhone ? 6.0 : 8.0)),
            child: _buildTimelineCard(activity, isSmallPhone, isMobile, isTablet),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isSmallPhone, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 3,
          height: isSmallPhone ? 18 : 22,
          decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallPhone ? 14 : (isMobile ? 16 : 20),
            fontWeight: FontWeight.bold,
            color: AppTheme.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineCard(Map<String, dynamic> activity, bool isSmallPhone, bool isMobile, bool isTablet) {
    final padding = isSmallPhone ? 8.0 : (isMobile ? 10.0 : 16.0);
    final containerSize = isSmallPhone ? 36.0 : (isMobile ? 40.0 : 48.0);
    final titleSize = isSmallPhone ? 12.0 : (isMobile ? 13.0 : 15.0);
    final descSize = isSmallPhone ? 10.0 : (isMobile ? 11.0 : 13.0);
    final timeSize = isSmallPhone ? 9.0 : (isMobile ? 10.0 : 11.0);
    final iconSize = isSmallPhone ? 16.0 : (isMobile ? 18.0 : 24.0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 12),
        border: Border.all(color: AppTheme.lightGray.withOpacity(0.4), width: 0.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Container(
            width: containerSize,
            height: containerSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue.withOpacity(0.15), AppTheme.primaryBlue.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(activity['icon'] as IconData, color: AppTheme.primaryBlue, size: iconSize),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600, color: AppTheme.charcoal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  activity['description'] as String,
                  style: TextStyle(fontSize: descSize, color: AppTheme.mediumGray, height: 1.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 4 : 6, vertical: isSmallPhone ? 2 : 3),
            decoration: BoxDecoration(color: AppTheme.lightGray.withOpacity(0.6), borderRadius: BorderRadius.circular(4)),
            child: Text(
              _formatTime(activity['time'] as DateTime),
              style: TextStyle(fontSize: timeSize, color: AppTheme.mediumGray, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays > 0) return '${difference.inDays}d';
    if (difference.inHours > 0) return '${difference.inHours}h';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m';
    return 'Now';
  }
}