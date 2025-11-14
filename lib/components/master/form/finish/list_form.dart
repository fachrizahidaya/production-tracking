import 'dart:io';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/multiline_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final form;
  final data;
  final id;
  final processId;
  final length;
  final width;
  final weight;
  final note;
  final qty;
  final qtyItem;
  final notes;
  final handleSelectWo;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectQtyUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectQtyUnitItem;
  final handleSelectMachine;
  final isSubmitting;
  final handleSubmit;
  final isFormIncomplete;
  final isChanged;
  final initialQty;
  final initialWeight;
  final initialLength;
  final initialWidth;
  final initialNotes;
  final allAttachments;
  final handlePickAttachments;
  final processData;
  final withItemGrade;
  final itemGradeOption;
  final withQtyAndWeight;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.handleSelectWo,
      this.form,
      this.data,
      this.length,
      this.width,
      this.weight,
      this.note,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.isSubmitting,
      this.handleSelectMachine,
      this.handleSubmit,
      this.isFormIncomplete,
      this.processId,
      this.isChanged,
      this.initialWeight,
      this.initialLength,
      this.initialWidth,
      this.initialNotes,
      this.allAttachments,
      this.handlePickAttachments,
      this.processData,
      this.withItemGrade = false,
      this.itemGradeOption,
      this.handleSelectQtyUnit,
      this.notes,
      this.qty,
      this.withQtyAndWeight = false,
      this.handleSelectQtyUnitItem,
      this.initialQty,
      this.qtyItem});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  late String _initialQty;
  late String _initialWeight;
  late String _initialLength;
  late String _initialWidth;
  late String _initialNotes;
  late bool _isChanged;

  late List<Map<String, dynamic>> _grades;

  @override
  void initState() {
    _initialQty = widget.initialQty ?? '';
    _initialWeight = widget.initialWeight ?? '';
    _initialLength = widget.initialLength ?? '';
    _initialWidth = widget.initialWidth ?? '';
    _initialNotes = widget.initialNotes ?? '';
    _isChanged = widget.isChanged ?? false;
    _grades = (widget.form['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _syncGradesWithOptions();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemGradeOption != widget.itemGradeOption) {
      _syncGradesWithOptions();
    }
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (var grade in widget.itemGradeOption ?? []) {
      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['value'].toString(),
        orElse: () => {},
      );

      updated.add({
        'item_grade_id': grade['value'],
        'unit_id': existing['unit_id'] ?? '',
        'notes': existing['notes'] ?? '',
        'qty': existing['qty'] ?? '',
      });
    }

    // ✅ Schedule state update safely after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _grades = updated;
        });
        widget.handleChangeInput('grades', _grades);
      }
    });
  }

  void _updateGrade(int index, String key, dynamic value) {
    setState(() {
      _grades[index][key] = value;
    });

    widget.handleChangeInput('grades', _grades);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.id == null)
            CustomCard(
                child: Padding(
              padding: PaddingColumn.screen,
              child: SelectForm(
                  label: 'Work Order',
                  onTap: () => widget.handleSelectWo(),
                  selectedLabel: widget.form['no_wo'] ?? '',
                  selectedValue: widget.form['wo_id']?.toString() ?? '',
                  required: false),
            )),
          if (widget.form?['wo_id'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.withItemGrade == true)
                  CustomCard(
                      child: Padding(
                    padding: PaddingColumn.screen,
                    child: Column(
                      children: [
                        if ((widget.itemGradeOption ?? []).isNotEmpty &&
                            _grades.isNotEmpty &&
                            _grades.length >= widget.itemGradeOption.length)
                          for (int i = 0;
                              i < widget.itemGradeOption.length;
                              i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ViewText(
                                    viewLabel: 'Grade',
                                    viewValue:
                                        (widget.itemGradeOption.firstWhere(
                                              (e) =>
                                                  e['value'].toString() ==
                                                  _grades[i]['item_grade_id']
                                                      .toString(),
                                              orElse: () => {'label': ''},
                                            )['label']) ??
                                            '',
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextForm(
                                    label: 'Jumlah',
                                    req: false,
                                    isNumber: true,
                                    handleChange: (val) =>
                                        _updateGrade(i, 'qty', val),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SelectForm(
                                    label: 'Satuan',
                                    onTap: () => widget.handleSelectQtyUnit(i),
                                    selectedLabel: widget.form['grades']?[i]
                                            ?['unit']?['name'] ??
                                        '',
                                    selectedValue: widget.form['grades']?[i]
                                                ?['unit_id']
                                            ?.toString() ??
                                        '',
                                    required: false,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextForm(
                                    label: 'Catatan',
                                    req: false,
                                    handleChange: (val) =>
                                        _updateGrade(i, 'notes', val),
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
                  )),
                if (widget.withItemGrade == false)
                  CustomCard(
                      child: Padding(
                    padding: PaddingColumn.screen,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextForm(
                                label: 'Panjang',
                                req: false,
                                isNumber: true,
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
                                  selectedValue: widget.form['length_unit_id']
                                          ?.toString() ??
                                      '',
                                  required: false),
                            ),
                          ].separatedBy(SizedBox(
                            width: 16,
                          )),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextForm(
                                label: 'Lebar',
                                req: false,
                                isNumber: true,
                                controller: widget.width,
                                handleChange: (value) {
                                  setState(() {
                                    widget.width.text = value.toString();
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
                                  selectedValue: widget.form['width_unit_id']
                                          ?.toString() ??
                                      '',
                                  required: false),
                            ),
                          ].separatedBy(SizedBox(
                            width: 16,
                          )),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextForm(
                                label: 'Berat',
                                req: false,
                                isNumber: true,
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
                                  selectedValue: widget.form['weight_unit_id']
                                          ?.toString() ??
                                      '',
                                  required: false),
                            )
                          ].separatedBy(SizedBox(
                            width: 16,
                          )),
                        ),
                        if (widget.withQtyAndWeight == true)
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextForm(
                                  label: 'Jumlah',
                                  req: false,
                                  isNumber: true,
                                  controller: widget.qty,
                                  handleChange: (value) {
                                    setState(() {
                                      widget.qty.text = value.toString();
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
                                    onTap: () =>
                                        widget.handleSelectQtyUnitItem(),
                                    selectedLabel:
                                        widget.form['nama_satuan'] ?? '',
                                    selectedValue:
                                        widget.form['unit_id']?.toString() ??
                                            '',
                                    required: false),
                              )
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
                      ...List.generate(widget.allAttachments.length, (index) {
                        final item = widget.allAttachments[index];

                        if (item['is_add_button'] == true) {
                          return GestureDetector(
                            onTap: widget.handlePickAttachments,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade300,
                              ),
                              child: const Icon(Icons.add,
                                  size: 36, color: Colors.black54),
                            ),
                          );
                        }

                        final bool isNew =
                            item.containsKey('path'); // new local file
                        final String? filePath =
                            isNew ? item['path'] : item['file_path'];
                        final String fileName = isNew
                            ? item['name']
                            : (item['file_name'] ??
                                filePath?.split('/').last ??
                                '');
                        final String extension =
                            fileName.split('.').last.toLowerCase();

                        Widget previewWidget;
                        if (extension == 'pdf') {
                          previewWidget = const Icon(Icons.picture_as_pdf,
                              color: Colors.red, size: 60);
                        } else if (isNew && filePath != null) {
                          previewWidget =
                              Image.file(File(filePath), fit: BoxFit.cover);
                        } else if (filePath != null) {
                          previewWidget =
                              Image.network(filePath, fit: BoxFit.cover);
                        } else {
                          previewWidget = const Icon(Icons.insert_drive_file);
                        }

                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: previewWidget,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Hapus Lampiran'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus lampiran ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: const Text('Hapus',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    setState(() {
                                      if (isNew) {
                                        // Locally captured or picked image
                                        (widget.form['attachments'] as List)
                                            .remove(item);
                                      } else {
                                        // Existing from API (optional server delete)
                                        (widget.data!['attachments'] as List)
                                            .remove(item);
                                      }
                                    });

                                    // OPTIONAL: If you want to delete from server
                                    if (!isNew && item['id'] != null) {
                                      try {
                                        // Example call (depends on your backend)
                                        // await YourApiService.deleteAttachment(item['id']);
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Gagal menghapus dari server: $e")),
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                )),
                CustomCard(
                    child: Padding(
                  padding: PaddingColumn.screen,
                  child: MultilineForm(
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
                )),
              ],
            ),
        ],
      ),
    );
  }
}
