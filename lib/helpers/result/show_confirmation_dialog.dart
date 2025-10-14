import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/confirmation_dialog.dart';

void showConfirmationDialog({
  required BuildContext context,
  int? index,
  required VoidCallback onConfirm,
  required String title,
  required String message,
  required ValueNotifier<bool> isLoading,
  buttonBackground,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, _) {
          return ConfirmationDialog(
            title: title,
            message: message,
            onConfirm: onConfirm,
            onCancel: () => Navigator.pop(context),
            isLoading: loading,
            buttonBackground: buttonBackground,
          );
        },
      );
    },
  );
}
