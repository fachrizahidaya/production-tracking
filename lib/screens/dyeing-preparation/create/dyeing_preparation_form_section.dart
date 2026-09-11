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
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
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
  final List<Map<String, dynamic>>? itemOptions;
  final greigeInfoMessage;
  final note;
  final handleChangeInput;
  final isEdit;
  final disableWorkOrder;
  final attachments;
  final onAddAttachment;
  final onDeleteAttachment;
  final onPreviewImage;
  final greigeReady;

  const DyeingPreparationFormSection({
    super.key,
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
    this.itemOptions,
    this.greigeInfoMessage,
    this.handleChangeInput,
    this.note,
    this.disableWorkOrder,
    this.isEdit,
    this.attachments,
    this.onAddAttachment,
    this.onDeleteAttachment,
    this.onPreviewImage,
    this.greigeReady = false,
  });

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
  void didUpdateWidget(
    covariant DyeingPreparationFormSection oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.existingItems != widget.existingItems ||
        oldWidget.greigeReady != widget.greigeReady) {
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
    return [
      item['work_order_item_id'],
      item['item_id'],
      item['id'] ?? index,
    ].where((value) => value != null).join('-');
  }

  String _normalizeNumber(String value) {
    return value.replaceAll(".", "").replaceAll(",", ".");
  }

  double? _parseSourceNumber(dynamic value) {
    if (value is num) return value.toDouble();

    final text = value?.toString().trim() ?? '';
    return double.tryParse(text) ?? double.tryParse(_normalizeNumber(text));
  }

  String _formatInputNumber(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

    final number = _parseSourceNumber(value);
    return number == null ? value.toString() : formatNumber(number);
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
      "source_item_code": item["source_item_code"],
      "source_item_name": item["source_item_name"],
      "item_code": item["item_code"],
      "item_name": item["item_name"],
      "qty_tolerance": item["qty_tolerance"],
      "unit_id": item["unit_id"],
      "weight_unit_id": item["weight_unit_id"],
      "source_index": index,
      "item_value": _itemValue(item, index),

      // WAJIB dari Work Order
      "source_qty": item["source_qty"] ?? item["qty"],
      "source_weight": item["source_weight"] ?? item["weight"],

      "spk_no": TextEditingController(
        text: item["spk_no"]?.toString() ?? "",
      ),

      "qty": TextEditingController(
        text: _formatInputNumber(item["qty"]),
      ),

      "weight": TextEditingController(
        text: _formatInputNumber(item["weight"]),
      ),
    };
  }

  void _calculateGreigeWeight(int index) {
    final item = greigeForms[index];

    final sourceQty = _parseSourceNumber(item["source_qty"]);
    final sourceWeight = _parseSourceNumber(item["source_weight"]);

    final qtyGreige = double.tryParse(
      _normalizeNumber(
        (item["qty"] as TextEditingController).text,
      ),
    );

    if (sourceQty == null ||
        sourceWeight == null ||
        qtyGreige == null ||
        sourceQty == 0) {
      (item["weight"] as TextEditingController).clear();
      return;
    }

    final weightGreige = (sourceWeight / sourceQty) * qtyGreige;

    (item["weight"] as TextEditingController).text = formatNumber(
      double.parse(weightGreige.toStringAsFixed(2)),
    );
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

    if (items.isEmpty) {
      _syncGreigeItemsToForm();
      return;
    }

    for (var index = 0; index < items.length; index++) {
      greigeForms.add(
        _createGreigeForm(
          items[index],
          index,
        ),
      );
    }

    _syncGreigeItemsToForm();
  }

  void _syncGreigeItemsToForm() {
    final Map<dynamic, Map<String, dynamic>> groupedItems = {};

    for (final item in greigeForms) {
      final workOrderItemId = item["work_order_item_id"];

      if (workOrderItemId == null) continue;

      groupedItems.putIfAbsent(
        workOrderItemId,
        () => {
          "wo_item_id": workOrderItemId,
          "notes": null,
          "greige_items": <Map<String, dynamic>>[],
        },
      );

      groupedItems[workOrderItemId]!["greige_items"].add({
        if (item["id"] != null) "id": item["id"],
        "greige_item_id": item["item_id"],
        "greige_item_op_no":
            (item["spk_no"] as TextEditingController).text.isEmpty
                ? null
                : (item["spk_no"] as TextEditingController).text,
        "qty": int.tryParse(
              _normalizeNumber((item["qty"] as TextEditingController).text),
            ) ??
            0,
        "qty_tolerance": item["qty_tolerance"] ?? 0,
        "weight": double.tryParse(
              _normalizeNumber(
                (item["weight"] as TextEditingController).text,
              ),
            ) ??
            0,
        "unit_id": item["unit_id"],
        "weight_unit_id": item["weight_unit_id"],
      });
    }

    widget.form?["items"] = groupedItems.values.toList();
  }

  List<Map<String, dynamic>> _itemOptions(dynamic workOrderItemId) {
    final allOptions = widget.itemOptions?.isNotEmpty == true
        ? widget.itemOptions!
        : widget.existingItems;
    final options = allOptions
        .where((item) => item["work_order_item_id"] == workOrderItemId)
        .toList();

    return options.asMap().entries.map((entry) {
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

  void _handleAddGreigeItem(Map<String, dynamic> sourceItem) {
    final options = widget.itemOptions?.isNotEmpty == true
        ? widget.itemOptions!
        : widget.existingItems;
    final matchingOptions = options
        .where(
          (item) =>
              item["work_order_item_id"] == sourceItem["work_order_item_id"],
        )
        .toList();

    if (matchingOptions.isEmpty) {
      _showStockMoreWarning();
      return;
    }

    setState(() {
      greigeForms.add(
        _createGreigeForm(matchingOptions.first, greigeForms.length),
      );
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
          options: _itemOptions(formItem["work_order_item_id"]),
          selected: formItem["item_value"]?.toString() ?? '',
          isAnyAdditionalData: true,
          handleChangeValue: (selected) {
            if (selected == null) {
              setState(() {
                formItem["item_id"] = null;
                formItem["spk_item_id"] = null;
                formItem["work_order_item_id"] = null;
                formItem["qty_tolerance"] = 0;
                formItem["unit_id"] = null;
                formItem["weight_unit_id"] = null;
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
            final allOptions = widget.itemOptions?.isNotEmpty == true
                ? widget.itemOptions!
                : widget.existingItems;
            final options = allOptions
                .where(
                  (item) =>
                      item["work_order_item_id"] ==
                      formItem["work_order_item_id"],
                )
                .toList();
            final selectedItem = options[sourceIndex];
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
              formItem["work_order_item_id"] =
                  selectedItem["work_order_item_id"];
              formItem["item_id"] = selectedItem["item_id"];
              formItem["spk_item_id"] = selectedItem["spk_item_id"];
              formItem["source_item_code"] = selectedItem["source_item_code"];
              formItem["source_item_name"] = selectedItem["source_item_name"];
              formItem["qty_tolerance"] = selectedItem["qty_tolerance"];
              formItem["unit_id"] = selectedItem["unit_id"];
              formItem["weight_unit_id"] = selectedItem["weight_unit_id"];
              formItem["source_index"] = sourceIndex;
              formItem["item_value"] = selectedValue;
              formItem["item_code"] =
                  selectedItem["item_code"]?.toString() ?? "";
              formItem["item_name"] =
                  selectedItem["item_name"]?.toString() ?? "";

              (formItem["spk_no"] as TextEditingController).text =
                  selectedItem["spk_no"]?.toString() ?? "";
              (formItem["qty"] as TextEditingController).text =
                  _formatInputNumber(selectedItem["qty"]);
              (formItem["weight"] as TextEditingController).text =
                  _formatInputNumber(selectedItem["weight"]);

              _syncGreigeItemsToForm();
            });
          },
        );
      },
    );
  }

  void _removeGreigeItem(int index) {
    final workOrderItemId = greigeForms[index]["work_order_item_id"];
    final formCount = greigeForms
        .where((item) => item["work_order_item_id"] == workOrderItemId)
        .length;

    if (formCount <= 1) return;

    setState(() {
      final item = greigeForms.removeAt(index);

      (item["spk_no"] as TextEditingController?)?.dispose();
      (item["qty"] as TextEditingController?)?.dispose();
      (item["weight"] as TextEditingController?)?.dispose();

      _syncGreigeItemsToForm();
    });
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
        title: widget.isEdit
            ? 'Batal Edit Persiapan Dyeing'
            : 'Batal Buat Persiapan Dyeing',
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

    final attachments = widget.attachments is List
        ? List<dynamic>.from(widget.attachments)
        : <dynamic>[];
    final hasAttachment = attachments.any(
      (attachment) => attachment is Map && attachment['is_add_button'] != true,
    );

    if (widget.isEdit != true && !hasAttachment) {
      await showAlertDialog(
        context: context,
        title: 'Peringatan',
        message: 'Lampiran wajib diisi.',
      );
      return;
    }

    showConfirmationDialog(
      context: context,
      isLoading: widget.isSubmitting,
      onConfirm: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        widget.isSubmitting.value = true;
        try {
          _syncGreigeItemsToForm();
          await widget.handleSubmit();
        } finally {
          widget.isSubmitting.value = false;
        }
      },
      title: widget.isEdit ? 'Edit Persiapan Dyeing' : 'Buat Persiapan Dyeing',
      buttonBackground: CustomTheme().buttonColor('primary'),
      child: buildBoldMessage(widget.woData['wo_no']?.toString() ?? '-'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.form?['wo_id'] == null || !widget.greigeReady;

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
                            if (widget.greigeReady)
                              _buildGreigeItemsForm(isTablet)
                            else if (widget.greigeInfoMessage != null)
                              _buildGreigeInfo(),
                            if (widget.greigeReady) ...[
                              AttachmentPicker(
                                attachments: widget.attachments ?? [],
                                onAddAttachment: (source) async {
                                  await widget.onAddAttachment?.call(source);
                                },
                                onDeleteAttachment: widget.onDeleteAttachment ??
                                    (_) async => false,
                                onPreviewImage: (isNew, filePath) {
                                  widget.onPreviewImage?.call(
                                    isNew,
                                    filePath,
                                  );
                                },
                              ),
                              NoteEditor(
                                controller: widget.note,
                                formKey: 'notes',
                                label: 'Catatan',
                                form: widget.form,
                                onChanged: (value) {
                                  widget.handleChangeInput('notes', value);
                                },
                              ),
                            ]
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
                          label: widget.isEdit ? 'Simpan' : 'Buat',
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
        isDisabled: widget.disableWorkOrder,
      ),
    );
  }

  Widget _buildGreigeItemsForm(bool isTablet) {
    final groupedIndexes = <dynamic, List<int>>{};

    for (final entry in greigeForms.asMap().entries) {
      groupedIndexes
          .putIfAbsent(
            entry.value["work_order_item_id"],
            () => <int>[],
          )
          .add(entry.key);
    }

    return TemplateCard(
      icon: Icons.inventory_2_outlined,
      title: "Item",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedIndexes.values
            .map((indexes) => _buildGreigeItem(indexes, isTablet))
            .toList()
            .separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildGreigeItem(List<int> indexes, bool isTablet) {
    final item = greigeForms[indexes.first];
    final itemCode =
        item["source_item_code"]?.toString() ?? item["item_code"]?.toString();
    final itemName =
        item["source_item_name"]?.toString() ?? item["item_name"]?.toString();

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
            [itemCode, itemName]
                .where((value) => value != null && value.isNotEmpty)
                .join(' - '),
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
          Text(
            'Batas Maks Qty: ${_formatInputNumber(item["source_qty"])}',
          ),
          Text(
            'Batas Maks Berat: ${_formatInputNumber(item["source_weight"])}',
          ),
          ...indexes.map(
            (index) => _buildGreigeForm(
              index,
              isTablet,
              indexes.length > 1,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () => _handleAddGreigeItem(item),
              icon: const Icon(Icons.add),
              label: const Text("Tambah Form"),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildGreigeForm(
    int index,
    bool isTablet,
    bool canRemove,
  ) {
    final item = greigeForms[index];
    final fields = [
      TextForm(
        label: "No. OP",
        controller: item["spk_no"],
        handleChange: (_) => _syncGreigeItemsToForm(),
      ),
      TextForm(
        label: "Qty Greige (PCS)",
        controller: item["qty"],
        isNumber: true,
        handleChange: (_) {
          _calculateGreigeWeight(index);
          _syncGreigeItemsToForm();
        },
      ),
      TextForm(
        label: "Berat Greige (KG)",
        controller: item["weight"],
        isNumber: true,
        handleChange: (_) => _syncGreigeItemsToForm(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canRemove)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Hapus Form',
                onPressed: () => _removeGreigeItem(index),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              ),
            ),
          SelectForm(
            label: "Greige Awal",
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
