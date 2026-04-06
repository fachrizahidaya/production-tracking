import 'dart:async';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/filter/select_filter_dialog.dart';

Future<List<dynamic>?> showFilterSelectDialog(
    {context,
    title,
    option,
    isLoading,
    selected,
    handleChangeValue,
    isFetching,
    options,
    selectedItems,
    onHandleFilter}) async {
  return showDialog<List<dynamic>>(
    context: context,
    builder: (_) {
      return SelectFilterDialog(
        statusOption: options,
        selectedStatuses: selected,
      );
    },
  );
}
