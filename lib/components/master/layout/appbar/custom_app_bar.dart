import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
  final status;
  final isTextEditor;
  final handleSave;

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
      this.user,
      this.status,
      this.isTextEditor = false,
      this.handleSave});

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
        if (hasOptions && status == true)
          PopupMenuButton<String>(
            color: Colors.white,
            offset: const Offset(0, 40),
            onSelected: (value) {
              final String stringId = id.toString();

              if (value == 'update' && canUpdate == true) {
                handleUpdate();
              }
              if (value == 'delete' && canDelete == true) {
                handleDelete(stringId);
              }
            },
            itemBuilder: (context) => [
              if (canUpdate == true)
                PopupMenuItem(
                  value: 'update',
                  child: Text('Edit'),
                ),
              if (canDelete == true)
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Hapus'),
                ),
            ],
          ),
        if (isTextEditor)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              handleSave();
            },
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
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'logout') {
                handleLogout();
              }
              if (value == 'account') {
                Navigator.pushNamed(context, '/account');
              }
              if (value == 'user') {}
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user',
                child: Column(
                  children: [
                    Text(
                      user,
                    ),
                    Text(
                      '@$user',
                      style: TextStyle(
                          fontSize: 12,
                          color: CustomTheme().colors('secondary')),
                    ),
                  ].separatedBy(CustomTheme().vGap('sm')),
                ),
              ),
              PopupMenuItem(
                value: 'account',
                child: Text('Account'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text(
                  'Log Out',
                ),
              ),
            ],
          ),
        ...?actions
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Column(
          children: [
            if (tab != null) tab!,
            Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
