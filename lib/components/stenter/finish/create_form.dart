import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/components/stenter/finish/list_form.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';

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
  final handleSubmit;
  final id;
  final data;
  final stenterId;
  final stenterData;
  final isLoading;

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
      this.handleSubmit,
      this.id,
      this.data,
      this.stenterData,
      this.stenterId,
      this.isLoading});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _isChanged = false;
  late String _initialWeight;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(covariant CreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stenterData != oldWidget.stenterData &&
        widget.stenterData.isNotEmpty) {
      setState(() {
        _initialWeight = widget.stenterData['weight']?.toString() ?? '';
        _initialLength = widget.stenterData['length']?.toString() ?? '';
        _initialWidth = widget.stenterData['width']?.toString() ?? '';
        _initialNotes = widget.stenterData['notes']?.toString() ?? '';

        widget.weight.text = _initialWeight;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

        _isChanged = false;
      });
    }
  }

  void _checkForChanges() {
    setState(() {
      _isChanged = widget.weight.text != _initialWeight ||
          widget.length.text != _initialLength ||
          widget.note.text != _initialNotes ||
          widget.width.text != _initialWidth;
    });
  }

  bool get _isFormIncomplete {
    final weight = widget.form?['weight'];
    final width = widget.form?['width'];
    final length = widget.form?['length'];
    final unitId = widget.form?['weight_unit_id'];
    final lengthUnitId = widget.form?['length_unit_id'];
    final widthUnitId = widget.form?['width_unit_id'];

    return weight == null ||
        width == null ||
        length == null ||
        unitId == null ||
        lengthUnitId == null ||
        widthUnitId == null;
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
          final currentFormAttachments =
              List<Map<String, dynamic>>.from(widget.form['attachments'] ?? []);

          final newFiles = result.files.map((file) {
            return {
              'name': file.name,
              'path': file.path,
              'extension': file.extension,
            };
          }).toList();

          widget.form['attachments'] = [
            ...currentFormAttachments,
            ...newFiles,
          ];
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final existing = (widget.data?['attachments'] ?? []) as List<dynamic>;
    final newOnes = (widget.form['attachments'] ?? []) as List<dynamic>;
    final allAttachments = [
      ...existing.cast<Map<String, dynamic>>(),
      ...newOnes.cast<Map<String, dynamic>>(),
      {'is_add_button': true},
    ];

    if (widget.isLoading) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
        padding: MarginSearch.screen,
        child: CustomCard(
          child: ListForm(
            formKey: widget.formKey,
            form: widget.form,
            data: widget.data,
            id: widget.id,
            stenterId: widget.stenterId,
            length: widget.length,
            width: widget.width,
            weight: widget.weight,
            note: widget.note,
            handleSelectWo: widget.handleSelectWo,
            handleChangeInput: widget.handleChangeInput,
            handleSelectUnit: widget.handleSelectUnit,
            isSubmitting: _isSubmitting,
            handleSubmit: widget.handleSubmit,
            isFormIncomplete: _isFormIncomplete,
            isChanged: _isChanged,
            initialWeight: _initialWeight,
            initialLength: _initialLength,
            initialWidth: _initialWidth,
            initialNotes: _initialNotes,
            allAttachments: allAttachments,
            handlePickAttachments: _pickAttachments,
            stenterData: widget.stenterData,
            handleSelectLengthUnit: widget.handleSelectLengthUnit,
            handleSelectWidthUnit: widget.handleSelectWidthUnit,
          ),
        ));
  }
}
