import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_bottom_sheet.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

void showBottomSheet(
    {required BuildContext context,
    required List<FormFieldData> fields,
    required String title,
    required String submitLabel,
    required VoidCallback onSubmit,
    VoidCallback? onDelete,
    bool isLoading = false,
    bool isDisabled = false,
    bool isAllowed = false}) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadiusDirectional.vertical(top: Radius.circular(8))),
      isScrollControlled: true,
      builder: (context) => Padding(
            padding: PaddingColumn.screen,
            child: CustomBottomSheet(
                fields: fields,
                title: title,
                submitLabel: submitLabel,
                onSubmit: onSubmit,
                isLoading: isLoading),
          ));
}
