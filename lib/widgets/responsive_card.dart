import 'package:flutter/material.dart';
import 'package:university_app_2/core/utils/responsive_utils.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool wrapWithCard;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.wrapWithCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardPadding = padding ?? ResponsiveUtils.getScreenPadding(context);

    final content = Padding(padding: cardPadding, child: child);

    if (!wrapWithCard) {
      return content;
    }

    return Card(
      elevation: elevation ?? 2.0,
      color: backgroundColor ?? theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      ),
      child: content,
    );
  }
}
