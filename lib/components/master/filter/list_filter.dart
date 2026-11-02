// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/filter/filter_select_form.dart';
import 'package:textile_tracking/components/master/filter/show_filter_select_dialog.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class DropdownConfig<T> {
  final String id;
  final String hint;
  final List<DropdownMenuItem<T>>? manualDropdownItems;
  final ValueChanged<T?> onChanged;

  DropdownConfig({
    required this.id,
    required this.hint,
    this.manualDropdownItems,
    required this.onChanged,
  });

  bool get hasManualItems =>
      manualDropdownItems != null && manualDropdownItems!.isNotEmpty;
}

class ListFilter<T> extends StatefulWidget {
  final params;
  final onHandleFilter;
  final dariTanggal;
  final sampaiTanggal;

  const ListFilter(
      {super.key,
      this.params,
      this.onHandleFilter,
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

  List<dynamic> selectedStatuses = [];
  List<dynamic> selectedOperators = [];

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
          .map((s) => Map<dynamic, dynamic>.from(s))
          .toList();
    }

    // if (widget.params['user_id'] != null) {
    //   final activeOperators = widget.params['user_id'].split(',');
    //   selectedStatuses = operatorOption
    //       .where((s) => activeOperators.contains(s['value']))
    //       .map((s) => Map<String, dynamic>.from(s))
    //       .toList();
    // }

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
            child: Row(
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
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),
          Container(
            padding: CustomTheme().padding('card-detail'),
            child: FilterSelectForm(
              label: "Status",
              onTap: () async {
                final result = await showFilterSelectDialog(
                  context: context,
                  options: statusOption,
                  selectedItems: selectedStatuses,
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
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
