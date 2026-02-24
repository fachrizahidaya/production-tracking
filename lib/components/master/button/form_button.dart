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
  final danger;

  const FormButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isLoading = false,
      this.isDisabled = false,
      this.backgroundColor,
      this.customHeight,
      this.fontSize,
      this.danger});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: (isDisabled || isLoading
              ? CustomTheme().disabledButton()
              : CustomTheme().primaryButton())
          .copyWith(
        backgroundColor: MaterialStateProperty.all(
          isDisabled
              ? CustomTheme().colors('disabled')
              : danger == true
                  ? CustomTheme().buttonColor('danger')
                  : backgroundColor ?? CustomTheme().colors('primary'),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: isDisabled
                ? CustomTheme().colors('disabled')
                : danger == true
                    ? CustomTheme().buttonColor('danger')
                    : backgroundColor ?? CustomTheme().colors('primary'),
            width: 1.5,
          ),
        ),
        minimumSize: customHeight != null
            ? MaterialStateProperty.all(
                Size(double.infinity, customHeight),
              )
            : null,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
    );
  }
}
