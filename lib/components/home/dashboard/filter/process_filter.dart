import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/filter/filter_select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessFilter<T> extends StatefulWidget {
  final onHandleFilter;
  final params;

  const ProcessFilter({
    super.key,
    this.onHandleFilter,
    this.params,
  });

  @override
  State<ProcessFilter<T>> createState() => _ProcessFilterState<T>();
}

class _ProcessFilterState<T> extends State<ProcessFilter<T>> {
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
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                                                BorderRadius.circular(12),
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
