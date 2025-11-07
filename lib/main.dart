import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/screens/auth/login_screen.dart';
import 'package:university_app_2/screens/profile/profile_screen.dart';
import 'package:university_app_2/screens/main/main_screen.dart';
import 'package:university_app_2/screens/notifications/notifications_screen.dart';
import 'package:university_app_2/screens/settings/settings_screen.dart';
import 'package:university_app_2/screens/support/support_screen.dart';
import 'package:university_app_2/screens/dashboard/dashboard_screen.dart';
import 'package:university_app_2/screens/courses/comprehensive_add_course_screen.dart';
import 'package:university_app_2/screens/university/consultant_share_setup_screen.dart';
import 'package:university_app_2/screens/university/consultant_share_report_screen.dart';
import 'package:university_app_2/screens/university/fee_student_reports_screen.dart';

void main() {
  runApp(const UniversityApp());
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Management System',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        // Handle all routes dynamically
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/main':
            return MaterialPageRoute(builder: (_) => const MainScreen());
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const DashboardScreen());
          case '/profile':
          case '/university-profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/support':
            return MaterialPageRoute(builder: (_) => const SupportScreen());
          case '/courses':
            return MaterialPageRoute(builder: (_) => _buildPlaceholderScreen('Courses'));
          case '/add-course':
          case '/comprehensive-add-course':
            return MaterialPageRoute(builder: (_) => const ComprehensiveAddCourseScreen());
          case '/students':
            return MaterialPageRoute(builder: (_) => _buildPlaceholderScreen('Student Applications'));
          case '/consultancy':
            return MaterialPageRoute(builder: (_) => _buildPlaceholderScreen('Consultant Reports'));
          case '/consultant-share-setup':
            return MaterialPageRoute(builder: (_) => const ConsultantShareSetupScreen());
          case '/consultant-share-report':
            return MaterialPageRoute(builder: (_) => const ConsultantShareReportScreen());
          case '/fee-reports':
          case '/fee-student-reports':
            return MaterialPageRoute(builder: (_) => const FeeStudentReportsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      },
    );
  }

  static Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              '$title Page',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.charcoal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
