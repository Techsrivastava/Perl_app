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
import 'package:university_app_2/screens/fee_management/one_time_fee_template_screen.dart';
import 'package:university_app_2/screens/consultant/consultant_login_screen.dart';
import 'package:university_app_2/screens/consultant/consultant_dashboard_screen.dart';
import 'package:university_app_2/screens/consultant/consultant_profile_setup_screen.dart';
import 'package:university_app_2/screens/consultant/comprehensive_consultant_register_screen.dart';
import 'package:university_app_2/screens/consultant/quick_actions/view_leads_screen.dart';
import 'package:university_app_2/screens/consultant/quick_actions/commission_summary_screen.dart';
import 'package:university_app_2/screens/consultant/notifications/consultant_notifications_screen.dart';
import 'package:university_app_2/screens/consultant/quick_actions/add_agent_screen.dart';
import 'package:university_app_2/screens/consultant/quick_actions/pending_payments_screen.dart';
import 'package:university_app_2/screens/consultant/universities/universities_courses_screen.dart';
import 'package:university_app_2/screens/consultant/students/student_management_screen.dart';
import 'package:university_app_2/screens/consultant/agents/agent_management_screen.dart';
import 'package:university_app_2/screens/consultant/fee_payment/fee_payment_management_screen.dart';
import 'package:university_app_2/screens/consultant/support/support_consultant_screen.dart';

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
          case '/fee-template':
            return MaterialPageRoute(builder: (_) => const OneTimeFeeTemplateScreen());
          case '/consultant-login':
            return MaterialPageRoute(builder: (_) => const ConsultantLoginScreen());
          case '/consultant-dashboard':
            return MaterialPageRoute(builder: (_) => const ConsultantDashboardScreen());
          case '/consultant-profile-setup':
            return MaterialPageRoute(builder: (_) => const ConsultantProfileSetupScreen());
          case '/consultant-comprehensive-register':
            return MaterialPageRoute(builder: (_) => const ComprehensiveConsultantRegisterScreen());
          case '/consultant-leads':
            return MaterialPageRoute(builder: (_) => const ViewLeadsScreen());
          case '/consultant-commission-summary':
            return MaterialPageRoute(builder: (_) => const CommissionSummaryScreen());
          case '/consultant-notifications':
            return MaterialPageRoute(builder: (_) => const ConsultantNotificationsScreen());
          case '/consultant-add-agent':
            return MaterialPageRoute(builder: (_) => const AddAgentScreen());
          case '/consultant-pending-payments':
            return MaterialPageRoute(builder: (_) => const PendingPaymentsScreen());
          case '/consultant-universities':
            return MaterialPageRoute(builder: (_) => const UniversitiesCoursesScreen());
          case '/consultant-students':
            return MaterialPageRoute(builder: (_) => const StudentManagementScreen());
          case '/consultant-agents':
          case '/consultant-agent-management':
            return MaterialPageRoute(builder: (_) => const AgentManagementScreen());
          case '/consultant-fee-payments':
            return MaterialPageRoute(builder: (_) => const FeePaymentManagementScreen());
          case '/consultant-support':
            return MaterialPageRoute(builder: (_) => const SupportConsultantScreen());
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
