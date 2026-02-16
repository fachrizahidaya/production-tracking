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
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Padding(
          padding: CustomTheme().padding('dialog'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(actions.length, (index) {
              final item = actions[index];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(item.icon, color: item.iconColor),
                    title: Text(item.title),
                    onTap: () {
                      Navigator.pop(context);
                      item.onTap();
                    },
                  ),
                  if (index != actions.length - 1) const Divider(height: 1),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
