import 'api_service.dart';
import 'auth_service.dart';

/// Commission Service
/// Handles commission rules and calculations
class CommissionService {
  /// Get all commission rules
  /// Returns list of commission configurations
  static Future<List<dynamic>> getCommissionRules() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/commission-rules', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load commission rules');
  }

  /// Get single commission rule by ID
  static Future<Map<String, dynamic>> getCommissionRule(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/commission-rules/$id',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load commission rule');
  }

  /// Create new commission rule
  /// Defines commission structure for courses/universities
  static Future<Map<String, dynamic>> createCommissionRule(
    Map<String, dynamic> ruleData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post(
      '/commission-rules',
      ruleData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to create commission rule');
  }

  /// Update existing commission rule
  static Future<Map<String, dynamic>> updateCommissionRule(
    String id,
    Map<String, dynamic> ruleData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/commission-rules/$id',
      ruleData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update commission rule');
  }

  /// Delete commission rule
  static Future<void> deleteCommissionRule(String id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.delete(
      '/commission-rules/$id',
      token: token,
    );

    if (response['success'] != true) {
      throw Exception(
        response['message'] ?? 'Failed to delete commission rule',
      );
    }
  }

  /// Calculate commission for an admission
  /// Returns commission breakdown
  static Future<Map<String, dynamic>> calculateCommission({
    required String courseId,
    required double displayFee,
    required double actualFee,
    String? agentCode,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post('/commission-rules/calculate', {
      'courseId': courseId,
      'displayFee': displayFee,
      'actualFee': actualFee,
      if (agentCode != null) 'agentCode': agentCode,
    }, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to calculate commission');
  }

  /// Get commission for specific course
  /// Returns applicable commission rules for a course
  static Future<Map<String, dynamic>> getCourseCommission(
    String courseId,
  ) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/commission-rules/course/$courseId',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load course commission');
  }

  /// Get default commission settings
  /// Returns system-wide default commission percentages
  static Future<Map<String, dynamic>> getDefaultCommission() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/commission-rules/defaults',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load default commission');
  }

  /// Update default commission settings
  static Future<Map<String, dynamic>> updateDefaultCommission(
    Map<String, dynamic> defaults,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/commission-rules/defaults',
      defaults,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(
      response['message'] ?? 'Failed to update default commission',
    );
  }
}
