// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class FormButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final dynamic customHeight;
  final dynamic fontSize;
  final dynamic danger;

  const FormButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.customHeight,
    this.fontSize,
    this.danger,
  });

  @override
  State<FormButton> createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          widget.isDisabled || widget.isLoading ? null : widget.onPressed,
      style: (widget.isDisabled || widget.isLoading
              ? CustomTheme().disabledButton()
              : CustomTheme().primaryButton())
          .copyWith(
        backgroundColor: MaterialStateProperty.all(
          widget.isDisabled
              ? CustomTheme().colors('disabled')
              : widget.danger == true
                  ? CustomTheme().buttonColor('danger')
                  : widget.backgroundColor ?? CustomTheme().colors('primary'),
        ),
        side: MaterialStateProperty.all(
          BorderSide(
            color: widget.isDisabled
                ? CustomTheme().colors('disabled')
                : widget.danger == true
                    ? CustomTheme().buttonColor('danger')
                    : widget.backgroundColor ?? CustomTheme().colors('primary'),
            width: 1.5,
          ),
        ),
        minimumSize: widget.customHeight != null
            ? MaterialStateProperty.all(
                Size(double.infinity, widget.customHeight),
              )
            : null,
      ),
      child: widget.isLoading
          ? const SizedBox(
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
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: Colors.white,
              ),
            ),
    );
  }
}
