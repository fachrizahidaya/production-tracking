import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool isLoading;

  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.onConfirm,
      required this.onCancel,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;
            final dialogWidth = screenWidth < 600
                ? screenWidth * 0.9 // mobile
                : 400.0;

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: dialogWidth,
                minWidth: 280,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: onCancel,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.grey))),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                          onPressed: isLoading ? null : onConfirm,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: isLoading
                              ? const SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Ya',
                                  style: TextStyle(color: Colors.white),
                                ))
                    ])
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
              ),
            );
          },
        ));
  }
}
