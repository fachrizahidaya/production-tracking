import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SelectForm extends StatefulWidget {
  final String label;
  final onTap;
  final String selectedLabel;
  final selectedCode;
  final String selectedValue;
  final bool required;
  final isDisabled;
  final validator;
  final isWithCode;
  final String? badge;

  const SelectForm(
      {super.key,
      required this.label,
      required this.onTap,
      required this.selectedLabel,
      required this.selectedValue,
      this.selectedCode,
      required this.required,
      this.isDisabled = false,
      this.validator,
      this.isWithCode = false,
      this.badge});

  @override
  State<SelectForm> createState() => _SelectFormState();
}

class _SelectFormState extends State<SelectForm> {
  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: CustomTheme().buttonColor('primary'),
          fontSize: CustomTheme().fontSize('sm'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
    );
  }

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
              height:
                  widget.isWithCode && widget.selectedValue != '' ? 84.0 : 56.0,
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
                    child: Builder(
                      builder: (_) {
                        final isEmpty = (widget.selectedCode ?? '').isEmpty &&
                            (widget.selectedLabel).isEmpty;

                        if (isEmpty) {
                          return Text('Pilih ${widget.label}');
                        }

                        if (widget.isWithCode) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.selectedCode ?? ''),
                              Text(
                                widget.selectedLabel,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: CustomTheme().fontSize('sm'),
                                ),
                              ),
                            ].separatedBy(CustomTheme().vGap('sm')),
                          );
                        }

                        return Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.selectedLabel,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if ((widget.badge ?? '').isNotEmpty) ...[
                              const SizedBox(width: 8),
                              _buildBadge(widget.badge!),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  if (widget.isDisabled == false)
                    Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: CustomTheme().colors('base'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
