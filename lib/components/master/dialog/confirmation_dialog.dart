import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;
  final buttonBackground;
  final child;

  const ConfirmationDialog(
      {super.key,
      required this.title,
      this.message,
      required this.onConfirm,
      required this.onCancel,
      required this.isLoading,
      this.buttonBackground,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('2xl'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                    SizedBox(height: 16),
                    message != null
                        ? Text(
                            message,
                            style: TextStyle(
                              fontSize: CustomTheme().fontSize('lg'),
                            ),
                          )
                        : child,
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: CancelButton(
                        label: 'Tidak',
                        onPressed: onCancel,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: FormButton(
                        label: 'Ya',
                        onPressed: isLoading ? null : onConfirm,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('lg')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
