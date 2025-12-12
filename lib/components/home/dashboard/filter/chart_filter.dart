import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ChartFilter<T> extends StatefulWidget {
  final dariTanggal;
  final sampaiTanggal;
  final onHandleFilter;
  final pickDate;
  final handleProcess;

  const ChartFilter(
      {super.key,
      this.dariTanggal,
      this.sampaiTanggal,
      this.onHandleFilter,
      this.pickDate,
      this.handleProcess});

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
                        hintTextString: 'Pilih tanggal', hasValue: false),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () => widget.pickDate(
                        controller: widget.dariTanggal,
                        type: 'dari_tanggal',
                        widget.handleProcess),
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
                        hintTextString: 'Pilih tanggal', hasValue: false),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () => widget.pickDate(
                        controller: widget.sampaiTanggal,
                        type: 'sampai_tanggal',
                        widget.handleProcess),
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
