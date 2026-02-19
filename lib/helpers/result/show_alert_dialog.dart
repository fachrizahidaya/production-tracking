import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/custom_alert_dialog.dart';

Future<void> showAlertDialog(
    {required BuildContext context,
    required String title,
    String? message,
    child}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomAlertDialog(
            title: title,
            message: message,
            child: child,
          ));
}
