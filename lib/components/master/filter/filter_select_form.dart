import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';

class FilterSelectForm extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final List<dynamic> selectedItems;
  final bool required;
  final bool? isDisabled;
  final Function(Map<dynamic, dynamic>)? onRemoveItem;
  final VoidCallback? onClearAll;
  final Function(List<dynamic>) onSelectionChanged;

  const FilterSelectForm(
      {super.key,
      required this.label,
      required this.onTap,
      required this.selectedItems,
      required this.required,
      this.isDisabled,
      this.onRemoveItem,
      this.onClearAll,
      required this.onSelectionChanged});

  @override
  State<FilterSelectForm> createState() => _FilterSelectFormState();
}

class _FilterSelectFormState extends State<FilterSelectForm> {
  @override
  Widget build(BuildContext context) {
    return GroupForm(
      label: widget.label,
      req: widget.required,
      formControl: GestureDetector(
        onTap: widget.isDisabled == true ? null : widget.onTap,
        child: Container(
          padding: CustomTheme().padding('card'),
          decoration: CustomTheme().inputStaticDecorationRequired(),
          child: widget.selectedItems.isEmpty
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Pilih ${widget.label}",
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
                          runSpacing: 8,
                          children: widget.selectedItems.map((item) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Text(item['label']),
                              // onDeleted: () {
                              //   widget.onRemoveItem?.call(item);
                              //   widget.onSelectionChanged(widget.selectedItems);
                              // },
                            );
                          }).toList(),
                        ),
                        Icon(Icons.arrow_drop_down,
                            size: 18, color: CustomTheme().colors('base'))
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
