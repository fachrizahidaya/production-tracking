import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ChartFilter<T> extends StatefulWidget {
  final dariTanggal;
  final sampaiTanggal;
  final onHandleFilter;
  final pickDate;
  final params;

  const ChartFilter(
      {super.key,
      this.dariTanggal,
      this.sampaiTanggal,
      this.onHandleFilter,
      this.pickDate,
      this.params});

  @override
  State<ChartFilter<T>> createState() => _ChartFilterState<T>();
}

class _ChartFilterState<T> extends State<ChartFilter<T>> {
  TextEditingController dariTanggalInput = TextEditingController();
  TextEditingController sampaiTanggalInput = TextEditingController();

  @override
  void initState() {
    super.initState();

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
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    setState(() {
      dariTanggalInput.text = widget.params['process_start_date'] ?? '';
      sampaiTanggalInput.text = widget.params['process_end_date'] ?? '';
    });

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
                            widget.onHandleFilter(
                                'process_start_date',
                                DateFormat('yyyy-MM-dd')
                                    .format(firstDayOfMonth));
                          });
                        },
                        withReset: true),
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
                          widget.onHandleFilter(
                              'process_start_date', formatted);
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
                            widget.onHandleFilter('process_end_date',
                                DateFormat('yyyy-MM-dd').format(now));
                          });
                        },
                        withReset: true),
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
                          widget.onHandleFilter('process_end_date', formatted);
                        });
                      }
                    },
                  ),
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
