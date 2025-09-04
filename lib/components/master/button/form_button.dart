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
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ))
              : Text(
                  label,
                  style:
                      TextStyle(color: isDisabled ? Colors.grey : Colors.white),
                )),
    );
  }
}
