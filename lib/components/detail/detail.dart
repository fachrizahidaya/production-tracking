// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textile_tracking/components/detail/detail_list.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';

class Detail extends StatefulWidget {
  final data;
  final isLoading;
  final form;
  final isSubmitting;
  final handleChangeInput;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectMachine;
  final refetch;
  final hasMore;
  final fieldControllers;
  final fieldConfigs;
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
  final canDelete;
  final canUpdate;
  final handleDelete;
  final handleRefetch;
  final handleNavigateToUpdate;
  final handleNavigateToFinish;

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
      this.forDyeing,
      this.canDelete,
      this.canUpdate,
      this.handleNavigateToUpdate,
      this.handleDelete,
      this.handleRefetch,
      this.handleNavigateToFinish});

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
        await File(imagePath).copy(savePath);
      } else {
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

  List<Widget> _buildAttachmentList(BuildContext context) {
    final existingAttachments =
        (widget.data['attachments'] ?? []) as List<dynamic>;

    final baseUrl = dotenv.env['IMAGE_URL_DEV'] ?? '';

    return existingAttachments.map<Widget>((item) {
      final bool isNew = item.containsKey('path');
      final String? filePath = isNew ? item['path'] : item['file_path'];
      final String fileName = isNew
          ? item['name']
          : (item['file_name'] ?? filePath?.split('/').last ?? '');
      final String extension = fileName.split('.').last.toLowerCase();

      String fileSizeText = '';

      if (isNew && filePath != null) {
        final file = File(filePath);
        if (file.existsSync()) {
          final bytes = file.lengthSync();
          fileSizeText = formatBytes(bytes);
        }
      } else {
        if (item['file_size'] != null) {
          fileSizeText = formatBytes(item['file_size']);
        } else {
          fileSizeText = 'Unknown size';
        }
      }

      Widget preview;
      if (extension == 'pdf') {
        preview = const Icon(Icons.picture_as_pdf, color: Colors.red, size: 50);
      } else if (isNew && filePath != null) {
        preview = Image.file(File(filePath), fit: BoxFit.cover);
      } else if (filePath != null &&
          ['png', 'jpg', 'jpeg', 'gif'].contains(extension)) {
        preview = Image.network(
          '$baseUrl$filePath',
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) =>
              const Icon(Icons.broken_image, size: 50),
        );
      } else {
        preview = const Icon(Icons.insert_drive_file, size: 50);
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Preview
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade100,
                ),
                clipBehavior: Clip.antiAlias,
                child: preview,
              ),

              const SizedBox(width: 12),

              /// File name + size (COLUMN)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fileSizeText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final existingAttachments =
        (widget.data['attachments'] ?? []) as List<dynamic>;

    final existingGrades = (widget.data['grades'] ?? []) as List<dynamic>;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Detail Proses ${widget.label}',
          onReturn: () => Navigator.pop(context),
          // canDelete: widget.canDelete,
          // canUpdate: widget.canUpdate,
          handleDelete: widget.handleDelete,
          handleUpdate: widget.handleNavigateToUpdate,
          handleFinish: widget.handleNavigateToFinish,
          id: widget.data['id'],
          status: widget.data['can_delete'],
        ),
        body: SafeArea(
          child: widget.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : widget.data.isEmpty
                  ? NoData()
                  : DetailList(
                      data: widget.data,
                      existingAttachment: existingAttachments,
                      existingGrades: existingGrades,
                      handleBuildAttachment: _buildAttachmentList,
                      no: widget.no,
                      withItemGrade: widget.withItemGrade,
                      withQtyAndWeight: widget.withQtyAndWeight,
                      label: widget.label,
                      forDyeing: widget.forDyeing,
                      maklon: widget.maklon,
                      onRefresh: widget.handleRefetch,
                      handleUpdate: widget.handleNavigateToUpdate,
                      handleDelete: widget.handleDelete,
                    ),
        ),
      ),
    );
  }
}
