import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
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

  final weight;
  final length;
  final width;
  final note;
  final maklon;
  final qty;
  final qtyItem;
  final notes;

  final VoidCallback? handleSelectMachine;
  final Widget Function(Map<String, dynamic> data)? extraTopSection;
  final Widget Function(Map<String, dynamic> data)? extraBottomSection;

  final fieldConfigs;
  final fieldControllers;
  final handleSelectUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectQtyUnit;
  final handleSelectQtyItemUnit;
  final handlePickAttachments;
  final handleChangeInput;
  final checkForChanges;
  final no;
  final withItemGrade;
  final existingGrades;
  final withQtyAndWeight;
  final initialQty;
  final withMaklon;

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
      this.withQtyAndWeight,
      this.initialQty,
      this.qtyItem,
      this.handleSelectQtyItemUnit,
      this.withMaklon,
      this.maklon,
      this.initialMaklon});

  @override
  State<ListInfoSection> createState() => _ListInfoSectionState();
}

class _ListInfoSectionState extends State<ListInfoSection> {
  late String _initialQty;
  late String _initialWeight;
  late String _initialLength;
  late String _initialWidth;
  late String _initialNotes;
  late bool _isChanged;

  @override
  void initState() {
    _initialQty = widget.initialQty ?? '';
    _initialWeight = widget.initialWeight ?? '';
    _initialLength = widget.initialLength ?? '';
    _initialWidth = widget.initialWidth ?? '';
    _initialNotes = widget.initialNotes ?? '';
    _isChanged = widget.isChanged ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final grades = widget.existingGrades;
    bool _isMaklon = widget.data['maklon'] == 1 ? true : false;

    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFFEBEBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            child: Padding(
              padding: PaddingColumn.screen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ViewText(
                        viewLabel: 'Nomor',
                        viewValue: widget.no ?? '-',
                      ),
                      Text(
                        'Dibuat pada ${data['start_time'] != null ? DateFormat("dd MMMM yyyy HH:mm").format(DateTime.parse(data['start_time'])) : '-'}',
                      ),
                    ].separatedBy(SizedBox(
                      height: 8,
                    )),
                  ),
                  CustomBadge(title: data['status'] ?? '-'),
                ],
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
                        ViewText<Map<String, dynamic>>(
                          viewLabel: 'Work Order',
                          viewValue:
                              data['work_orders']?['wo_no']?.toString() ?? '-',
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
                        ViewText(
                          viewLabel: 'Tanggal',
                          viewValue: data['work_orders']?['wo_date'] != null
                              ? DateFormat("dd MMMM yyyy").format(
                                  DateTime.parse(
                                      data['work_orders']['wo_date']),
                                )
                              : '-',
                        ),
                        ViewText(
                          viewLabel: 'Status',
                          childValue: CustomBadge(
                            title: data['work_orders']?['status']?.toString() ??
                                '-',
                          ),
                        ),
                      ].separatedBy(SizedBox(
                        height: 8,
                      )),
                    ),
                  ),
                ),
              ),
              if (widget.data['status'] == 'Diproses')
                Expanded(
                  flex: 1,
                  child: CustomCard(
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ViewText(
                            viewLabel: 'Panjang',
                            viewValue: data['length'] != null &&
                                    data['length_unit']?['code'] != null
                                ? '${data['length']} ${data['length_unit']['code']}'
                                : '-',
                          ),
                          ViewText(
                            viewLabel: 'Lebar',
                            viewValue: data['width'] != null &&
                                    data['width_unit']?['code'] != null
                                ? '${data['width']} ${data['width_unit']['code']}'
                                : '-',
                          ),
                          ViewText(
                            viewLabel: 'Berat',
                            viewValue: data['weight'] != null &&
                                    data['weight_unit']?['code'] != null
                                ? '${data['weight']} ${data['weight_unit']['code']}'
                                : '-',
                          ),
                        ].separatedBy(SizedBox(
                          height: 8,
                        )),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
                    Switch(
                      value: data['maklon'],
                      onChanged: (value) {
                        setState(() {
                          data['maklon'] = value;
                          widget.form['maklon'] = value;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.redAccent,
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
                      )
                  ].separatedBy(SizedBox(
                    height: 8,
                  )),
                ),
              ),
            ),
          if (widget.withItemGrade == true)
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
                                        '',
                                    viewValue: grades[i]['item_grade']
                                                ['description']
                                            ?.split('-')
                                            .last
                                            .trim() ??
                                        ''),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextForm(
                                  label: 'Jumlah',
                                  req: false,
                                  controller: (i < widget.qty.length)
                                      ? widget.qty[i]
                                      : TextEditingController(
                                          text: grades[i]['qty']?.toString() ??
                                              ''),
                                  handleChange: (value) {
                                    setState(() {
                                      // ensure form has grades entry
                                      if (widget.form['grades'] == null ||
                                          i >= widget.form['grades'].length) {
                                        widget.form['grades'] =
                                            List.from(grades);
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
                                      ? widget.notes[i]
                                      : TextEditingController(
                                          text:
                                              grades[i]['notes']?.toString() ??
                                                  ''),
                                  handleChange: (value) {
                                    setState(() {
                                      // ensure form has grades entry
                                      if (widget.form['grades'] == null ||
                                          i >= widget.form['grades'].length) {
                                        widget.form['grades'] =
                                            List.from(grades);
                                      }
                                      // widget.form['grades'][i]['notes'] =
                                      //     double.tryParse(value) ?? 0;
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
          if (widget.withItemGrade == false)
            CustomCard(
              child: Padding(
                padding: PaddingColumn.screen,
                child: SelectForm(
                  label: 'Mesin',
                  onTap: widget.handleSelectMachine!,
                  selectedLabel: widget.form['nama_mesin'] ?? '',
                  selectedValue: widget.form['machine_id'].toString(),
                  required: false,
                ),
              ),
            ),
          if (widget.withItemGrade == false &&
              widget.data['status'] != 'Diproses')
            CustomCard(
                child: Padding(
              padding: PaddingColumn.screen,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Panjang',
                          req: false,
                          controller: widget.length,
                          handleChange: (value) {
                            setState(() {
                              widget.length.text = value.toString();
                              widget.handleChangeInput('length', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan Panjang',
                            onTap: () => widget.handleSelectLengthUnit(),
                            selectedLabel:
                                widget.form['nama_satuan_panjang'] ?? '',
                            selectedValue:
                                widget.form['length_unit_id']?.toString() ?? '',
                            required: false),
                      ),
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Lebar',
                          req: false,
                          controller: widget.width,
                          handleChange: (value) {
                            setState(() {
                              widget.length.text = value.toString();
                              widget.handleChangeInput('width', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan Lebar',
                            onTap: () => widget.handleSelectWidthUnit(),
                            selectedLabel:
                                widget.form['nama_satuan_lebar'] ?? '',
                            selectedValue:
                                widget.form['width_unit_id']?.toString() ?? '',
                            required: false),
                      ),
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextForm(
                          label: 'Berat',
                          req: false,
                          controller: widget.weight,
                          handleChange: (value) {
                            setState(() {
                              widget.weight.text = value.toString();
                              widget.handleChangeInput('weight', value);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectForm(
                            label: 'Satuan Berat',
                            onTap: () => widget.handleSelectUnit(),
                            selectedLabel:
                                widget.form['nama_satuan_berat'] ?? '',
                            selectedValue:
                                widget.form['weight_unit_id']?.toString() ?? '',
                            required: false),
                      ),
                    ].separatedBy(SizedBox(
                      width: 16,
                    )),
                  ),
                  if (widget.withQtyAndWeight == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextForm(
                            label: 'Jumlah',
                            req: false,
                            controller: widget.qtyItem,
                            handleChange: (value) {
                              setState(() {
                                widget.qtyItem.text = value.toString();
                                widget.handleChangeInput('item_qty', value);
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SelectForm(
                              label: 'Satuan',
                              onTap: () => widget.handleSelectQtyItemUnit(),
                              selectedLabel: widget.form['nama_satuan'] ?? '',
                              selectedValue:
                                  widget.form['item_unit_id']?.toString() ?? '',
                              required: false),
                        ),
                      ].separatedBy(SizedBox(
                        width: 16,
                      )),
                    ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        ViewText(
                          viewLabel: 'Catatan',
                          viewValue: widget.data['notes']?.toString() ?? '-',
                        ),
                      ].separatedBy(SizedBox(
                        height: 16,
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
              child: _buildAttachmentList(context),
            ),
          ),
          // ValueListenableBuilder<bool>(
          //   valueListenable: widget.isSubmitting,
          //   builder: (context, isSubmitting, _) {
          //     return Align(
          //       alignment: Alignment.center,
          //       child: FormButton(
          //         label: 'Simpan',
          //         isLoading: isSubmitting,
          //         onPressed: () async {
          //           if (widget.handleUpdate == null) return;
          //           widget.isSubmitting.value = true;
          //           try {
          //             await widget.handleUpdate!(data['id'].toString())
          //                 .timeout(const Duration(seconds: 10));
          //             setState(() {
          //               _initialWeight = widget.weight?.text ?? '';
          //               _initialLength = widget.length?.text ?? '';
          //               _initialWidth = widget.width?.text ?? '';
          //               _initialNotes = widget.note?.text ?? '';
          //               _isChanged = false;
          //             });
          //           } finally {
          //             widget.isSubmitting.value = false;
          //           }
          //         },
          //       ),
          //     );
          //   },
          // ),
        ].separatedBy(SizedBox(
          height: 16,
        )),
      ),
    ));
  }

  Widget _buildAttachmentList(BuildContext context) {
    final attachments = widget.existingAttachment;

    final baseUrl = dotenv.env['IMAGE_URL_DEV'] ?? '';

    return Wrap(spacing: 8, runSpacing: 8, children: [
      Row(
        children: [
          Text(
            'Lampiran',
            style: TextStyle(fontSize: 16),
          ),
          CustomTheme().hGap('sm'),
        ],
      ),
      if (widget.existingAttachment.isEmpty)
        const NoData()
      else
        ...attachments.map<Widget>((item) {
          final bool isNew = item.containsKey('path');
          final String? filePath = isNew ? item['path'] : item['file_path'];
          final String fileName = isNew
              ? item['name']
              : (item['file_name'] ?? filePath?.split('/').last ?? '');
          final String extension = fileName.split('.').last.toLowerCase();

          Widget preview;
          if (extension == 'pdf') {
            preview =
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 60);
          } else if (isNew && filePath != null) {
            preview = Image.file(File(filePath), fit: BoxFit.cover);
          } else if (filePath != null &&
              ['png', 'jpg', 'jpeg', 'gif'].contains(extension)) {
            preview = Image.network('$baseUrl$filePath',
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) =>
                    const Icon(Icons.broken_image, size: 60));
          } else {
            preview = const Icon(Icons.insert_drive_file, size: 60);
          }

          return Container(
            width: 100,
            height: 100,
            color: Colors.white,
            child: preview,
          );
        }).toList(),
    ]);
  }
}
