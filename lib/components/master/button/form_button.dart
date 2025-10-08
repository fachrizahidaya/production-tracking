import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;
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
              ? Colors.grey
              : (backgroundColor ?? Colors.blue),
          shape: RoundedRectangleBorder()),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.white,
              ),
            ),
    ));
  }
}
