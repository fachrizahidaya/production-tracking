// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final id;
  final form;
  final selectWorkOrder;
  final selectMachine;
  final isMaklon;
  final maklonName;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final label;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.form,
      this.selectWorkOrder,
      this.selectMachine,
      this.maklonName,
      this.isMaklon = false,
      this.withMaklonOrMachine = false,
      this.withOnlyMaklon = false,
      this.withNoMaklonOrMachine = false,
      this.label});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  bool _isMaklon = false;

  @override
  void initState() {
    super.initState();
  }

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
                title: 'Work Order',
                child: SelectForm(
                  label: 'Work Order',
                  onTap: () => widget.selectWorkOrder(),
                  selectedLabel: widget.form?['no_wo'] ?? '',
                  selectedValue: widget.form?['wo_id']?.toString() ?? '',
                  required: true,
                )),
          ],
        ),
      );
    }

    return Form(
        child: Column(
      children: [
        if (widget.id == null)
          TemplateCard(
            title: 'Work Order',
            icon: Icons.assessment_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectForm(
                  label: 'Work Order',
                  onTap: () => widget.selectWorkOrder(),
                  selectedLabel: widget.form?['no_wo'] ?? '',
                  selectedValue: widget.form?['wo_id']?.toString() ?? '',
                  required: true,
                ),
              ].separatedBy(CustomTheme().vGap('xl')),
            ),
          ),
        if (widget.form?['wo_id'] != null)
          TemplateCard(
            title: (widget.withOnlyMaklon == true &&
                        widget.form?['wo_id'] != null) ||
                    (widget.withMaklonOrMachine == true &&
                        widget.form?['wo_id'] != null)
                ? 'Maklon'
                : 'Mesin',
            icon: (widget.withOnlyMaklon == true &&
                        widget.form?['wo_id'] != null) ||
                    (widget.withMaklonOrMachine == true &&
                        widget.form?['wo_id'] != null)
                ? Icons.business_outlined
                : Icons.local_laundry_service_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.withOnlyMaklon == true &&
                    widget.form?['wo_id'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maklon',
                        style:
                            TextStyle(fontSize: CustomTheme().fontSize('lg')),
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
                      if (_isMaklon)
                        TextForm(
                          label: 'Nama Maklon',
                          req: false,
                          controller: widget.maklonName,
                          handleChange: (value) {
                            setState(() {
                              widget.maklonName.text = value.toString();
                              widget.form['maklon_name'] = value.toString();
                            });
                          },
                        )
                    ].separatedBy(CustomTheme().hGap('xl')),
                  )
                else if (widget.withMaklonOrMachine == true &&
                    widget.form?['wo_id'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maklon',
                        style:
                            TextStyle(fontSize: CustomTheme().fontSize('lg')),
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
                      if (_isMaklon)
                        TextForm(
                          label: 'Nama Maklon',
                          req: false,
                          controller: widget.maklonName,
                          handleChange: (value) {
                            setState(() {
                              widget.maklonName.text = value.toString();
                              widget.form['maklon_name'] = value.toString();
                            });
                          },
                        )
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
      ].separatedBy(CustomTheme().vGap('2xl')),
    ));
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
                // LIST MACHINE (HORIZONTAL)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: machines
                        .map((machine) {
                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(machine['label']),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      machines.removeWhere(
                                        (e) => e['value'] == machine['value'],
                                      );
                                      widget.form['machines'] = machines;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                        .toList()
                        .separatedBy(CustomTheme().hGap('lg')),
                  ),
                ),

                // BUTTON TAMBAH
                GestureDetector(
                  onTap: () async {
                    await widget.selectMachine();
                  },
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('+ Tambah Mesin'),
                    ),
                  ),
                ),
              ].separatedBy(CustomTheme().vGap('lg')),
            )),
      ],
    );
  }
}
