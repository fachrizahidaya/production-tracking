import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
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
      padding: EdgeInsets.fromLTRB(0, 16.0, 0, 64.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: CustomTheme().padding('card-detail'),
            child: Text(
              'Filter',
              style: TextStyle(
                  height: 1,
                  fontSize: CustomTheme().fontSize('xl'),
                  fontWeight: CustomTheme().fontWeight('bold')),
            ),
          ),
          Divider(),
          Container(
            padding: CustomTheme().padding('card-detail'),
            child: FilterSelectForm(
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
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            void runSearch(String value) {
                              if (debounce?.isActive ?? false) {
                                debounce!.cancel();
                              }

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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pilih Status",
                                        style: TextStyle(
                                          fontSize:
                                              CustomTheme().fontSize('xl'),
                                          fontWeight: CustomTheme()
                                              .fontWeight('semibold'),
                                        ),
                                      ),
                                      SizedBox(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Pencarian...',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onChanged: runSearch,
                                        ),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('lg')),
                                  ),
                                ),
                                Expanded(
                                  child: Scrollbar(
                                    child: ListView.separated(
                                      itemCount: filteredList.length,
                                      itemBuilder: (context, index) {
                                        final item = filteredList[index];

                                        final status = statusOption[index];
                                        final isSelected = selectedStatuses.any(
                                            (s) => s['value'] == item['value']);

                                        return CheckboxListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 24),
                                          value: isSelected,
                                          title: Text(
                                            status['label'],
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
                                          Divider(),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12)),
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 56,
                                          child: CancelButton(
                                            label: 'Reset',
                                            onPressed: () {
                                              setState(() {
                                                selectedStatuses.clear();
                                                filteredList =
                                                    List.from(statusOption);
                                              });
                                            },
                                            fontSize:
                                                CustomTheme().fontSize('xl'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 56,
                                          child: FormButton(
                                            label: 'Terapkan',
                                            onPressed: () {
                                              Navigator.pop(
                                                  context, selectedStatuses);
                                            },
                                            fontSize:
                                                CustomTheme().fontSize('xl'),
                                          ),
                                        ),
                                      ),
                                    ].separatedBy(CustomTheme().hGap('lg')),
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
                widget.onHandleFilter("status",
                    selectedStatuses.map((e) => e['value']).join(","));
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
          )
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
