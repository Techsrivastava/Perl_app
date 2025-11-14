import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMaxWidth)
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
    if (width < tabletMaxWidth)
      return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
    return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0);
  }

  static double getTitleFontSize(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 24.0;
    return 28.0;
  }

  static double getBodyFontSize(BuildContext context) {
    if (isMobile(context)) return 14.0;
    if (isTablet(context)) return 16.0;
    return 18.0;
  }
}
