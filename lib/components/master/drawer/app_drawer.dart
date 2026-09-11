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
    'Warping',
    'Sizing',
    'Weaving',
    'Shearing',
<<<<<<< HEAD
<<<<<<< HEAD
    'Persiapan Dyeing',
=======
>>>>>>> a1ea7df (feat: warping)
=======
    'Persiapan Dyeing',
>>>>>>> 57f45d55 (feat: persiapan dyeing)
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
    'Laporan Produksi',
<<<<<<< HEAD
<<<<<<< HEAD
    'Evaluasi Rework',
    'Evaluasi BS',
<<<<<<< HEAD
<<<<<<< HEAD
    'Evaluasi GSM',
=======
>>>>>>> 7a6aa3b1 (feat: model for report)
=======
    'Evaluasi Rework',
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
=======
    'Evaluasi GSM',
>>>>>>> e2884b8b (fix: notification all evaluasi)
  ];

  final List<String> hiddenMenus = [
    'SPK',
    'Work Order',
    'Proses Produksi',
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    'Produksi',
    'Pesanan',
    'Order Greige',
    'Desain',
    'Warping',
    'Sizing',
    'Weaving',
    'Shearing',
    'Persiapan Dyeing',
    'Anomali Data',
    'Desain',
    'Notifikasi'
=======
    'Laporan',
<<<<<<< HEAD
    'Persiapan Dyeing'
>>>>>>> a1ea7df (feat: warping)
=======
=======
>>>>>>> 7a6aa3b1 (feat: model for report)
    'Produksi',
    'Pesanan',
    'Order Greige',
    'Desain',
    'Warping',
    'Sizing',
    'Weaving',
    'Shearing',
    'Persiapan Dyeing',
<<<<<<< HEAD
    'Anomali Data'
>>>>>>> f6b18dcd (fix: adjust drawer)
=======
    'Anomali Data',
    'Notifikasi'
>>>>>>> 7a6aa3b1 (feat: model for report)
=======
    'Laporan',
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
    'Produksi',
    'Pesanan',
    // 'Laporan',
<<<<<<< HEAD
>>>>>>> 44aea830 (fix: dashboard)
=======
    'Order Greige',
    'Anomali Data',
    'Desain'
>>>>>>> bce73725 (fix: hidden in drawer)
  ];

  List<MenuItem> flattenMenus(List<MenuItem> menus) {
    final List<MenuItem> result = [];

    for (final menu in menus) {
      if (menu.subMenuItems.isEmpty) {
        if (menu.allowMobile) {
          result.add(menu);
        }
      } else {
        for (final sub in menu.subMenuItems) {
          if (sub.allowMobile == false) continue;

          result.add(
            MenuItem(
              title: sub.title,
              route: sub.route,
              subMenuItems: const [],
              allowMobile: sub.allowMobile,
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
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Drawer(
      width: isTablet ? 320 : 280,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'assets/images/icon_logo.png',
                  height: isTablet ? 100 : 72,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<MenuItem>>(
                  future: _menuFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No menu found'));
                    }

                    final menus = flattenMenus(snapshot.data!)
                        .where((m) => !hiddenMenus.contains(m.title))
                        .toList();

                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final item = menus[index];
                        final displayTitle =
                            item.title.toLowerCase() == 'sorting'
                                ? 'Sortir'
                                : item.title;

                        return ListTile(
                          title: Text(displayTitle),
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
                                                            ? Icons
                                                                .link_outlined
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
                                                                            ? Icons.layers_outlined
                                                                            : item.title == 'Tumbler'
                                                                                ? Icons.dry_cleaning_outlined
                                                                                : item.title == 'Warping'
<<<<<<< HEAD
<<<<<<< HEAD
                                                                                    ? Icons.join_inner_outlined
                                                                                    : item.title == 'Sizing'
                                                                                        ? Icons.straighten_outlined
                                                                                        : item.title == 'Weaving'
                                                                                            ? Icons.grid_on
                                                                                            : item.title == 'Shearing'
                                                                                                ? Icons.content_cut_outlined
<<<<<<< HEAD
<<<<<<< HEAD
                                                                                                : item.title == 'Persiapan Dyeing'
                                                                                                    ? Icons.format_color_fill_outlined
                                                                                                    : item.title == 'Laporan Produksi'
                                                                                                        ? Icons.file_copy_outlined
                                                                                                        : item.title == 'Evaluasi Rework'
                                                                                                            ? Icons.restart_alt_outlined
                                                                                                            : item.title == 'Evaluasi BS'
                                                                                                                ? Icons.production_quantity_limits_outlined
<<<<<<< HEAD
<<<<<<< HEAD
                                                                                                                : item.title == 'Evaluasi GSM'
                                                                                                                    ? Icons.inventory_outlined
                                                                                                                    : Icons.menu,
=======
                                                                                    ? Icons.straighten_outlined
=======
                                                                                    ? Icons.join_inner_outlined
>>>>>>> a1ea7df (feat: warping)
                                                                                    : item.title == 'Sizing'
                                                                                        ? Icons.straighten_outlined
                                                                                        : item.title == 'Weaving'
                                                                                            ? Icons.grid_on
                                                                                            : item.title == 'Shearing'
                                                                                                ? Icons.content_cut_outlined
                                                                                                : Icons.menu,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
                                                                                                : item.title == 'Laporan Produksi'
                                                                                                    ? Icons.file_copy_outlined
<<<<<<< HEAD
                                                                                                    : Icons.menu,
>>>>>>> 7a6aa3b1 (feat: model for report)
=======
                                                                                                    : item.title == 'Persiapan Dyeing'
                                                                                                        ? Icons.format_color_fill_outlined
=======
                                                                                                : item.title == 'Persiapan Dyeing'
                                                                                                    ? Icons.format_color_fill_outlined
                                                                                                    : item.title == 'Laporan Produksi'
                                                                                                        ? Icons.file_copy_outlined
<<<<<<< HEAD
>>>>>>> 260d45ce (fix: dashboard)
                                                                                                        : Icons.menu,
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
                                                                                                        : item.title == 'Evaluasi Rework'
                                                                                                            ? Icons.restart_alt_outlined
                                                                                                            : Icons.menu,
>>>>>>> 41ded02d (fix: rework)
=======
                                                                                                                : Icons.menu,
>>>>>>> 58857212 (feat: notifikasi evaluasi bs)
=======
                                                                                                                : item.title == 'Evaluasi GSM'
                                                                                                                    ? Icons.inventory_outlined
                                                                                                                    : Icons.menu,
>>>>>>> e2884b8b (fix: notification all evaluasi)
                          ),
                          onTap: () {
                            Navigator.pop(context);

<<<<<<< HEAD
<<<<<<< HEAD
=======
                            if (item.title == 'Warping') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WarpingScreen(),
                                ),
                              );
                              return;
                            }
                            if (item.title == 'Sizing') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SizingScreen(),
                                ),
                              );
                              return;
                            }
                            if (item.title == 'Weaving') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WeavingScreen(),
                                ),
                              );
                              return;
                            }
                            if (item.title == 'Shearing') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ShearingScreen(),
                                ),
                              );
                              return;
                            }

>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> a1ea7df (feat: warping)
                            if (item.route != null) {
                              Navigator.pushNamed(context, item.route!);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
