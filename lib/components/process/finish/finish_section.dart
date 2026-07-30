import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  final gsm;
  final totalWeight;
  final handleSelectWo;
  final handleChangeInput;
  final id;
  final processData;
  final withItemGrade;
  final itemGradeOption;
  final qty;
  final withQtyAndWeight;
  final data;

  final qtyItem;
  final label;
  final forDyeing;
  final validateWeight;
  final weightWarning;
  final validateQty;
  final qtyWarning;
  final weightGood;
  final weightDefect;
  final woData;
  final packingQty;
  final combing;
  final spraying;
  final itemTypeOption;
  final defects;
  final defectQty;
  final weightGradeA;
  final finishedItem;
  final dyeingQty;
  final finishedItemGrb;
  final isInitializing;

  const FinishSection(
      {super.key,
      this.formKey,
      this.form,
      this.note,
      this.weight,
      this.length,
      this.width,
      this.handleSelectWo,
      this.handleChangeInput,
      this.id,
      this.processData,
      this.withItemGrade,
      this.itemGradeOption,
      this.qty,
      this.withQtyAndWeight,
      this.qtyItem,
      this.label,
      this.forDyeing,
      this.data,
      this.gsm,
      this.totalWeight,
      this.validateWeight,
      this.weightWarning,
      this.qtyWarning,
      this.validateQty,
      this.weightDefect,
      this.weightGood,
      this.woData,
      this.packingQty,
      this.combing,
      this.spraying,
      this.itemTypeOption,
      this.defects,
      this.defectQty,
      this.weightGradeA,
      this.finishedItem,
      this.dyeingQty,
      this.finishedItemGrb,
      this.isInitializing});

  @override
  State<FinishSection> createState() => _FinishSectionState();
}

class _FinishSectionState extends State<FinishSection> {
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
      });
    }
  }

  Future<File?> compressImage(String path) async {
    if (kIsWeb) {
      return File(path); // skip compression on web
    }

    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 70,
    );

    return result != null ? File(result.path) : null;
  }

  Future<void> _pickAttachments() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        final compressedFile = await compressImage(image.path);

        if (compressedFile == null) return;

        setState(() {
          allAttachments.removeWhere((e) => e['is_add_button'] == true);

          final newFile = {
            'name': compressedFile.path.split('/').last,
            'path': compressedFile.path,
            'extension': compressedFile.path.split('.').last,
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
        await Future.delayed(Duration(milliseconds: 200));

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
      length: widget.length,
      width: widget.width,
      weight: widget.weight,
      note: widget.note,
      handleSelectWo: widget.handleSelectWo,
      handleChangeInput: widget.handleChangeInput,
      allAttachments: allAttachments,
      handlePickAttachments: _pickAttachments,
      processData: widget.processData,
      withItemGrade: widget.withItemGrade,
      itemGradeOption: widget.itemGradeOption ?? [],
      qty: widget.qty,
      withQtyAndWeight: widget.withQtyAndWeight,
      qtyItem: widget.qtyItem,
      showImageDialog: showImageDialog,
      handleDeleteAttachment: _handleDeleteAttachment,
      label: widget.label,
      forDyeing: widget.forDyeing,
      data: widget.data,
      gsm: widget.gsm,
      totalWeight: widget.totalWeight,
      validateWeight: widget.validateWeight,
      weightWarning: widget.weightWarning,
      validateQty: widget.validateQty,
      qtyWarning: widget.qtyWarning,
      weightDefect: widget.weightDefect,
      weightGood: widget.weightGood,
      woData: widget.woData,
      packingQty: widget.packingQty,
      combing: widget.combing,
      spraying: widget.spraying,
      itemTypeOption: widget.itemTypeOption,
      defects: widget.defects,
      defectQty: widget.defectQty,
      weightGradeA: widget.weightGradeA,
      finishedItem: widget.finishedItem,
      dyeingQty: widget.dyeingQty,
      finishedItemGrb: widget.finishedItemGrb,
      isInitializing: widget.isInitializing,
    );
  }
}
