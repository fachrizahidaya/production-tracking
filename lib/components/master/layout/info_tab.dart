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
      this.no});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  bool _isChanged = false;
  late String _initialWeight;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;
  late Map<String, String> _initialValues;

  @override
  void initState() {
    super.initState();
    _setInitialValues();
    _initialWeight = widget.data['weight']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';

    widget.weight.text = _initialWeight;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;
  }

  @override
  void didUpdateWidget(covariant InfoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data && widget.data.isNotEmpty) {
      _setInitialValues();
      setState(() {
        _initialWeight = widget.data['weight']?.toString() ?? '';
        _initialLength = widget.data['length']?.toString() ?? '';
        _initialWidth = widget.data['width']?.toString() ?? '';
        _initialNotes = widget.data['notes']?.toString() ?? '';

        widget.weight.text = _initialWeight;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

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
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.data.isEmpty) {
      return const Center(child: NoData());
    }

    final existingAttachments =
        (widget.data['attachments'] ?? []) as List<dynamic>;

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
    );
  }
}
