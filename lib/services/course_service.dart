import 'api_service.dart';
import 'auth_service.dart';

/// Course Service
/// Handles all course-related API calls
class CourseService {
  /// Get all courses with optional filters
  static Future<List<dynamic>> getCourses({
    String? universityId,
    bool activeOnly = true,
  }) async {
    final token = await AuthService.getToken();

    // Build query string
    String url = '/courses?';
    if (universityId != null) {
      url += 'universityId=$universityId&';
    }
    if (activeOnly) {
      url += 'activeOnly=true&';
    }

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load courses');
  }

  /// Get single course by ID
  static Future<Map<String, dynamic>> getCourse(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/courses/$id', token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load course');
  }

  /// Create new course
  static Future<Map<String, dynamic>> createCourse(
    Map<String, dynamic> courseData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post(
      '/courses',
      courseData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to create course');
  }

  /// Update course
  static Future<Map<String, dynamic>> updateCourse(
    String id,
    Map<String, dynamic> courseData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/courses/$id',
      courseData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update course');
  }

  /// Toggle course status (active/inactive)
  static Future<Map<String, dynamic>> toggleCourseStatus(String id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/courses/$id/status',
      {},
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to toggle course status');
  }
}
