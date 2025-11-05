import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color? backgroundColor;
  const CustomFloatingButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? CustomTheme().buttonColor('primary'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: icon,
    );
  }
}
