import 'api_service.dart';
import 'auth_service.dart';

class FeeService {
  /// Get all payments (fees)
  static Future<List<dynamic>> getPayments() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/payments', token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }
    throw Exception(response['message'] ?? 'Failed to load payments');
  }

  /// Initiate a payment
  static Future<Map<String, dynamic>> initiatePayment({
    required String admissionId,
    required double amount,
    String? mode,
    String? transactionId,
    String? remarks,
  }) async {
    final token = await AuthService.getToken();
    final response = await ApiService.post('/payments/initiate', {
      'admissionId': admissionId,
      'amount': amount,
      if (mode != null) 'mode': mode,
      if (transactionId != null) 'transactionId': transactionId,
      if (remarks != null) 'remarks': remarks,
    }, token: token);

    if (response['success'] == true) {
      return response['data'];
    }
    throw Exception(response['message'] ?? 'Failed to initiate payment');
  }

  /// Confirm a payment (upload receipt logic might be separate or part of this if handling files)
  /// For now, this confirms the record in the backend.
  static Future<void> confirmPayment(String paymentId, {String? status}) async {
    final token = await AuthService.getToken();
    final response = await ApiService.post('/payments/$paymentId/confirm', {
      if (status != null) 'status': status,
    }, token: token);

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to confirm payment');
    }
  }
}
