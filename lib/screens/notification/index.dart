import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: CustomTheme().padding('content'),
        color: Color(0xFFEBEBEB),
      ),
    );
  }
}
