import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/multi_select_dialog.dart';

Future<List<dynamic>?> showMultiSelectDialog(
    {required BuildContext context,
    required List<dynamic> items,
    List<dynamic> initialSelectedIds = const [],
    isFetching}) async {
  List<dynamic> selectedIds = [...initialSelectedIds];

  return await showDialog<List<dynamic>>(
    context: context,
    builder: (context) {
      return isFetching == true
          ? CircularProgressIndicator()
          : MultiSelectDialog(
              items: items,
              initialSelectedIds: selectedIds,
            );
    },
  );
}
