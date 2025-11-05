import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/filter_select_form.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_machine.dart';
import 'package:textile_tracking/models/option/option_operator.dart';
import 'package:provider/provider.dart';

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
      this.getMachineOptions});

  @override
  State<ListFilter<T>> createState() => _ListFilterState<T>();
}

class _ListFilterState<T> extends State<ListFilter<T>> {
  TextEditingController dariTanggalInput = TextEditingController();
  TextEditingController sampaiTanggalInput = TextEditingController();
  bool _isFetchingMachine = false;
  int? operatorId;
  String? namaOperator = '';
  int? machineId;
  String? namaMachine = '';
  int page = 0;

  late List<dynamic> _dataList;

  List<dynamic> machineOption = [];
  List<dynamic> operatorOption = [];

  List<Map<String, dynamic>> selectedMachines = [];
  List<Map<String, dynamic>> selectedStatuses = [];

  List<dynamic> statusOption = [
    {'label': 'Diproses', 'value': 'Diproses'},
    {'label': 'Selesai', 'value': 'Selesai'},
  ];

  @override
  void initState() {
    super.initState();
    // _getOperator();
    _getMachine();

    if (widget.params['status'] != null) {
      final activeStatuses = widget.params['status'].split(',');
      selectedStatuses = statusOption
          .where((s) => activeStatuses.contains(s['value']))
          .map((s) => Map<String, dynamic>.from(s))
          .toList();
    }

    dariTanggalInput.text = widget.params['dari_tanggal'] ?? '';
    sampaiTanggalInput.text = widget.params['sampai_tanggal'] ?? '';

    if (widget.params['machine_id'] != null) {
      final activeMachines = widget.params['machine_id'].split(',');
      selectedMachines = machineOption
          .where((m) => activeMachines.contains(m['value'].toString()))
          .toList()
          .cast<Map<String, dynamic>>();
    }
  }

  Future<void> _getMachine() async {
    setState(() {
      _isFetchingMachine = true;
    });

    final service = Provider.of<OptionMachineService>(context, listen: false);

    try {
      if (widget.fetchMachine != null) {
        await widget.fetchMachine!(service);
      } else {
        await service.fetchOptions();
      }

      final data = widget.getMachineOptions != null
          ? widget.getMachineOptions!(service)
          : service.dataListOption;

      setState(() {
        machineOption = data;
      });
    } catch (e) {
      debugPrint("Error fetching machines: $e");
    } finally {
      setState(() {
        _isFetchingMachine = false;
      });
    }
  }

  Future<void> _getOperator() async {
    await Provider.of<OptionOperatorService>(context, listen: false)
        .fetchOptions();
    // ignore: use_build_context_synchronously
    final result = Provider.of<OptionOperatorService>(context, listen: false)
        .dataListOption;

    setState(() {
      operatorOption = result;
    });
  }

  _searchDataOption(value) {
    setState(() {
      _dataList = statusOption
          .where((element) => element['label']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      dariTanggalInput.text = widget.params['dari_tanggal'] ?? '';
      sampaiTanggalInput.text = widget.params['sampai_tanggal'] ?? '';
    });

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FilterSelectForm(
          //     label: "Mesin",
          //     onTap: () async {
          //       final result = await showDialog<List<Map<String, dynamic>>>(
          //         context: context,
          //         builder: (_) {
          //           return SimpleDialog(
          //             title: const Text("Pilih Mesin"),
          //             children: machineOption.map((machine) {
          //               final isSelected = selectedMachines.contains(machine);
          //               return CheckboxListTile(
          //                 value: isSelected,
          //                 title: Text(machine['label']),
          //                 onChanged: (checked) {
          //                   setState(() {
          //                     if (checked == true) {
          //                       selectedMachines.add(machine);
          //                     } else {
          //                       selectedMachines.remove(machine);
          //                     }
          //                   });
          //                   Navigator.pop(context, selectedMachines);
          //                 },
          //               );
          //             }).toList(),
          //           );
          //         },
          //       );

          //       if (result != null) {
          //         setState(() {
          //           selectedMachines = result;
          //         });
          //         widget.onHandleFilter(
          //             "machine_id", result.map((e) => e['value']).join(","));
          //       }
          //     },
          //     selectedItems: selectedMachines,
          //     required: false,
          //     onRemoveItem: (item) {
          //       setState(() {
          //         selectedMachines.remove(item);
          //       });
          //       widget.onHandleFilter("machine_id",
          //           selectedStatuses.map((e) => e['value']).join(","));
          //     },
          //     onClearAll: () {
          //       setState(() {
          //         selectedMachines.clear();
          //       });
          //       widget.onHandleFilter("machine_id", "");
          //     },
          //     onSelectionChanged: (selected) {
          //       widget.onHandleFilter(
          //           "machine_id", selected.map((e) => e['value']).join(","));
          //     }),
          Row(
            children: [
              Expanded(
                child: GroupForm(
                  label: 'Dari Tanggal',
                  formControl: TextFormField(
                    controller: dariTanggalInput,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: CustomTheme().inputDateDecoration(
                        clearable: dariTanggalInput.text != '' ? true : false,
                        onPressClear: () => {
                              setState(() {
                                widget.onHandleFilter('dari_tanggal', '');
                                dariTanggalInput.text = '';
                              })
                            },
                        hintTextString: 'Pilih tanggal'),
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
                          widget.onHandleFilter('dari_tanggal', formattedDate);
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
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: CustomTheme().inputDateDecoration(
                        clearable: sampaiTanggalInput.text != '' ? true : false,
                        onPressClear: () => {
                              setState(() {
                                widget.onHandleFilter('sampai_tanggal', '');
                                sampaiTanggalInput.text = '';
                              })
                            },
                        hintTextString: 'Pilih tanggal'),
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
                          widget.onHandleFilter(
                              'sampai_tanggal', formattedDate);
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
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 🔹 Header
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
                                        onChanged: (value) {
                                          _searchDataOption(value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 🔹 List of Options
                              Expanded(
                                child: Scrollbar(
                                  thickness: 4,
                                  child: ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: statusOption.length,
                                    itemBuilder: (context, index) {
                                      final status = statusOption[index];
                                      final isSelected =
                                          selectedStatuses.contains(status);

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

                              // 🔹 Footer (Buttons)
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // cancel
                                      },
                                      child: const Text('Batal'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            selectedStatuses); // return selected
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
