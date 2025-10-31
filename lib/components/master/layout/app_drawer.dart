import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/screens/home/index.dart';

class AppDrawer extends StatefulWidget {
  final Function() handleLogout;
  final handleFetchMenu;

  const AppDrawer(
      {super.key, required this.handleLogout, this.handleFetchMenu});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Future<List<MenuItem>> menuItems;
  late Future<List<MenuItem>> _menuFuture;

  @override
  void initState() {
    menuItems = widget.handleFetchMenu();
    _menuFuture = widget.handleFetchMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic_launcher.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                )
              ],
            )),
            Expanded(
              child: FutureBuilder<List<MenuItem>>(
                future: _menuFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No menu found'));
                  }

                  final menus = snapshot.data!;
                  return ListView.builder(
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final item = menus[index];

                      if (item.subMenuItems.isEmpty) {
                        // Regular menu (no children)
                        return ListTile(
                          title: Text(item.title),
                          onTap: () {
                            if (item.route != null && item.route!.isNotEmpty) {
                              Navigator.pushNamed(context, item.route!);
                            }
                          },
                        );
                      } else {
                        // Menu with children
                        return Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            title: Text(item.title),
                            children: item.subMenuItems.map((sub) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(sub.title),
                                ),
                                onTap: () {
                                  if (sub.route != null &&
                                      sub.route!.isNotEmpty) {
                                    Navigator.pushNamed(context, sub.route!);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.logout, color: Colors.red),
            //   title: const Text('Logout'),
            //   onTap: widget.handleLogout,
            // ),
          ],
        ),
      ),
    );
  }
}
