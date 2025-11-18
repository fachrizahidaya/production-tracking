import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ChartFilter<T> extends StatefulWidget {
  final dariTanggal;
  final sampaiTanggal;
  final onHandleFilter;

  const ChartFilter(
      {super.key, this.dariTanggal, this.sampaiTanggal, this.onHandleFilter});

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
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: CustomTheme()
                        .inputDateDecoration(hintTextString: 'Pilih tanggal'),
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
              Expanded(
                child: GroupForm(
                  label: 'Sampai Tanggal',
                  formControl: TextFormField(
                    controller: sampaiTanggalInput,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: CustomTheme()
                        .inputDateDecoration(hintTextString: 'Pilih tanggal'),
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
            ].separatedBy(SizedBox(
              width: 16,
            )),
          ),
        ].separatedBy(SizedBox(
          height: 16,
        )),
      ),
    );
  }
}
