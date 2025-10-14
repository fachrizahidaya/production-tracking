import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/detail/list_info.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';

class InfoTab extends StatefulWidget {
  final data;
  final isLoading;
  final qty;
  final length;
  final width;
  final note;
  final form;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectMachine;
  final handleUpdate;
  final refetch;
  final hasMore;

  const InfoTab(
      {super.key,
      this.data,
      this.isLoading,
      this.qty,
      this.length,
      this.width,
      this.note,
      this.form,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleUpdate,
      this.refetch,
      this.hasMore,
      this.handleSelectMachine});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
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
  void didUpdateWidget(covariant InfoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data && widget.data.isNotEmpty) {
      setState(() {
        _initialQty = widget.data['qty']?.toString() ?? '';
        _initialLength = widget.data['length']?.toString() ?? '';
        _initialWidth = widget.data['width']?.toString() ?? '';
        _initialNotes = widget.data['notes']?.toString() ?? '';

        widget.qty.text = _initialQty;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

        _isChanged = false;
      });
    }
  }

  void _checkForChanges() {
    setState(() {
      _isChanged = widget.qty.text != _initialQty ||
          widget.length.text != _initialLength ||
          widget.note.text != _initialNotes ||
          widget.width.text != _initialWidth;
    });
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

    if (widget.data.isEmpty) {
      return Container(
        color: const Color(0xFFEBEBEB),
        alignment: Alignment.center,
        child: const NoData(),
      );
    }

    return ListInfo(
      data: widget.data,
      form: widget.form,
      isSubmitting: _isSubmitting,
      existingAttachment: existing,
      handleUpdate: widget.handleUpdate,
      initialQty: _initialQty,
      initialLength: _initialLength,
      initialWidth: _initialWidth,
      initialNotes: _initialNotes,
      isChanged: _isChanged,
      length: widget.length,
      width: widget.width,
      qty: widget.qty,
      note: widget.note,
      handleSelectMachine: widget.handleSelectMachine,
    );
  }
}
