import 'api_service.dart';
import 'auth_service.dart';

/// Dashboard Service
/// Handles dashboard data for different user roles
class DashboardService {
  /// Get university dashboard data
  /// Returns stats: total courses, admissions, revenue, etc.
  static Future<Map<String, dynamic>> getUniversityDashboard() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/dashboard/university',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load dashboard');
  }

  /// Get consultant dashboard data
  /// Returns stats: leads, admissions, commissions, agent performance
  static Future<Map<String, dynamic>> getConsultantDashboard() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/dashboard/consultant',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load dashboard');
  }

  /// Get super admin dashboard data
  /// Returns overall system statistics
  static Future<Map<String, dynamic>> getSuperAdminDashboard() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/dashboard/super-admin',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load dashboard');
  }

  /// Get quick stats for dashboard cards
  /// Generic method for any role-specific stats
  static Future<Map<String, dynamic>> getStats({
    String? role,
    Map<String, dynamic>? filters,
  }) async {
    final token = await AuthService.getToken();

    String url = '/dashboard/stats';
    if (role != null) {
      url += '?role=$role';
    }

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load stats');
  }
}
