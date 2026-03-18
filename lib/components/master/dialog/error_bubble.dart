// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/arrow_painter.dart';

class ErrorBubble extends StatelessWidget {
  final String message;

  const ErrorBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),

          /// little arrow
          CustomPaint(
            size: Size(12, 6),
            painter: ArrowPainter(),
          ),
        ],
      ),
    );
  }
}
