import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
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

  @override
  void initState() {
    menuItems = widget.handleFetchMenu();
    super.initState();
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
                          leading: item.title == 'Pencelupan (Dyeing)'
                              ? Icon(Icons.water_drop_outlined)
                              : item.title == 'Press Tumbler'
                                  ? Icon(Icons.layers_outlined)
                                  : item.title == 'Stenter'
                                      ? Icon(Icons.dry_cleaning_outlined)
                                      : item.title == 'Long Hemming'
                                          ? Icon(Icons.cut_outlined)
                                          : item.title == 'Jahit (Sewing)'
                                              ? Icon(Icons.straighten_outlined)
                                              : Icon(Icons.telegram_outlined),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, item.route);
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
