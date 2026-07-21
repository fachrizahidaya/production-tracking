// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
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
      this.note});

  @override
  State<GreigeListForm> createState() => _GreigeListFormState();
}

class _GreigeListFormState extends State<GreigeListForm> {
  bool _isMaklon = false;

  String getSelectedMachineLabel(List machines) {
    if (machines.isEmpty) return '';
    return machines.map((e) => e['name']).join(', ');
  }

  @override
  Widget build(BuildContext context) {
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
                    selectedLabel: widget.form?['no_wo'] ?? '',
                    selectedValue: widget.form?['wo_id']?.toString() ?? '',
                    required: true,
                  ),
                ].separatedBy(CustomTheme().vGap('xl')),
              ),
            ),
          WarpingSection(
            data: null,
            items: null,
            onChange: null,
          ),
          if (widget.form?['wo_id'] != null)
            TemplateCard(
              title: 'Mesin',
              icon: Icons.local_laundry_service_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.withOnlyMaklon == true &&
                      widget.form?['wo_id'] != null)
                    _buildMaklonForm()
                  else if (widget.withMaklonOrMachine == true &&
                      widget.form?['wo_id'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMaklonSwitch(),
                        if (_isMaklon)
                          _buildMaklonNameInput()
                        else
                          _buildMultiMesin()
                      ].separatedBy(CustomTheme().vGap('xl')),
                    )
                  else if (widget.form?['wo_id'] != null)
                    if (widget.label == 'Long Hemming' ||
                        widget.label == 'Cross Cutting')
                      _buildMultiMesin()
                    else
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
    );
  }

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
    );
  }
}
