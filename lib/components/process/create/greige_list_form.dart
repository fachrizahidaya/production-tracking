// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/process/warping.dart';
import 'package:textile_tracking/components/process/create/process/weaving.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeListForm extends StatefulWidget {
  final formKey;
  final id;
  final form;
  final selectGreigeOrder;
  final selectMachine;
  final isMaklon;
  final maklonName;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final label;
  final data;
  final handleChangeInput;
  final note;
  final yarnQty;

  const GreigeListForm(
      {super.key,
      this.formKey,
      this.id,
      this.form,
      this.selectGreigeOrder,
      this.selectMachine,
      this.maklonName,
      this.isMaklon = false,
      this.withMaklonOrMachine = false,
      this.withOnlyMaklon = false,
      this.withNoMaklonOrMachine = false,
      this.label,
      this.data,
      this.handleChangeInput,
      this.note,
      this.yarnQty});

  @override
  State<GreigeListForm> createState() => _GreigeListFormState();
}

class _GreigeListFormState extends State<GreigeListForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          if (widget.id == null)
            TemplateCard(
              title: 'Greige Order',
              icon: Icons.assessment_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectForm(
                    label: 'Greige Order',
                    onTap: () => widget.selectGreigeOrder(),
                    selectedLabel: widget.form?['no_greige_order'] ?? '',
                    selectedValue:
                        widget.form?['order_greige_id']?.toString() ?? '',
                    required: true,
                  ),
                ].separatedBy(CustomTheme().vGap('xl')),
              ),
            ),
          if (widget.form?['order_greige_id'] != null)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TemplateCard(
                        title: 'Mesin',
                        icon: Icons.local_laundry_service_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if (widget.form?['wo_id'] != null)
                            //   Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [_buildMultiMesin()]
                            //         .separatedBy(CustomTheme().vGap('xl')),
                            //   )
                            // else if (widget.form?['wo_id'] != null)
                            //   _buildMultiMesin()
                            // else
                            SelectForm(
                              label: 'Mesin',
                              onTap: () => widget.selectMachine(),
                              selectedLabel: widget.form['nama_mesin'] ?? '',
                              selectedValue:
                                  widget.form['machine_id'].toString(),
                              required: true,
                            ),
                          ].separatedBy(CustomTheme().vGap('xl')),
                        ),
                      ),
                    ),
                    if (widget.label == 'Warping')
                      Expanded(
                        child: WarpingSection(
                          controller: widget.yarnQty,
                          onChange: (value) {
                            widget.handleChangeInput('yarn_qty', value);
                          },
                        ),
                      ),
                    if (widget.label == 'Weaving')
                      Expanded(
                        child: WeavingSection(
                          skipShearing: widget.form['skip_shearing'] ?? false,
                          onSkipShearing: (value) {
                            widget.handleChangeInput('skip_shearing', value);
                          },
                        ),
                      ),
                  ].separatedBy(CustomTheme().hGap('xl')),
                ),
                NoteEditor(
                  controller: widget.note,
                  formKey: 'notes',
                  label: 'Catatan',
                  form: widget.form,
                  onChanged: (value) {
                    widget.handleChangeInput('notes', value);
                  },
                )
              ].separatedBy(CustomTheme().vGap('2xl')),
            ),
        ].separatedBy(CustomTheme().vGap('2xl')),
      ),
    );
  }
}
