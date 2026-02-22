import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';

class NavItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isMain; // Whether it's one of the bottom nav items

  const NavItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isMain = false,
  });
}

class NavigationConfig {
  static List<NavItem> getNavigationForRole(String role) {
    switch (role) {
      case 'UNIVERSITY':
        return [
          const NavItem(
            title: 'Dashboard',
            icon: Icons.dashboard_rounded,
            route: AppRoutes.universityDashboard,
            isMain: true,
          ),
          const NavItem(
            title: 'Courses',
            icon: Icons.book_rounded,
            route: AppRoutes.courseManagement,
            isMain: true,
          ),
          const NavItem(
            title: 'Students',
            icon: Icons.people_rounded,
            route: AppRoutes.studentManagement,
            isMain: true,
          ),
          const NavItem(
            title: 'Payments',
            icon: Icons.receipt_long_rounded,
            route: AppRoutes.feeTemplate,
            isMain: true,
          ),
          const NavItem(
            title: 'Share',
            icon: Icons.handshake_rounded,
            route: AppRoutes.consultantShareSetup,
            isMain: true,
          ),
          const NavItem(
            title: 'Profile',
            icon: Icons.school_rounded,
            route: AppRoutes.universityProfile,
          ),
          const NavItem(
            title: 'Support',
            icon: Icons.help_rounded,
            route: AppRoutes.support,
          ),
        ];
      case 'CONSULTANT':
        return [
          const NavItem(
            title: 'Dashboard',
            icon: Icons.dashboard_rounded,
            route: AppRoutes.consultantDashboard,
            isMain: true,
          ),
          const NavItem(
            title: 'Univ.',
            icon: Icons.school_rounded,
            route: AppRoutes.consultantUniversities,
            isMain: true,
          ),
          const NavItem(
            title: 'Students',
            icon: Icons.people_rounded,
            route: AppRoutes.consultantStudents,
            isMain: true,
          ),
          const NavItem(
            title: 'Agents',
            icon: Icons.support_agent_rounded,
            route: AppRoutes.consultantAgents,
            isMain: true,
          ),
          const NavItem(
            title: 'Earnings',
            icon: Icons.account_balance_wallet_rounded,
            route: AppRoutes.consultantCommission,
            isMain: true,
          ),
          const NavItem(
            title: 'Profile',
            icon: Icons.person_rounded,
            route: AppRoutes.consultantProfile,
          ),
          const NavItem(
            title: 'Leads',
            icon: Icons.leaderboard_rounded,
            route: AppRoutes.consultantLeads,
          ),
          const NavItem(
            title: 'Payments',
            icon: Icons.payments_rounded,
            route: AppRoutes.consultantFeePayments,
          ),
          const NavItem(
            title: 'Support',
            icon: Icons.help_rounded,
            route: AppRoutes.consultantSupport,
          ),
        ];
      case 'SUPER_ADMIN':
        return [
          const NavItem(
            title: 'Dashboard',
            icon: Icons.dashboard_rounded,
            route: AppRoutes.universityDashboard,
            isMain: true,
          ),
          const NavItem(
            title: 'Univ.',
            icon: Icons.school_rounded,
            route: '/universities',
            isMain: true,
          ),
          const NavItem(
            title: 'Consult.',
            icon: Icons.business_rounded,
            route: '/consultancy',
            isMain: true,
          ),
          const NavItem(
            title: 'Agents',
            icon: Icons.support_agent_rounded,
            route: AppRoutes.consultantAgents,
            isMain: true,
          ),
          const NavItem(
            title: 'Reports',
            icon: Icons.analytics_rounded,
            route: AppRoutes.feeReports,
            isMain: true,
          ),
        ];
      default:
        return [
          const NavItem(
            title: 'Dashboard',
            icon: Icons.dashboard_rounded,
            route: AppRoutes.universityDashboard,
            isMain: true,
          ),
          const NavItem(
            title: 'Support',
            icon: Icons.help_rounded,
            route: AppRoutes.support,
            isMain: true,
          ),
        ];
    }
  }

  static List<NavItem> getMainNavigationForRole(String role) {
    return getNavigationForRole(role).where((item) => item.isMain).toList();
  }
}
