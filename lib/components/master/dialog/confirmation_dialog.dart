import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;
  final buttonBackground;

  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.onConfirm,
      required this.onCancel,
      required this.isLoading,
      this.buttonBackground});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Padding(
            padding: CustomTheme().padding('dialog'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: CustomTheme().fontSize('xl'),
                          fontWeight: CustomTheme().fontWeight('bold')),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                      ),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CancelButton(label: 'Tidak', onPressed: onCancel),
                      FormButton(
                        label: 'Ya',
                        onPressed: isLoading ? null : onConfirm,
                        isLoading: isLoading,
                      ),
                    ].separatedBy(CustomTheme().hGap('lg')))
              ].separatedBy(CustomTheme().vGap('lg')),
            ),
          ),
        ));
  }
}
