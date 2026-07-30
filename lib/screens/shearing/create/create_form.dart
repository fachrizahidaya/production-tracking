import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/shearing/create/create_shearing_process_manual.dart';

class CreateForm extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final processId;

  const CreateForm(
      {super.key,
      this.id,
      this.data,
      this.form,
      this.handleSubmit,
      this.processId});

  @override
  Widget build(BuildContext context) {
    return CreateShearingProcessManual(
      id: id,
      data: data,
      processId: processId,
      form: form,
      handleSubmit: handleSubmit,
    );
  }
}
