import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:textile_tracking/components/master/layout/list_info_section.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';

class InfoTab extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isLoading;
  final Map<String, dynamic> form;
  final ValueNotifier<bool>? isSubmitting;
  final Function(String field, dynamic value)? handleChangeInput;
  final VoidCallback? handleSelectUnit;
  final VoidCallback? handleSelectLengthUnit;
  final VoidCallback? handleSelectWidthUnit;
  final VoidCallback? handleSelectMachine;
  final Future<void> Function(String id)? handleUpdate;
  final Future<void> Function()? refetch;
  final bool? hasMore;

  /// Dynamic fields: define text controllers for any fields you want to display
  final Map<String, TextEditingController> fieldControllers;

  /// Define which fields appear and their labels
  final List<Map<String, String>> fieldConfigs;
  final weight;
  final length;
  final width;
  final note;
  final no;
  final withItemGrade;
  final qty;
  final notes;
  final handleSelectQtyUnit;
  final withQtyAndWeight;
  final qtyItem;
  final handleSelectQtyItemUnit;
  final withMaklon;
  final maklon;
  final onlySewing;

  const InfoTab(
      {super.key,
      required this.data,
      required this.isLoading,
      required this.form,
      required this.fieldControllers,
      required this.fieldConfigs,
      this.isSubmitting,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleSelectMachine,
      this.handleUpdate,
      this.refetch,
      this.hasMore,
      this.length,
      this.note,
      this.weight,
      this.width,
      this.no,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.withItemGrade,
      this.handleSelectQtyUnit,
      this.qty,
      this.notes,
      this.withQtyAndWeight,
      this.qtyItem,
      this.handleSelectQtyItemUnit,
      this.withMaklon,
      this.maklon,
      this.onlySewing});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  bool _isChanged = false;
  late String _initialQty;
  late String _initialWeight;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;
  late String _initialMaklonName;
  late Map<String, String> _initialValues;

  @override
  void initState() {
    super.initState();
    _setInitialValues();
    _initialQty = widget.data['item_qty']?.toString() ?? '';
    _initialWeight = widget.data['weight']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';
    _initialMaklonName = widget.data['maklon_name']?.toString() ?? '';

    widget.qtyItem.text = _initialQty;
    widget.weight.text = _initialWeight;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;
    widget.maklon.text = _initialMaklonName;
  }

  @override
  void didUpdateWidget(covariant InfoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    final grades = widget.form['grades'] ?? [];
    final minLen =
        widget.qty.length < grades.length ? widget.qty.length : grades.length;
    for (int i = 0; i < minLen; i++) {
      final newText = grades[i]['qty']?.toString() ?? '';
      if (widget.qty[i].text != newText) {
        widget.qty[i].text = newText;
      }
    }

    final minLenNotes = widget.notes.length < grades.length
        ? widget.notes.length
        : grades.length;
    for (int i = 0; i < minLenNotes; i++) {
      final newText = grades[i]['notes']?.toString() ?? '';
      if (widget.notes[i].text != newText) {
        widget.notes[i].text = newText;
      }
    }

    if (widget.data != oldWidget.data && widget.data.isNotEmpty) {
      _setInitialValues();
      setState(() {
        _initialQty = widget.data['item_qty']?.toString() ?? '';
        _initialWeight = widget.data['weight']?.toString() ?? '';
        _initialLength = widget.data['length']?.toString() ?? '';
        _initialWidth = widget.data['width']?.toString() ?? '';
        _initialNotes = widget.data['notes']?.toString() ?? '';
        _initialMaklonName = widget.data['maklon_name']?.toString() ?? '';

        widget.qtyItem.text = _initialQty;
        widget.weight.text = _initialWeight;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;
        widget.maklon.text = _initialMaklonName;

        _isChanged = false;
      });
    }
  }

  void _setInitialValues() {
    _initialValues = {};
    for (var field in widget.fieldConfigs) {
      final name = field['name']!;
      final value = widget.data[name]?.toString() ?? '';
      _initialValues[name] = value;
      widget.fieldControllers[name]?.text = value;
    }
  }

  void _checkForChanges() {
    bool changed = false;
    for (var field in widget.fieldConfigs) {
      final name = field['name']!;
      if (widget.fieldControllers[name]?.text != _initialValues[name]) {
        changed = true;
        break;
      }
    }
    setState(() => _isChanged = changed);
  }

  Future<void> _pickAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          final currentAttachments =
              List<Map<String, dynamic>>.from(widget.form['attachments'] ?? []);
          final newFiles = result.files.map((file) {
            return {
              'name': file.name,
              'path': file.path,
              'extension': file.extension,
            };
          }).toList();

          widget.form['attachments'] = [...currentAttachments, ...newFiles];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingAttachments =
        (widget.data['attachments'] ?? []) as List<dynamic>;

    final existingGrades = (widget.data['grades'] ?? []) as List<dynamic>;

    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.data.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const NoData(),
      );
    }

    return ListInfoSection(
      data: widget.data,
      form: widget.form,
      isSubmitting: widget.isSubmitting ?? ValueNotifier(false),
      handleUpdate: widget.handleUpdate,
      isChanged: _isChanged,
      existingAttachment: existingAttachments,
      fieldConfigs: widget.fieldConfigs,
      fieldControllers: widget.fieldControllers,
      handleSelectMachine: widget.handleSelectMachine,
      handleSelectUnit: widget.handleSelectUnit,
      handleSelectLengthUnit: widget.handleSelectLengthUnit,
      handleSelectWidthUnit: widget.handleSelectWidthUnit,
      handlePickAttachments: _pickAttachments,
      handleChangeInput: widget.handleChangeInput,
      checkForChanges: _checkForChanges,
      no: widget.no,
      length: widget.length,
      width: widget.width,
      weight: widget.weight,
      note: widget.note,
      initialLength: _initialLength,
      initialNotes: _initialNotes,
      initialWeight: _initialWeight,
      initialWidth: _initialWidth,
      initialMaklon: _initialMaklonName,
      withItemGrade: widget.withItemGrade,
      qty: widget.qty,
      qtyItem: widget.qtyItem,
      initialQty: _initialQty,
      handleSelectQtyUnit: widget.handleSelectQtyUnit,
      existingGrades: existingGrades,
      notes: widget.notes,
      withQtyAndWeight: widget.withQtyAndWeight,
      handleSelectQtyItemUnit: widget.handleSelectQtyItemUnit,
      withMaklon: widget.withMaklon,
      maklon: widget.maklon,
      onlySewing: widget.onlySewing,
    );
  }
}
