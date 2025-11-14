import 'package:flutter/material.dart';
import 'package:university_app_2/core/routes/app_routes.dart';

// Auth
import 'package:university_app_2/screens/auth/login_screen.dart';
import 'package:university_app_2/screens/auth/university_register_screen.dart';

// University
import 'package:university_app_2/screens/dashboard/dashboard_screen.dart';
import 'package:university_app_2/screens/profile/profile_screen.dart';
import 'package:university_app_2/screens/courses/comprehensive_add_course_screen.dart';
import 'package:university_app_2/screens/courses/courses_screen.dart';
import 'package:university_app_2/screens/students/students_screen.dart';
import 'package:university_app_2/screens/university/consultant_share_setup_screen.dart';
import 'package:university_app_2/screens/university/consultant_share_report_screen.dart';
import 'package:university_app_2/screens/university/fee_student_reports_screen.dart';
import 'package:university_app_2/screens/fee_management/one_time_fee_template_screen.dart';
import 'package:university_app_2/screens/notifications/notifications_screen.dart';
import 'package:university_app_2/screens/settings/settings_screen.dart';
import 'package:university_app_2/screens/support/support_screen.dart';

// Consultant
import 'package:university_app_2/screens/consultant/consultant_login_screen.dart';
import 'package:university_app_2/screens/consultant/consultant_dashboard_screen.dart';
import 'package:university_app_2/screens/consultant/consultant_profile_screen.dart';
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
import 'package:university_app_2/screens/consultant/admission/admission_form_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      case AppRoutes.login:
        return _buildRoute(const LoginScreen());
      
      case AppRoutes.consultantLogin:
        return _buildRoute(const ConsultantLoginScreen());
      
      case AppRoutes.universityRegister:
        return _buildRoute(const UniversityRegisterScreen());
      
      case AppRoutes.consultantRegister:
        return _buildRoute(const ComprehensiveConsultantRegisterScreen());

      // University Routes
      case AppRoutes.universityDashboard:
        return _buildRoute(const DashboardScreen());
      
      case AppRoutes.universityProfile:
        return _buildRoute(const ProfileScreen());
      
      case AppRoutes.addCourse:
        return _buildRoute(const ComprehensiveAddCourseScreen());
      
      case AppRoutes.courseManagement:
        return _buildRoute(const CoursesScreen());
      
      case AppRoutes.studentManagement:
        return _buildRoute(const StudentsScreen());
      
      case AppRoutes.consultantShareSetup:
        return _buildRoute(const ConsultantShareSetupScreen());
      
      case AppRoutes.consultantShareReport:
        return _buildRoute(const ConsultantShareReportScreen());
      
      case AppRoutes.feeReports:
        return _buildRoute(const FeeStudentReportsScreen());
      
      case AppRoutes.feeTemplate:
        return _buildRoute(const OneTimeFeeTemplateScreen());
      
      case AppRoutes.notifications:
        return _buildRoute(const NotificationsScreen());
      
      case AppRoutes.settings:
        return _buildRoute(const SettingsScreen());
      
      case AppRoutes.support:
        return _buildRoute(const SupportScreen());

      // Consultant Routes
      case AppRoutes.consultantDashboard:
        return _buildRoute(const ConsultantDashboardScreen());
      
      case AppRoutes.consultantProfile:
        return _buildRoute(const ConsultantProfileScreen());
      
      case AppRoutes.consultantProfileSetup:
        return _buildRoute(const ConsultantProfileSetupScreen());
      
      case AppRoutes.consultantLeads:
        return _buildRoute(const ViewLeadsScreen());
      
      case AppRoutes.consultantCommission:
        return _buildRoute(const CommissionSummaryScreen());
      
      case AppRoutes.consultantNotifications:
        return _buildRoute(const ConsultantNotificationsScreen());
      
      case AppRoutes.consultantAddAgent:
        return _buildRoute(const AddAgentScreen());
      
      case AppRoutes.consultantPendingPayments:
        return _buildRoute(const PendingPaymentsScreen());
      
      case AppRoutes.consultantUniversities:
        return _buildRoute(const UniversitiesCoursesScreen());
      
      case AppRoutes.consultantStudents:
        return _buildRoute(const StudentManagementScreen());
      
      case AppRoutes.consultantAgents:
        return _buildRoute(const AgentManagementScreen());
      
      case AppRoutes.consultantFeePayments:
        return _buildRoute(const FeePaymentManagementScreen());
      
      case AppRoutes.consultantSupport:
        return _buildRoute(const SupportConsultantScreen());
      
      case AppRoutes.admissionForm:
        return _buildRoute(AdmissionFormScreen());

      default:
        return _buildRoute(_ErrorScreen(routeName: settings.name ?? 'Unknown'));
    }
  }

  static MaterialPageRoute _buildRoute(Widget screen) {
    return MaterialPageRoute(builder: (_) => screen);
  }
}

class _ErrorScreen extends StatelessWidget {
  final String routeName;
  
  const _ErrorScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('Route not found: $routeName'),
      ),
    );
  }
}
