import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/create/list_form.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final handleSubmit;
  final data;
  final selectWorkOrder;
  final selectMachine;
  final id;
  final isLoading;

  const CreateForm(
      {super.key,
      this.formKey,
      this.form,
      this.handleSubmit,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.id,
      this.isLoading});

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool get _isFormIncomplete {
    final woId = widget.form?['wo_id'];
    final machineId = widget.form?['machine_id'];

    return woId == null || machineId == null;
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
        id: widget.id,
        form: widget.form,
        data: widget.data,
        attachments: attachments,
        selectWorkOrder: widget.selectWorkOrder,
        selectMachine: widget.selectMachine,
        isSubmitting: _isSubmitting,
        isFormIncomplete: _isFormIncomplete,
        handleSubmit: widget.handleSubmit,
        handlePickAttachments: _pickAttachments,
      )),
    );
  }
}
