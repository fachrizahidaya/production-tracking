import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;

  const DashboardCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomTheme().cardTheme(),
      child: child,
    );
  }
}
