// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/process/create/greige_list_form.dart';

class GreigeCreateSection extends StatefulWidget {
  final formKey;
  final form;
  final selectGreigeOrder;
  final selectMachine;
  final id;
  final maklonName;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final label;
  final data;
  final handleChangeInput;
  final note;
  final yarnQty;
  final beamQty;
  final section;

  const GreigeCreateSection(
      {super.key,
      this.formKey,
      this.form,
      this.selectGreigeOrder,
      this.selectMachine,
      this.id,
      this.maklonName,
      this.isMaklon,
      this.withMaklonOrMachine,
      this.withOnlyMaklon,
      this.withNoMaklonOrMachine,
      this.label,
      this.data,
      this.handleChangeInput,
      this.note,
      this.yarnQty,
      this.beamQty,
      this.section});

  @override
  State<GreigeCreateSection> createState() => _GreigeCreateSectionState();
}

class _GreigeCreateSectionState extends State<GreigeCreateSection> {
  @override
  Widget build(BuildContext context) {
    return GreigeListForm(
      formKey: widget.formKey,
      isMaklon: widget.isMaklon,
      id: widget.id,
      form: widget.form,
      maklonName: widget.maklonName,
      selectGreigeOrder: widget.selectGreigeOrder,
      selectMachine: widget.selectMachine,
      withMaklonOrMachine: widget.withMaklonOrMachine,
      withOnlyMaklon: widget.withOnlyMaklon,
      withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
      label: widget.label,
      data: widget.data,
      handleChangeInput: widget.handleChangeInput,
      note: widget.note,
      yarnQty: widget.yarnQty,
      beamQty: widget.beamQty,
      section: widget.section,
    );
  }
}
