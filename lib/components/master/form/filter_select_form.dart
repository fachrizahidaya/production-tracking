import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/form/group_form.dart';
import 'package:production_tracking/components/master/theme.dart';

class FilterSelectForm extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final List<Map<String, dynamic>> selectedItems;
  final bool required;
  final bool? isDisabled;
  final Function(Map<String, dynamic>)? onRemoveItem;
  final VoidCallback? onClearAll;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;

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
      formControl: GestureDetector(
        onTap: widget.isDisabled == true ? null : widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400, width: 1)),
          child: widget.selectedItems.isEmpty
              ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Pilih ${widget.label}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
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
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: widget.selectedItems.map((item) {
                            return InputChip(
                              label: Text(item['label']),
                              onDeleted: () {
                                widget.onRemoveItem?.call(item);
                                widget.onSelectionChanged(widget.selectedItems);
                              },
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
      req: widget.required,
    );
  }
}
