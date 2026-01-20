import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class StaticFormField extends StatelessWidget {
  final String value;

  const StaticFormField({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: CustomTheme().inputDecoration(),
      child: Text(
        value,
        style: TextStyle(
          fontSize: CustomTheme().fontSize('md'),
          fontWeight: CustomTheme().fontWeight('semibold'),
        ),
      ),
    );
  }
}
