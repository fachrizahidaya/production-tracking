import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onReturn;
  final List<Widget>? actions;
  final bool isWithNotification;
  final tab;
  final bool? canDelete;
  final bool? canUpdate;
  final handleDelete;
  final handleUpdate;
  final id;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.onReturn,
      this.actions,
      this.isWithNotification = false,
      this.tab,
      this.canDelete,
      this.canUpdate,
      this.handleDelete,
      this.handleUpdate,
      this.id});

  @override
  Widget build(BuildContext context) {
    final bool hasOptions = (canDelete == true || canUpdate == true);
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
        if (hasOptions)
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              final String stringId = id.toString();

              // if (value == 'update' && canUpdate == true) {
              //   handleUpdate(stringId);
              // }
              if (value == 'delete' && canDelete == true) {
                handleDelete(stringId);
              }
            },
            itemBuilder: (context) => [
              // if (canUpdate == true)
              //   const PopupMenuItem(
              //     value: 'update',
              //     child: Text('Update'),
              //   ),
              if (canDelete == true)
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
            ],
          )
        else if (isWithNotification)
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
        ...?actions
      ],
      bottom: tab,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
