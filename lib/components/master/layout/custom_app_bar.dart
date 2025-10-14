import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onReturn;
  final List<Widget>? actions;
  final bool isWithNotification;
  final bool isWithAccount;
  final tab;
  final bool? canDelete;
  final bool? canUpdate;
  final handleDelete;
  final handleUpdate;
  final handleLogout;
  final id;
  final String? label;
  final user;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.onReturn,
      this.actions,
      this.isWithNotification = false,
      this.isWithAccount = false,
      this.tab,
      this.canDelete,
      this.canUpdate,
      this.handleDelete,
      this.handleUpdate,
      this.id,
      this.label,
      this.handleLogout,
      this.user});

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

              if (value == 'delete' && canDelete == true) {
                handleDelete(stringId);
              }
            },
            itemBuilder: (context) => [
              if (canDelete == true)
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Hapus'),
                ),
            ],
          ),
        if (isWithNotification)
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
        if (isWithAccount)
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle_outlined),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'logout') {
                handleLogout();
              }
              if (value == 'user') {
                handleLogout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user),
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Log Out'),
              ),
            ],
          ),
        ...?actions
      ],
      bottom: tab,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
