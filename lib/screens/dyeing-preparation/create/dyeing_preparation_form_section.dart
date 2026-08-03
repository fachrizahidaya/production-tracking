// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class DyeingPreparationFormSection extends StatefulWidget {
  final dynamic id;
  final String title;
  final Map<String, dynamic>? form;
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> woData;
  final Future<void> Function() handleSubmit;
  final ValueNotifier<bool> isSubmitting;
  final VoidCallback selectWorkOrder;
  final bool firstLoading;
  final List<Map<String, dynamic>> existingItems;
  final greigeInfoMessage;
  final note;
  final handleChangeInput;

  const DyeingPreparationFormSection(
      {super.key,
      this.id,
      required this.title,
      required this.form,
      required this.formKey,
      required this.woData,
      required this.handleSubmit,
      required this.isSubmitting,
      required this.selectWorkOrder,
      required this.firstLoading,
      this.existingItems = const [],
      this.greigeInfoMessage,
      this.handleChangeInput,
      this.note});

  @override
  State<DyeingPreparationFormSection> createState() =>
      _DyeingPreparationFormSectionState();
}

class _DyeingPreparationFormSectionState
    extends State<DyeingPreparationFormSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final List<Map<String, dynamic>> greigeForms = [];

  @override
  void initState() {
    super.initState();
    _setGreigeForms(widget.existingItems);
  }

  @override
  void didUpdateWidget(covariant DyeingPreparationFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.existingItems != widget.existingItems) {
      _setGreigeForms(widget.existingItems);
    }
  }

  @override
  void dispose() {
    _disposeGreigeForms();
    _isLoading.dispose();
    super.dispose();
  }

  String _itemValue(Map<String, dynamic> item, int index) {
    return (item['spk_item_id'] ?? item['item_id'] ?? index).toString();
  }

  Map<String, dynamic> _createGreigeForm(
    Map<String, dynamic> item,
    int index,
  ) {
    return {
      "id": item["id"],
      "work_order_item_id": item["work_order_item_id"],
      "item_id": item["item_id"],
      "spk_item_id": item["spk_item_id"],
      "item_code": item["item_code"],
      "item_name": item["item_name"],
      "qty_tolerance": item["qty_tolerance"],
      "unit_id": item["unit_id"],
      "weight_unit_id": item["weight_unit_id"],
      "source_index": index,
      "item_value": _itemValue(item, index),
      "spk_no": TextEditingController(
        text: item["spk_no"]?.toString() ?? "",
      ),
      "qty": TextEditingController(
        text: item["qty"]?.toString() ?? "",
      ),
      "weight": TextEditingController(
        text: item["weight"]?.toString() ?? "",
      ),
    };
  }

  void _disposeGreigeForms() {
    for (final item in greigeForms) {
      (item["spk_no"] as TextEditingController?)?.dispose();
      (item["qty"] as TextEditingController?)?.dispose();
      (item["weight"] as TextEditingController?)?.dispose();
    }
    greigeForms.clear();
  }

  void _setGreigeForms(List<Map<String, dynamic>> items) {
    _disposeGreigeForms();

    for (var index = 0; index < items.length; index++) {
      greigeForms.add(_createGreigeForm(items[index], index));
    }

    _syncGreigeItemsToForm();
  }

  void _syncGreigeItemsToForm() {
    widget.form?['items'] = greigeForms.map((item) {
      return {
        "work_order_item_id": item["work_order_item_id"],
        "notes": null,
        "greige_items": [
          {
            "id": item["id"],
            "greige_item_id": item["item_id"],
            "greige_item_op_no":
                (item["spk_no"] as TextEditingController).text.isEmpty
                    ? null
                    : (item["spk_no"] as TextEditingController).text,
            "qty": int.tryParse(
                  (item["qty"] as TextEditingController)
                      .text
                      .replaceAll('.', ''),
                ) ??
                0,
            "qty_tolerance": item["qty_tolerance"] ?? 0,
            "weight": double.tryParse(
                  (item["weight"] as TextEditingController)
                      .text
                      .replaceAll('.', ''),
                ) ??
                0,
            "unit_id": item["unit_id"],
            "weight_unit_id": item["weight_unit_id"],
          }
        ]
      };
    }).toList();
  }

  List<Map<String, dynamic>> get _itemOptions {
    return widget.existingItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return {
        "value": _itemValue(item, index),
        "code": item["item_code"]?.toString() ?? "",
        "label": item["item_name"]?.toString() ?? "",
        "source_index": index,
      };
    }).toList();
  }

  void _showStockMoreWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('stok lebih')),
    );
  }

  void _handleAddGreigeItem() {
    setState(() {
      greigeForms.add({
        "item_id": null,
        "spk_item_id": null,
        "source_index": null,
        "item_value": "",
        "item_code": "",
        "item_name": "",
        "spk_no": TextEditingController(),
        "qty": TextEditingController(),
        "weight": TextEditingController(),
      });

      _syncGreigeItemsToForm();
    });
  }

  void _selectGreigeItem(int formIndex) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final formItem = greigeForms[formIndex];

        return SelectDialog(
          label: 'Greige Awal',
          options: _itemOptions,
          selected: formItem["item_value"]?.toString() ?? '',
          isAnyAdditionalData: true,
          handleChangeValue: (selected) {
            if (selected == null) {
              setState(() {
                formItem["item_id"] = null;
                formItem["spk_item_id"] = null;
                formItem["source_index"] = null;
                formItem["item_value"] = "";
                formItem["item_code"] = "";
                formItem["item_name"] = "";
                (formItem["spk_no"] as TextEditingController).clear();
                (formItem["qty"] as TextEditingController).clear();
                (formItem["weight"] as TextEditingController).clear();
                _syncGreigeItemsToForm();
              });
              return;
            }

            final sourceIndex = selected["source_index"] as int;
            final selectedItem = widget.existingItems[sourceIndex];
            final selectedValue = selected["value"]?.toString() ?? "";
            // final isSelectedInAnotherForm = greigeForms.asMap().entries.any(
            //       (entry) =>
            //           entry.key != formIndex &&
            //           entry.value["item_value"]?.toString() == selectedValue,
            //     );

            // if (isSelectedInAnotherForm) {
            //   _showStockMoreWarning();
            //   return;
            // }

            setState(() {
              formItem["item_id"] = selectedItem["item_id"];
              formItem["spk_item_id"] = selectedItem["spk_item_id"];
              formItem["source_index"] = sourceIndex;
              formItem["item_value"] = selectedValue;
              formItem["item_code"] =
                  selectedItem["item_code"]?.toString() ?? "";
              formItem["item_name"] =
                  selectedItem["item_name"]?.toString() ?? "";

              (formItem["spk_no"] as TextEditingController).text =
                  selectedItem["spk_no"]?.toString() ?? "";
              (formItem["qty"] as TextEditingController).text =
                  selectedItem["qty"]?.toString() ?? "";
              (formItem["weight"] as TextEditingController).text =
                  selectedItem["weight"]?.toString() ?? "";

              _syncGreigeItemsToForm();
            });
          },
        );
      },
    );
  }

  Future<void> _handleCancel(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: CustomTheme().fontSize('xl'),
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'Anda yakin ingin kembali? '),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            const TextSpan(
              text: ' tidak dibuat dan semua perubahan tidak disimpan!',
            ),
          ],
        ),
      );
    }

    if (!context.mounted) return;

    if (widget.form?['wo_id'] != null) {
      showConfirmationDialog(
        context: context,
        isLoading: _isLoading,
        onConfirm: () async {
          await Future.delayed(const Duration(milliseconds: 200));
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        title: 'Batal Persiapan Dyeing',
        buttonBackground: CustomTheme().buttonColor('danger'),
        child: buildBoldMessage(widget.woData['wo_no']?.toString() ?? '-'),
      );
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: CustomTheme().fontSize('xl'),
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            const TextSpan(
              text: 'Anda yakin ingin membuat Persiapan Dyeing untuk ',
            ),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            const TextSpan(text: '? Pastikan semua data sudah benar!'),
          ],
        ),
      );
    }

    if (!context.mounted) return;

    if (widget.form?['wo_id'] == null) {
      Navigator.pop(context);
      return;
    }

    showConfirmationDialog(
      context: context,
      isLoading: widget.isSubmitting,
      onConfirm: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        widget.isSubmitting.value = true;
        try {
          await widget.handleSubmit();
        } finally {
          widget.isSubmitting.value = false;
        }
      },
      title: 'Buat Persiapan Dyeing',
      buttonBackground: CustomTheme().buttonColor('primary'),
      child: buildBoldMessage(widget.woData['wo_no']?.toString() ?? '-'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.form?['wo_id'] == null;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: widget.title,
          onReturn: () => _handleCancel(context),
        ),
        body: SafeArea(
          child: widget.firstLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;

                    return SingleChildScrollView(
                      padding: CustomTheme().padding('content'),
                      child: Form(
                        key: widget.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWorkOrderForm(),
                            if (widget.existingItems.isNotEmpty)
                              _buildGreigeItemsForm(isTablet)
                            else if (widget.greigeInfoMessage != null)
                              _buildGreigeInfo(),
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
                      ),
                    );
                  },
                ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              color: Colors.white,
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.isSubmitting,
                builder: (context, isSubmitting, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: CancelButton(
                          label: 'Batal',
                          onPressed: () => _handleCancel(context),
                          customHeight: 56.0,
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                      Expanded(
                        child: FormButton(
                          label: 'Buat',
                          isDisabled: isDisabled,
                          onPressed: () => _handleSubmit(context),
                          customHeight: 56.0,
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('xl')),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkOrderForm() {
    return TemplateCard(
      icon: Icons.assignment_outlined,
      title: 'Work Order',
      child: SelectForm(
        label: 'Work Order',
        onTap: widget.selectWorkOrder,
        selectedLabel: widget.form?['no_wo'] ?? '',
        selectedValue: widget.form?['wo_id']?.toString() ?? '',
        required: true,
      ),
    );
  }

  Widget _buildGreigeItemsForm(bool isTablet) {
    return TemplateCard(
      icon: Icons.inventory_2_outlined,
      title: "Greige Awal",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...greigeForms.asMap().entries.map((entry) {
            return _buildGreigeItem(entry.key, isTablet);
          }),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _handleAddGreigeItem,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Item"),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildGreigeItem(int index, bool isTablet) {
    final item = greigeForms[index];
    final fields = [
      TextForm(
        label: "OP",
        controller: null,
        handleChange: (_) => _syncGreigeItemsToForm(),
      ),
      TextForm(
        label: "Qty",
        controller: item["qty"],
        isNumber: true,
        handleChange: (_) => _syncGreigeItemsToForm(),
      ),
      TextForm(
        label: "Weight",
        controller: item["weight"],
        isNumber: true,
        handleChange: (_) => _syncGreigeItemsToForm(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item ${index + 1}",
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
          SelectForm(
            label: "Item",
            selectedValue: item["item_value"]?.toString() ?? "",
            selectedCode: item["item_code"]?.toString() ?? "",
            selectedLabel: item["item_name"]?.toString() ?? "",
            required: true,
            isWithCode: true,
            onTap: () async => _selectGreigeItem(index),
          ),
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fields
                  .map((field) => Expanded(child: field))
                  .toList()
                  .separatedBy(CustomTheme().hGap('xl')),
            )
          else
            Column(
              children: fields,
            ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildGreigeInfo() {
    return TemplateCard(
      icon: Icons.info_outline,
      title: 'Greige Awal',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.orange.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange.shade700,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.greigeInfoMessage!,
                style: TextStyle(
                  color: Colors.orange.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
