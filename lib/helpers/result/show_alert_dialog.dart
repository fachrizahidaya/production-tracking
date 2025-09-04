import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/dialog/custom_alert_dialog.dart';

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(title: title, message: message));
}
