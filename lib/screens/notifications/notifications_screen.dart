import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            icon: Icons.check_circle,
            title: 'Application Approved',
            message: 'Student application #12345 has been approved',
            time: '2 hours ago',
            color: Colors.green,
            isRead: false,
          ),
          _buildNotificationCard(
            icon: Icons.school,
            title: 'New Course Added',
            message: 'Computer Science program is now available',
            time: '5 hours ago',
            color: Colors.blue,
            isRead: false,
          ),
          _buildNotificationCard(
            icon: Icons.payment,
            title: 'Payment Received',
            message: 'Fee payment of \$5000 received',
            time: '1 day ago',
            color: Colors.purple,
            isRead: true,
          ),
          _buildNotificationCard(
            icon: Icons.people,
            title: 'New Student Enrolled',
            message: '3 new students enrolled today',
            time: '2 days ago',
            color: Colors.orange,
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required Color color,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? AppTheme.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.charcoal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message, style: TextStyle(color: AppTheme.mediumGray)),
            const SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }
}
