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
  final handleFinish;
  final handleLogout;
  final id;
  final String? label;
  final user;
  final status;
  final isTextEditor;
  final handleSave;
  final name;

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
      this.handleSave,
      this.name,
      this.handleFinish});

  @override
  Widget build(BuildContext context) {
    String getInitial(String? name) {
      if (name == null || name.trim().isEmpty) return '?';
      return name.trim()[0].toUpperCase();
    }

    final bool hasOptions = (canDelete == true || canUpdate == true);
    return AppBar(
      leading: onReturn != null
          ? IconButton(
              onPressed: onReturn, icon: const Icon(Icons.chevron_left))
          : null,
      title: Text(
        title,
        style: TextStyle(fontSize: CustomTheme().fontSize('xl')),
      ),
      actions: [
        if (hasOptions && status == true)
          PopupMenuButton<String>(
            color: Colors.white,
            offset: const Offset(0, 40),
            onSelected: (value) {
              final String stringId = id.toString();

              if (value == 'finish' && canUpdate == true) {
                handleFinish();
              }
              if (value == 'update' && canUpdate == true) {
                handleUpdate();
              }
              if (value == 'delete' && canDelete == true) {
                handleDelete(stringId);
              }
            },
            itemBuilder: (context) => [
              if (canUpdate == true)
                //   PopupMenuItem(
                //     value: 'finish',
                //     child: Text('Selesai Proses'),
                //   ),
                if (canUpdate == true &&
                    (label != 'Sorting' || label != 'Packing'))
                  PopupMenuItem(
                    value: 'update',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                        ),
                        Text('Edit'),
                      ].separatedBy(CustomTheme().hGap('sm')),
                    ),
                  ),
              if (canDelete == true)
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 14),
                      Text('Hapus'),
                    ].separatedBy(CustomTheme().hGap('sm')),
                  ),
                ),
            ],
          ),
        if (isTextEditor)
          //   IconButton(
          //     icon: const Icon(Icons.check),
          //     onPressed: () {
          //       handleSave();
          //     },
          //   ),
          if (isWithNotification)
            //   IconButton(
            //     icon: const Icon(Icons.notifications_outlined),
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/notification');
            //     },
            //   ),
            if (isWithAccount)
              PopupMenuButton<String>(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: CustomTheme().colors('primary'),
                  child: Text(
                    getInitial(name),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: CustomTheme().fontSize('sm'),
                    ),
                  ),
                ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                        ),
                        Text(
                          '@$user',
                          style: TextStyle(
                              fontSize: CustomTheme().fontSize('sm'),
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
