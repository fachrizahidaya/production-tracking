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

  const ChartFilter(
      {super.key,
      this.dariTanggal,
      this.sampaiTanggal,
      this.onHandleFilter,
      this.pickDate});

  @override
  State<ChartFilter<T>> createState() => _ChartFilterState<T>();
}

class _ChartFilterState<T> extends State<ChartFilter<T>> {
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
                    controller: widget.dariTanggal,
                    style: const TextStyle(fontSize: 14),
                    decoration: CustomTheme().inputDateDecoration(
                      hintTextString: 'Pilih tanggal',
                    ),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () => widget.pickDate(
                      controller: widget.dariTanggal,
                      type: 'dari_tanggal',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GroupForm(
                  label: 'Sampai Tanggal',
                  formControl: TextFormField(
                    controller: widget.sampaiTanggal,
                    style: const TextStyle(fontSize: 14),
                    decoration: CustomTheme().inputDateDecoration(
                      hintTextString: 'Pilih tanggal',
                    ),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () => widget.pickDate(
                      controller: widget.sampaiTanggal,
                      type: 'sampai_tanggal',
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: GroupForm(
              //     label: 'Dari Tanggal',
              //     formControl: TextFormField(
              //       controller: dariTanggalInput,
              //       style: const TextStyle(
              //         fontSize: 16,
              //       ),
              //       decoration: CustomTheme()
              //           .inputDateDecoration(hintTextString: 'Pilih tanggal'),
              //       keyboardType: TextInputType.datetime,
              //       readOnly: true,
              //       onTap: () async {
              //         DateTime? pickedDate = await showDatePicker(
              //           context: context,
              //           initialDate: DateTime.now(),
              //           firstDate: DateTime(2020),
              //           lastDate: DateTime(2101),
              //           builder: (context, child) {
              //             return Theme(
              //               data: ThemeData.light().copyWith(
              //                 colorScheme: ColorScheme.light(
              //                   primary: CustomTheme().colors('base'),
              //                   onPrimary: Colors.white,
              //                   onSurface: Colors.black87,
              //                 ),
              //               ),
              //               child: child!,
              //             );
              //           },
              //         );

              //         if (pickedDate != null) {
              //           String formattedDate =
              //               DateFormat('yyyy-MM-dd').format(pickedDate);
              //           setState(() {
              //             dariTanggalInput.text = formattedDate;
              //             widget.onHandleFilter('start_date', formattedDate);
              //           });
              //         }
              //       },
              //     ),
              //   ),
              // ),
              // Expanded(
              //   child: GroupForm(
              //     label: 'Sampai Tanggal',
              //     formControl: TextFormField(
              //       controller: sampaiTanggalInput,
              //       style: const TextStyle(
              //         fontSize: 16,
              //       ),
              //       decoration: CustomTheme()
              //           .inputDateDecoration(hintTextString: 'Pilih tanggal'),
              //       keyboardType: TextInputType.datetime,
              //       readOnly: true,
              //       onTap: () async {
              //         DateTime? pickedDate = await showDatePicker(
              //           context: context,
              //           initialDate: DateTime.now(),
              //           firstDate: DateTime(2020),
              //           lastDate: DateTime(2101),
              //           builder: (context, child) {
              //             return Theme(
              //               data: ThemeData.light().copyWith(
              //                 colorScheme: ColorScheme.light(
              //                   primary: CustomTheme().colors('base'),
              //                   onPrimary: Colors.white,
              //                   onSurface: Colors.black87,
              //                 ),
              //               ),
              //               child: child!,
              //             );
              //           },
              //         );

              //         if (pickedDate != null) {
              //           String formattedDate =
              //               DateFormat('yyyy-MM-dd').format(pickedDate);
              //           setState(() {
              //             sampaiTanggalInput.text = formattedDate;
              //             widget.onHandleFilter('end_date', formattedDate);
              //           });
              //         }
              //       },
              //     ),
              //   ),
              // ),
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
