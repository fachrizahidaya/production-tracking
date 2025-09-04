import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/button/form_button.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class MenuItem {
  final String title;

  MenuItem({required this.title});
}

class AppDrawer extends StatefulWidget {
  final Function() handleLogout;

  const AppDrawer({super.key, required this.handleLogout});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late Future<List<MenuItem>> menuItems;

  @override
  void initState() {
    menuItems = _loadMenuItems();
    super.initState();
  }

  Future<List<MenuItem>> _loadMenuItems() async {
    return [
      MenuItem(title: 'Dyeing'),
      MenuItem(title: 'Press Tumbler'),
      MenuItem(title: 'Stenter'),
      MenuItem(title: 'Long Sitting'),
      MenuItem(title: 'Long Hemming'),
      MenuItem(title: 'Cross Cutting'),
      MenuItem(title: 'Sewing'),
      MenuItem(title: 'Emborideries'),
      MenuItem(title: 'Sorting'),
      MenuItem(title: 'Packing'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login_logo.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              )
            ],
          )),
          Expanded(
              child: FutureBuilder<List<MenuItem>>(
                  future: menuItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No menu items found'),
                      );
                    }

                    return ListView.builder(
                      padding: PaddingColumn.screen,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return ListTile(
                          title: Text(item.title),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  })),
          const Divider(),
          Padding(
            padding: PaddingColumn.screen,
            child: FormButton(label: 'LOG OUT', onPressed: widget.handleLogout),
          )
        ],
      ),
    );
  }
}
