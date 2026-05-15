import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';

class WeightSection extends StatefulWidget {
  final Map form;
  final TextEditingController controller;
  final String? warning;

  final Function(String) onChange;
  final Function(String) onValidate;

  const WeightSection({
    super.key,
    required this.form,
    required this.controller,
    required this.onChange,
    required this.onValidate,
    this.warning,
  });

  @override
  State<WeightSection> createState() => _WeightSectionState();
}

class _WeightSectionState extends State<WeightSection> {
  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Berat',
      icon: Icons.scale_outlined,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// INPUT BERAT
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextForm(
                      label: 'Berat (KG)',
                      req: true,
                      isNumber: true,
                      isDisabled: true,
                      initialValue: widget.form['weight']?.toString() ?? '0',
                      controller: widget.controller,
                      handleChange: (value) {
                        final safeValue =
                            value.toString().trim().isEmpty ? '0' : value;

                        widget.onChange(safeValue);

                        setState(() {
                          widget.onValidate(safeValue);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Berat wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              /// WARNING
              if (widget.warning != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.warning ?? '-',
                        style: TextStyle(
                          color: CustomTheme().colors('warning'),
                          fontSize: CustomTheme().fontSize('sm'),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          )
        ],
      ),
    );
  }
}
