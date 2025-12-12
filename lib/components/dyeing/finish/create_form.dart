// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_tracking/components/dyeing/finish/list_form.dart';

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
  final isLoading;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;

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
      this.isLoading,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit});

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
  late List<Map<String, dynamic>> allAttachments;

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
    final width = widget.form?['width'];
    final length = widget.form?['length'];
    final unitId = widget.form?['unit_id'];

    return qty == null || width == null || length == null || unitId == null;
  }

  Future<void> _pickAttachments() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          final currentFormAttachments =
              List<Map<String, dynamic>>.from(widget.form['attachments'] ?? []);

          final newFile = {
            'name': image.name,
            'path': image.path,
            'extension': image.path.split('.').last,
            'isFromCamera': true,
          };

          widget.form['attachments'] = [
            ...currentFormAttachments,
            newFile,
          ];
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
      dyeingId: widget.dyeingId,
      length: widget.length,
      width: widget.width,
      qty: widget.qty,
      note: widget.note,
      handleSelectWo: widget.handleSelectWo,
      handleChangeInput: widget.handleChangeInput,
      handleSelectUnit: widget.handleSelectUnit,
      handleSelectLengthUnit: widget.handleSelectLengthUnit,
      handleSelectWidthUnit: widget.handleSelectWidthUnit,
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
      dyeingData: widget.dyeingData,
      showImageDialog: showImageDialog,
      handleDeleteAttachment: _handleDeleteAttachment,
    );
  }
}
