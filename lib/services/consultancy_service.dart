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
    // We might not have a dedicated endpoint for single consultancy with stats yet
    // But we can reuse getConsultancies for now or filter
    // Or if backend supports /users/:id, but that doesn't return stats.
    // Let's assume for now we use the list.
    // Or just fetch basic user info if needed.
    // For now, let's just stick to the list method which is what the screen needs.
    throw UnimplementedError();
  }
}
