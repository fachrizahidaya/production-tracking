import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';

class DropdownForm extends StatefulWidget {
  final String label;
  final List<dynamic> options;
  final Function(dynamic)? onChange;
  final Function(List<dynamic>)? onMultiChange;
  final dynamic selectedValue;
  final List<dynamic> selectedValues;
  final bool req;
  final bool isMultiple;

  const DropdownForm(
      {super.key,
      required this.label,
      required this.options,
      this.onChange,
      this.selectedValue,
      this.req = false,
      this.selectedValues = const [],
      this.isMultiple = false,
      this.onMultiChange});

  @override
  State<DropdownForm> createState() => _DropdownFormState();
}

class _DropdownFormState extends State<DropdownForm> {
  @override
  Widget build(BuildContext context) {
    return GroupForm(
      label: widget.label,
      formControl:
          widget.isMultiple ? _buildMultiSelect(context) : _buildSingleSelect(),
      req: widget.req,
    );
  }

  Widget _buildSingleSelect() {
    return DropdownButtonFormField(
      isDense: true,
      isExpanded: true,
      decoration: CustomTheme().inputDecoration(),
      dropdownColor: Colors.white,
      style: TextStyle(
        fontSize: 16,
        color: CustomTheme().colors('text-primary'),
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
      ),
      value: widget.selectedValue != '' ? widget.selectedValue : null,
      onChanged: (value) => widget.onChange?.call(value),
      items: widget.options.map((item) {
        return DropdownMenuItem(
          value: item['value'] ?? item['id'],
          child: Text(item['label'] ?? item['nomor']),
        );
      }).toList(),
      validator: (value) {
        if (widget.req && (value == null || value == '')) {
          return '${widget.label} is required';
        }
        return null;
      },
      hint: Text(
        "Pilih ${widget.label}",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildMultiSelect(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final List<dynamic> tempSelected = List.from(widget.selectedValues);

        final result = await showDialog<List<dynamic>>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Pilih ${widget.label}"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  children: widget.options.map((item) {
                    final val = item['value'] ?? item['id'];
                    final isChecked =
                        tempSelected.any((sel) => sel['value'] == val);

                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(item['label'] ?? item['nomor']),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected
                                .removeWhere((sel) => sel['value'] == val);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, tempSelected),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        if (result != null) {
          widget.onMultiChange?.call(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: CustomTheme().inputStaticDecorationRequired(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedValues.isEmpty)
              Text(
                "Pilih ${widget.label}",
                style: const TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: -8,
                children: widget.selectedValues.map((item) {
                  return Chip(
                    label: Text(item['label'] ?? item['nomor']),
                    onDeleted: () {
                      final newValues = List.of(widget.selectedValues)
                        ..removeWhere((sel) => sel['value'] == item['value']);
                      widget.onMultiChange?.call(newValues);
                    },
                  );
                }).toList(),
              ),
            if (widget.selectedValues.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => widget.onMultiChange?.call([]),
                  child: const Text("Clear All"),
                ),
              )
          ],
        ),
      ),
    );
  }
}
