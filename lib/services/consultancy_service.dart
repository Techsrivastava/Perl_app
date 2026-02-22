import 'api_service.dart';
import 'auth_service.dart';
import '../models/consultancy_model.dart'; // Make sure this path is correct

/// Consultancy Service
/// Handles all consultancy-related API calls
class ConsultancyService {
  /// Get all consultancies with stats
  static Future<List<Consultancy>> getConsultancies() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/users/consultancies', token: token);

    if (response['success'] == true) {
      final List<dynamic> data = response['data'];
      return data.map((json) => Consultancy.fromJson(json)).toList();
    }

    throw Exception(response['message'] ?? 'Failed to load consultancies');
  }

  /// Get single consultancy by ID
  static Future<Consultancy> getConsultancy(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/users/$id', token: token);

    if (response['success'] == true) {
      return Consultancy.fromJson(response['data']);
    }

    throw Exception(response['message'] ?? 'Failed to load consultancy');
  }

  /// Update consultancy
  static Future<Map<String, dynamic>> updateConsultancy(
    String id,
    Map<String, dynamic> data,
  ) async {
    final token = await AuthService.getToken();
    final response = await ApiService.patch('/users/$id', data, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update consultancy');
  }
}
