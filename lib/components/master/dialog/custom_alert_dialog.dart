import 'package:flutter/material.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomAlertDialog(
      {super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              message,
              textAlign: TextAlign.left,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ].separatedBy(SizedBox(
            height: 8,
          )),
        ),
      ),
    );
  }
}
