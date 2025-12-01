import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
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
                  'assets/images/icon_logo.png',
                  height: 100,
                  width: 100,
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
                                title: Row(
                                  children: [
                                    Icon(
                                      sub.title == 'Pencelupan (Dyeing)'
                                          ? Icons.invert_colors_on_outlined
                                          : sub.title == 'Press Tumbler'
                                              ? Icons.content_copy_rounded
                                              : sub.title == 'Stenter'
                                                  ? Icons.air
                                                  : sub.title == 'Long Sitting'
                                                      ? Icons
                                                          .content_paste_outlined
                                                      : sub.title ==
                                                              'Long Hemming'
                                                          ? Icons.cut
                                                          : sub.title ==
                                                                  'Cross Cutting'
                                                              ? Icons.cut
                                                              : sub.title ==
                                                                      'Jahit (Sewing)'
                                                                  ? Icons
                                                                      .link_outlined
                                                                  : sub.title ==
                                                                          'Bordir (Embroidery)'
                                                                      ? Icons
                                                                          .color_lens_outlined
                                                                      : sub.title ==
                                                                              'Printing'
                                                                          ? Icons
                                                                              .print_rounded
                                                                          : sub.title == 'Sorting'
                                                                              ? Icons.sort_outlined
                                                                              : Icons.stacked_bar_chart_outlined, // 👈 your fixed icon
                                    ),
                                    Text(sub.title),
                                  ].separatedBy(SizedBox(
                                    width: 16,
                                  )),
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
          ],
        ),
      ),
    );
  }
}
