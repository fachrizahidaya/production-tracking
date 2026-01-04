// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/list_form.dart';

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

  @override
  Widget build(BuildContext context) {
    final attachments = (widget.form['attachments'] as List?) ?? [];

    return ListForm(
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
      handlePickAttachments: null,
    );
  }
}
