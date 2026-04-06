import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';

class MultiSelectForm extends StatelessWidget {
  final String label;
  final List<dynamic> selectedValues;
  final List<dynamic> selectedItems;
  final String selectedLabel;
  final VoidCallback onTap;
  final bool required;
  final onRemoveItem;
  final onClearAll;
  final onSelectionChanged;

  const MultiSelectForm(
      {super.key,
      required this.label,
      required this.selectedValues,
      required this.selectedLabel,
      required this.onTap,
      this.required = false,
      this.selectedItems = const [],
      this.onClearAll,
      this.onRemoveItem,
      this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return GroupForm(
      label: label,
      req: required,
      formControl: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: CustomTheme().padding('card'),
          decoration: CustomTheme().inputStaticDecorationRequired(),
          child: selectedItems.isEmpty
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Pilih $label",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: CustomTheme().fontSize('lg'),
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down,
                        size: 18, color: CustomTheme().colors('base'))
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: selectedItems
                              .map<Widget>((item) => InputChip(
                                    label: Text(item['label']),
                                    onDeleted: () {
                                      onRemoveItem?.call(item);
                                    },
                                  ))
                              .toList(),
                        ),
                        Icon(Icons.arrow_drop_down,
                            size: 18, color: CustomTheme().colors('base'))
                      ],
                    ),
                  ],
                ),

          //  TextFormField(
          //   decoration: InputDecoration(
          //     labelText: required ? '$label *' : label,
          //     hintText: 'Pilih $label',
          //     suffixIcon: const Icon(Icons.arrow_drop_down),
          //   ),
          //   controller: TextEditingController(text: selectedLabel),
          //   validator: (value) {
          //     if (required && selectedValues.isEmpty) {
          //       return '$label wajib dipilih';
          //     }
          //     return null;
          //   },
          // ),
        ),
      ),
    );
  }
}
