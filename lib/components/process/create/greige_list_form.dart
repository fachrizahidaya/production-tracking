// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/process/weaving.dart';
=======
import 'package:textile_tracking/components/master/form/text_form.dart';
=======
>>>>>>> 1e3750ac (fix: create process)
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/process/warping.dart';
import 'package:textile_tracking/components/process/create/process/weaving.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
>>>>>>> a1ea7df (feat: warping)
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
<<<<<<< HEAD
<<<<<<< HEAD
  final yarnQty;
  final beamQty;
  final section;
<<<<<<< HEAD
  final onFormChanged;
=======
>>>>>>> a1ea7df (feat: warping)
=======
  final yarnQty;
>>>>>>> 1e3750ac (fix: create process)
=======
>>>>>>> 6aaef7aa (fix: create warping)

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
<<<<<<< HEAD
<<<<<<< HEAD
      this.note,
      this.yarnQty,
      this.beamQty,
      this.section,
      this.onFormChanged});
=======
      this.note});
>>>>>>> a1ea7df (feat: warping)
=======
      this.note,
<<<<<<< HEAD
      this.yarnQty});
>>>>>>> 1e3750ac (fix: create process)
=======
      this.yarnQty,
      this.beamQty,
      this.section});
>>>>>>> 6aaef7aa (fix: create warping)

  @override
  State<GreigeListForm> createState() => _GreigeListFormState();
}

class _GreigeListFormState extends State<GreigeListForm> {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  String _formatWarpingType(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

=======
  String _formatWarpingType(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

    final text = value.toString().toLowerCase();
    if (text.contains('double')) return 'Double Sectional';
    if (text.contains('single')) return 'Single Warping';

>>>>>>> 6aaef7aa (fix: create warping)
    return value
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
<<<<<<< HEAD
=======
  bool _isMaklon = false;

  String getSelectedMachineLabel(List machines) {
    if (machines.isEmpty) return '';
    return machines.map((e) => e['name']).join(', ');
>>>>>>> a1ea7df (feat: warping)
  }

=======
>>>>>>> 1e3750ac (fix: create process)
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    final warpingTypeLabel = _formatWarpingType(widget.form?['warping_type']);
=======
    if (widget.withNoMaklonOrMachine == true) {
      return Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TemplateCard(
              icon: Icons.assignment_outlined,
              title: 'Greige Order',
              child: SelectForm(
                label: 'Greige Order',
                onTap: () => widget.selectGreigeOrder(),
                selectedLabel: widget.form?['no_wo'] ?? '',
                selectedValue: widget.form?['wo_id']?.toString() ?? '',
                required: true,
              ),
            ),
          ],
        ),
      );
    }
>>>>>>> a1ea7df (feat: warping)

=======
>>>>>>> e2c3f0c (fix: warping form)
=======
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

>>>>>>> 6aaef7aa (fix: create warping)
    return Form(
      child: Column(
        children: [
          if (widget.id == null)
<<<<<<< HEAD
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
=======
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
<<<<<<< HEAD
          ),
          WarpingSection(
            data: null,
            items: null,
            onChange: null,
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
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 1e3750ac (fix: create process)
        ].separatedBy(CustomTheme().vGap('2xl')),
      ),
    );
  }
<<<<<<< HEAD

<<<<<<< HEAD
<<<<<<< HEAD
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
=======
  Widget _buildMaklonForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMaklonSwitch(),
        if (_isMaklon) _buildMaklonNameInput(),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildMaklonSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maklon',
          style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
        ),
        Row(
          children: [
            Opacity(
              opacity: widget.form?['wo_id'] != null ? 1.0 : 0.5,
              child: Switch(
                value: _isMaklon,
                onChanged: widget.form?['wo_id'] != null
                    ? (value) {
                        setState(() {
                          _isMaklon = value;
                          widget.form['maklon'] = value;
                        });
                      }
                    : null,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.redAccent,
              ),
            ),
            Text(_isMaklon ? 'Ya' : 'Tidak'),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  Widget _buildMaklonNameInput() {
    return TextForm(
      label: 'Nama Maklon',
      req: false,
      controller: widget.maklonName,
      handleChange: (value) {
        setState(() {
          widget.maklonName.text = value.toString();
          widget.form['maklon_name'] = value.toString();
        });
      },
    );
  }

=======
>>>>>>> e2c3f0c (fix: warping form)
  Widget _buildMultiMesin() {
    final machines = widget.form['machines'] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupForm(
          label: 'Mesin',
          req: false,
          formControl: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: machines
                      .map<Widget>((machine) => Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: CustomTheme()
                                  .buttonColor('primary')
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: CustomTheme().buttonColor('primary'),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(machine['label'].toString()),
                                SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      machines.remove(machine);
                                      widget.form['machines'] = machines;
                                    });
                                  },
                                  child: Icon(Icons.close, size: 16),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              SelectForm(
                label: 'Pilih Mesin',
                onTap: () => widget.selectMachine(),
                selectedLabel: '',
                selectedValue: '',
                required: true,
              ),
            ].separatedBy(CustomTheme().vGap('md')),
          ),
        ),
      ],
>>>>>>> a1ea7df (feat: warping)
    );
  }
=======
>>>>>>> 1e3750ac (fix: create process)
}
