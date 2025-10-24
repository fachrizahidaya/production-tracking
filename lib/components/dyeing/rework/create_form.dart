import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/list_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final note;
  final qty;
  final width;
  final length;
  final handleSelectWo;
  final handleSelectUnit;
  final handleChangeInput;
  final handleSubmit;
  final id;
  final data;
  final dyeingId;
  final dyeingData;
  final selectMachine;
  final isLoading;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.note,
      this.qty,
      this.length,
      this.width,
      this.handleSelectWo,
      this.handleSelectUnit,
      this.handleChangeInput,
      this.handleSubmit,
      this.id,
      this.data,
      this.dyeingData,
      this.dyeingId,
      this.selectMachine,
      this.isLoading});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _isChanged = false;
  late String _initialQty;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;

  @override
  void initState() {
    super.initState();
    _initialQty = widget.data['qty']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';

    widget.qty.text = _initialQty;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;
  }

  @override
  void didUpdateWidget(covariant CreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dyeingData != oldWidget.dyeingData &&
        widget.dyeingData.isNotEmpty) {
      setState(() {
        _initialQty = widget.dyeingData['qty']?.toString() ?? '';
        _initialLength = widget.dyeingData['length']?.toString() ?? '';
        _initialWidth = widget.dyeingData['width']?.toString() ?? '';
        _initialNotes = widget.dyeingData['notes']?.toString() ?? '';

        widget.qty.text = _initialQty;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

        _isChanged = false;
      });
    }
  }

  bool get _isFormIncomplete {
    final woId = widget.form?['wo_id'];
    final machineId = widget.form?['machine_id'];
    final qty = widget.form?['qty'];
    final width = widget.form?['width'];
    final length = widget.form?['length'];
    final unitId = widget.form?['unit_id'];

    return woId == null ||
        machineId == null ||
        qty == null ||
        width == null ||
        length == null ||
        unitId == null;
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
        color: const Color(0xFFEBEBEB),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.dyeingData != null &&
        widget.note.text !=
            'Rework dari Dyeing ${widget.dyeingData['dyeing_no']}') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.note.text =
              'Rework dari Dyeing ${widget.dyeingData['dyeing_no']}';
          widget.handleChangeInput('notes', widget.note.text);
        });
      });
    }

    return Container(
        padding: MarginSearch.screen,
        child: CustomCard(
          child: ListForm(
            formKey: widget.formKey,
            form: widget.form,
            data: widget.data,
            id: widget.id,
            dyeingId: widget.dyeingId,
            length: widget.length,
            width: widget.width,
            qty: widget.qty,
            note: widget.note,
            handleSelectWo: widget.handleSelectWo,
            handleChangeInput: widget.handleChangeInput,
            handleSelectUnit: widget.handleSelectUnit,
            handleSelectMachine: widget.selectMachine,
            isSubmitting: _isSubmitting,
            handleSubmit: widget.handleSubmit,
            isFormIncomplete: _isFormIncomplete,
            isChanged: _isChanged,
            initialQty: _initialQty,
            initialLength: _initialLength,
            initialWidth: _initialWidth,
            initialNotes: _initialNotes,
            allAttachments: allAttachments,
            handlePickAttachments: _pickAttachments,
          ),
        ));
  }
}
