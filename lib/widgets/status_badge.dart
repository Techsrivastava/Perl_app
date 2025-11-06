import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({super.key, required this.status, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final badgeData = _getBadgeData(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: badgeData['color'],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: isSmall ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: badgeData['textColor'],
        ),
      ),
    );
  }

  Map<String, Color> _getBadgeData(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        return {
          'color': AppTheme.commissionPercentage,
          'textColor': const Color(0xFF2E7D32),
        };
      case 'pending':
        return {
          'color': AppTheme.commissionFlat,
          'textColor': const Color(0xFFE65100),
        };
      case 'rejected':
      case 'inactive':
        return {
          'color': const Color(0xFFFFCDD2),
          'textColor': const Color(0xFFC62828),
        };
      default:
        return {'color': AppTheme.lightBlue, 'textColor': AppTheme.darkBlue};
    }
  }
}
