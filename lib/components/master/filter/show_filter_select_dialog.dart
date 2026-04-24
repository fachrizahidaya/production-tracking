import 'dart:async';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/filter/select_filter_dialog.dart';

Future<List<dynamic>?> showFilterSelectDialog({
  required BuildContext context,
  required List<dynamic> options,
  required List<dynamic> selectedItems,
}) async {
  return showDialog<List<dynamic>>(
    context: context,
    builder: (_) {
      return SelectFilterDialog(
        statusOption: options,
        selectedStatuses: selectedItems,
      );
    },
  );
}
