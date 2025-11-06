import 'package:flutter/material.dart';
import 'package:university_app_2/widgets/app_bottom_nav.dart';
import 'package:university_app_2/widgets/app_drawer.dart';
import 'package:university_app_2/screens/dashboard/dashboard_screen.dart';
import 'package:university_app_2/screens/courses/courses_screen.dart';
import 'package:university_app_2/screens/students/students_screen.dart';
import 'package:university_app_2/screens/consultancy/consultancy_screen.dart';
import 'package:university_app_2/screens/university/university_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> get _screens => [
    DashboardScreen(scaffoldKey: _scaffoldKey),
    CoursesScreen(scaffoldKey: _scaffoldKey),
    StudentsScreen(scaffoldKey: _scaffoldKey),
    ConsultancyScreen(scaffoldKey: _scaffoldKey),
    UniversityProfileScreen(scaffoldKey: _scaffoldKey),
  ];

  final List<String> _routeNames = [
    '/dashboard',
    '/courses',
    '/students',
    '/consultancy',
    '/university-profile',
  ];

  void _onDrawerNavigate(String route) {
    final index = _routeNames.indexOf(route);
    if (index != -1) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        
        return Scaffold(
          key: _scaffoldKey,
          drawer: isSmallScreen 
              ? AppDrawer(
                  currentRoute: _routeNames[_currentIndex],
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
                      currentRoute: _routeNames[_currentIndex],
                      onNavigate: _onDrawerNavigate,
                    ),
                  ),
                // Main content area
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isSmallScreen
              ? AppBottomNav(
                  currentIndex: _currentIndex,
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
