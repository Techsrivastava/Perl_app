import 'dart:convert';
import 'package:http/http.dart' as http;

/// A minimal HTTP client for interacting with the backend API.
///
/// This service centralizes API calls and handles JSON encoding/decoding.
/// It also surfaces validation errors from the server as Dart exceptions so
/// that callers (e.g. providers or UI screens) can display meaningful
/// messages.  Update [baseUrl] to point to your deployed backend.
class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://educrmbackend-production-7480.up.railway.app/api/v1',
  );

  /// Perform a POST request.  Optionally include a JWT token for authenticated
  /// routes.  Returns the decoded JSON body on success, or throws an
  /// Exception with the error message on failure.  Validation errors from
  /// the backend will propagate up as Exception messages.
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  /// Perform a GET request.
  static Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return _processResponse(response);
  }

  /// Perform a PATCH request.
  static Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  /// Perform a PUT request.
  static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  /// Perform a DELETE request.
  static Future<Map<String, dynamic>> delete(
    String path, {
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return _processResponse(response);
  }

  /// Helper to decode the HTTP response and throw if not successful.  This
  /// method surfaces the server's `message` property if present, or falls back
  /// to the status reason phrase.  Successful responses return the decoded
  /// JSON body (Map<String, dynamic>).
  static Map<String, dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final Map<String, dynamic> jsonBody = jsonDecode(
      response.body.isEmpty ? '{}' : response.body,
    );
    if (statusCode >= 200 && statusCode < 300) {
      return jsonBody;
    }
    final errorMessage =
        jsonBody['message'] ?? 'Request failed with status $statusCode';
    throw Exception(errorMessage);
  }

  // Convenience methods for specific API endpoints

  /// Register a new student account.  Returns the created user data on success.
  static Future<Map<String, dynamic>> registerStudent({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await post('/students/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return response['data'] ?? response;
  }

  /// Register a new university.  Returns the user and university on success.
  static Future<Map<String, dynamic>> registerUniversity({
    required String name,
    required String email,
    required String password,
    required String universityName,
  }) async {
    final response = await post('/universities/register', {
      'name': name,
      'email': email,
      'password': password,
      'universityName': universityName,
    });
    return response['data'] ?? response;
  }

  /// Fetch all courses.  Optionally require authentication to see restricted
  /// fields.  Returns a list of courses with fee structure and seat counts.
  static Future<List<dynamic>> getCourses({String? token}) async {
    final response = await get('/courses', token: token);
    return response['data'] as List<dynamic>? ?? [];
  }

  /// Fetch notifications for the logged-in user.
  static Future<List<dynamic>> getNotifications({
    String? token,
    bool unreadOnly = false,
  }) async {
    final path = '/notifications${unreadOnly ? '?unread=true' : ''}';
    final response = await get(path, token: token);
    return response['data'] as List<dynamic>? ?? [];
  }
}
