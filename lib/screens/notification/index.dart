import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';
import 'package:production_tracking/helpers/util/margin_card.dart';

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
        padding: MarginCard.screen,
        color: const Color(0xFFEBEBEB),
      ),
    );
  }
}
