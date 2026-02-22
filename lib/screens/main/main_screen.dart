import 'package:flutter/material.dart';
import 'package:educonnect/widgets/app_bottom_nav.dart';
import 'package:educonnect/widgets/app_drawer.dart';
import 'package:educonnect/screens/dashboard/dashboard_screen.dart';
import 'package:educonnect/screens/courses/courses_screen.dart';
import 'package:educonnect/screens/students/students_screen.dart';
import 'package:educonnect/screens/consultancy/consultancy_screen.dart';
import 'package:educonnect/screens/university/university_profile_screen.dart';
import 'package:educonnect/screens/consultant/agents/agent_management_screen.dart';
import 'package:educonnect/screens/consultant/students/student_management_screen.dart';
import 'package:educonnect/screens/consultant/universities/universities_courses_screen.dart';
import 'package:educonnect/screens/consultant/fee_payment/fee_payment_management_screen.dart';
import 'package:educonnect/screens/university/university_management_screen.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/config/navigation_config.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getUser();
    if (mounted) {
      setState(() => _user = user);
    }
  }

  List<NavItem> get _mainNavItems {
    final role = _user?['role'] ?? '';
    return NavigationConfig.getMainNavigationForRole(role);
  }

  Widget _getScreen(String route) {
    switch (route) {
      case '/dashboard':
      case '/university-dashboard':
      case '/consultant-dashboard':
        return DashboardScreen(scaffoldKey: _scaffoldKey);
      case '/courses':
      case '/course-management':
        return CoursesScreen(scaffoldKey: _scaffoldKey);
      case '/students':
      case '/student-management':
      case '/consultant-students':
        if (_user?['role'] == 'CONSULTANT') {
          return StudentManagementScreen(scaffoldKey: _scaffoldKey);
        }
        return StudentsScreen(scaffoldKey: _scaffoldKey);
      case '/consultancy':
        return const ConsultancyScreen();
      case '/university-profile':
        return const UniversityProfileScreen();
      case '/consultant-universities':
        return const UniversitiesCoursesScreen();
      case '/consultant-agents':
        return const AgentManagementScreen();
      case '/consultant-fee-payments':
        return const FeePaymentManagementScreen();
      case '/universities':
        return const UniversityManagementScreen();
      case '/fee-template':
        // University fee template
        return const Center(child: Text('Fee Template Screen Placeholder'));
      case '/consultant-share-setup':
        return const Center(child: Text('Consultant Share Setup Placeholder'));
      default:
        return Center(child: Text('Screen for $route not found'));
    }
  }

  void _onDrawerNavigate(String route) {
    final items = _mainNavItems;
    final index = items.indexWhere((item) => item.route == route);

    if (index != -1) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      // If it's not a main route, let the drawer or Navigator handle it
      Navigator.of(context).pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final items = _mainNavItems;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;

        return Scaffold(
          key: _scaffoldKey,
          drawer: isSmallScreen
              ? AppDrawer(
                  currentRoute: items.isNotEmpty && _currentIndex < items.length
                      ? items[_currentIndex].route
                      : '',
                  onNavigate: _onDrawerNavigate,
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                // Sidebar for larger screens
                if (!isSmallScreen)
                  SizedBox(
                    width: 250,
                    child: AppDrawer(
                      currentRoute:
                          items.isNotEmpty && _currentIndex < items.length
                          ? items[_currentIndex].route
                          : '',
                      onNavigate: _onDrawerNavigate,
                    ),
                  ),
                // Main content area
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: items
                        .map((item) => _getScreen(item.route))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isSmallScreen
              ? AppBottomNav(
                  currentIndex: _currentIndex,
                  items: items,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                )
              : null,
        );
      },
    );
  }
}
