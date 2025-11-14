import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/screens/consultant/consultant_profile_screen.dart';
import 'package:university_app_2/screens/consultant/universities/universities_courses_screen.dart';
import 'package:university_app_2/screens/consultant/students/student_management_screen.dart';
import 'package:university_app_2/screens/consultant/agents/agent_management_screen.dart';
import 'package:university_app_2/screens/consultant/fee_payment/fee_payment_management_screen.dart';
import 'package:university_app_2/screens/auth/login_screen.dart';

class ConsultantDashboardScreen extends StatefulWidget {
  const ConsultantDashboardScreen({super.key});

  @override
  State<ConsultantDashboardScreen> createState() =>
      _ConsultantDashboardScreenState();
}

class _ConsultantDashboardScreenState extends State<ConsultantDashboardScreen> {
  int _selectedIndex = 0;

  // Mock data
  final Map<String, dynamic> _dashboardStats = {
    'universities': 102,
    'courses': 540,
    'students': 112,
    'agents': 15,
    'earnings': 127000,
    'pending ': 7,
  };

  final List<Map<String, dynamic>> _notificationFeed = [
    {
      'id': 9001,
      'category': 'Admissions',
      'title': 'Admission Approved',
      'message': '✅ Admission for Rahul Sharma has been approved.',
      'timestamp': DateTime(2025, 11, 7, 11, 15),
      'priority': 'High',
      'isRead': false,
    },
    {
      'id': 9002,
      'category': 'Payments',
      'title': 'Payment Received',
      'message': '💰 ₹50,000 payment received for John Doe (BPT).',
      'timestamp': DateTime(2025, 11, 7, 10, 45),
      'priority': 'High',
      'isRead': false,
    },
    {
      'id': 9003,
      'category': 'University Updates',
      'title': 'Fee Structure Updated',
      'message': '🏫 Sunrise University updated BNYS fee structure.',
      'timestamp': DateTime(2025, 11, 6, 18, 5),
      'priority': 'Medium',
      'isRead': true,
    },
    {
      'id': 9004,
      'category': 'Reverted Applications',
      'title': 'Action Required',
      'message': '🔁 Upload missing TC for Priya Verma’s application.',
      'timestamp': DateTime(2025, 11, 6, 9, 30),
      'priority': 'High',
      'isRead': false,
    },
    {
      'id': 9005,
      'category': 'Agent Activity',
      'title': 'New Lead Added',
      'message': '👥 Agent Saurabh Yadav added BNYS lead “Neha Kapoor”.',
      'timestamp': DateTime(2025, 11, 5, 16, 10),
      'priority': 'Low',
      'isRead': true,
    },
  ];

  int get _unreadNotificationCount =>
      _notificationFeed.where((n) => !(n['isRead'] as bool)).length;

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    '/consultant-notifications',
                  );
                  setState(() {});
                },
              ),
              if (_unreadNotificationCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _unreadNotificationCount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, '/consultant-settings'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getSelectedScreen(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Modern gradient header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.darkBlue, Color(0xFF0A1628)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile avatar with gradient border
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade400, Colors.amber.shade700],
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.business_center_rounded,
                        size: 32,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name with emoji
                  const Row(
                    children: [
                      Text(
                        '👋',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Rajesh Consultancy',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // ID badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.badge_outlined, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'ID: CONS2001',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'MAIN MENU',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.mediumGray,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _buildModernDrawerItem(Icons.dashboard_rounded, 'Dashboard', 0, '🏠'),
                ListTile(
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.primaryBlue,
                      ),
                      if (_unreadNotificationCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _unreadNotificationCount.toString(),
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.pushNamed(
                      context,
                      '/consultant-notifications',
                    );
                    setState(() {
                      for (final notification in _notificationFeed) {
                        notification['isRead'] = true;
                      }
                    });
                  },
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
                _buildModernDrawerItem(Icons.person_rounded, 'My Profile', 1, '👤'),
                _buildModernDrawerItem(Icons.school_rounded, 'Universities & Courses', 2, '🎓'),
                _buildModernDrawerItem(Icons.people_rounded, 'Student Management', 3, '👥'),
                _buildModernDrawerItem(Icons.group_rounded, 'Agent Management', 4, '🤝'),
                _buildModernDrawerItem(Icons.attach_money_rounded, 'Fee & Payments', 5, '💳'),
                _buildModernDrawerItem(Icons.bar_chart_rounded, 'Reports & Analytics', 6, '📊'),
                _buildModernDrawerItem(Icons.phone_in_talk_rounded, 'Lead Management', 7, '📞'),
                _buildModernDrawerItem(Icons.campaign_rounded, 'Marketing & Posters', 8, '📢'),
                _buildModernDrawerItem(Icons.account_balance_wallet_rounded, 'Commission', 9, '💰'),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'SUPPORT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.mediumGray,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    color: AppTheme.primaryBlue,
                  ),
                  title: const Text(
                    'Support & Help',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/consultant-support');
                  },
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Logout section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade50, Colors.red.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text(
                'Sign out from portal',
                style: TextStyle(color: Colors.red, fontSize: 11),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 14),
              onTap: _handleLogout,
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildModernDrawerItem(IconData icon, String title, int index, String emoji) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppTheme.primaryBlue.withOpacity(0.15),
                  AppTheme.primaryBlue.withOpacity(0.05),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: AppTheme.primaryBlue.withOpacity(0.3), width: 1.5)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue.withOpacity(0.15)
                    : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
                size: 20,
              ),
            ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.charcoal,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
        ),
        onTap: () {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return _buildProfileScreen();
      case 2:
        return _buildUniversitiesScreen();
      case 3:
        return _buildStudentsScreen();
      case 4:
        return _buildAgentsScreen();
      case 5:
        return _buildPaymentsScreen();
      case 6:
        return _buildReportsScreen();
      case 7:
        return _buildLeadsScreen();
      case 8:
        return _buildMarketingScreen();
      case 9:
        return _buildCommissionScreen();
      case 10:
        return _buildHelpScreen();
      default:
        return _buildDashboardHome();
    }
  }

  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card - Like University Dashboard
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.darkBlue,
                  Color(0xFF0A1628),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
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
                // Floating circles
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  right: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.waving_hand,
                          color: Colors.amber,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Welcome back!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rajesh Consultancy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade300,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Everything looks great!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats Overview - Grid Layout
          _buildSectionHeader('Overview'),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildModernStatCard(
                title: 'Universities',
                value: '${_dashboardStats['universities']}',
                subtitle: 'Total',
                color: const Color(0xFF1E3A8A),
                gradientColor: const Color(0xFF3B82F6),
                icon: Icons.school_rounded,
              ),
              _buildModernStatCard(
                title: 'Courses',
                value: '${_dashboardStats['courses']}',
                subtitle: 'Available',
                color: const Color(0xFF6B21A8),
                gradientColor: const Color(0xFF9333EA),
                icon: Icons.menu_book_rounded,
              ),
              _buildModernStatCard(
                title: 'Students',
                value: '${_dashboardStats['students']}',
                subtitle: 'Active',
                color: const Color(0xFF059669),
                gradientColor: const Color(0xFF10B981),
                icon: Icons.groups_rounded,
              ),
              _buildModernStatCard(
                title: 'Agents',
                value: '${_dashboardStats['agents']}',
                subtitle: 'Working',
                color: const Color(0xFFD97706),
                gradientColor: const Color(0xFFF59E0B),
                icon: Icons.group_rounded,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions
          _buildSectionHeader('Quick Actions'),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.7,
            children: [
              _buildQuickActionCard(
                'View Leads',
                Icons.phone_in_talk,
                Colors.blue,
                '48 Total',
                '5 New',
                () => Navigator.pushNamed(context, '/consultant-leads'),
              ),
              _buildQuickActionCard(
                'Commission',
                Icons.account_balance_wallet,
                Colors.green,
                '₹1.82L',
                null,
                () => Navigator.pushNamed(
                  context,
                  '/consultant-commission-summary',
                ),
              ),
              _buildQuickActionCard(
                'Add Agent',
                Icons.group_add,
                Colors.orange,
                '8 Active',
                null,
                () => Navigator.pushNamed(context, '/consultant-add-agent'),
              ),
              _buildQuickActionCard(
                'Payments',
                Icons.pending_actions,
                Colors.red,
                '6 Pending',
                'Review',
                () => Navigator.pushNamed(
                  context,
                  '/consultant-pending-payments',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activities
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildSectionHeader('Recent Activities')),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    '/consultant-notifications',
                  );
                  setState(() {});
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._notificationFeed
              .where((n) => n['isRead'] == false)
              .followedBy(_notificationFeed.where((n) => n['isRead'] == true))
              .take(4)
              .map(
                (notification) => _buildNotificationPreviewCard(notification),
              )
              .toList(),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildModernStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color gradientColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, gradientColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.5),
                size: 11,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 1),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.95),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.75),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 22,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    String count,
    String? badge,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.15),
                            color.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    letterSpacing: 0.1,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: -0.2,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationPreviewCard(Map<String, dynamic> notification) {
    final iconInfo = _categoryIcon(notification['category'] as String);
    final timestamp = notification['timestamp'] as DateTime;
    final isRead = notification['isRead'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : iconInfo.color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: iconInfo.color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconInfo.color.withValues(alpha: 0.12),
                  iconInfo.color.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconInfo.icon, size: 18, color: iconInfo.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'] as String,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _timeAgo(timestamp),
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mark_email_read_outlined, size: 18),
            color: iconInfo.color,
            onPressed: () {
              setState(() {
                notification['isRead'] = true;
              });
            },
          ),
        ],
      ),
    );
  }

  _NotificationCategoryIcon _categoryIcon(String category) {
    switch (category) {
      case 'Admissions':
        return const _NotificationCategoryIcon(
          Icons.assignment_turned_in_outlined,
          Colors.green,
        );
      case 'Payments':
        return const _NotificationCategoryIcon(
          Icons.currency_rupee,
          Colors.blue,
        );
      case 'University Updates':
        return const _NotificationCategoryIcon(
          Icons.campaign_outlined,
          Colors.purple,
        );
      case 'Reverted Applications':
        return const _NotificationCategoryIcon(
          Icons.replay_outlined,
          Colors.orange,
        );
      case 'Agent Activity':
        return const _NotificationCategoryIcon(
          Icons.groups_outlined,
          Colors.indigo,
        );
      default:
        return const _NotificationCategoryIcon(
          Icons.notifications_outlined,
          AppTheme.primaryBlue,
        );
    }
  }

  String _timeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}';
  }

  // Actual module screens
  Widget _buildProfileScreen() => const ConsultantProfileScreen();
  Widget _buildUniversitiesScreen() => const UniversitiesCoursesScreen();
  Widget _buildStudentsScreen() => const StudentManagementScreen();
  Widget _buildAgentsScreen() => const AgentManagementScreen();
  Widget _buildPaymentsScreen() => const FeePaymentManagementScreen();
  Widget _buildReportsScreen() =>
      _buildPlaceholder('Reports & Analytics', Icons.bar_chart);
  Widget _buildLeadsScreen() =>
      _buildPlaceholder('Lead Management', Icons.phone_in_talk);
  Widget _buildMarketingScreen() =>
      _buildPlaceholder('Marketing & Posters', Icons.campaign);
  Widget _buildCommissionScreen() =>
      _buildPlaceholder('Commission Management', Icons.account_balance_wallet);
  Widget _buildHelpScreen() =>
      _buildPlaceholder('Help & Support', Icons.help_outline);

  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _NotificationCategoryIcon {
  final IconData icon;
  final Color color;

  const _NotificationCategoryIcon(this.icon, this.color);
}
