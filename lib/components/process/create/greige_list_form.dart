// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/process/weaving.dart';
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
  final onFormChanged;

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
      this.section,
      this.onFormChanged});

  @override
  State<GreigeListForm> createState() => _GreigeListFormState();
}

class _GreigeListFormState extends State<GreigeListForm> {
  String _formatWarpingType(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

    return value
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final warpingTypeLabel = _formatWarpingType(widget.form?['warping_type']);

    return Form(
      child: Column(
        children: [
          if (widget.id == null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TemplateCard(
                    title: 'Order Greige',
                    icon: Icons.assessment_outlined,
                    child: SelectForm(
                      label: 'Order Greige',
                      onTap: () => widget.selectGreigeOrder(),
                      selectedLabel: widget.form?['no_greige_order'] ?? '',
                      selectedValue:
                          widget.form?['order_greige_id']?.toString() ?? '',
                      badge: warpingTypeLabel.isEmpty ? null : warpingTypeLabel,
                      required: true,
                    ),
                  ),
                ),
                if (widget.label == 'Weaving' &&
                    widget.form?['order_greige_id'] != null)
                  Expanded(
                    child: WeavingSection(
                      skipShearing: widget.form?['skip_shearing'] == true,
                      onSkipShearing: (value) {
                        widget.handleChangeInput('skip_shearing', value);
                      },
                    ),
                  ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          if (widget.form?['order_greige_id'] != null)
            Column(
              children: [
                TemplateCard(
                  title: 'Mesin',
                  icon: Icons.local_laundry_service_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildMultiMesin()]
                        .separatedBy(CustomTheme().vGap('xl')),
                  ),
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

  Widget _buildMultiMesin() {
    final machines = widget.form['machines'] as List? ?? [];

    return GroupForm(
      label: 'Mesin',
      req: true,
      formControl: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: machines
                  .map(
                    (machine) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            machine['label']?.toString() ??
                                machine['name']?.toString() ??
                                '',
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                machines.removeWhere(
                                  (item) =>
                                      (item['value'] ?? item['id'])
                                          .toString() ==
                                      (machine['value'] ?? machine['id'])
                                          .toString(),
                                );
                                widget.form['machines'] = machines;
                              });
                              widget.onFormChanged?.call();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await widget.selectMachine();
            },
            child: Container(
              height: 48,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('+ Tambah Mesin'),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }
}
