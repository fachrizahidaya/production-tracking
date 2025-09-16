import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/button/cancel_button.dart';
import 'package:production_tracking/components/master/button/form_button.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

enum FieldType {
  text,
  dropdown,
  textArea,
  date,
  switchField,
  password,
  multiSelectDropdown
}

class FormFieldData {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final List<String>? options;
  final bool isTextArea;
  final FieldType fieldType;
  final bool isRequired;
  String? selectedValue;
  List<String>? selectedValues;
  DateTime? selectedDate;
  final bool isPassword;
  final bool isDisabled;
  final bool isAllowed;

  FormFieldData(
      {required this.label,
      required this.controller,
      required this.hint,
      this.keyboardType = TextInputType.text,
      this.options,
      this.isTextArea = false,
      this.fieldType = FieldType.text,
      this.isRequired = false,
      this.isPassword = false,
      this.selectedValue,
      this.selectedValues,
      this.selectedDate,
      this.isDisabled = false,
      this.isAllowed = false});
}

class CustomBottomSheet extends StatefulWidget {
  final List<FormFieldData> fields;
  final String title;
  final String submitLabel;
  final VoidCallback onSubmit;
  final VoidCallback? onDelete;
  final bool isLoading;
  final bool isDisabled;
  final bool isAllowed;

  const CustomBottomSheet(
      {super.key,
      required this.fields,
      required this.title,
      required this.submitLabel,
      required this.onSubmit,
      this.onDelete,
      required this.isLoading,
      this.isDisabled = false,
      this.isAllowed = false});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PaddingColumn.screen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (widget.onDelete != null && widget.isAllowed)
                TextButton(
                  onPressed: widget.onDelete,
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ...widget.fields.map((field) => _buildFormField(context, field)),
              if (widget.isAllowed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CancelButton(
                        label: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FormButton(
                          label: widget.submitLabel,
                          onPressed: widget.onSubmit,
                          isLoading: widget.isLoading,
                          isDisabled: widget
                              .isDisabled // Disable if form is invalid or loading
                          ),
                    ),
                  ],
                ),
            ].separatedBy(SizedBox(
              height: 16,
            )),
          )
        ],
      ),
    );
  }

  Widget _buildFormField(BuildContext context, FormFieldData field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(field.label),
            if (field.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        _buildField(context, field)
      ],
    );
  }

  Widget _buildField(BuildContext context, FormFieldData field) {
    switch (field.fieldType) {
      case FieldType.text:
        return _buildTextField(field);
      case FieldType.dropdown:
        return _buildDropdownField(field);
      case FieldType.textArea:
        return _buildTextAreaField(field);
      case FieldType.date:
        return _buildDateField(context, field);
      case FieldType.switchField:
        return _buildSwitchField(field);
      case FieldType.password:
        return _buildPasswordField(field);
      case FieldType.multiSelectDropdown:
        return _buildMultiSelectDropdownField(field);
    }
  }

  Widget _buildTextField(FormFieldData field) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                enabled: widget.isAllowed,
                controller: field.controller,
                keyboardType: field.keyboardType,
                decoration: InputDecoration(
                  hintText: field.hint,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                validator: (value) {
                  if (field.isRequired == true &&
                      (value == null || value.isEmpty)) {
                    return '${field.label} is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Trigger a rebuild to show/hide the required message
                  setState(() {});
                },
              ),
              if (field.isRequired == true &&
                  (field.controller.text.isEmpty ||
                      field.controller.text.trim().isEmpty))
                Text(
                  '${field.label} is required',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ));
    });
  }

  Widget _buildDropdownField(FormFieldData field) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: field.controller.text.isEmpty
                    ? null
                    : field.controller.text,
                onChanged: widget.isAllowed
                    ? (newValue) {
                        field.selectedValue = newValue;
                        field.controller.text = newValue ?? '';
                      }
                    : null,
                items: field.options
                    ?.map((option) => DropdownMenuItem<String>(
                        value: option,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.white),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxWidth: 250), // Adjust as needed
                            child: Text(
                              option,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )))
                    .toList(),
                isDense: true,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  // labelText: field.hint,
                  hintText: field.hint,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (field.isRequired && (value == null || value.isEmpty)) {
                    return '${field.label} is required';
                  }
                  return null;
                },
              ),
              if (field.isRequired == true &&
                  (field.controller.text.isEmpty ||
                      field.controller.text.trim().isEmpty))
                Text(
                  '${field.label} is required',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ));
    });
  }

  Widget _buildMultiSelectDropdownField(FormFieldData field) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.isAllowed
                    ? () async {
                        final List<String> tempSelected =
                            List.from(field.selectedValues ?? []);
                        String searchQuery = '';
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, modalSetState) {
                                final filteredOptions = field.options
                                        ?.where((option) => option
                                            .toLowerCase()
                                            .contains(
                                                searchQuery.toLowerCase()))
                                        .toList() ??
                                    [];

                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    height: 500,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Select ${field.label}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 12),
                                        TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Search...',
                                            prefixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            modalSetState(() {
                                              searchQuery = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: filteredOptions.isNotEmpty
                                              ? ListView(
                                                  children: filteredOptions
                                                      .map((option) {
                                                    final isSelected =
                                                        tempSelected
                                                            .contains(option);
                                                    return CheckboxListTile(
                                                      title: Text(option),
                                                      value: isSelected,
                                                      onChanged: (checked) {
                                                        modalSetState(() {
                                                          if (checked == true) {
                                                            tempSelected
                                                                .add(option);
                                                          } else {
                                                            tempSelected
                                                                .remove(option);
                                                          }
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                )
                                              : const Center(
                                                  child:
                                                      Text('No results found'),
                                                ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end, // Aligns to the right
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context, tempSelected);
                                                },
                                                child: const Text("Done"),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ).then((result) {
                          if (result != null) {
                            setState(() {
                              field.selectedValues = List<String>.from(result);
                              field.controller.text =
                                  field.selectedValues!.join(', ');
                            });
                          }
                        });
                      }
                    : null,
                child: AbsorbPointer(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // ✅ Chips take flexible space
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              if (field.selectedValues != null &&
                                  field.selectedValues!.isNotEmpty)
                                ...field.selectedValues!.map((item) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      border: Border.all(
                                          color: Colors.blue.shade200),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(item,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        const SizedBox(width: 4),
                                        if (widget.isAllowed)
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                field.selectedValues!
                                                    .remove(item);
                                                field.controller.text = field
                                                    .selectedValues!
                                                    .join(', ');
                                              });
                                            },
                                            child: const Icon(Icons.close,
                                                size: 14, color: Colors.red),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              if (field.selectedValues == null ||
                                  field.selectedValues!.isEmpty)
                                Text(
                                  field.hint,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                            ],
                          ),
                        ),
                        // ✅ Arrow Icon fixed at end
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              if (field.isRequired &&
                  (field.selectedValues == null ||
                      field.selectedValues!.isEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${field.label} is required',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextAreaField(FormFieldData field) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                enabled: widget.isAllowed,
                controller: field.controller,
                keyboardType: field.keyboardType,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: field.hint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (field.isRequired == true &&
                      (value == null || value.isEmpty)) {
                    return '${field.label} is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
              if (field.isRequired == true &&
                  (field.controller.text.isEmpty ||
                      field.controller.text.trim().isEmpty))
                Text(
                  '${field.label} is required',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ));
    });
  }

  Widget _buildDateField(BuildContext context, FormFieldData field) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                enabled: widget.isAllowed,
                controller: field.controller,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: field.hint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (field.isRequired && (value == null || value.isEmpty)) {
                    return '${field.label} is required';
                  }
                  return null;
                },
                onTap: widget.isAllowed
                    ? () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          field.controller.text = formattedDate;
                          field.selectedDate = pickedDate;
                        }
                      }
                    : null,
              ),
              if (field.isRequired == true &&
                  (field.controller.text.isEmpty ||
                      field.controller.text.trim().isEmpty))
                Text(
                  '${field.label} is required',
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ));
    });
  }

  Widget _buildSwitchField(FormFieldData field) {
    bool isSwitched = field.controller.text == '1';

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return Switch(
                      value: isSwitched,
                      onChanged: widget.isAllowed
                          ? (value) {
                              setState(() {
                                isSwitched = value;
                              });
                              field.controller.text = value ? '1' : '0';
                            }
                          : null);
                }),
                if (field.isRequired == true &&
                    (field.controller.text.isEmpty ||
                        field.controller.text.trim().isEmpty))
                  Text(
                    '${field.label} is required',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            )),
      );
    });
  }

  Widget _buildPasswordField(FormFieldData field) {
    // Use a ValueNotifier to persist the state of isObscured
    final ValueNotifier<bool> isObscured = ValueNotifier<bool>(true);

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isObscured,
              builder: (context, value, _) {
                return TextFormField(
                  controller: field.controller,
                  keyboardType: field.keyboardType,
                  obscureText: value,
                  decoration: InputDecoration(
                    hintText: field.hint,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        isObscured.value = !value;
                      },
                    ),
                  ),
                  validator: (value) {
                    if (field.isRequired == true &&
                        (value == null || value.isEmpty)) {
                      return '${field.label} is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                );
              },
            ),
            if (field.isRequired == true &&
                (field.controller.text.isEmpty ||
                    field.controller.text.trim().isEmpty))
              Text(
                '${field.label} is required',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      );
    });
  }
}
