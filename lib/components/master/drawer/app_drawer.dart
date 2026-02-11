import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/home/index.dart';

class AppDrawer extends StatefulWidget {
  final handleLogout;
  final handleFetchMenu;

  const AppDrawer(
      {super.key, required this.handleLogout, this.handleFetchMenu});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Future<List<MenuItem>> _menuFuture;

  List<String> menuOrder = [
    'Dashboard',
    'Dyeing',
    'Press',
    'Tumbler',
    'Stenter',
    'Long Slitting',
    'Long Hemming',
    'Cross Cutting',
    'Sewing',
    'Embroidery',
    'Printing',
    'Sorting',
    'Packing',
  ];

  final List<String> hiddenMenus = [
    'SPK',
    'Work Order',
    'Proses Produksi',
    'Laporan'
  ];

  List<MenuItem> flattenMenus(List<MenuItem> menus) {
    final List<MenuItem> result = [];

    for (final menu in menus) {
      if (menu.subMenuItems.isEmpty) {
        result.add(menu);
      } else {
        for (final sub in menu.subMenuItems) {
          result.add(
            MenuItem(
              title: sub.title,
              route: sub.route,
              subMenuItems: const [],
            ),
          );
        }
      }
    }

    result.sort((a, b) {
      final aIndex = menuOrder.indexOf(a.title);
      final bIndex = menuOrder.indexOf(b.title);
      if (aIndex == -1 && bIndex == -1) return 0;
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });

    return result;
  }

  @override
  void initState() {
    super.initState();
    _menuFuture = widget.handleFetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset(
                'assets/images/icon_logo.png',
                height: 100,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<MenuItem>>(
                future: _menuFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No menu found'));
                  }

                  final menus = flattenMenus(snapshot.data!)
                      .where((m) => !hiddenMenus.contains(m.title))
                      .toList();

                  return ListView.builder(
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final item = menus[index];
                      return ListTile(
                        title: Text(item.title),
                        leading: Icon(
                          item.title == 'Dyeing'
                              ? Icons.invert_colors_on_outlined
                              : item.title == 'Press'
                                  ? Icons.dry_outlined
                                  : item.title == 'Stenter'
                                      ? Icons.air
                                      : item.title == 'Long Slitting'
                                          ? Icons.cut_outlined
                                          : item.title == 'Long Hemming'
                                              ? Icons.link_outlined
                                              : item.title == 'Cross Cutting'
                                                  ? Icons.cut_outlined
                                                  : item.title == 'Sewing'
                                                      ? Icons.link_outlined
                                                      : item.title ==
                                                              'Embroidery'
                                                          ? Icons.link_outlined
                                                          : item.title ==
                                                                  'Printing'
                                                              ? Icons
                                                                  .print_rounded
                                                              : item.title ==
                                                                      'Sorting'
                                                                  ? Icons
                                                                      .sort_outlined
                                                                  : item.title ==
                                                                          'Dashboard'
                                                                      ? Icons
                                                                          .home_outlined
                                                                      : item.title ==
                                                                              'Packing'
                                                                          ? Icons
                                                                              .layers_outlined
                                                                          : item.title == 'Tumbler'
                                                                              ? Icons.dry_cleaning_outlined
                                                                              : Icons.menu,
                        ),
                        onTap: item.route == null
                            ? null
                            : () => Navigator.pushNamed(context, item.route!),
                      );
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
