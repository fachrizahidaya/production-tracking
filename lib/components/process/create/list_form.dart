// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final id;
  final form;
  final selectWorkOrder;
  final selectMachine;
  final isMaklon;
  final maklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.form,
      this.selectWorkOrder,
      this.selectMachine,
      this.maklon,
      this.isMaklon = false,
      this.withMaklonOrMachine = false,
      this.withOnlyMaklon = false,
      this.withNoMaklonOrMachine = false});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  bool _isMaklon = false;

  @override
  Widget build(BuildContext context) {
    if (widget.withNoMaklonOrMachine == true) {
      return Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.id == null)
            CustomCard(
                child: SelectForm(
              label: 'Work Order',
              onTap: () => widget.selectWorkOrder(),
              selectedLabel: widget.form?['no_wo'] ?? '',
              selectedValue: widget.form?['wo_id']?.toString() ?? '',
              required: true,
            )),
          if (widget.withOnlyMaklon == true)
            CustomCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maklon',
                  style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
                ),
                Row(
                  children: [
                    Switch(
                      value: _isMaklon,
                      onChanged: (value) {
                        setState(() {
                          _isMaklon = value;
                          widget.form['maklon'] = value;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.redAccent,
                    ),
                    Text(_isMaklon ? 'Ya' : 'Tidak'),
                  ].separatedBy(CustomTheme().hGap('lg')),
                ),
              ],
            ))
          else if (widget.withMaklonOrMachine == true)
            CustomCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maklon',
                  style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
                ),
                Row(
                  children: [
                    Switch(
                      value: _isMaklon,
                      onChanged: (value) {
                        setState(() {
                          _isMaklon = value;
                          widget.form['maklon'] = value;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.redAccent,
                    ),
                    Text(_isMaklon ? 'Ya' : 'Tidak'),
                  ].separatedBy(CustomTheme().hGap('lg')),
                ),
                if (_isMaklon)
                  TextForm(
                    label: 'Nama Maklon',
                    req: false,
                    controller: widget.maklon,
                    handleChange: (value) {
                      setState(() {
                        widget.maklon.text = value.toString();
                        widget.form['maklon_name'] = value.toString();
                      });
                    },
                  )
                else
                  SelectForm(
                    label: 'Mesin',
                    onTap: () => widget.selectMachine(),
                    selectedLabel: widget.form['nama_mesin'] ?? '',
                    selectedValue: widget.form['machine_id'].toString(),
                    required: true,
                  ),
              ],
            ))
          else if (widget.isMaklon == true)
            CustomCard(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maklon',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                  ),
                ),
                Row(
                  children: [
                    Switch(
                      value: _isMaklon,
                      onChanged: (value) {
                        setState(() {
                          _isMaklon = value;
                          widget.form['maklon'] = value;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.redAccent,
                    ),
                    Text(_isMaklon ? 'Yes' : 'No'),
                  ].separatedBy(CustomTheme().hGap('lg')),
                ),
              ],
            ))
          else
            CustomCard(
                child: SelectForm(
              label: 'Mesin',
              onTap: () => widget.selectMachine(),
              selectedLabel: widget.form['nama_mesin'] ?? '',
              selectedValue: widget.form['machine_id'].toString(),
              required: true,
            )),
          if (_isMaklon && widget.withMaklonOrMachine != true)
            CustomCard(
                child: TextForm(
              label: 'Nama Maklon',
              req: false,
              controller: widget.maklon,
              handleChange: (value) {
                setState(() {
                  widget.form['maklon_name'] = value.toString();
                });
              },
            )),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }
}
