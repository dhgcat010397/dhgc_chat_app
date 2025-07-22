import 'package:flutter/material.dart';
import 'package:dhgc_chat_app/src/core/responsive/responsive_breakpoint.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoint.sm;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoint.sm &&
        MediaQuery.of(context).size.width < ResponsiveBreakpoint.lg;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoint.lg;
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return desktop ?? mobile;
    }
  }
}
