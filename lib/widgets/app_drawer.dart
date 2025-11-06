import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.school, color: AppTheme.white, size: 40),
                const SizedBox(height: 12),
                const Text(
                  'Stanford University',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'admin@stanford.edu',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isSelected: currentRoute == '/dashboard',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.school,
                  title: 'University Profile',
                  route: '/university-profile',
                  isSelected: currentRoute == '/university-profile',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.book,
                  title: 'Courses',
                  route: '/courses',
                  isSelected: currentRoute == '/courses',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.people,
                  title: 'Student Applications',
                  route: '/students',
                  isSelected: currentRoute == '/students',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.business,
                  title: 'Consultant Reports',
                  route: '/consultancy',
                  isSelected: currentRoute == '/consultancy',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.attach_money,
                  title: 'Fee Reports',
                  route: '/fee-reports',
                  isSelected: currentRoute == '/fee-reports',
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  route: '/notifications',
                  isSelected: currentRoute == '/notifications',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.help,
                  title: 'Support & Help',
                  route: '/support',
                  isSelected: currentRoute == '/support',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                  isSelected: currentRoute == '/settings',
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.error),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigate to login screen
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.primaryBlue : AppTheme.mediumGray,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.charcoal,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          onNavigate(route);
        },
      ),
    );
  }
}
