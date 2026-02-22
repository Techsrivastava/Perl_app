import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'auth_service.dart';

class ConsultantService {
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> getMyProfile() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/consultants/me'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load consultant profile');
    }
  }

  static Future<Map<String, dynamic>> updateMyProfile(
    Map<String, dynamic> data,
  ) async {
    final response = await http.patch(
      Uri.parse('${ApiService.baseUrl}/consultants/me'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      final jsonResponse = jsonDecode(response.body);
      throw Exception(jsonResponse['message'] ?? 'Failed to update profile');
    }
  }

  static Future<String> uploadDocument(
    String filePath,
    String documentType,
  ) async {
    final token = await AuthService.getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/consultants/upload'),
    );

    request.headers.addAll({'Authorization': 'Bearer $token'});

    request.fields['documentType'] = documentType;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['filePath'];
    } else {
      final jsonResponse = jsonDecode(response.body);
      throw Exception(jsonResponse['message'] ?? 'Failed to upload document');
    }
  }
}
