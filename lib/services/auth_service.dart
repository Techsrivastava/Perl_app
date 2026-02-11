import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

/// Authentication Service
/// Handles user authentication, token management, and session persistence
class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Login with email and password
  /// Returns user data and token on success
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });

    // Save token and user data
    if (response['success'] == true) {
      final token = response['token'];
      final user = response['data'];

      await _saveToken(token);
      await _saveUser(user);

      return {'token': token, 'user': user};
    }

    throw Exception(response['message'] ?? 'Login failed');
  }

  /// Register new user account
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> userData,
  ) async {
    final response = await ApiService.post('/auth/register', userData);

    if (response['success'] == true) {
      // Optionally auto-login after registration
      final token = response['token'];
      final user = response['data'];

      if (token != null) {
        await _saveToken(token);
        await _saveUser(user);
      }

      return response;
    }

    throw Exception(response['message'] ?? 'Registration failed');
  }

  /// Logout - clear all stored data
  static Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        // Call backend logout endpoint
        await ApiService.post('/auth/logout', {}, token: token);
      }
    } catch (e) {
      // Ignore backend errors on logout
      debugPrint('Logout error: $e');
    } finally {
      // Always clear local data
      await _clearAuthData();
    }
  }

  /// Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await ApiService.get('/auth/me', token: token);

      if (response['success'] == true) {
        await _saveUser(response['data']);
        return response['data'];
      }

      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  /// Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get stored user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      try {
        return jsonDecode(userString) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('Parse user data error: $e');
        return null;
      }
    }

    return null;
  }

  /// Save authentication token
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Save user data
  static Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  /// Clear all authentication data
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Update password
  static Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      await ApiService.patch('/auth/update-password', {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }, token: token);

      return true;
    } catch (e) {
      debugPrint('Update password error: $e');
      return false;
    }
  }
}
