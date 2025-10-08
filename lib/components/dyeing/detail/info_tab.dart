import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/multiline_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class InfoTab extends StatefulWidget {
  final data;
  final isLoading;
  final qty;
  final length;
  final width;
  final note;
  final form;
  final handleChangeInput;
  final handleSelectUnit;
  final handleUpdate;

  const InfoTab(
      {super.key,
      this.data,
      this.isLoading,
      this.qty,
      this.length,
      this.width,
      this.note,
      this.form,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleUpdate});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? Container(
            color: const Color(0xFFEBEBEB),
            padding: PaddingColumn.screen,
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomCard(
                    child: SingleChildScrollView(
                        padding: PaddingColumn.screen,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ViewText(
                                  viewLabel: 'Nomor',
                                  viewValue:
                                      widget.data['dyeing_no']?.toString() ??
                                          '-',
                                ),
                                ViewText<Map<String, dynamic>>(
                                  viewLabel: 'Work Order',
                                  viewValue: widget.data['work_orders']
                                              ?['wo_no']
                                          ?.toString() ??
                                      '-',
                                  item: widget.data['work_orders'],
                                  onItemTap: (context, workOrder) {
                                    if (workOrder['id'] != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorkOrderDetail(
                                            id: workOrder['id'].toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                ViewText(
                                  viewLabel: 'Tanggal',
                                  viewValue: widget.data['start_time'] != null
                                      ? DateFormat("dd MMM yyyy").format(
                                          DateTime.parse(
                                              widget.data['start_time']))
                                      : '-',
                                ),
                                ViewText(
                                  viewLabel: 'Rework',
                                  viewValue: widget.data['rework'] == true
                                      ? 'Yes'
                                      : 'No',
                                ),
                                ViewText(
                                  viewLabel: 'Mesin',
                                  viewValue:
                                      '${widget.data['machine']?['code'] ?? ''} - ${widget.data['machine']?['name'] ?? ''}',
                                ),
                                ViewText(
                                  viewLabel: 'Mulai',
                                  viewValue: widget.data['start_time'] != null
                                      ? '${DateFormat("HH:mm").format(DateTime.parse(widget.data['start_time']))} Oleh ${widget.data['start_by']?['name'] ?? '-'}'
                                      : '-',
                                ),
                                ViewText(
                                  viewLabel: 'Selesai',
                                  viewValue: widget.data['end_time'] != null
                                      ? '${DateFormat("HH:mm").format(DateTime.parse(widget.data['end_time']))} Oleh ${widget.data['end_by']?['name'] ?? '-'}'
                                      : '-',
                                ),
                                ViewText(
                                    viewLabel: 'Status',
                                    viewValue: widget.data['status'] ?? '-'),
                              ].separatedBy(SizedBox(
                                height: 16,
                              )),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextForm(
                                        label: 'Panjang',
                                        req: false,
                                        controller: widget.length,
                                        handleChange: (value) {
                                          setState(() {
                                            widget.length.text =
                                                value.toString();
                                            widget.handleChangeInput(
                                                'length', value);
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextForm(
                                        label: 'Lebar',
                                        req: false,
                                        controller: widget.width,
                                        handleChange: (value) {
                                          setState(() {
                                            widget.width.text =
                                                value.toString();
                                            widget.handleChangeInput(
                                                'width', value);
                                          });
                                        },
                                      ),
                                    )
                                  ].separatedBy(SizedBox(
                                    width: 16,
                                  )),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextForm(
                                        label: 'Jumlah',
                                        req: false,
                                        controller: widget.qty,
                                        handleChange: (value) {
                                          setState(() {
                                            widget.qty.text = value.toString();
                                            widget.handleChangeInput(
                                                'qty', value);
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: SelectForm(
                                            label: 'Satuan',
                                            onTap: () =>
                                                widget.handleSelectUnit(),
                                            selectedLabel:
                                                widget.form['nama_satuan'] ??
                                                    '',
                                            selectedValue: widget
                                                    .form['unit_id']
                                                    ?.toString() ??
                                                '',
                                            required: false))
                                  ].separatedBy(SizedBox(
                                    width: 16,
                                  )),
                                ),
                                MultilineForm(
                                  label: 'Catatan',
                                  req: false,
                                  controller: widget.note,
                                  handleChange: (value) {
                                    setState(() {
                                      widget.note.text = value.toString();
                                      widget.handleChangeInput('notes', value);
                                    });
                                  },
                                ),
                                FormButton(
                                  label: 'Simpan',
                                  onPressed: () => widget.handleUpdate(
                                      widget.data['id'].toString()),
                                )
                              ].separatedBy(SizedBox(
                                height: 16,
                              )),
                            ),
                          ].separatedBy(SizedBox(
                            height: 16,
                          )),
                        ))),
          )
        : Container(
            color: const Color(0xFFEBEBEB),
            alignment: Alignment.center,
            child: NoData());
  }
}
