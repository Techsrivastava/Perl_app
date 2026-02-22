import 'api_service.dart';
import 'auth_service.dart';

class LeadService {
  /// submit public lead (no token needed usually, but here we might use specific logic)
  static Future<void> submitPublicLead(Map<String, dynamic> leadData) async {
    final response = await ApiService.post(
      '/leads/submit',
      leadData,
      token: null,
    );
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to submit lead');
    }
  }

  /// Get leads for the current consultant/agent
  static Future<List<dynamic>> getMyLeads() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/leads/my', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }
    throw Exception(response['message'] ?? 'Failed to fetch leads');
  }

  /// Create a new lead
  static Future<Map<String, dynamic>> createLead(
    Map<String, dynamic> leadData,
  ) async {
    final token = await AuthService.getToken();
    final response = await ApiService.post('/leads', leadData, token: token);

    if (response['success'] == true) {
      return response['data'];
    }
    throw Exception(response['message'] ?? 'Failed to create lead');
  }

  /// Update a lead
  static Future<void> updateLead(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final token = await AuthService.getToken();
    final response = await ApiService.patch(
      '/leads/$id',
      updates,
      token: token,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update lead');
    }
  }

  /// Delete a lead
  static Future<void> deleteLead(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.delete('/leads/$id', token: token);

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete lead');
    }
  }
}
