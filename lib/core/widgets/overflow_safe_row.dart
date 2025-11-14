import 'package:flutter/material.dart';

/// Overflow-safe Row with automatic text wrapping
class OverflowSafeRow extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;

  const OverflowSafeRow({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _wrapChildren(children),
    );
  }

  List<Widget> _wrapChildren(List<Widget> widgets) {
    return widgets.map((child) {
      // If it's a Text widget without Expanded/Flexible, wrap it
      if (child is Text && child.overflow == null) {
        return Flexible(
          child: Text(
            child.data ?? '',
            style: child.style,
            textAlign: child.textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: child.maxLines,
          ),
        );
      }
      // If already wrapped, return as is
      if (child is Flexible || child is Expanded) {
        return child;
      }
      // For other widgets, return as is
      return child;
    }).toList();
  }
}

/// Safe Row for label-value pairs (common pattern)
class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? valueColor;
  final bool valueBold;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            label,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 1,
          child: Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor,
                ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
