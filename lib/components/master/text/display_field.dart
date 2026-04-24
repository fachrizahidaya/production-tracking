import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class DisplayField extends StatelessWidget {
  final String label;
  final String value;
  final bool isNumber;

  const DisplayField({
    super.key,
    required this.label,
    required this.value,
    this.isNumber = false,
  });

  String formatId(String val) {
    if (val.isEmpty) return '-';

    final number = double.tryParse(
          val.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;

    return NumberFormat.decimalPattern('id_ID').format(number);
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = isNumber ? formatId(value) : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (seperti TextForm)
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        SizedBox(height: 6),

        // Box (seperti input field)
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // efek disabled
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            displayValue.isEmpty ? '-' : displayValue,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
