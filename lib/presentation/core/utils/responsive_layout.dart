import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class ResponsiveLayout {
  static const double mobileBreakpoint = 500;
  static const double tabletBreakpoint = 724;

  static ScreenType getScreenType(BuildContext context) {
    return getScreenTypeFromWidth(MediaQuery.of(context).size.width);
  }

  static ScreenType getScreenTypeFromWidth(double width) {
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  static int getCrossAxisCount(double width) {
    if (width < mobileBreakpoint) {
      return 1;
    } else if (width < tabletBreakpoint) {
      return 2;
    } else {
      return 3;
    }
  }

  static double getHorizontalPadding(double width) {
    if (width < mobileBreakpoint) {
      return 16;
    } else if (width < tabletBreakpoint) {
      return 20;
    } else {
      return 32;
    }
  }

  static double getVerticalPadding(double width) {
    if (width < mobileBreakpoint) {
      return 16;
    } else if (width < tabletBreakpoint) {
      return 20;
    } else {
      return 32;
    }
  }
}
