import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_tracking/components/master/section/finish/list_form.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final note;
  final weight;
  final width;
  final length;
  final handleSelectWo;
  final handleSelectUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleChangeInput;
  final id;
  final data;
  final processId;
  final processData;
  final isLoading;
  final withItemGrade;
  final itemGradeOption;
  final handleSelectQtyUnit;
  final qty;
  final notes;
  final withQtyAndWeight;
  final handleSelectQtyUnitItem;
  final handleSelectQtyUnitDyeing;

  final qtyItem;
  final label;
  final forDyeing;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.note,
      this.weight,
      this.length,
      this.width,
      this.handleSelectWo,
      this.handleSelectUnit,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.handleChangeInput,
      this.id,
      this.data,
      this.processData,
      this.processId,
      this.isLoading,
      this.withItemGrade,
      this.itemGradeOption,
      this.handleSelectQtyUnit,
      this.qty,
      this.notes,
      this.withQtyAndWeight,
      this.handleSelectQtyUnitItem,
      this.qtyItem,
      this.label,
      this.forDyeing,
      this.handleSelectQtyUnitDyeing});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  bool _isChanged = false;
  late String _initialWeight;
  late String _initialQty;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;
  late List<Map<String, dynamic>> allAttachments;

  @override
  void initState() {
    super.initState();
    _initialQty = widget.data['qty']?.toString() ?? '';
    _initialWeight = widget.data['weight']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';

    widget.qty.text = _initialQty;
    widget.weight.text = _initialWeight;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;

    final existing =
        (widget.data?['attachments'] ?? []).cast<Map<String, dynamic>>();
    final newOnes =
        (widget.form['attachments'] ?? []).cast<Map<String, dynamic>>();

    allAttachments = [
      ...existing,
      ...newOnes,
      {'is_add_button': true},
    ];
  }

  @override
  void didUpdateWidget(covariant CreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.processData != oldWidget.processData &&
        widget.processData.isNotEmpty) {
      setState(() {
        _initialQty = widget.processData['qty']?.toString() ?? '';
        _initialWeight = widget.processData['weight']?.toString() ?? '';
        _initialLength = widget.processData['length']?.toString() ?? '';
        _initialWidth = widget.processData['width']?.toString() ?? '';
        _initialNotes = widget.processData['notes']?.toString() ?? '';

        widget.qty.text = _initialWeight;
        widget.weight.text = _initialWeight;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

        final existing =
            (widget.data?['attachments'] ?? []).cast<Map<String, dynamic>>();
        final newOnes =
            (widget.form['attachments'] ?? []).cast<Map<String, dynamic>>();

        allAttachments = [
          ...existing,
          ...newOnes,
          {'is_add_button': true},
        ];

        _isChanged = false;
      });
    }
  }

  bool get _isFormIncomplete {
    final qty = widget.form?['qty'];
    final qtyItem = widget.form?['item_qty'];
    final weight = widget.form?['weight'];
    final width = widget.form?['width'];
    final length = widget.form?['length'];
    final qtyItemUnitId = widget.form?['item_unit_id'];
    final qtyUnitId = widget.form?['unit_id'];
    final unitId = widget.form?['weight_unit_id'];
    final lengthUnitId = widget.form?['length_unit_id'];
    final widthUnitId = widget.form?['width_unit_id'];

    return qty == null ||
        qtyItem == null ||
        weight == null ||
        width == null ||
        length == null ||
        unitId == null ||
        qtyItemUnitId == null ||
        lengthUnitId == null ||
        qtyUnitId == null ||
        widthUnitId == null;
  }

  Future<void> _pickAttachments() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          allAttachments.removeWhere((e) => e['is_add_button'] == true);

          final newFile = {
            'name': image.name,
            'path': image.path,
            'extension': image.path.split('.').last,
            'isNew': true,
          };

          allAttachments.add(newFile);

          allAttachments.add({'is_add_button': true});

          widget.form['attachments'] =
              allAttachments.where((e) => e['is_add_button'] != true).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error capturing image: $e")),
        );
      }
    }
  }

  void showImageDialog(BuildContext context, bool isNew, String filePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(10),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: isNew
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _handleDeleteAttachment(Map item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Lampiran'),
        content: const Text('Apakah Anda yakin ingin menghapus lampiran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        allAttachments.remove(item);

        widget.form['attachments'] =
            allAttachments.where((e) => e['is_add_button'] != true).toList();
      });

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListForm(
      formKey: widget.formKey,
      form: widget.form,
      data: widget.data,
      id: widget.id,
      processId: widget.processId,
      length: widget.length,
      width: widget.width,
      weight: widget.weight,
      note: widget.note,
      handleSelectWo: widget.handleSelectWo,
      handleChangeInput: widget.handleChangeInput,
      handleSelectUnit: widget.handleSelectUnit,
      isFormIncomplete: _isFormIncomplete,
      isChanged: _isChanged,
      initialWeight: _initialWeight,
      initialLength: _initialLength,
      initialWidth: _initialWidth,
      initialNotes: _initialNotes,
      allAttachments: allAttachments,
      handlePickAttachments: _pickAttachments,
      processData: widget.processData,
      handleSelectLengthUnit: widget.handleSelectLengthUnit,
      handleSelectWidthUnit: widget.handleSelectWidthUnit,
      handleSelectQtyUnitItem: widget.handleSelectQtyUnitItem,
      handleSelectQtyUnitDyeing: widget.handleSelectQtyUnitDyeing,
      withItemGrade: widget.withItemGrade,
      itemGradeOption: widget.itemGradeOption ?? [],
      handleSelectQtyUnit: widget.handleSelectQtyUnit,
      notes: widget.notes,
      qty: widget.qty,
      withQtyAndWeight: widget.withQtyAndWeight,
      qtyItem: widget.qtyItem,
      showImageDialog: showImageDialog,
      handleDeleteAttachment: _handleDeleteAttachment,
      label: widget.label,
      forDyeing: widget.forDyeing,
    );
  }
}
