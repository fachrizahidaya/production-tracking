import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class LargeConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;
  final buttonBackground;

  const LargeConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    required this.isLoading,
    this.buttonBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
          maxHeight: MediaQuery.of(context).size.height * 0.7, // taller
        ),
        child: Padding(
          padding: CustomTheme().padding('content'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title + Message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 26, // bigger
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 20, // bigger
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 60, // taller button
                    width: 100,
                    child: CancelButton(
                      label: 'Tidak',
                      onPressed: onCancel,
                    ),
                  ),
                  SizedBox(
                    height: 60, // taller button
                    width: 100,
                    child: FormButton(
                      label: 'Ya',
                      onPressed: isLoading ? null : onConfirm,
                      isLoading: isLoading,
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('xl')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
