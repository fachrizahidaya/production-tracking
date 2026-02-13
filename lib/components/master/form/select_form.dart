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
    return FormField<String>(
      validator: widget.validator,
      initialValue: widget.selectedValue,
      builder: (FormFieldState<String> field) {
        if (field.value != widget.selectedValue) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            field.didChange(widget.selectedValue);
          });
        }
        return GroupForm(
          label: widget.label,
          req: widget.required,
          errorText: field.errorText,
          formControl: GestureDetector(
            onTap: widget.isDisabled == true
                ? null
                : () async {
                    await widget.onTap();

                    field.didChange(widget.selectedValue);
                    field.validate();
                  },
            child: Container(
              padding: CustomTheme().padding('card'),
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
        );
      },
    );
  }
}
