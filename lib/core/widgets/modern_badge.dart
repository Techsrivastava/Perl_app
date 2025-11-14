import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

/// Modern minimal badge
class ModernBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool isOutlined;

  const ModernBadge({
    super.key,
    required this.label,
    required this.color,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: isOutlined ? Border.all(color: color, width: 1.5) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Status badge with predefined colors
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
      case 'completed':
      case 'success':
        return AppTheme.success;
      case 'pending':
      case 'in progress':
        return AppTheme.warning;
      case 'rejected':
      case 'failed':
      case 'cancelled':
        return AppTheme.error;
      default:
        return AppTheme.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModernBadge(label: status, color: _getColor());
  }
}
