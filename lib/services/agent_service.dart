import 'api_service.dart';
import 'auth_service.dart';

/// Agent Service
/// Handles all agent-related API calls including code lookup
class AgentService {
  /// Lookup agent by referral code
  /// Used in admission forms for agent validation
  static Future<Map<String, dynamic>> lookupAgentByCode(String code) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/agents/by-code/$code',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Agent not found');
  }

  /// Get all agents
  static Future<List<dynamic>> getAgents() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/agents', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load agents');
  }

  /// Get single agent by ID
  static Future<Map<String, dynamic>> getAgent(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/agents/$id', token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load agent');
  }

  /// Create new agent
  static Future<Map<String, dynamic>> createAgent(
    Map<String, dynamic> agentData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.post('/agents', agentData, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to create agent');
  }

  /// Get agent performance metrics
  static Future<Map<String, dynamic>> getAgentPerformance(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get(
      '/agents/$id/performance',
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load performance data');
  }

  /// Update agent details
  static Future<Map<String, dynamic>> updateAgent(
    String id,
    Map<String, dynamic> agentData,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/agents/$id',
      agentData,
      token: token,
    );

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update agent');
  }
}
