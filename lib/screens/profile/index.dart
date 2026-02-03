import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/profile/profle_list.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<Map<String, String>> menuList = [
    {'title': 'EULA', "onTap": '', "route": '/eula'},
    {'title': 'Privacy Policy', "onTap": '', "route": '/privacy-policy'},
    {'title': 'Terms and Conditions', "onTap": '', "route": 'terms-conditions'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEBEBEB),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: ProfleList<Map<String, String>>(
                    onTapItem: (item) {
                      if (item != null) {
                        if (item['title'] == 'Change Password') {
                        } else if (item['route'] != null) {
                          Navigator.pushNamed(context, item['route']!);
                        }
                      }
                    },
                    itemBuilder: (item) {
                      return ListTile(
                        title: Text(item['title']!),
                      );
                    },
                    initialItems: menuList,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
