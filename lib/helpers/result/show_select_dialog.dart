import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';

void showSelectDialog(
    {context,
    title,
    option,
    isLoading,
    selected,
    handleChangeValue,
    isFetching}) {
  showDialog(
    context: context,
    builder: (context) {
      return isFetching == true
          ? CircularProgressIndicator()
          : SelectDialog(
              label: title,
              options: option,
              selected: selected,
              handleChangeValue: handleChangeValue,
            );
    },
  );
}
