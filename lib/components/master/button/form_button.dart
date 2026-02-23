// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class FormButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final customHeight;
  final fontSize;

  const FormButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isLoading = false,
      this.isDisabled = false,
      this.backgroundColor,
      this.customHeight,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: (isDisabled || isLoading
              ? CustomTheme().disabledButton()
              : CustomTheme().primaryButton())
          .copyWith(
        minimumSize: customHeight != null
            ? MaterialStateProperty.all(Size(double.infinity, customHeight))
            : null,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  CustomTheme().colors('secondary'),
                ),
              ),
            )
          : Text(
              label,
              style: TextStyle(fontSize: fontSize),
            ),
    );
  }
}
