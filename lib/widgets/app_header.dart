import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showDrawer;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showDrawer = false,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppTheme.white,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: AppTheme.white,
      elevation: 0,
      leading: showDrawer
          ? IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.white),
              onPressed: () {
                if (scaffoldKey?.currentState != null) {
                  scaffoldKey!.currentState!.openDrawer();
                }
              },
            )
          : showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppTheme.white),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppTheme.white),
          onPressed: () {
            // Handle notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No new notifications'),
                backgroundColor: AppTheme.primaryBlue,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
