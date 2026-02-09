import 'api_service.dart';
import 'auth_service.dart';

/// Report Service
/// Handles all reporting and analytics operations
class ReportService {
  /// Get earnings report
  /// Returns revenue, payments, and earnings data
  static Future<Map<String, dynamic>> getEarningsReport({
    String? startDate,
    String? endDate,
    String? universityId,
  }) async {
    final token = await AuthService.getToken();

    String url = '/reports/earnings?';
    if (startDate != null) url += 'startDate=$startDate&';
    if (endDate != null) url += 'endDate=$endDate&';
    if (universityId != null) url += 'universityId=$universityId&';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load earnings report');
  }

  /// Get commission report
  /// Returns agent/consultant commission details
  static Future<Map<String, dynamic>> getCommissionReport({
    String? startDate,
    String? endDate,
    String? agentId,
    String? status,
  }) async {
    final token = await AuthService.getToken();

    String url = '/reports/commission?';
    if (startDate != null) url += 'startDate=$startDate&';
    if (endDate != null) url += 'endDate=$endDate&';
    if (agentId != null) url += 'agentId=$agentId&';
    if (status != null) url += 'status=$status&';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load commission report');
  }

  /// Get analytics report
  /// Returns charts and analytics data
  static Future<Map<String, dynamic>> getAnalytics({
    String? type,
    String? period,
  }) async {
    final token = await AuthService.getToken();

    String url = '/reports/analytics?';
    if (type != null) url += 'type=$type&';
    if (period != null) url += 'period=$period&';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load analytics');
  }

  /// Get student fee report
  /// Returns student-wise fee collection data
  static Future<List<dynamic>> getFeeReport({
    String? status,
    String? universityId,
  }) async {
    final token = await AuthService.getToken();

    String url = '/reports/fees?';
    if (status != null) url += 'status=$status&';
    if (universityId != null) url += 'universityId=$universityId&';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load fee report');
  }

  /// Get consultant share report
  /// Returns commission sharing breakdown
  static Future<Map<String, dynamic>> getConsultantShareReport({
    String? startDate,
    String? endDate,
  }) async {
    final token = await AuthService.getToken();

    String url = '/reports/consultant-share?';
    if (startDate != null) url += 'startDate=$startDate&';
    if (endDate != null) url += 'endDate=$endDate&';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(
      response['message'] ?? 'Failed to load consultant share report',
    );
  }

  /// Export report to PDF/CSV
  /// Returns download URL or file data
  static Future<String> exportReport({
    required String reportType,
    required String format, // 'pdf' or 'csv'
    Map<String, dynamic>? filters,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post('/reports/export', {
      'reportType': reportType,
      'format': format,
      'filters': filters ?? {},
    }, token: token);

    if (response['success'] == true) {
      return response['data']['url'] ?? response['data']['downloadUrl'];
    }

    throw Exception(response['message'] ?? 'Failed to export report');
  }

  /// Get ranking/leaderboard
  /// Returns top performers
  static Future<List<dynamic>> getRanking({
    String? type, // 'agent', 'consultant', 'university'
    int limit = 10,
  }) async {
    final token = await AuthService.getToken();

    String url = '/reports/ranking?';
    if (type != null) url += 'type=$type&';
    url += 'limit=$limit';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load ranking');
  }
}
