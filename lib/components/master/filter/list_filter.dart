import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/button/form_button.dart';
import 'package:production_tracking/components/master/form/group_form.dart';
import 'package:production_tracking/components/master/form/select_form.dart';
import 'package:production_tracking/components/master/theme.dart';
import 'package:production_tracking/helpers/util/margin_card.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';
import 'package:production_tracking/models/option/option_machine.dart';
import 'package:production_tracking/models/option/option_operator.dart';
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
      this.onSubmitFilter});

  @override
  State<ListFilter<T>> createState() => _ListFilterState<T>();
}

class _ListFilterState<T> extends State<ListFilter<T>> {
  TextEditingController dariTanggalInput = TextEditingController();
  TextEditingController sampaiTanggalInput = TextEditingController();

  int? operatorId;
  String? namaOperator = '';
  int? machineId;
  String? namaMachine = '';
  int page = 0;

  List<dynamic> machineOption = [];
  List<dynamic> operatorOption = [];

  List<Map<String, dynamic>> selectedMachines = [];
  List<Map<String, dynamic>> selectedStatuses = [];

  List<dynamic> statusOption = [
    {'label': 'Completed', 'value': 'Completed'},
    {'label': 'On Progress', 'value': 'On Progress'},
  ];

  @override
  void initState() {
    _getOperator();
    _getMachine();
    super.initState();
  }

  Future<void> _getMachine() async {
    await Provider.of<OptionMachineService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionMachineService>(context, listen: false)
        .dataListOption;

    setState(() {
      machineOption = result;
    });
  }

  Future<void> _getOperator() async {
    await Provider.of<OptionOperatorService>(context, listen: false)
        .fetchOptions();
    final result = Provider.of<OptionOperatorService>(context, listen: false)
        .dataListOption;

    setState(() {
      operatorOption = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      dariTanggalInput.text = widget.params['dari_tanggal'] ?? '';
      sampaiTanggalInput.text = widget.params['sampai_tanggal'] ?? '';
    });

    return Container(
      padding: MarginCard.screen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: PaddingColumn.screen,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectForm(
                      label: "Mesin",
                      onTap: () async {
                        final result =
                            await showDialog<List<Map<String, dynamic>>>(
                          context: context,
                          builder: (_) {
                            return SimpleDialog(
                              title: const Text("Pilih Mesin"),
                              children: machineOption.map((machine) {
                                final isSelected =
                                    selectedMachines.contains(machine);
                                return CheckboxListTile(
                                  value: isSelected,
                                  title: Text(machine['label']),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked == true) {
                                        selectedMachines.add(machine);
                                      } else {
                                        selectedMachines.remove(machine);
                                      }
                                    });
                                    Navigator.pop(context, selectedMachines);
                                  },
                                );
                              }).toList(),
                            );
                          },
                        );

                        if (result != null) {
                          setState(() {
                            selectedMachines = result;
                          });
                        }
                      },
                      selectedItems: selectedMachines,
                      required: false,
                      onRemoveItem: (item) {
                        setState(() {
                          selectedMachines.remove(item);
                        });
                      },
                      onClearAll: () {
                        setState(() {
                          selectedMachines.clear();
                        });
                      },
                    ),
                  ],
                ),
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
                              clearable:
                                  dariTanggalInput.text != '' ? true : false,
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
                                widget.onHandleFilter(
                                    'dari_tanggal', formattedDate);
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
                              clearable:
                                  sampaiTanggalInput.text != '' ? true : false,
                              onPressClear: () => {
                                    setState(() {
                                      widget.onHandleFilter(
                                          'sampai_tanggal', '');
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
                                      primary: CustomTheme()
                                          .colors('base'), // <-- SEE HERE
                                      onPrimary: Colors.white, // <-- SEE HERE
                                      onSurface: Colors.black87, // <-- SEE HERE
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
                SelectForm(
                  label: "Status",
                  onTap: () async {
                    final result = await showDialog<List<Map<String, dynamic>>>(
                      context: context,
                      builder: (_) {
                        return SimpleDialog(
                          title: const Text("Pilih Status"),
                          children: statusOption.map((status) {
                            final isSelected =
                                selectedStatuses.contains(status);
                            return CheckboxListTile(
                              value: isSelected,
                              title: Text(status['label']),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    selectedStatuses.add(status);
                                  } else {
                                    selectedStatuses.remove(status);
                                  }
                                });
                                Navigator.pop(context, selectedStatuses);
                              },
                            );
                          }).toList(),
                        );
                      },
                    );

                    if (result != null) {
                      setState(() {
                        selectedStatuses = result;
                      });
                    }
                  },
                  selectedItems: selectedStatuses,
                  required: false,
                  onRemoveItem: (item) {
                    setState(() {
                      selectedStatuses.remove(item);
                    });
                  },
                  onClearAll: () {
                    setState(() {
                      selectedStatuses.clear();
                    });
                  },
                ),
                FormButton(
                  label: 'Submit',
                  onPressed: () {},
                )
              ].separatedBy(SizedBox(
                height: 16,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
