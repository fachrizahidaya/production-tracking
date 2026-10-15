import 'package:flutter/material.dart';

class AppLayout extends InheritedWidget {
  static const double breakpoint = 600;

  final bool isMobile;

  const AppLayout({
    super.key,
    required this.isMobile,
    required super.child,
  });

  bool get isTablet => !isMobile;

  static AppLayout of(BuildContext context) {
    final layout = context.dependOnInheritedWidgetOfExactType<AppLayout>();
    assert(layout != null, 'AppLayout not found in widget tree');
    return layout!;
  }

  static AppLayout? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLayout>();
  }

  static bool resolveIsMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < breakpoint;
  }

  @override
  bool updateShouldNotify(AppLayout oldWidget) {
    return isMobile != oldWidget.isMobile;
  }
}
