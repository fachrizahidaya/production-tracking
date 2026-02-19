import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/finish/list_form.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';

class FinishSection extends StatefulWidget {
  final formKey;
  final form;
  final note;
  final weight;
  final width;
  final length;
  final weightDozen;
  final gsm;
  final totalWeight;
  final handleSelectWo;
  final handleSelectUnit;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleChangeInput;
  final id;
  final processId;
  final processData;
  final isLoading;
  final withItemGrade;
  final itemGradeOption;
  final handleSelectQtyUnit;
  final qty;
  final withQtyAndWeight;
  final handleSelectQtyUnitItem;
  final handleSelectQtyUnitDyeing;
  final data;
  final forPacking;

  final qtyItem;
  final label;
  final forDyeing;
  final validateWeight;
  final weightWarning;
  final validateQty;
  final qtyWarning;
  final handleTotalItemQty;
  final handleRemainingQtyForGrade;
  final onGradeChanged;

  const FinishSection(
      {super.key,
      this.formKey,
      this.form,
      this.note,
      this.weight,
      this.length,
      this.width,
      this.handleSelectWo,
      this.handleSelectUnit,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.handleChangeInput,
      this.id,
      this.processData,
      this.processId,
      this.isLoading,
      this.withItemGrade,
      this.itemGradeOption,
      this.handleSelectQtyUnit,
      this.qty,
      this.withQtyAndWeight,
      this.handleSelectQtyUnitItem,
      this.qtyItem,
      this.label,
      this.forDyeing,
      this.handleSelectQtyUnitDyeing,
      this.data,
      this.forPacking,
      this.gsm,
      this.weightDozen,
      this.totalWeight,
      this.validateWeight,
      this.weightWarning,
      this.qtyWarning,
      this.validateQty,
      this.handleRemainingQtyForGrade,
      this.handleTotalItemQty,
      this.onGradeChanged});

  @override
  State<FinishSection> createState() => _FinishSectionState();
}

class _FinishSectionState extends State<FinishSection> {
  bool _isChanged = false;
  late List<Map<String, dynamic>> allAttachments;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    final existing =
        (widget.processData?['attachments'] ?? []).cast<Map<String, dynamic>>();
    final newOnes =
        (widget.form['attachments'] ?? []).cast<Map<String, dynamic>>();

    allAttachments = [
      ...existing,
      ...newOnes,
      {'is_add_button': true},
    ];
  }

  @override
  void didUpdateWidget(covariant FinishSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.processData != oldWidget.processData &&
        widget.processData.isNotEmpty) {
      setState(() {
        final existing = (widget.processData?['attachments'] ?? [])
            .cast<Map<String, dynamic>>();
        final newOnes =
            (widget.form['attachments'] ?? []).cast<Map<String, dynamic>>();

        allAttachments = [
          ...existing,
          ...newOnes,
          {'is_add_button': true},
        ];

        _isChanged = false;
      });
    }
  }

  Future<void> _pickAttachments() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final isValid = await _validateTotalImageSize(image.path);

        if (!isValid) {
          if (mounted) {
            await showAlertDialog(
              context: context,
              title: 'Error',
              message: 'Lampiran melebihi 1 MB',
            );
          }
          return;
        }

        setState(() {
          allAttachments.removeWhere((e) => e['is_add_button'] == true);

          final newFile = {
            'name': image.name,
            'path': image.path,
            'extension': image.path.split('.').last,
            'isNew': true,
          };

          allAttachments.add(newFile);
          allAttachments.add({'is_add_button': true});

          widget.form['attachments'] =
              allAttachments.where((e) => e['is_add_button'] != true).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        await showAlertDialog(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }

  Future<bool> _validateTotalImageSize(String newFilePath) async {
    const int maxTotalSize = 1 * 1024 * 1024; // 1 MB

    int totalSize = 0;

    // existing attachments
    for (final item in allAttachments) {
      if (item['is_add_button'] == true) continue;

      if (item['path'] != null) {
        final file = File(item['path']);
        if (await file.exists()) {
          totalSize += await file.length();
        }
      }
    }

    // add new image size
    final newFile = File(newFilePath);
    totalSize += await newFile.length();

    return totalSize <= maxTotalSize;
  }

  void showImageDialog(BuildContext context, bool isNew, String filePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: CustomTheme().padding('content'),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: CustomTheme().padding('process-content'),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: isNew
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _handleDeleteAttachment(Map item) async {
    if (!context.mounted) return false;

    final completer = Completer<bool?>();

    showConfirmationDialog(
      context: context,
      isLoading: _isLoading,
      title: 'Hapus Lampiran',
      message: 'Apakah Anda yakin ingin menghapus lampiran ini?',
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        await Future.delayed(const Duration(milliseconds: 200));

        if (!mounted) {
          completer.complete(false);
          return;
        }

        setState(() {
          allAttachments.remove(item);

          widget.form['attachments'] =
              allAttachments.where((e) => e['is_add_button'] != true).toList();
        });

        Navigator.pop(context);
        completer.complete(true);
      },
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return ListForm(
      formKey: widget.formKey,
      form: widget.form,
      id: widget.id,
      processId: widget.processId,
      length: widget.length,
      width: widget.width,
      weight: widget.weight,
      note: widget.note,
      handleSelectWo: widget.handleSelectWo,
      handleChangeInput: widget.handleChangeInput,
      handleSelectUnit: widget.handleSelectUnit,
      isChanged: _isChanged,
      allAttachments: allAttachments,
      handlePickAttachments: _pickAttachments,
      processData: widget.processData,
      handleSelectLengthUnit: widget.handleSelectLengthUnit,
      handleSelectWidthUnit: widget.handleSelectWidthUnit,
      handleSelectQtyUnitItem: widget.handleSelectQtyUnitItem,
      handleSelectQtyUnitDyeing: widget.handleSelectQtyUnitDyeing,
      withItemGrade: widget.withItemGrade,
      itemGradeOption: widget.itemGradeOption ?? [],
      handleSelectQtyUnit: widget.handleSelectQtyUnit,
      qty: widget.qty,
      withQtyAndWeight: widget.withQtyAndWeight,
      qtyItem: widget.qtyItem,
      showImageDialog: showImageDialog,
      handleDeleteAttachment: _handleDeleteAttachment,
      label: widget.label,
      forDyeing: widget.forDyeing,
      data: widget.data,
      forPacking: widget.forPacking,
      gsm: widget.gsm,
      weightDozen: widget.weightDozen,
      totalWeight: widget.totalWeight,
      validateWeight: widget.validateWeight,
      weightWarning: widget.weightWarning,
      validateQty: widget.validateQty,
      qtyWarning: widget.qtyWarning,
      handleRemainingQtyForGrade: widget.handleRemainingQtyForGrade,
      handleTotalItemQty: widget.handleTotalItemQty,
      onGradeChanged: widget.onGradeChanged,
    );
  }
}
