// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/create/list_form.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final handleSubmit;
  final data;
  final selectWorkOrder;
  final selectMachine;
  final id;
  final isLoading;
  final maklon;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.handleSubmit,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.id,
      this.isLoading,
      this.maklon,
      this.isMaklon,
      this.withMaklonOrMachine,
      this.withOnlyMaklon,
      this.withNoMaklonOrMachine});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool get _isFormIncomplete {
    final woId = widget.form?['wo_id'];
    final machineId = widget.form?['machine_id'];
    final maklon = widget.form?['maklon_name'];

    if (widget.isMaklon == true) {
      return woId == null || machineId == null;
    } else {
      return woId == null || maklon == null;
    }
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
          final existing = (widget.form['attachments'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          for (final file in result.files) {
            existing.add({
              'name': file.name,
              'path': file.path,
              'extension': file.extension,
            });
          }
          widget.form['attachments'] = existing;
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
    final attachments = (widget.form['attachments'] as List?) ?? [];

    if (widget.isLoading) {
      return Container(
        color: const Color(0xFFEBEBEB),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ListForm(
      formKey: widget.formKey,
      isMaklon: widget.isMaklon,
      id: widget.id,
      form: widget.form,
      data: widget.data,
      attachments: attachments,
      maklon: widget.maklon,
      selectWorkOrder: widget.selectWorkOrder,
      selectMachine: widget.selectMachine,
      isSubmitting: _isSubmitting,
      isFormIncomplete: _isFormIncomplete,
      handleSubmit: widget.handleSubmit,
      handlePickAttachments: _pickAttachments,
      withMaklonOrMachine: widget.withMaklonOrMachine,
      withOnlyMaklon: widget.withOnlyMaklon,
      withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
    );
  }
}
