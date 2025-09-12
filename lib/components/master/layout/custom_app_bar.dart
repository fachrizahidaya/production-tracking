import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onReturn;
  final List<Widget>? actions;
  final bool isWithNotification;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.onReturn,
      this.actions,
      this.isWithNotification = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onReturn != null
          ? IconButton(
              onPressed: onReturn, icon: const Icon(Icons.chevron_left))
          : null,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      actions: [
        if (isWithNotification)
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
        ...?actions
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
