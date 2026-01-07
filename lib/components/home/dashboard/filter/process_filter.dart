import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/filter/filter_select_form.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessFilter<T> extends StatefulWidget {
  final dariTanggal;
  final sampaiTanggal;
  final onHandleFilter;
  final onSubmitFilter;
  final pickDate;
  final params;
  final String title;

  const ProcessFilter(
      {super.key,
      this.dariTanggal,
      this.sampaiTanggal,
      this.onHandleFilter,
      this.pickDate,
      this.params,
      required this.title,
      this.onSubmitFilter});

  @override
  State<ProcessFilter<T>> createState() => _ProcessFilterState<T>();
}

class _ProcessFilterState<T> extends State<ProcessFilter<T>> {
  TextEditingController dariTanggalInput = TextEditingController();
  TextEditingController sampaiTanggalInput = TextEditingController();

  List<dynamic> statusOption = [
    {'label': 'Menunggu Diproses', 'value': 'Menunggu Diproses'},
    {'label': 'Diproses', 'value': 'Diproses'},
    {'label': 'Selesai', 'value': 'Selesai'},
  ];

  List<Map<String, dynamic>> selectedStatuses = [];

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
    setState(() {
      dariTanggalInput.text = widget.params['start_date'] ?? '';
      sampaiTanggalInput.text = widget.params['end_date'] ?? '';
    });

    return Container(
      padding: CustomTheme().padding('card'),
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
                    style: TextStyle(fontSize: CustomTheme().fontSize('md')),
                    decoration: CustomTheme().inputDateDecoration(
                        hintTextString: 'Pilih tanggal',
                        hasValue: dariTanggalInput.text.isNotEmpty),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: CustomTheme().colors('base'),
                                onPrimary: Colors.white,
                                onSurface: Colors.black87,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dariTanggalInput.text = formattedDate;
                          widget.onHandleFilter('start_date', formattedDate);
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GroupForm(
                  label: 'Sampai Tanggal',
                  formControl: TextFormField(
                    controller: sampaiTanggalInput,
                    style: TextStyle(fontSize: CustomTheme().fontSize('md')),
                    decoration: CustomTheme().inputDateDecoration(
                        hintTextString: 'Pilih tanggal',
                        hasValue: dariTanggalInput.text.isNotEmpty),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: CustomTheme().colors('base'),
                                onPrimary: Colors.white,
                                onSurface: Colors.black87,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          sampaiTanggalInput.text = formattedDate;
                          widget.onHandleFilter('end_date', formattedDate);
                        });
                      }
                    },
                  ),
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
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
                                padding: CustomTheme().padding('content'),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pilih Status",
                                      style: TextStyle(
                                        fontSize: CustomTheme().fontSize('xl'),
                                        fontWeight:
                                            CustomTheme().fontWeight('bold'),
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
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];

                                      final status = statusOption[index];
                                      final isSelected = selectedStatuses.any(
                                          (s) => s['value'] == item['value']);

                                      return CheckboxListTile(
                                        value: isSelected,
                                        title: Text(
                                          status['label'],
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                        activeColor: Colors.green,
                                        onChanged: (checked) {
                                          setState(() {
                                            if (checked == true) {
                                              selectedStatuses.add(status);
                                            } else {
                                              selectedStatuses.remove(status);
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
                                padding: CustomTheme().padding('card'),
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
          )
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
