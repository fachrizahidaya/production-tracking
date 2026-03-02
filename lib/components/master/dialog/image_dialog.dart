import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ImageDialog extends StatelessWidget {
  final isNew;
  final filePath;
  const ImageDialog({super.key, this.filePath, this.isNew});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: CustomTheme().padding('content'),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: CustomTheme().padding('process-content'),
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: isNew
              ? Image.file(
                  File(filePath),
                  fit: BoxFit.contain,
                )
              : Image.network(
                  filePath,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
