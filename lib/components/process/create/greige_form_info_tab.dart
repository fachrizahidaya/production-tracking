import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/greige_create_section.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeFormInfoTab extends StatefulWidget {
  final id;
  final data;
  final processData;
  final label;
  final form;
  final formKey;
  final handleSelectMachine;
  final handleSelectGreigeOrder;
  final isLoading;
  final maklonName;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final handleChangeInput;
  final note;
  final yarnQty;

  const GreigeFormInfoTab(
      {super.key,
      this.data,
      this.processData,
      this.form,
      this.label,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectGreigeOrder,
      this.id,
      this.isLoading,
      this.isMaklon,
      this.maklonName,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon,
      this.handleChangeInput,
      this.note,
      this.yarnQty});

  @override
  State<GreigeFormInfoTab> createState() => _GreigeFormInfoTabState();
}

class _GreigeFormInfoTabState extends State<GreigeFormInfoTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: CustomTheme().padding('content'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreigeCreateSection(
                formKey: widget.formKey,
                form: widget.form,
                maklonName: widget.maklonName,
                isMaklon: widget.isMaklon,
                selectGreigeOrder: widget.handleSelectGreigeOrder,
                selectMachine: widget.handleSelectMachine,
                id: widget.id,
                withMaklonOrMachine: widget.withMaklonOrMachine,
                withOnlyMaklon: widget.withOnlyMaklon,
                withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
                label: widget.label,
                data: widget.processData,
                handleChangeInput: widget.handleChangeInput,
                note: widget.note,
                yarnQty: widget.yarnQty,
              ),
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
        );
      },
    );
  }
}
