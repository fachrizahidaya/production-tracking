import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';

class SelectForm extends StatefulWidget {
  final String label;
  final onTap;
  final String selectedLabel;
  final String selectedValue;
  final bool required;
  final isDisabled;
  final validator;

  const SelectForm(
      {super.key,
      required this.label,
      required this.onTap,
      required this.selectedLabel,
      required this.selectedValue,
      required this.required,
      this.isDisabled = false,
      this.validator});

  @override
  State<SelectForm> createState() => _SelectFormState();
}

class _SelectFormState extends State<SelectForm> {
  @override
  Widget build(BuildContext context) {
    return GroupForm(
      label: widget.label,
      formControl: Stack(
        children: [
          TextFormField(
            controller: TextEditingController(text: widget.selectedValue),
            validator: widget.required ? widget.validator : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: CustomTheme().inputDecoration(),
          ),
          GestureDetector(
            onTap: widget.isDisabled == true ? null : widget.onTap,
            child: Container(
              padding: CustomTheme().padding('card'),
              height: 52,
              width: double.infinity,
              decoration: widget.isDisabled
                  ? CustomTheme().inputStaticDecorationDisabled()
                  : CustomTheme().inputStaticDecorationRequired(),
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
                  if (widget.isDisabled == false)
                    Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: CustomTheme().colors('base'),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
      req: widget.required,
    );
  }
}
