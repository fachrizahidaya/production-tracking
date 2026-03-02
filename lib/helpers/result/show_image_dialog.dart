import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/image_dialog.dart';

Future<void> showImageDialog({required BuildContext context, isNew, filePath}) {
  return showDialog(
      context: context,
      builder: (context) => ImageDialog(
            isNew: isNew,
            filePath: filePath,
          ));
}
