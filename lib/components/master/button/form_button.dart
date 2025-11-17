import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class FormButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const FormButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.isLoading = false,
      this.isDisabled = false,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled || isLoading
              ? CustomTheme().buttonColor('In Progress')
              : (backgroundColor ?? CustomTheme().buttonColor('primary')),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    CustomTheme().colors('secondary')),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                color: isDisabled
                    ? CustomTheme().colors('secondary')
                    : Colors.white,
              ),
            ),
    ));
  }
}
