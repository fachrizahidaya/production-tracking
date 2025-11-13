import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/layout/option_list.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final List<Map<String, String>> menuOptions = [
    {'label': 'EULA', 'route': '/eula'},
    {'label': 'Privacy Policy', 'route': '/privacy-policy'},
    {'label': 'Terms Conditions', 'route': '/terms-conditions'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      appBar: CustomAppBar(
        title: 'Account',
        onReturn: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
              child: OptionList(
            dataList: menuOptions,
            itemBuilder: (item) {
              return CustomCard(
                child: Padding(
                  padding: PaddingColumn.screen,
                  child: Text(
                    item['label'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
            onItemTap: (context, item) {
              Navigator.pushNamed(context, item['route']!);
            },
          ))
        ],
      ),
    );
  }
}
