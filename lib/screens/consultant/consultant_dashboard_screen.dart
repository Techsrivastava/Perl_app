import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/screens/consultant/consultant_profile_screen.dart';
import 'package:university_app_2/screens/consultant/universities/universities_courses_screen.dart';
import 'package:university_app_2/screens/consultant/students/student_management_screen.dart';
import 'package:university_app_2/screens/consultant/agents/agent_management_screen.dart';
import 'package:university_app_2/screens/consultant/fee_payment/fee_payment_management_screen.dart';

class ConsultantDashboardScreen extends StatefulWidget {
  const ConsultantDashboardScreen({super.key});

  @override
  State<ConsultantDashboardScreen> createState() => _ConsultantDashboardScreenState();
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
              Navigator.pushReplacementNamed(context, '/consultant-login');
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profit Pulse EduConnect'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/consultant-notifications');
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
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/consultant-settings'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getSelectedScreen(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.business_center, size: 35, color: AppTheme.primaryBlue),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rajesh Consultancy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: CONS2001',
                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
                ListTile(
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_outlined, color: AppTheme.primaryBlue),
                      if (_unreadNotificationCount > 0)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: Text(
                              _unreadNotificationCount.toString(),
                              style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: const Text('Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.pushNamed(context, '/consultant-notifications');
                    setState(() {
                      for (final notification in _notificationFeed) {
                        notification['isRead'] = true;
                      }
                    });
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
                _buildDrawerItem(Icons.person, 'My Profile', 1),
                _buildDrawerItem(Icons.school, 'Universities & Courses', 2),
                _buildDrawerItem(Icons.people, 'Student Management', 3),
                _buildDrawerItem(Icons.group, 'Agent Management', 4),
                _buildDrawerItem(Icons.attach_money, 'Fee & Payments', 5),
                _buildDrawerItem(Icons.bar_chart, 'Reports & Analytics', 6),
                _buildDrawerItem(Icons.phone_in_talk, 'Lead Management', 7),
                _buildDrawerItem(Icons.campaign, 'Marketing & Posters', 8),
                _buildDrawerItem(Icons.account_balance_wallet, 'Commission', 9),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: AppTheme.primaryBlue),
                  title: const Text('Support & Help', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/consultant-support');
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  onTap: _handleLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppTheme.primaryBlue : Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card - Modern Minimal
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Rajesh Consultancy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business_center, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Overview - Compact
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
              ),
              Text(
                'Today',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              _buildStatCard('Universities', '${_dashboardStats['universities']}', Icons.school, Colors.blue),
              _buildStatCard('Courses', '${_dashboardStats['courses']}', Icons.book, Colors.purple),
              _buildStatCard('Students', '${_dashboardStats['students']}', Icons.people, Colors.green),
              _buildStatCard('Agents', '${_dashboardStats['agents']}', Icons.group, Colors.orange),
              _buildStatCard('Earnings', '₹${_dashboardStats['earnings']}', Icons.currency_rupee, Colors.teal),
              _buildStatCard('Pending', '${_dashboardStats['pending']}', Icons.pending, Colors.red),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '4 actions',
                  style: TextStyle(fontSize: 11, color: Colors.amber[800], fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
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
                () => Navigator.pushNamed(context, '/consultant-commission-summary'),
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
                () => Navigator.pushNamed(context, '/consultant-pending-payments'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activities
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.3),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/consultant-notifications');
                  setState(() {});
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._notificationFeed
              .where((n) => n['isRead'] == false)
              .followedBy(_notificationFeed.where((n) => n['isRead'] == true))
              .take(4)
              .map((notification) => _buildNotificationPreviewCard(notification))
              .toList(),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, String count, String? badge, VoidCallback onTap) {
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
                          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
        border: Border.all(color: iconInfo.color.withValues(alpha: 0.2), width: 1),
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
                colors: [iconInfo.color.withValues(alpha: 0.12), iconInfo.color.withValues(alpha: 0.05)],
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
        return const _NotificationCategoryIcon(Icons.assignment_turned_in_outlined, Colors.green);
      case 'Payments':
        return const _NotificationCategoryIcon(Icons.currency_rupee, Colors.blue);
      case 'University Updates':
        return const _NotificationCategoryIcon(Icons.campaign_outlined, Colors.purple);
      case 'Reverted Applications':
        return const _NotificationCategoryIcon(Icons.replay_outlined, Colors.orange);
      case 'Agent Activity':
        return const _NotificationCategoryIcon(Icons.groups_outlined, Colors.indigo);
      default:
        return const _NotificationCategoryIcon(Icons.notifications_outlined, AppTheme.primaryBlue);
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
  Widget _buildReportsScreen() => _buildPlaceholder('Reports & Analytics', Icons.bar_chart);
  Widget _buildLeadsScreen() => _buildPlaceholder('Lead Management', Icons.phone_in_talk);
  Widget _buildMarketingScreen() => _buildPlaceholder('Marketing & Posters', Icons.campaign);
  Widget _buildCommissionScreen() => _buildPlaceholder('Commission Management', Icons.account_balance_wallet);
  Widget _buildHelpScreen() => _buildPlaceholder('Help & Support', Icons.help_outline);

  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
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
