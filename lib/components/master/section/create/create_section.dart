// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/create/list_form.dart';

class CreateSection extends StatefulWidget {
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

  const CreateSection(
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
  State<CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<CreateSection> {
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
      handleSubmit: widget.handleSubmit,
      withMaklonOrMachine: widget.withMaklonOrMachine,
      withOnlyMaklon: widget.withOnlyMaklon,
      withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
    );
  }
}
