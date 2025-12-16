import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class ListInfoSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> form;
  final ValueNotifier<bool> isSubmitting;
  final List<dynamic> existingAttachment;
  final Future<void> Function(String id)? handleUpdate;
  final String? initialWeight;
  final String? initialLength;
  final String? initialWidth;
  final String? initialNotes;
  final String? initialMaklon;
  final bool? isChanged;
  final VoidCallback? handleSelectMachine;
  final Widget Function(Map<String, dynamic> data)? extraTopSection;
  final Widget Function(Map<String, dynamic> data)? extraBottomSection;

  final weight;
  final length;
  final width;
  final note;
  final maklon;
  final qty;
  final qtyItem;
  final notes;
  final fieldConfigs;
  final fieldControllers;
  final handleSelectUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectQtyUnit;
  final handleSelectQtyItemUnit;
  final handlePickAttachments;
  final handleChangeInput;
  final handleBuildAttachment;
  final handleHtmlText;
  final checkForChanges;
  final no;
  final withItemGrade;
  final existingGrades;
  final withQtyAndWeight;
  final initialQty;
  final withMaklon;
  final onlySewing;
  final label;

  const ListInfoSection(
      {super.key,
      required this.data,
      required this.form,
      required this.isSubmitting,
      required this.existingAttachment,
      this.handleUpdate,
      this.initialWeight,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.isChanged,
      this.weight,
      this.length,
      this.width,
      this.note,
      this.handleSelectMachine,
      this.extraTopSection,
      this.extraBottomSection,
      this.fieldConfigs,
      this.fieldControllers,
      this.handleSelectUnit,
      this.handlePickAttachments,
      this.handleChangeInput,
      this.checkForChanges,
      this.no,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.withItemGrade = false,
      this.qty,
      this.handleSelectQtyUnit,
      this.existingGrades,
      this.notes,
      this.withQtyAndWeight = false,
      this.initialQty,
      this.qtyItem,
      this.handleSelectQtyItemUnit,
      this.withMaklon = false,
      this.maklon,
      this.initialMaklon,
      this.onlySewing = false,
      this.handleBuildAttachment,
      this.handleHtmlText,
      this.label});

  @override
  State<ListInfoSection> createState() => _ListInfoSectionState();
}

class _ListInfoSectionState extends State<ListInfoSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final grades = widget.existingGrades;

    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          widget.no ?? '-',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Dibuat pada ${data['start_time'] != null ? DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(data['start_time'])) : '-'}',
                        ),
                      ].separatedBy(SizedBox(
                        height: 4,
                      )),
                    ),
                    CustomBadge(
                        title: data['status'] ?? '-',
                        withDifferentColor: true,
                        withStatus: true,
                        status: data['status'],
                        color: data['status'] == 'Diproses'
                            ? Color(0xFFfff3c6)
                            : Color(0xffd1fae4)),
                  ],
                ),
                if (widget.withMaklon == false)
                  SelectForm(
                    label: 'Mesin',
                    isDisabled: data['can_update'] ? false : true,
                    onTap: widget.handleSelectMachine!,
                    selectedLabel: widget.form['nama_mesin'] ?? '',
                    selectedValue: widget.form['machine_id'].toString(),
                    required: false,
                  )
              ].separatedBy(SizedBox(
                height: 8,
              )),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CustomCard(
                child: Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ViewText<Map<String, dynamic>>(
                                viewLabel: 'Work Order',
                                viewValue:
                                    data['work_orders']?['wo_no']?.toString() ??
                                        '-',
                                item: data['work_orders'],
                                onItemTap: (context, workOrder) {
                                  if (workOrder['id'] != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorkOrderDetail(
                                              id: workOrder['id'].toString()),
                                        ));
                                  }
                                },
                              ),
                              CustomBadge(
                                  title: data['work_orders']?['status']
                                          ?.toString() ??
                                      '-',
                                  withDifferentColor: true,
                                  withStatus: true,
                                  status: data['work_orders']['status'],
                                  color: data['work_orders']['status'] ==
                                          'Diproses'
                                      ? Color(0xFFfff3c6)
                                      : Color(0xffd1fae4))
                            ],
                          ),
                          ViewText(
                            viewLabel: 'Tanggal',
                            viewValue: data['work_orders']?['wo_date'] != null
                                ? DateFormat("dd MMMM yyyy").format(
                                    DateTime.parse(
                                        data['work_orders']['wo_date']),
                                  )
                                : '-',
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextForm(
                                      isDisabled:
                                          data['can_update'] ? false : true,
                                      label: 'Panjang',
                                      req: false,
                                      controller: widget.length
                                        ..text = (widget.length.text == '0')
                                            ? '0'
                                            : widget.length.text,
                                      handleChange: (value) {
                                        setState(() {
                                          widget.length.text = value.toString();
                                          widget.handleChangeInput(
                                              'length', value);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SelectForm(
                                        isDisabled:
                                            data['can_update'] ? false : true,
                                        label: 'Satuan Panjang',
                                        onTap: () =>
                                            widget.handleSelectLengthUnit(),
                                        selectedLabel: widget
                                                .form['nama_satuan_panjang'] ??
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextForm(
                                      isDisabled:
                                          data['can_update'] ? false : true,
                                      label: 'Lebar',
                                      req: false,
                                      controller: widget.width
                                        ..text = (widget.width.text == '0')
                                            ? '0'
                                            : widget.width.text,
                                      handleChange: (value) {
                                        setState(() {
                                          widget.length.text = value.toString();
                                          widget.handleChangeInput(
                                              'width', value);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SelectForm(
                                        isDisabled:
                                            data['can_update'] ? false : true,
                                        label: 'Satuan Lebar',
                                        onTap: () =>
                                            widget.handleSelectWidthUnit(),
                                        selectedLabel:
                                            widget.form['nama_satuan_lebar'] ??
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextForm(
                                      isDisabled:
                                          data['can_update'] ? false : true,
                                      label: 'Berat',
                                      req: false,
                                      controller: widget.weight
                                        ..text = (widget.weight.text.isEmpty ||
                                                widget.weight.text == '0'
                                            ? 'No Data'
                                            : widget.weight.text),
                                      handleChange: (value) {
                                        setState(() {
                                          widget.weight.text = value.toString();
                                          widget.handleChangeInput(
                                              'weight', value);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SelectForm(
                                        isDisabled:
                                            data['can_update'] ? false : true,
                                        label: 'Satuan Berat',
                                        onTap: () => widget.handleSelectUnit(),
                                        selectedLabel:
                                            widget.form['nama_satuan_berat'] ??
                                                '',
                                        selectedValue: widget
                                                .form['weight_unit_id']
                                                ?.toString() ??
                                            '',
                                        required: false),
                                  ),
                                ].separatedBy(SizedBox(
                                  width: 8,
                                )),
                              ),
                              if (widget.withQtyAndWeight == true)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextForm(
                                        label: 'Jumlah',
                                        isDisabled:
                                            data['can_update'] ? false : true,
                                        req: false,
                                        controller: widget.qtyItem
                                          ..text = (widget
                                                      .qtyItem.text.isEmpty ||
                                                  widget.qtyItem.text == '0')
                                              ? 'No Data'
                                              : widget.qtyItem.text,
                                        handleChange: (value) {
                                          setState(() {
                                            widget.qtyItem.text =
                                                value.toString();
                                            widget.handleChangeInput(
                                                'item_qty', value);
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SelectForm(
                                          label: 'Satuan',
                                          isDisabled:
                                              data['can_update'] ? false : true,
                                          onTap: () =>
                                              widget.handleSelectQtyItemUnit(),
                                          selectedLabel:
                                              widget.form['nama_satuan'] ?? '',
                                          selectedValue: widget
                                                  .form['item_unit_id']
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
                    ].separatedBy(SizedBox(
                      height: 8,
                    )),
                  ),
                ),
              ),
            ),
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
                              '${data['work_orders']?['greige_qty'] ?? '-'} ${data['work_orders']?['greige_unit']?['code'] ?? '-'}',
                        ),
                        ViewText(
                          viewLabel: 'Catatan ${widget.label}',
                          viewValue: widget.handleHtmlText(
                              data['work_orders']['notes'] is Map
                                  ? data['work_orders']['notes'][widget.label]
                                  : '-'),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ViewText(
                  viewLabel: 'Qty Greige',
                  viewValue:
                      '${data['work_orders']?['greige_qty'] ?? '-'} ${data['work_orders']?['greige_unit']?['code'] ?? '-'}',
                ),
                ViewText(
                  viewLabel: 'Catatan Work Order',
                  viewValue: widget.handleHtmlText(
                      data['work_orders']['notes'] is Map
                          ? data['work_orders']['notes'][widget.label]
                          : '-'),
                )
              ].separatedBy(SizedBox(
                height: 8,
              )),
            ),
          )),
        if (widget.withMaklon == true)
          CustomCard(
            child: Padding(
              padding: PaddingColumn.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Maklon',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Switch(
                        value: data['maklon'],
                        onChanged: data['can_update']
                            ? (value) {
                                setState(() {
                                  data['maklon'] = value;
                                  widget.form['maklon'] = value;
                                });
                              }
                            : null,
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.redAccent,
                      ),
                    ],
                  ),
                  Text(data['maklon'] ? 'Ya' : 'Tidak'),
                  if (data['maklon'] == true)
                    TextForm(
                      label: 'Nama Maklon',
                      req: false,
                      controller: widget.maklon,
                      handleChange: (value) {
                        setState(() {
                          widget.maklon.text = value.toString();
                          widget.form['maklon_name'] = value.toString();
                        });
                      },
                    ),
                  if (widget.onlySewing == true && data['maklon'] == false)
                    SelectForm(
                      label: 'Mesin',
                      isDisabled: data['can_update'] ? false : true,
                      onTap: widget.handleSelectMachine!,
                      selectedLabel: widget.form['nama_mesin'] ?? '',
                      selectedValue: widget.form['machine_id'].toString(),
                      required: false,
                    )
                ].separatedBy(SizedBox(
                  height: 8,
                )),
              ),
            ),
          ),
        if (widget.withItemGrade == true && data['status'] == 'Selesai')
          CustomCard(
              child: Padding(
                  padding: PaddingColumn.screen,
                  child: Column(
                    children: [
                      for (int i = 0; i < grades.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ViewText(
                                  viewLabel: grades[i]['item_grade']
                                              ['description']
                                          ?.split('-')
                                          .first
                                          .trim() ??
                                      '-',
                                  viewValue: grades[i]['item_grade']
                                              ['description']
                                          ?.split('-')
                                          .last
                                          .trim() ??
                                      '-'),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextForm(
                                label: 'Jumlah',
                                req: false,
                                controller: (i < widget.qty.length)
                                    ? widget.qty[i]
                                    : TextEditingController(
                                        text:
                                            grades[i]['qty']?.toString() ?? ''),
                                handleChange: (value) {
                                  setState(() {
                                    if (widget.form['grades'] == null ||
                                        i >= widget.form['grades'].length) {
                                      widget.form['grades'] = List.from(grades);
                                    }
                                    widget.form['grades'][i]['qty'] =
                                        double.tryParse(value) ?? 0;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SelectForm(
                                  label: 'Satuan',
                                  onTap: () => widget.handleSelectQtyUnit(i),
                                  selectedLabel: widget.form['grades'][i]
                                          ['unit']['name'] ??
                                      '-',
                                  selectedValue: widget.form['grades'][i]
                                          ['unit_id']
                                      .toString(),
                                  required: false),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextForm(
                                label: 'Catatan',
                                req: false,
                                controller: (i < widget.notes.length)
                                    ? TextEditingController(
                                        text: widget.handleHtmlText(
                                          widget.notes[i]
                                                  is TextEditingController
                                              ? widget.notes[i].text
                                              : widget.notes[i].toString(),
                                        ),
                                      )
                                    : TextEditingController(
                                        text: widget.handleHtmlText(
                                          grades[i]['notes']?.toString() ?? '',
                                        ),
                                      ),
                                handleChange: (value) {
                                  setState(() {
                                    if (widget.form['grades'] == null ||
                                        i >= widget.form['grades'].length) {
                                      widget.form['grades'] = List.from(grades);
                                    }
                                    widget.form['grades'][i]['notes'] = value;
                                  });
                                },
                              ),
                            ),
                          ].separatedBy(SizedBox(
                            width: 16,
                          )),
                        ),
                    ].separatedBy(SizedBox(
                      height: 16,
                    )),
                  ))),
        CustomCard(
            child: Padding(
          padding: PaddingColumn.screen,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                        viewLabel: 'Dimulai oleh',
                        viewValue: data['start_time'] != null
                            ? '${data['start_by']['name']} pada ${DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(data['start_time']))}'
                            : '-',
                      ),
                      ViewText(
                        viewLabel: 'Selesai oleh',
                        viewValue: data['end_time'] != null
                            ? '${data['end_by']['name']} pada ${DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(data['end_time']))}'
                            : '-',
                      ),
                    ].separatedBy(SizedBox(
                      height: 8,
                    )),
                  ),
                ],
              ),
            ],
          ),
        )),
        CustomCard(
          child: Padding(
            padding: PaddingColumn.screen,
            child: widget.handleBuildAttachment(context),
          ),
        ),
        if (data['status'] == 'Selesai')
          CustomCard(
              child: Padding(
            padding: PaddingColumn.screen,
            child: Row(
              children: [
                ViewText(
                  viewLabel: 'Catatan',
                  viewValue: widget.handleHtmlText(data['notes'] ?? '-'),
                ),
              ],
            ),
          ))
      ]),
    ));
  }
}
