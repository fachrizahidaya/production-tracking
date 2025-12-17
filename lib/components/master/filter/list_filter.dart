// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/filter_select_form.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class DropdownConfig<T> {
  final String id;
  final String hint;
  final Future<List<DropdownMenuItem<T>>> Function()? fetchDropdownItems;
  final List<DropdownMenuItem<T>>? manualDropdownItems;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;

  DropdownConfig({
    required this.id,
    required this.hint,
    this.fetchDropdownItems,
    this.manualDropdownItems,
    this.selectedValue,
    required this.onChanged,
  });

  bool get hasManualItems =>
      manualDropdownItems != null && manualDropdownItems!.isNotEmpty;
}

class ListFilter<T> extends StatefulWidget {
  final String title;
  final List<DropdownConfig<T>>? dropdownConfigs;
  final bool useDateFilter;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final ValueChanged<DateTime?>? onStartDateChanged;
  final ValueChanged<DateTime?>? onEndDateChanged;
  final params;
  final onHandleFilter;
  final onSubmitFilter;
  final fetchMachine;
  final getMachineOptions;
  final fetchOperators;
  final getOperatorOptions;
  final dariTanggal;
  final sampaiTanggal;

  const ListFilter(
      {super.key,
      required this.title,
      this.dropdownConfigs,
      this.useDateFilter = false,
      this.initialStartDate,
      this.initialEndDate,
      this.onStartDateChanged,
      this.onEndDateChanged,
      this.params,
      this.onHandleFilter,
      this.onSubmitFilter,
      this.fetchMachine,
      this.getMachineOptions,
      this.fetchOperators,
      this.getOperatorOptions,
      this.dariTanggal,
      this.sampaiTanggal});

  @override
  State<ListFilter<T>> createState() => _ListFilterState<T>();
}

class _ListFilterState<T> extends State<ListFilter<T>> {
  TextEditingController dariTanggalInput = TextEditingController();
  TextEditingController sampaiTanggalInput = TextEditingController();
  int? operatorId;
  String? namaOperator = '';
  int page = 0;

  List<dynamic> operatorOption = [];

  List<Map<String, dynamic>> selectedStatuses = [];
  List<Map<String, dynamic>> selectedOperators = [];

  List<dynamic> statusOption = [
    {'label': 'Diproses', 'value': 'Diproses'},
    {'label': 'Selesai', 'value': 'Selesai'},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.params['status'] != null) {
      final activeStatuses = widget.params['status'].split(',');
      selectedStatuses = statusOption
          .where((s) => activeStatuses.contains(s['value']))
          .map((s) => Map<String, dynamic>.from(s))
          .toList();
    }

    if (widget.params['user_id'] != null) {
      final activeOperators = widget.params['user_id'].split(',');
      selectedStatuses = operatorOption
          .where((s) => activeOperators.contains(s['value']))
          .map((s) => Map<String, dynamic>.from(s))
          .toList();
    }

    dariTanggalInput.text = widget.dariTanggal;
    sampaiTanggalInput.text = widget.sampaiTanggal;
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dariTanggal != dariTanggalInput.text) {
      dariTanggalInput.text = widget.dariTanggal;
    }
    if (widget.sampaiTanggal != sampaiTanggalInput.text) {
      sampaiTanggalInput.text = widget.sampaiTanggal;
    }
  }

  @override
  void dispose() {
    dariTanggalInput.dispose();
    sampaiTanggalInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dariTanggalInput.text = widget.params['start_date'] ?? '';
    sampaiTanggalInput.text = widget.params['end_date'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GroupForm(
                  label: 'Dari Tanggal',
                  formControl: TextFormField(
                    controller: dariTanggalInput,
                    readOnly: true,
                    decoration: CustomTheme().inputDateDecoration(
                      hintTextString: 'Pilih tanggal',
                      hasValue: dariTanggalInput.text.isNotEmpty,
                      onPressClear: () {
                        setState(() {
                          dariTanggalInput.clear();
                          widget.onHandleFilter('start_date', '');
                        });
                      },
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          String formatted =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          dariTanggalInput.text = formatted;
                          widget.onHandleFilter('start_date', formatted);
                        });
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: GroupForm(
                  label: 'Sampai Tanggal',
                  formControl: TextFormField(
                    controller: sampaiTanggalInput,
                    readOnly: true,
                    decoration: CustomTheme().inputDateDecoration(
                      hintTextString: 'Pilih tanggal',
                      hasValue: sampaiTanggalInput.text.isNotEmpty,
                      onPressClear: () {
                        setState(() {
                          sampaiTanggalInput.clear();
                          widget.onHandleFilter('end_date', '');
                        });
                      },
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          String formatted =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          sampaiTanggalInput.text = formatted;
                          widget.onHandleFilter('end_date', formatted);
                        });
                      }
                    },
                  ),
                ),
              ),
            ].separatedBy(SizedBox(
              width: 16,
            )),
          ),
          FilterSelectForm(
            label: "Status",
            onTap: () async {
              final result = await showDialog<List<Map<String, dynamic>>>(
                context: context,
                builder: (_) {
                  List<dynamic> filteredList = List.from(statusOption);
                  Timer? debounce;

                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          void runSearch(String value) {
                            if (debounce?.isActive ?? false) debounce!.cancel();

                            debounce =
                                Timer(const Duration(milliseconds: 300), () {
                              setState(() {
                                if (value.isEmpty) {
                                  filteredList = List.from(statusOption);
                                } else {
                                  filteredList = statusOption
                                      .where((e) => e['label']
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                }
                              });
                            });
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Pilih Status",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Pencarian...',
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        onChanged: runSearch,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Scrollbar(
                                  thickness: 4,
                                  child: ListView.separated(
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];
                                      final isSelected = selectedStatuses.any(
                                          (s) => s['value'] == item['value']);

                                      return CheckboxListTile(
                                        value: isSelected,
                                        title: Text(item['label']),
                                        activeColor: Colors.green,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedStatuses.add(item);
                                            } else {
                                              selectedStatuses.removeWhere(
                                                  (s) =>
                                                      s['value'] ==
                                                      item['value']);
                                            }
                                          });
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(height: 0.5),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedStatuses.clear();
                                          filteredList =
                                              List.from(statusOption);
                                        });
                                      },
                                      child: const Text('Reset'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, selectedStatuses);
                                      },
                                      child: const Text('Simpan'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              );

              if (result != null) {
                setState(() {
                  selectedStatuses = result;
                });
                widget.onHandleFilter(
                    "status", result.map((e) => e['value']).join(","));
              }
            },
            selectedItems: selectedStatuses,
            required: false,
            onRemoveItem: (item) {
              setState(() {
                selectedStatuses.remove(item);
              });
              widget.onHandleFilter(
                  "status", selectedStatuses.map((e) => e['value']).join(","));
            },
            onClearAll: () {
              setState(() {
                selectedStatuses.clear();
              });
              widget.onHandleFilter("status", "");
            },
            onSelectionChanged: (selected) {
              widget.onHandleFilter(
                  "status", selected.map((e) => e['value']).join(","));
            },
          ),
        ].separatedBy(SizedBox(
          height: 16,
        )),
      ),
    );
  }
}
