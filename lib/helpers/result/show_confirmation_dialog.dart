import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/confirmation_dialog.dart';

void showConfirmationDialog(
    {required BuildContext context,
    int? index,
    required VoidCallback onConfirm,
    required String title,
    required String message,
    bool isLoading = false}) {
  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return ConfirmationDialog(
              title: title,
              message: message,
              onConfirm: onConfirm,
              onCancel: () => Navigator.pop(context),
              isLoading: isLoading);
        });
      });
}
