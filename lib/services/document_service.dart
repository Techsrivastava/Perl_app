import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';
import 'auth_service.dart';

/// Document Service
/// Handles document upload, download, and management
class DocumentService {
  /// Upload a document with file
  static Future<Map<String, dynamic>> uploadDocument({
    required File file,
    required String type,
    String? studentId,
    String? admissionId,
    String? notes,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final uri = Uri.parse('${ApiService.baseUrl}/documents/upload');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    // Add file
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Add form fields
    if (studentId != null) request.fields['student'] = studentId;
    request.fields['type'] = type;
    if (admissionId != null) request.fields['admission'] = admissionId;
    if (notes != null) request.fields['notes'] = notes;

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);

      if (jsonResponse['success'] == true) {
        return jsonResponse['data'];
      }

      throw Exception(jsonResponse['message'] ?? 'Upload failed');
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  /// Get all documents with optional filters
  static Future<List<dynamic>> getDocuments({
    String? type,
    String? status,
    String? studentId,
  }) async {
    final token = await AuthService.getToken();

    String url = '/documents?';
    if (type != null) url += 'type=$type&';
    if (status != null) url += 'status=$status&';
    if (studentId != null) url += 'student=$studentId&';

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load documents');
  }

  /// Get single document by ID
  static Future<Map<String, dynamic>> getDocument(String id) async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/documents/$id', token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to load document');
  }

  /// Update document status (VERIFIED/REJECTED)
  static Future<Map<String, dynamic>> updateDocumentStatus(
    String id,
    String status, {
    String? rejectionReason,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.put('/documents/$id/status', {
      'status': status,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    }, token: token);

    if (response['success'] == true) {
      return response['data'];
    }

    throw Exception(response['message'] ?? 'Failed to update status');
  }

  /// Delete document
  static Future<void> deleteDocument(String id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.delete('/documents/$id', token: token);

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete document');
    }
  }

  /// Get download URL for document
  static String getDownloadUrl(String id, String? token) {
    return '${ApiService.baseUrl}/documents/$id/download';
  }
}
