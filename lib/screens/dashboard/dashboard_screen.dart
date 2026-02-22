import 'package:flutter/material.dart';
import 'package:educonnect/config/theme.dart';
import 'package:educonnect/widgets/app_header.dart';
import 'package:educonnect/core/utils/responsive_utils.dart';
import 'package:educonnect/services/dashboard_service.dart';
import 'package:educonnect/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DashboardScreen({super.key, this.scaffoldKey});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await AuthService.getUser();
      if (user == null) throw Exception('User not found');

      _userData = user;
      final role = user['role'];

      Map<String, dynamic> data;
      if (role == 'UNIVERSITY') {
        data = await DashboardService.getUniversityDashboard();
      } else if (role == 'CONSULTANT') {
        data = await DashboardService.getConsultantDashboard();
      } else if (role == 'SUPER_ADMIN') {
        data = await DashboardService.getSuperAdminDashboard();
      } else {
        // Fallback or student dashboard
        data = await DashboardService.getStats();
      }

      if (!mounted) return;

      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_errorMessage'),
              ElevatedButton(
                onPressed: _loadDashboardData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Role-based Stats Mapping
    final role = _userData?['role'] ?? 'USER';
    final stats = _dashboardData ?? {};

    String stat1Label = 'Total';
    String stat1Value = '0';
    String stat2Label = 'Students';
    String stat2Value = '0';
    String stat3Label = 'Applications';
    String stat3Value = '0';
    String stat4Label = 'Pending';
    String stat4Value = '0';

    if (role == 'UNIVERSITY') {
      stat1Label = 'Courses';
      stat1Value = stats['totalCourses']?.toString() ?? '0';
      stat2Label = 'Applied';
      stat2Value = stats['studentsApplied']?.toString() ?? '0';
      stat3Label = 'Admissions';
      stat3Value = stats['totalAdmissions']?.toString() ?? '0';
      stat4Label = 'Pending';
      stat4Value = stats['pendingApplications']?.toString() ?? '0';
    } else if (role == 'CONSULTANT') {
      stat1Label = 'Leads';
      stat1Value = stats['totalLeads']?.toString() ?? '0';
      stat2Label = 'Agents';
      stat2Value = stats['totalAgents']?.toString() ?? '0';
      stat3Label = 'Applied';
      stat3Value = stats['totalAdmissions']?.toString() ?? '0';
      stat4Label = 'Earned';
      stat4Value = '₹${stats['totalCommission'] ?? '0'}';
    } else if (role == 'SUPER_ADMIN') {
      stat1Label = 'Universities';
      stat1Value = stats['totalUniversities']?.toString() ?? '0';
      stat2Label = 'Consultants';
      stat2Value = stats['totalConsultants']?.toString() ?? '0';
      stat3Label = 'Students';
      stat3Value = stats['totalStudents']?.toString() ?? '0';
      stat4Label = 'Revenue';
      stat4Value = '₹${stats['totalRevenue'] ?? '0'}';
    } else {
      // Default / Student
      stat1Label = 'Applied';
      stat1Value = stats['appliedUniversities']?.toString() ?? '0';
      stat2Label = 'Status';
      stat2Value = stats['applicationStatus']?.toString() ?? 'Active';
      stat3Label = 'Notifications';
      stat3Value = stats['unreadNotifications']?.toString() ?? '0';
      stat4Label = 'Support';
      stat4Value = stats['openTickets']?.toString() ?? '0';
    }

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppHeader(
        title: 'Dashboard',
        showBackButton: false,
        showDrawer: true,
        scaffoldKey: widget.scaffoldKey,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isMobile = ResponsiveUtils.isMobile(context);
            final isTablet = ResponsiveUtils.isTablet(context);
            final isSmallPhone = screenWidth < 375;

            final padding = ResponsiveUtils.getScreenPadding(context);

            return RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCreativeWelcomeCard(
                      context,
                      isSmallPhone,
                      isMobile,
                      isTablet,
                    ),
                    SizedBox(height: isSmallPhone ? 12 : 16),
                    _buildCreativeStatsSection(
                      isSmallPhone,
                      isMobile,
                      isTablet,
                      stat1Label,
                      stat1Value,
                      stat2Label,
                      stat2Value,
                      stat3Label,
                      stat3Value,
                      stat4Label,
                      stat4Value,
                    ),
                    SizedBox(height: isSmallPhone ? 12 : 16),
                    _buildModernQuickActions(isSmallPhone, isMobile),
                    SizedBox(height: isSmallPhone ? 12 : 16),
                    // _buildTimelineActivity(
                    //   recentActivity, // TODO: Fetch real activity
                    //   isSmallPhone,
                    //   isMobile,
                    //   isTablet,
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // === Welcome Card (Fixed: Context passed correctly) ===
  Widget _buildCreativeWelcomeCard(
    BuildContext context,
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
  ) {
    final fontSize = ResponsiveUtils.getTitleFontSize(context);
    final subtitleSize = isSmallPhone ? 12.0 : (isMobile ? 14.0 : 18.0);
    final iconSize = isSmallPhone ? 18.0 : (isMobile ? 22.0 : 32.0);

    final userName = _userData?['name'] ?? 'User';
    final userRole = _userData?['role'] ?? 'Welcome';

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
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildFloatingCircle(
            isSmallPhone,
            isMobile,
            isTablet,
            top: -30,
            right: -30,
            sizeFactor: 1.0,
          ),
          _buildFloatingCircle(
            isSmallPhone,
            isMobile,
            isTablet,
            bottom: -40,
            right: 20,
            sizeFactor: 0.7,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.waving_hand, color: Colors.amber, size: iconSize),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Welcome back, $userName!',
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
                userRole, // Display Role
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

  Widget _buildFloatingCircle(
    bool isSmallPhone,
    bool isMobile,
    bool isTablet, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double sizeFactor,
  }) {
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
          color: Colors.white.withValues(alpha: 0.08 * (sizeFactor + 0.3)),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isSmallPhone) {
    return Container(
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
          const SizedBox(width: 4),
          Text(
            'System Active',
            style: TextStyle(
              fontSize: isSmallPhone ? 10 : 12,
              color: AppTheme.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // === Stats Section ===
  Widget _buildCreativeStatsSection(
    bool isSmallPhone,
    bool isMobile,
    bool isTablet,
    String label1,
    String stat1,
    String label2,
    String stat2,
    String label3,
    String stat3,
    String label4,
    String stat4,
  ) {
    final spacing = isSmallPhone ? 6.0 : (isMobile ? 8.0 : 16.0);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        _buildModernStatCard(
          title: label1,
          value: stat1,
          subtitle: 'Total',
          color: const Color(0xFF1E3A8A),
          gradientColor: const Color(0xFF3B82F6),
          icon: Icons.menu_book_rounded,
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: label2,
          value: stat2,
          subtitle: 'Count',
          color: const Color(0xFF059669),
          gradientColor: const Color(0xFF10B981),
          icon: Icons.groups_rounded,
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: label3,
          value: stat3,
          subtitle: 'Activity',
          color: const Color(0xFFD97706),
          gradientColor: const Color(0xFFF59E0B),
          icon: Icons.business_center_rounded,
          isSmallPhone: isSmallPhone,
          isMobile: isMobile,
          isTablet: isTablet,
        ),
        _buildModernStatCard(
          title: label4,
          value: stat4,
          subtitle: 'Status',
          color: const Color(0xFFDC2626),
          gradientColor: const Color(0xFFEF4444),
          icon: Icons.pending_actions_rounded,
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
    required Color gradientColor,
    required IconData icon,
    required bool isSmallPhone,
    required bool isMobile,
    required bool isTablet,
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
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 0.9,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        title, // Swapped title and subtitle visual hierarchy if needed, but keeping as is
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
            Expanded(
              child: _buildActionCard(
                'View Apps',
                'Check pending',
                Icons.description_rounded,
                Colors.blue,
                isSmallPhone,
                isMobile,
                onTap: () {
                  final role = _userData?['role'];
                  if (role == 'UNIVERSITY') {
                    Navigator.pushNamed(context, '/university-admissions');
                  } else if (role == 'CONSULTANT') {
                    Navigator.pushNamed(context, '/consultant-admissions');
                  }
                },
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
                onTap: () {
                  final role = _userData?['role'];
                  if (role == 'UNIVERSITY') {
                    Navigator.pushNamed(context, '/university-reports');
                  } else if (role == 'CONSULTANT') {
                    Navigator.pushNamed(context, '/consultant-reports');
                  }
                },
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
    bool isMobile, {
    required VoidCallback onTap,
  }) {
    final padding = isSmallPhone ? 10.0 : (isMobile ? 12.0 : 16.0);
    final titleSize = isSmallPhone ? 12.0 : (isMobile ? 13.0 : 15.0);
    final subtitleSize = isSmallPhone ? 10.0 : (isMobile ? 11.0 : 12.0);
    final iconSize = isSmallPhone ? 18.0 : (isMobile ? 20.0 : 24.0);

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
          onTap: onTap,
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
                const SizedBox(width: 10),
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
                      const SizedBox(height: 2),
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

  Widget _buildSectionHeader(String title, bool isSmallPhone, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 3,
          height: isSmallPhone ? 18 : 22,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
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
}
