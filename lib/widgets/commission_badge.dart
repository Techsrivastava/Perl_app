import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';
import 'package:university_app_2/models/consultancy_model.dart';

class CommissionBadge extends StatelessWidget {
  final CommissionType type;
  final double value;
  final bool isSmall;

  const CommissionBadge({
    super.key,
    required this.type,
    required this.value,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final badgeData = _getBadgeData(type);
    final displayText = _getDisplayText(type, value);

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
        displayText,
        style: TextStyle(
          fontSize: isSmall ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: badgeData['textColor'],
        ),
      ),
    );
  }

  Map<String, Color> _getBadgeData(CommissionType type) {
    switch (type) {
      case CommissionType.percentage:
        return {
          'color': AppTheme.commissionPercentage,
          'textColor': const Color(0xFF2E7D32),
        };
      case CommissionType.flat:
        return {
          'color': AppTheme.commissionFlat,
          'textColor': const Color(0xFFE65100),
        };
      case CommissionType.oneTime:
        return {
          'color': AppTheme.commissionOneTime,
          'textColor': AppTheme.darkBlue,
        };
    }
  }

  String _getDisplayText(CommissionType type, double value) {
    switch (type) {
      case CommissionType.percentage:
        return '${value.toStringAsFixed(1)}%';
      case CommissionType.flat:
        return '\$${value.toStringAsFixed(0)}';
      case CommissionType.oneTime:
        return '\$${value.toStringAsFixed(0)} (One-time)';
    }
  }
}
