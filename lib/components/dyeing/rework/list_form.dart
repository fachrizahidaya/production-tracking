import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/group_form.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ListForm extends StatefulWidget {
  final formKey;
  final id;
  final form;
  final data;
  final attachments;
  final selectWorkOrder;
  final selectMachine;
  final selectReworkCategory;
  final reworkCategoryOption;
  final isSubmitting;
  final isFormIncomplete;
  final handleSubmit;
  final handlePickAttachments;

  const ListForm(
      {super.key,
      this.formKey,
      this.id,
      this.form,
      this.data,
      this.selectWorkOrder,
      this.selectMachine,
      this.selectReworkCategory,
      this.reworkCategoryOption,
      this.isSubmitting,
      this.isFormIncomplete,
      this.handleSubmit,
      this.handlePickAttachments,
      this.attachments});

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.id == null)
                  Expanded(
                    child: TemplateCard(
                        title: 'Work Order',
                        icon: Icons.assignment_outlined,
                        child: SelectForm(
                          label: 'Work Order',
                          onTap: () => widget.selectWorkOrder(),
                          selectedLabel: widget.form?['no_wo'] ?? '',
                          selectedValue:
                              widget.form?['wo_id']?.toString() ?? '',
                          required: true,
                        )),
                  ),
              ].separatedBy(CustomTheme().hGap('xl'))),
          if (widget.form?['wo_id'] != null)
            TemplateCard(
                title: 'Mesin',
                icon: Icons.local_laundry_service_outlined,
                child: _buildMultiMesin()),
          if (widget.form?['wo_id'] != null)
            TemplateCard(
              title: 'Rework',
              icon: Icons.build_circle_outlined,
              child: _buildReworkForm(),
            ),
        ].separatedBy(CustomTheme().vGap('xl')),
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
                  .map((machine) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                widget.form['machine_ids'] = machines
                                    .map((machine) => machine['value'])
                                    .toList();
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
      ),
    );
  }

  Widget _buildReworkForm() {
    final category = _selectedCategory;
    final categoryValue = widget.form?['rework_category']?.toString();
    final categoryLabel = category?['label']?.toString() ?? '';
    final typeOptions = List<Map<String, dynamic>>.from(
      category?['children'] ?? [],
    );
    final selectedTypes = List<String>.from(widget.form?['rework_type'] ?? []);
    final methodOptions = _methodOptions(typeOptions);
    final selectedMethods =
        List<String>.from(widget.form?['rework_method'] ?? []);
    final isPerbaikan = categoryValue == 'perbaikan';
    final isPerbaikanWarna = selectedTypes.contains('perbaikan_warna');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SelectForm(
            label: 'Kategori Rework',
            onTap: () => widget.selectReworkCategory(),
            selectedLabel: categoryLabel,
            selectedValue: categoryValue ?? '',
            required: true,
          ),
        ),
        if (isPerbaikan)
          Expanded(
            flex: 2,
            child: GroupForm(
              label: 'Jenis Perbaikan',
              req: true,
              errorText: selectedTypes.isEmpty
                  ? 'Jenis perbaikan wajib diisi'
                  : isPerbaikanWarna && selectedMethods.isEmpty
                      ? 'Metode perbaikan wajib diisi'
                      : null,
              formControl: Container(
                width: double.infinity,
                padding: CustomTheme().padding('card'),
                decoration: CustomTheme().inputStaticDecorationRequired(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: typeOptions
                      .map((type) {
                        final typeValue = type['value']?.toString() ?? '';
                        final typeLabel = type['label']?.toString() ?? '';
                        final isSelected = selectedTypes.contains(typeValue);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(typeLabel),
                              value: isSelected,
                              onChanged: (checked) {
                                setState(() {
                                  _toggleValue(
                                    fieldName: 'rework_type',
                                    value: typeValue,
                                    checked: checked == true,
                                  );

                                  if (typeValue == 'perbaikan_warna' &&
                                      checked != true) {
                                    widget.form['rework_method'] = [];
                                  }
                                });
                              },
                            ),
                            if (typeValue == 'perbaikan_warna' && isSelected)
                              Padding(
                                padding: EdgeInsets.only(left: 40),
                                child: _buildMethodOptions(
                                  methodOptions,
                                  selectedMethods,
                                ),
                              ),
                          ],
                        );
                      })
                      .toList()
                      .separatedBy(CustomTheme().vGap('sm')),
                ),
              ),
            ),
          ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildMethodOptions(
    List<Map<String, dynamic>> methodOptions,
    List<String> selectedMethods,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      child: GroupForm(
        label: 'Metode Perbaikan',
        req: true,
        formControl: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: methodOptions.map((method) {
            final methodValue = method['value']?.toString() ?? '';
            final methodLabel = method['label']?.toString() ?? '';

            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(methodLabel),
              value: selectedMethods.contains(methodValue),
              onChanged: (checked) {
                setState(() {
                  _toggleValue(
                    fieldName: 'rework_method',
                    value: methodValue,
                    checked: checked == true,
                  );
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Map<String, dynamic>? get _selectedCategory {
    final categoryValue = widget.form?['rework_category']?.toString();
    if (categoryValue == null || categoryValue.isEmpty) return null;

    final options = List<Map<String, dynamic>>.from(
      widget.reworkCategoryOption ?? [],
    );

    for (final option in options) {
      if (option['value']?.toString() == categoryValue) {
        return option;
      }
    }

    return null;
  }

  List<Map<String, dynamic>> _methodOptions(
    List<Map<String, dynamic>> typeOptions,
  ) {
    for (final option in typeOptions) {
      if (option['value']?.toString() == 'perbaikan_warna') {
        return List<Map<String, dynamic>>.from(option['children'] ?? []);
      }
    }

    return [];
  }

  void _toggleValue({
    required String fieldName,
    required String value,
    required bool checked,
  }) {
    final values = List<String>.from(widget.form[fieldName] ?? []);

    if (checked) {
      if (!values.contains(value)) values.add(value);
    } else {
      values.remove(value);
    }

    widget.form[fieldName] = values;
  }
}
