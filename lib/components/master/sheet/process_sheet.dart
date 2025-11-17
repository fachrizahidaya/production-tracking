import 'package:flutter/material.dart';

class ProcessSheet {
  static void showOptions(
    BuildContext context, {
    required List<BottomSheetOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return ListTile(
              leading: Icon(option.icon, color: option.iconColor),
              title: Text(option.title),
              onTap: () {
                Navigator.pop(context);
                option.onTap();
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class BottomSheetOption {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  BottomSheetOption({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}
