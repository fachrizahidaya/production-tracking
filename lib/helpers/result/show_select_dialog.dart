import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';

Future<List<dynamic>?> showSelectDialog(
    {context,
    title,
    option,
    isLoading,
    selected,
    handleChangeValue,
    isFetching}) async {
  return showDialog<List<dynamic>>(
    context: context,
    builder: (context) {
      return isFetching == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SelectDialog(
              label: title,
              options: option,
              selected: selected,
              handleChangeValue: handleChangeValue,
            );
    },
  );
}
