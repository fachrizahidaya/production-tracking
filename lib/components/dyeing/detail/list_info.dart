// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/clickable_text.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SingleChildScrollView(
      child: Container(
        padding: CustomTheme().padding('content'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.data['dyeing_no']?.toString() ?? '-',
                              style: TextStyle(
                                  fontSize: CustomTheme().fontSize('2xl'),
                                  fontWeight: CustomTheme().fontWeight('bold')),
                            ),
                            if (widget.data['rework'] == true)
                              CustomBadge(
                                title: 'Rework',
                                status: 'Rework',
                                withStatus: true,
                                rework: true,
                              ),
                          ].separatedBy(CustomTheme().hGap('lg')),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              size: CustomTheme().iconSize('lg'),
                            ),
                            Text(
                                'Dimulai pada ${widget.data['start_time'] != null ? DateFormat("dd MMMM yyyy, HH:mm").format(DateTime.parse(widget.data['start_time'])) : '-'}'),
                          ].separatedBy(CustomTheme().hGap('sm')),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.task_alt_outlined,
                              size: CustomTheme().iconSize('lg'),
                            ),
                            Text(
                                'Selesai pada ${widget.data['end_time'] != null ? DateFormat("dd MMMM yyyy, HH:mm").format(DateTime.parse(widget.data['end_time'])) : '-'}'),
                          ].separatedBy(CustomTheme().hGap('sm')),
                        ),
                      ].separatedBy(CustomTheme().vGap('sm')),
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
                ClickableText(
                  text: widget.data['work_orders']?['wo_no']?.toString() ?? '-',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkOrderDetail(
                          id: widget.data['work_orders']['id'].toString(),
                        ),
                      ),
                    );
                  },
                )
                // SelectForm(
                //   isDisabled: widget.data['can_update'] ? false : true,
                //   label: 'Mesin',
                //   onTap: () => widget.handleSelectMachine(),
                //   selectedLabel: widget.form['nama_mesin'] ?? '',
                //   selectedValue: widget.form['machine_id'].toString(),
                //   required: false,
                // )
              ].separatedBy(CustomTheme().vGap('lg')),
            )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomCard(
                      child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Proses',
                            style: TextStyle(
                                fontSize: CustomTheme().fontSize('xl'),
                                fontWeight: CustomTheme().fontWeight('bold')),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.data['rework'] == true)
                                ViewText(
                                  viewLabel: 'Referensi Rework',
                                  viewValue:
                                      '${widget.data['rework_reference']['dyeing_no']}',
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ViewText(
                                    viewLabel: 'Mesin',
                                    viewValue:
                                        '${widget.data['machine']['name']}',
                                  ),
                                  ViewText(
                                    viewLabel: 'Lokasi',
                                    viewValue:
                                        '${widget.data['machine']['location']}',
                                  ),
                                ],
                              ),
                              if (widget.data['status'] == 'Selesai')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ViewText(
                                      viewLabel: 'Qty Hasil Dyeing',
                                      viewValue:
                                          '${widget.data['qty']} ${widget.data['unit']['code']}',
                                    ),
                                    ViewText(
                                      viewLabel: 'Panjang',
                                      viewValue:
                                          '${widget.data['length'] ?? '0'}',
                                    ),
                                    ViewText(
                                      viewLabel: 'Lebar',
                                      viewValue:
                                          '${widget.data['width'] ?? '0'}',
                                    ),
                                  ],
                                ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Expanded(
                              //       flex: 2,
                              //       child: TextForm(
                              //         label: 'Panjang',
                              //         req: false,
                              //         controller: widget.length
                              //           ..text = (widget.length.text == '0')
                              //               ? '0'
                              //               : widget.length.text,
                              //         isDisabled:
                              //             widget.data['can_update'] ? false : true,
                              //         handleChange: (value) {
                              //           setState(() {
                              //             widget.length.text = value.toString();
                              //             widget.handleChangeInput('length', value);
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: SelectForm(
                              //           label: 'Satuan Panjang',
                              //           onTap: () =>
                              //               widget.handleSelectLengthUnit(),
                              //           isDisabled: widget.data['can_update']
                              //               ? false
                              //               : true,
                              //           selectedLabel:
                              //               widget.form['nama_satuan_panjang'] ??
                              //                   '',
                              //           selectedValue: widget.form['length_unit_id']
                              //                   ?.toString() ??
                              //               '',
                              //           required: false),
                              //     ),
                              //   ].separatedBy(SizedBox(
                              //     width: 8,
                              //   )),
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Expanded(
                              //       flex: 2,
                              //       child: TextForm(
                              //         label: 'Lebar',
                              //         req: false,
                              //         isDisabled:
                              //             widget.data['can_update'] ? false : true,
                              //         controller: widget.width
                              //           ..text = (widget.width.text == '0'
                              //               ? '0'
                              //               : widget.width.text),
                              //         handleChange: (value) {
                              //           setState(() {
                              //             widget.width.text = value.toString();
                              //             widget.handleChangeInput('width', value);
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: SelectForm(
                              //           label: 'Satuan Lebar',
                              //           onTap: () => widget.handleSelectWidthUnit(),
                              //           isDisabled: widget.data['can_update']
                              //               ? false
                              //               : true,
                              //           selectedLabel:
                              //               widget.form['nama_satuan_lebar'] ?? '',
                              //           selectedValue: widget.form['width_unit_id']
                              //                   ?.toString() ??
                              //               '',
                              //           required: false),
                              //     ),
                              //   ].separatedBy(SizedBox(
                              //     width: 8,
                              //   )),
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     Expanded(
                              //       flex: 2,
                              //       child: TextForm(
                              //         label: 'Qty Hasil Dyeing',
                              //         req: false,
                              //         isDisabled:
                              //             widget.data['can_update'] ? false : true,
                              //         controller: widget.qty
                              //           ..text = (widget.qty.text.isEmpty ||
                              //                   widget.qty.text == '0'
                              //               ? 'No Data'
                              //               : widget.qty.text),
                              //         handleChange: (value) {
                              //           setState(() {
                              //             widget.qty.text = value.toString();
                              //             widget.handleChangeInput('qty', value);
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex: 1,
                              //       child: SelectForm(
                              //           label: 'Satuan Qty',
                              //           isDisabled: widget.data['can_update']
                              //               ? false
                              //               : true,
                              //           onTap: () => widget.handleSelectUnit(),
                              //           selectedLabel:
                              //               widget.form['nama_satuan'] ?? '',
                              //           selectedValue:
                              //               widget.form['unit_id']?.toString() ??
                              //                   '',
                              //           required: false),
                              //     ),
                              //   ].separatedBy(SizedBox(
                              //     width: 8,
                              //   )),
                              // ),
                            ].separatedBy(CustomTheme().vGap('lg')),
                          )
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    ],
                  )),
                ),
                if (!isPortrait)
                  Expanded(
                    child: CustomCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Work Order',
                          style: TextStyle(
                              fontSize: CustomTheme().fontSize('xl'),
                              fontWeight: CustomTheme().fontWeight('bold')),
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
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
                  ),
              ].separatedBy(CustomTheme().hGap('2xl')),
            ),
            if (isPortrait)
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Work Order',
                          style: TextStyle(
                              fontSize: CustomTheme().fontSize('xl'),
                              fontWeight: FontWeight.bold),
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
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
                  ),
                ],
              ),
            if (widget.data['status'] == 'Selesai')
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lampiran',
                          style: TextStyle(
                              fontSize: CustomTheme().fontSize('xl'),
                              fontWeight: CustomTheme().fontWeight('bold')),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            widget.existingAttachment.isEmpty
                                ? Text(
                                    'No Data',
                                    style: TextStyle(
                                      fontSize: CustomTheme().fontSize('lg'),
                                    ),
                                  )
                                : widget.handleBuildAttachment(context),
                          ],
                        ),
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
                  ),
                ],
              ),
            if (widget.data['status'] == 'Selesai')
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan',
                          style: TextStyle(
                              fontSize: CustomTheme().fontSize('xl'),
                              fontWeight: CustomTheme().fontWeight('bold')),
                        ),
                        Text(
                          '${widget.data['notes'] ?? '-'}',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('lg'),
                          ),
                        )
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
                  ),
                ],
              )
          ].separatedBy(CustomTheme().vGap('2xl')),
        ),
      ),
    );
  }
}
