import 'api_service.dart';
import 'auth_service.dart';

/// Student Service
/// Handles all student-related API calls
class StudentService {
  /// Get all students (via admissions)
  static Future<List<dynamic>> getStudents() async {
    final token = await AuthService.getToken();
    // Using /admissions because it contains the student status, course info, etc.
    final response = await ApiService.get('/admissions', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load students');
  }

  /// Get single student by ID
  static Future<Map<String, dynamic>> getStudent(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/students/$id', token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load student');
  }

  /// Create new student
  static Future<Map<String, dynamic>> createStudent(
    Map<String, dynamic> studentData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post(
      '/students',
      studentData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to create student');
  }

  /// Update student
  static Future<Map<String, dynamic>> updateStudent(
    String id,
    Map<String, dynamic> studentData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/students/$id',
      studentData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update student');
  }

  /// Delete student
  static Future<void> deleteStudent(String id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.delete('/students/$id', token: token);

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete student');
    }
  }
}
