// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class ListInfo extends StatefulWidget {
  final data;
  final form;
  final isSubmitting;
  final existingAttachment;
  final handleUpdate;
  final initialQty;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final isChanged;
  final length;
  final width;
  final qty;
  final label;
  final note;
  final handleSelectMachine;
  final handleChangeInput;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectUnit;
  final handleHtml;
  final handleShowImage;
  final handleBuildAttachment;

  const ListInfo(
      {super.key,
      this.data,
      this.form,
      this.isSubmitting,
      this.existingAttachment,
      this.handleUpdate,
      this.initialQty,
      this.initialLength,
      this.initialNotes,
      this.initialWidth,
      this.isChanged,
      this.length,
      this.note,
      this.width,
      this.qty,
      this.label,
      this.handleSelectMachine,
      this.handleChangeInput,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.handleSelectUnit,
      this.handleHtml,
      this.handleShowImage,
      this.handleBuildAttachment});

  @override
  State<ListInfo> createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
                child: Padding(
                    padding: PaddingColumn.screen,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data['dyeing_no']?.toString() ?? '-',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                        'Dibuat pada ${widget.data['start_time'] != null ? DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(widget.data['start_time'])) : '-'}'),
                                    if (widget.data['rework'] == true)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.replay_outlined,
                                            size: 16,
                                          ),
                                          Text(
                                            'Rework',
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ].separatedBy(SizedBox(
                                height: 4,
                              )),
                            ),
                            CustomBadge(
                              title: widget.data['status'] ?? '-',
                              withDifferentColor: true,
                              withStatus: true,
                              status: widget.data['status'],
                              color: widget.data['status'] == 'Diproses'
                                  ? Color(0xFFfff3c6)
                                  : Color(0xffd1fae4),
                            ),
                          ],
                        ),
                        SelectForm(
                          isDisabled: widget.data['can_update'] ? false : true,
                          label: 'Mesin',
                          onTap: () => widget.handleSelectMachine(),
                          selectedLabel: widget.form['nama_mesin'] ?? '',
                          selectedValue: widget.form['machine_id'].toString(),
                          required: false,
                        )
                      ].separatedBy(SizedBox(
                        height: 8,
                      )),
                    ))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 2,
                    child: CustomCard(
                        child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INFORMASI PROSES',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                            builder: (context) =>
                                                WorkOrderDetail(
                                              id: workOrder['id'].toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  CustomBadge(
                                    title: widget.data['work_orders']
                                            ['status'] ??
                                        '-',
                                    withDifferentColor: true,
                                    withStatus: true,
                                    status: widget.data['work_orders']
                                        ['status'],
                                    color: widget.data['work_orders']
                                                ['status'] ==
                                            'Diproses'
                                        ? Color(0xFFfff3c6)
                                        : Color(0xffd1fae4),
                                  )
                                ],
                              ),
                              ViewText(
                                viewLabel: 'Tanggal',
                                viewValue: widget.data['work_orders']
                                            ['wo_date'] !=
                                        null
                                    ? DateFormat("dd MMMM yyyy").format(
                                        DateTime.parse(widget
                                            .data['work_orders']['wo_date']))
                                    : '-',
                              ),
                              if (widget.data['status'] == 'Selesai')
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextForm(
                                            label: 'Panjang',
                                            req: false,
                                            controller: widget.length
                                              ..text =
                                                  (widget.length.text == '0')
                                                      ? '0'
                                                      : widget.length.text,
                                            isDisabled:
                                                widget.data['can_update']
                                                    ? false
                                                    : true,
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
                                          child: SelectForm(
                                              label: 'Satuan Panjang',
                                              onTap: () => widget
                                                  .handleSelectLengthUnit(),
                                              isDisabled:
                                                  widget.data['can_update']
                                                      ? false
                                                      : true,
                                              selectedLabel: widget.form[
                                                      'nama_satuan_panjang'] ??
                                                  '',
                                              selectedValue: widget
                                                      .form['length_unit_id']
                                                      ?.toString() ??
                                                  '',
                                              required: false),
                                        ),
                                      ].separatedBy(SizedBox(
                                        width: 8,
                                      )),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextForm(
                                            label: 'Lebar',
                                            req: false,
                                            isDisabled:
                                                widget.data['can_update']
                                                    ? false
                                                    : true,
                                            controller: widget.width
                                              ..text = (widget.width.text == '0'
                                                  ? '0'
                                                  : widget.width.text),
                                            handleChange: (value) {
                                              setState(() {
                                                widget.width.text =
                                                    value.toString();
                                                widget.handleChangeInput(
                                                    'width', value);
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SelectForm(
                                              label: 'Satuan Lebar',
                                              onTap: () => widget
                                                  .handleSelectWidthUnit(),
                                              isDisabled:
                                                  widget.data['can_update']
                                                      ? false
                                                      : true,
                                              selectedLabel: widget.form[
                                                      'nama_satuan_lebar'] ??
                                                  '',
                                              selectedValue: widget
                                                      .form['width_unit_id']
                                                      ?.toString() ??
                                                  '',
                                              required: false),
                                        ),
                                      ].separatedBy(SizedBox(
                                        width: 8,
                                      )),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextForm(
                                            label: 'Qty Hasil Dyeing',
                                            req: false,
                                            isDisabled:
                                                widget.data['can_update']
                                                    ? false
                                                    : true,
                                            controller: widget.qty
                                              ..text =
                                                  (widget.qty.text.isEmpty ||
                                                          widget.qty.text == '0'
                                                      ? 'No Data'
                                                      : widget.qty.text),
                                            handleChange: (value) {
                                              setState(() {
                                                widget.qty.text =
                                                    value.toString();
                                                widget.handleChangeInput(
                                                    'qty', value);
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SelectForm(
                                              label: 'Satuan Qty',
                                              isDisabled:
                                                  widget.data['can_update']
                                                      ? false
                                                      : true,
                                              onTap: () =>
                                                  widget.handleSelectUnit(),
                                              selectedLabel:
                                                  widget.form['nama_satuan'] ??
                                                      '',
                                              selectedValue: widget
                                                      .form['unit_id']
                                                      ?.toString() ??
                                                  '',
                                              required: false),
                                        ),
                                      ].separatedBy(SizedBox(
                                        width: 8,
                                      )),
                                    ),
                                  ].separatedBy(SizedBox(
                                    height: 8,
                                  )),
                                )
                            ].separatedBy(SizedBox(
                              height: 8,
                            )),
                          ),
                        ],
                      ),
                    ))),
                if (!isMobile)
                  Expanded(
                      flex: 1,
                      child: CustomCard(
                          child: Padding(
                        padding: PaddingColumn.screen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'INFORMASI GREIGE & CATATAN',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ViewText(
                              viewLabel: 'Qty Greige',
                              viewValue:
                                  '${widget.data['work_orders']['greige_qty']} ${widget.data['work_orders']['greige_unit']['code']}',
                            ),
                            ViewText(
                              viewLabel: 'Catatan Dyeing',
                              viewValue: widget.handleHtml(
                                widget.data['work_orders']['notes'] is Map
                                    ? widget.data['work_orders']['notes']
                                        [widget.label]
                                    : '-',
                              ),
                            )
                          ].separatedBy(SizedBox(
                            height: 8,
                          )),
                        ),
                      )))
              ],
            ),
            if (isMobile)
              CustomCard(
                  child: Padding(
                padding: PaddingColumn.screen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INFORMASI GREIGE & CATATAN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ViewText(
                      viewLabel: 'Qty Greige',
                      viewValue:
                          '${widget.data['work_orders']['greige_qty']} ${widget.data['work_orders']['greige_unit']['code']}',
                    ),
                    ViewText(
                      viewLabel: 'Catatan Dyeing',
                      viewValue: widget.handleHtml(
                        widget.data['work_orders']['notes'] is Map
                            ? widget.data['work_orders']['notes'][widget.label]
                            : '-',
                      ),
                    )
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
              )),
            CustomCard(
                child: Padding(
              padding: PaddingColumn.screen,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TIMELINE PROSES',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ViewText(
                        viewLabel: 'Dimulai oleh',
                        viewValue: widget.data['start_time'] != null
                            ? '${widget.data['start_by']['name']} pada ${DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(widget.data['start_time']))}'
                            : '-',
                      ),
                      ViewText(
                        viewLabel: 'Selesai oleh',
                        viewValue: widget.data['end_time'] != null
                            ? '${widget.data['end_by']['name']} pada ${DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(widget.data['end_time']))}'
                            : '-',
                      ),
                    ].separatedBy(SizedBox(
                      height: 8,
                    )),
                  ),
                ],
              ),
            )),
            if (widget.data['status'] == 'Selesai')
              CustomCard(
                  child: Padding(
                padding: PaddingColumn.screen,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Lampiran',
                          style: TextStyle(fontSize: 16),
                        ),
                        CustomTheme().hGap('sm'),
                      ],
                    ),
                    widget.handleBuildAttachment(context),
                  ],
                ),
              )),
            if (widget.data['status'] == 'Selesai')
              CustomCard(
                  child: Padding(
                padding: PaddingColumn.screen,
                child: Row(
                  children: [
                    ViewText(
                      viewLabel: 'Catatan',
                      viewValue: '${widget.data['notes'] ?? '-'}',
                    ),
                  ],
                ),
              ))
          ],
        ),
      ),
    );
  }
}
