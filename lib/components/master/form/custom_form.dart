import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomForm(
      {super.key,
      required this.hintText,
      this.isPassword = false,
      required this.controller});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _handleToggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget? renderSuffix() {
    if (!widget.isPassword) return null;

    return IconButton(
        onPressed: _handleToggleVisibility,
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ));
  }

  String? renderValidate(String? value) {
    if (value == null || value.isEmpty) {
      return '${widget.hintText} is required';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: renderSuffix()),
      validator: renderValidate,
    );
  }
}
