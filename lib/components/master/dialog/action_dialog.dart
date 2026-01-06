import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class DialogActionItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  DialogActionItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });
}

class ActionDialog extends StatelessWidget {
  final List<DialogActionItem> actions;

  const ActionDialog({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: CustomTheme().padding('dialog'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: actions.map((item) {
            return ListTile(
              leading: Icon(item.icon, color: item.iconColor),
              title: Text(item.title),
              onTap: () {
                Navigator.pop(context);
                item.onTap();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
