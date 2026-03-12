import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';

class SelectFunctions {
  static bool showLoadingIfNeeded(
    BuildContext context,
    bool isLoading,
  ) {
    if (!isLoading) return false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    return true;
  }

  static void selectWorkOrder({
    required BuildContext context,
    required bool isFetching,
    required List<dynamic> options,
    required String selected,
    required String idProcessKey,
    required void Function(Map<String, dynamic> selected) onSelected,
  }) {
    if (showLoadingIfNeeded(context, isFetching)) return;

    showDialog(
      context: context,
      useSafeArea: true,
      builder: (_) => SelectDialog(
        label: 'Work Order',
        options: options,
        selected: selected,
        handleChangeValue: onSelected,
      ),
    );
  }

  static void selectUnit({
    required BuildContext context,
    required bool isFetching,
    required String label,
    required List<dynamic> options,
    required String selected,
    required void Function(Map<String, dynamic> selected) onSelected,
  }) {
    if (showLoadingIfNeeded(context, isFetching)) return;

    showDialog(
      context: context,
      useSafeArea: true,
      builder: (_) => SelectDialog(
        label: label,
        options: options,
        selected: selected,
        handleChangeValue: onSelected,
      ),
    );
  }

  static Future<void> selectGradeUnit({
    required BuildContext context,
    required bool isFetching,
    required List<dynamic> options,
    required String selectedLabel,
    required void Function(Map<String, dynamic> selected) onSelected,
  }) async {
    if (showLoadingIfNeeded(context, isFetching)) return;

    await showDialog(
      context: context,
      builder: (_) => SelectDialog(
        label: 'Satuan',
        options: options,
        selected: selectedLabel,
        handleChangeValue: onSelected,
      ),
    );
  }
}
