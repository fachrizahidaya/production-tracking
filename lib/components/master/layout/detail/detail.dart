// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textile_tracking/components/master/layout/detail/list_item.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:html/parser.dart' as html_parser;

class Detail extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isLoading;
  final Map<String, dynamic> form;
  final ValueNotifier<bool>? isSubmitting;
  final Function(String field, dynamic value)? handleChangeInput;
  final VoidCallback? handleSelectLengthUnit;
  final VoidCallback? handleSelectWidthUnit;
  final VoidCallback? handleSelectMachine;
  final Future<void> Function(String id)? handleUpdate;
  final Future<void> Function()? refetch;
  final bool? hasMore;
  final Map<String, TextEditingController> fieldControllers;
  final List<Map<String, String>> fieldConfigs;

  final weight;
  final length;
  final width;
  final note;
  final no;
  final withItemGrade;
  final qty;
  final notes;
  final handleSelectQtyUnit;
  final withQtyAndWeight;
  final qtyItem;
  final handleSelectQtyItemUnit;
  final withMaklon;
  final maklon;
  final onlySewing;
  final label;
  final forDyeing;

  const Detail(
      {super.key,
      required this.data,
      required this.isLoading,
      required this.form,
      required this.fieldControllers,
      required this.fieldConfigs,
      this.isSubmitting,
      this.handleChangeInput,
      this.handleSelectMachine,
      this.handleUpdate,
      this.refetch,
      this.hasMore,
      this.length,
      this.note,
      this.weight,
      this.width,
      this.no,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.withItemGrade,
      this.handleSelectQtyUnit,
      this.qty,
      this.notes,
      this.withQtyAndWeight,
      this.qtyItem,
      this.handleSelectQtyItemUnit,
      this.withMaklon,
      this.maklon,
      this.onlySewing,
      this.label,
      this.forDyeing});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late String _initialQty;
  late String _initialWeight;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;
  late String _initialMaklonName;
  late Map<String, String> _initialValues;

  @override
  void initState() {
    super.initState();
    _setInitialValues();
    _initialQty = widget.data['item_qty']?.toString() ?? '';
    _initialWeight = widget.data['weight']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';
    _initialMaklonName = widget.data['maklon_name']?.toString() ?? '';

    widget.qtyItem.text = _initialQty;
    widget.weight.text = _initialWeight;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;
    widget.maklon.text = _initialMaklonName;
  }

  @override
  void didUpdateWidget(covariant Detail oldWidget) {
    super.didUpdateWidget(oldWidget);
    final grades = widget.form['grades'] ?? [];
    final minLen =
        widget.qty.length < grades.length ? widget.qty.length : grades.length;
    for (int i = 0; i < minLen; i++) {
      final newText = grades[i]['qty']?.toString() ?? '';
      if (widget.qty[i].text != newText) {
        widget.qty[i].text = newText;
      }
    }

    final minLenNotes = widget.notes.length < grades.length
        ? widget.notes.length
        : grades.length;
    for (int i = 0; i < minLenNotes; i++) {
      final newText = grades[i]['notes']?.toString() ?? '';
      if (widget.notes[i].text != newText) {
        widget.notes[i].text = newText;
      }
    }

    if (widget.data != oldWidget.data && widget.data.isNotEmpty) {
      _setInitialValues();
      setState(() {
        _initialQty = widget.data['item_qty']?.toString() ?? '';
        _initialWeight = widget.data['weight']?.toString() ?? '';
        _initialLength = widget.data['length']?.toString() ?? '';
        _initialWidth = widget.data['width']?.toString() ?? '';
        _initialNotes = widget.data['notes']?.toString() ?? '';
        _initialMaklonName = widget.data['maklon_name']?.toString() ?? '';

        widget.qtyItem.text = _initialQty;
        widget.weight.text = _initialWeight;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;
        widget.maklon.text = _initialMaklonName;
      });
    }
  }

  String htmlToPlainText(dynamic htmlString) {
    if (htmlString == null) return '';

    if (htmlString is List) {
      return htmlString.join(" ");
    }

    if (htmlString is! String) {
      return htmlString.toString();
    }

    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  void _setInitialValues() {
    _initialValues = {};
    for (var field in widget.fieldConfigs) {
      final name = field['name']!;
      final value = widget.data[name]?.toString() ?? '';
      _initialValues[name] = value;
      widget.fieldControllers[name]?.text = value;
    }
  }

  Future<void> _downloadImage(
    BuildContext context,
    bool isNew,
    String imagePath,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = imagePath.split('/').last;
      final savePath = '${dir.path}/$fileName';

      if (isNew) {
        // Local image → copy
        await File(imagePath).copy(savePath);
      } else {
        // Network image → download
        await Dio().download(imagePath, savePath);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image downloaded: $fileName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed')),
      );
    }
  }

  void _showImageDialog(BuildContext context, bool isNew, String filePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: CustomTheme().padding('content'),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: CustomTheme().padding('process-content'),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: isNew
                      ? Image.file(File(filePath), fit: BoxFit.contain)
                      : Image.network(filePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                  onPressed: () => _downloadImage(context, isNew, filePath),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentList(BuildContext context) {
    final existingAttachments =
        (widget.data['attachments'] ?? []) as List<dynamic>;

    final baseUrl = dotenv.env['IMAGE_URL_DEV'] ?? '';

    return Wrap(spacing: 8, runSpacing: 8, children: [
      if (existingAttachments.isEmpty)
        const NoData()
      else
        ...existingAttachments.map<Widget>((item) {
          final bool isNew = item.containsKey('path');
          final String? filePath = isNew ? item['path'] : item['file_path'];
          final String fileName = isNew
              ? item['name']
              : (item['file_name'] ?? filePath?.split('/').last ?? '');
          final String extension = fileName.split('.').last.toLowerCase();

          Widget preview;
          if (extension == 'pdf') {
            preview =
                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 60);
          } else if (isNew && filePath != null) {
            preview = Image.file(File(filePath), fit: BoxFit.cover);
          } else if (filePath != null &&
              ['png', 'jpg', 'jpeg', 'gif'].contains(extension)) {
            preview = Image.network('$baseUrl$filePath',
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) =>
                    const Icon(Icons.broken_image, size: 60));
          } else {
            preview = const Icon(Icons.insert_drive_file, size: 60);
          }

          return GestureDetector(
            onTap: filePath != null
                ? () {
                    _showImageDialog(
                      context,
                      isNew,
                      isNew ? filePath : '$baseUrl$filePath',
                    );
                  }
                : null,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.white,
              child: preview,
            ),
          );
        }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final existingAttachments =
        (widget.data['attachments'] ?? []) as List<dynamic>;

    final existingGrades = (widget.data['grades'] ?? []) as List<dynamic>;

    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.data.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const NoData(),
      );
    }

    return ListItem(
      data: widget.data,
      form: widget.form,
      existingAttachment: existingAttachments,
      no: widget.no,
      withItemGrade: widget.withItemGrade,
      qty: widget.qty,
      handleSelectQtyUnit: widget.handleSelectQtyUnit,
      existingGrades: existingGrades,
      notes: widget.notes,
      withQtyAndWeight: widget.withQtyAndWeight,
      handleBuildAttachment: _buildAttachmentList,
      handleHtmlText: htmlToPlainText,
      label: widget.label,
      forDyeing: widget.forDyeing,
    );
  }
}
