import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

enum ButtonVariant { primary, secondary, success, danger }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final ButtonSize size;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: size == ButtonSize.large ? 20 : 16),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    } else if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    return button;
  }

  ButtonStyle _getButtonStyle() {
    final padding = switch (size) {
      ButtonSize.small => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      ButtonSize.medium => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      ButtonSize.large => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
    };

    final textStyle = switch (size) {
      ButtonSize.small => const TextStyle(fontSize: 13),
      ButtonSize.medium => const TextStyle(fontSize: 14),
      ButtonSize.large => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    };

    final buttonStyle = switch (variant) {
      ButtonVariant.primary => ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: padding,
      ),
      ButtonVariant.secondary => ElevatedButton.styleFrom(
        backgroundColor: AppTheme.lightGray,
        foregroundColor: AppTheme.charcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        padding: padding,
      ),
      ButtonVariant.success => ElevatedButton.styleFrom(
        backgroundColor: AppTheme.success,
        foregroundColor: AppTheme.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: padding,
      ),
      ButtonVariant.danger => ElevatedButton.styleFrom(
        backgroundColor: AppTheme.error,
        foregroundColor: AppTheme.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: padding,
      ),
    };

    return buttonStyle.copyWith(
      textStyle: MaterialStateProperty.all<TextStyle>(textStyle),
    );
  }
}
