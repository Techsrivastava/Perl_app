import 'api_service.dart';
import 'auth_service.dart';

class CreativeService {
  /// Fetch all banner templates available for the user
  static Future<List<dynamic>> getBannerTemplates() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/banners/my', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }
    throw Exception(response['message'] ?? 'Failed to load banners');
  }

  /// Generate QR code and tracking assets for the current user
  static Future<Map<String, dynamic>> generateAssets() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/banners/generate', token: token);

    if (response['success'] == true) {
      return response['data'];
    }
    throw Exception(response['message'] ?? 'Failed to generate assets');
  }

  /// Create a creative record in the backend (optional, but good for tracking)
  static Future<Map<String, dynamic>> createCreative(
    Map<String, dynamic> data,
  ) async {
    final token = await AuthService.getToken();
    final response = await ApiService.post('/creatives', data, token: token);

    if (response['success'] == true) {
      return response['data'];
    }
    throw Exception(response['message'] ?? 'Failed to save creative');
  }
}
