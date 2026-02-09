import 'api_service.dart';
import 'auth_service.dart';

/// Admission Service
/// Handles all admission application related API calls
class AdmissionService {
  /// Submit new admission application
  static Future<Map<String, dynamic>> submitAdmission(
    Map<String, dynamic> admissionData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post(
      '/admissions',
      admissionData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to submit admission');
  }

  /// Get all admissions with optional filters
  static Future<List<dynamic>> getAdmissions({
    String? status,
    String? studentId,
  }) async {
    final token = await AuthService.getToken();

    String url = '/admissions?';
    if (status != null) {
      url += 'status=$status&';
    }
    if (studentId != null) {
      url += 'studentId=$studentId&';
    }

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load admissions');
  }

  /// Get single admission by ID
  static Future<Map<String, dynamic>> getAdmission(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/admissions/$id', token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load admission');
  }

  /// Update admission status
  static Future<Map<String, dynamic>> updateAdmissionStatus(
    String id,
    String status, {
    String? remarks,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch('/admissions/$id/status', {
      'status': status,
      if (remarks != null) 'remarks': remarks,
    }, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update status');
  }
}
