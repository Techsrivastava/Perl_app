import 'api_service.dart';
import 'auth_service.dart';

/// Notification Service
/// Handles all notification-related API calls
class NotificationService {
  /// Get all notifications
  static Future<List<dynamic>> getNotifications({
    bool unreadOnly = false,
  }) async {
    final token = await AuthService.getToken();

    String url = '/notifications';
    if (unreadOnly) {
      url += '?unread=true';
    }

    final response = await ApiService.get(url, token: token);

    if (response['success'] == true) {
      return response['data'] as List<dynamic>;
    }

    throw Exception(response['message'] ?? 'Failed to load notifications');
  }

  /// Get unread notification count
  static Future<int> getUnreadCount() async {
    final token = await AuthService.getToken();
    final response = await ApiService.get('/notifications/count', token: token);

    if (response['success'] == true) {
      return response['data']['count'] as int;
    }

    return 0;
  }

  /// Mark single notification as read
  static Future<void> markAsRead(String id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    await ApiService.patch('/notifications/$id/read', {}, token: token);
  }

  /// Mark all notifications as read
  static Future<int> markAllAsRead() async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.patch(
      '/notifications/mark-all-read',
      {},
      token: token,
    );

    if (response['success'] == true) {
      return response['data']['count'] as int;
    }

    return 0;
  }

  /// Delete notification
  static Future<void> deleteNotification(String id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await ApiService.delete(
      '/notifications/$id',
      token: token,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete notification');
    }
  }
}
