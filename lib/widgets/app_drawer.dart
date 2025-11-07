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
          // Header with Profile
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onNavigate('/profile');
            },
            child: Container(
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: AppTheme.white,
                        child: CircleAvatar(
                          radius: 33,
                          backgroundColor: AppTheme.primaryBlue.withOpacity(0.3),
                          child: const Icon(
                            Icons.school,
                            color: AppTheme.white,
                            size: 35,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppTheme.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onNavigate('/profile');
                        },
                      ),
                    ],
                  ),
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, color: AppTheme.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Tap to edit profile',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                  icon: Icons.handshake,
                  title: 'Consultant Share Setup',
                  route: '/consultant-share-setup',
                  isSelected: currentRoute == '/consultant-share-setup',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.attach_money,
                  title: 'Fee & Student Reports',
                  route: '/fee-student-reports',
                  isSelected: currentRoute == '/fee-student-reports' || currentRoute == '/fee-reports',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.receipt_long,
                  title: 'One-Time Fee Template',
                  route: '/fee-template',
                  isSelected: currentRoute == '/fee-template',
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
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                Navigator.of(context).pop(); // Close drawer
                                // Navigate to login screen and clear all routes
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: AppTheme.error),
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
          if (route.startsWith('/')) {
            Navigator.of(context).pushNamed(route);
          } else {
            onNavigate(route);
          }
        },
      ),
    );
  }
}
