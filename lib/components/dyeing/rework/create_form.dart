// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/dyeing/rework/list_form.dart';

class CreateForm extends StatefulWidget {
  final formKey;
  final form;
  final selectWorkOrder;
  final selectMachine;
  final id;

  const CreateForm({
    super.key,
    this.formKey,
    this.form,
    this.selectWorkOrder,
    this.selectMachine,
    this.id,
  });

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  @override
  Widget build(BuildContext context) {
    return ListForm(
      formKey: widget.formKey,
      id: widget.id,
      form: widget.form,
      selectWorkOrder: widget.selectWorkOrder,
      selectMachine: widget.selectMachine,
    );
  }
}
