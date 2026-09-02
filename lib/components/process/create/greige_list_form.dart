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
  final beamQty;
  final section;

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
      this.yarnQty,
      this.beamQty,
      this.section});

  @override
  State<GreigeListForm> createState() => _GreigeListFormState();
}

class _GreigeListFormState extends State<GreigeListForm> {
  String _formatWarpingType(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

    final text = value.toString().toLowerCase();
    if (text.contains('double')) return 'Double Sectional';
    if (text.contains('single')) return 'Single Warping';

    return value
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Widget _buildWarpingTypeBadge(String label) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withOpacity(0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: CustomTheme().buttonColor('primary'),
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('sm')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final warpingTypeLabel = _formatWarpingType(widget.form?['warping_type']);
    final isSingleWarping = widget.form?['warping_type'] == 'single_warping';

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SelectForm(
                          label: 'Greige Order',
                          onTap: () => widget.selectGreigeOrder(),
                          selectedLabel: widget.form?['no_greige_order'] ?? '',
                          selectedValue:
                              widget.form?['order_greige_id']?.toString() ?? '',
                          required: true,
                        ),
                      ),
                      if (widget.label == 'Warping' &&
                          warpingTypeLabel.isNotEmpty)
                        _buildWarpingTypeBadge(warpingTypeLabel),
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
                ].separatedBy(CustomTheme().vGap('xl')),
              ),
            ),
          if (widget.form?['order_greige_id'] != null)
            Column(
              children: [
                TemplateCard(
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
                        selectedValue: widget.form['machine_id'].toString(),
                        required: true,
                      ),
                    ].separatedBy(CustomTheme().vGap('xl')),
                  ),
                ),
                Row(
                  children: [
                    if (widget.label == 'Warping')
                      Expanded(
                        child: WarpingSection(
                          controller: widget.yarnQty,
                          onChange: (value) {
                            widget.handleChangeInput('yarn_qty', value);
                          },
                          form: widget.form,
                          valueController:
                              isSingleWarping ? widget.beamQty : widget.section,
                          onValueChange: (value) {
                            widget.handleChangeInput(
                              isSingleWarping ? 'beam_qty' : 'section',
                              value,
                            );
                          },
                          extraTitle: isSingleWarping ? 'Beam' : 'Section',
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
                // NoteEditor(
                //   controller: widget.note,
                //   formKey: 'notes',
                //   label: 'Catatan',
                //   form: widget.form,
                //   onChanged: (value) {
                //     widget.handleChangeInput('notes', value);
                //   },
                // )
              ].separatedBy(CustomTheme().vGap('2xl')),
            ),
        ].separatedBy(CustomTheme().vGap('2xl')),
      ),
    );
  }
}
