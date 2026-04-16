import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:textile_tracking/components/master/text/indonesian_currency_input_formatter.dart';

class CustomCurrencyField extends StatefulWidget {
  final String? label;
  final bool required;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(double?)? onChanged;
  final String? initialValue;
  final bool disabled;
  final String currencySymbol;

  const CustomCurrencyField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.required = false,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.disabled = false,
    this.currencySymbol = 'Rp',
  });

  @override
  State<CustomCurrencyField> createState() => _CustomCurrencyFieldState();
}

class _CustomCurrencyFieldState extends State<CustomCurrencyField> {
  late TextEditingController _controller;
  final NumberFormat _formatter = NumberFormat('#,##0.00', 'id_ID');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    // Set initial value if provided
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _controller.text = _formatCurrency(widget.initialValue!);
    }
  }

  String _formatCurrency(String value) {
    // Remove all non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return '';

    // Parse to number and format with Indonesian locale
    // Using _formatter which has format '#,##0.00' with id_ID locale
    // This produces format: 1.234.567,89
    double number = double.parse(digitsOnly) / 100;
    String formatted = _formatter.format(number);
    return formatted;
  }

  double? _parseValue(String text) {
    // Remove all non-digit characters (except we'll handle them)
    // Format is: 1.234.567,89
    // Replace thousand separators (.) and decimal separator (,) with standard format
    String normalized = text.replaceAll('.', ''); // Remove thousand separators
    normalized =
        normalized.replaceAll(',', '.'); // Convert comma to dot for parsing

    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label + Required *
        if (widget.label != null && widget.label != "")
          Row(
            children: [
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.required)
                const Text(
                  " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        if (widget.label != null && widget.label!.isNotEmpty)
          const SizedBox(height: 6),

        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            IndonesianCurrencyInputFormatter(decimalPlaces: 2),
          ],
          enabled: !widget.disabled,
          style: TextStyle(
            color: widget.disabled ? Colors.black54 : Colors.black,
            fontSize: 14,
          ),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(_parseValue(value));
            }
          },
          validator: widget.validator ??
              (widget.required
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return "${widget.label} is required";
                      }
                      return null;
                    }
                  : null),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.currencySymbol,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.disabled
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
