import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/form/group_form.dart';
import 'package:production_tracking/components/master/theme.dart';

class SelectForm extends StatefulWidget {
  final String label;
  final onTap;
  final String selectedLabel;
  final String selectedValue;
  final bool required;
  final bool? isDisabled;

  const SelectForm(
      {super.key,
      required this.label,
      required this.onTap,
      required this.selectedLabel,
      required this.selectedValue,
      required this.required,
      this.isDisabled});

  @override
  State<SelectForm> createState() => _SelectFormState();
}

class _SelectFormState extends State<SelectForm> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GroupForm(
      label: widget.label,
      formControl: Stack(
        children: [
          TextFormField(
            enabled: widget.isDisabled == true ? false : true,
            controller: _textEditingController,
            decoration: CustomTheme().inputDateDecoration(),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (widget.required && (value == null || value.isEmpty)) {
                return '${widget.label} is required';
              }
              return null;
            },
          ),
          Positioned(
            top: 0.5,
            left: 0.5,
            right: 0.5,
            child: GestureDetector(
              onTap: widget.isDisabled == true ? null : widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 47,
                width: double.infinity,
                decoration: CustomTheme().inputStaticDecorationRequired(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.selectedLabel != ''
                            ? widget.selectedLabel
                            : 'Pilih ${widget.label}',
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: CustomTheme().colors('base'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      req: widget.required,
    );
  }
}
