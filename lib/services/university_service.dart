import 'api_service.dart';
import 'auth_service.dart';
import '../models/university_model.dart';

/// University Service
/// Handles all university-related API calls
class UniversityService {
  /// Get current user's university profile
  static Future<University> getMyUniversity() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/universities/me', token: token);

    if (response['success'] == true) {
      return University.fromJson(response['data']);
    }

    throw Exception(response['message'] ?? 'Failed to load university profile');
  }

  /// Get all universities
  static Future<List<dynamic>> getUniversities() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/universities', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load universities');
  }

  /// Get single university by ID
  static Future<Map<String, dynamic>> getUniversity(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/universities/$id', token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load university');
  }

  /// Create new university
  static Future<Map<String, dynamic>> createUniversity(
    Map<String, dynamic> universityData,
  ) async {
    final token = await AuthService.getToken();
    // Allow public registration without token
    final response = await ApiService.post(
      '/universities',
      universityData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to create university');
  }

  /// Update university
  static Future<Map<String, dynamic>> updateUniversity(
    String id,
    Map<String, dynamic> universityData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/universities/$id',
      universityData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update university');
  }
}
