import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/dyeing/detail/list_info.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:html/parser.dart' as html_parser;

class InfoTab extends StatefulWidget {
  final data;
  final isLoading;
  final qty;
  final length;
  final width;
  final note;
  final form;
  final handleChangeInput;
  final handleSelectUnit;
  final handleSelectMachine;
  final handleUpdate;
  final refetch;
  final hasMore;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final label;

  const InfoTab(
      {super.key,
      this.data,
      this.isLoading,
      this.qty,
      this.length,
      this.width,
      this.note,
      this.form,
      this.handleChangeInput,
      this.handleSelectUnit,
      this.handleUpdate,
      this.refetch,
      this.hasMore,
      this.handleSelectMachine,
      this.handleSelectLengthUnit,
      this.handleSelectWidthUnit,
      this.label});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _isChanged = false;
  late String _initialQty;
  late String _initialLength;
  late String _initialNotes;
  late String _initialWidth;

  @override
  void initState() {
    super.initState();
    _initialQty = widget.data['qty']?.toString() ?? '';
    _initialLength = widget.data['length']?.toString() ?? '';
    _initialWidth = widget.data['width']?.toString() ?? '';
    _initialNotes = widget.data['notes']?.toString() ?? '';

    widget.qty.text = _initialQty;
    widget.note.text = _initialNotes;
    widget.length.text = _initialLength;
    widget.width.text = _initialWidth;
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

  void showImageDialog(
      BuildContext context, bool isNew, String filePath, String baseUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(10),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: isNew
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      '$baseUrl$filePath',
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant InfoTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data && widget.data.isNotEmpty) {
      setState(() {
        _initialQty = widget.data['qty']?.toString() ?? '';
        _initialLength = widget.data['length']?.toString() ?? '';
        _initialWidth = widget.data['width']?.toString() ?? '';
        _initialNotes = widget.data['notes']?.toString() ?? '';

        widget.qty.text = _initialQty;
        widget.length.text = _initialLength;
        widget.width.text = _initialWidth;
        widget.note.text = _initialNotes;

        _isChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final existing = (widget.data?['attachments'] ?? []) as List<dynamic>;

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

    return ListInfo(
      data: widget.data,
      form: widget.form,
      isSubmitting: _isSubmitting,
      existingAttachment: existing,
      handleUpdate: widget.handleUpdate,
      initialQty: _initialQty,
      initialLength: _initialLength,
      initialWidth: _initialWidth,
      initialNotes: _initialNotes,
      isChanged: _isChanged,
      length: widget.length,
      width: widget.width,
      qty: widget.qty,
      note: widget.note,
      label: widget.label,
      handleSelectMachine: widget.handleSelectMachine,
      handleChangeInput: widget.handleChangeInput,
      handleSelectLengthUnit: widget.handleSelectLengthUnit,
      handleSelectUnit: widget.handleSelectUnit,
      handleSelectWidthUnit: widget.handleSelectWidthUnit,
      handleHtml: htmlToPlainText,
      handleShowImage: showImageDialog,
      handleBuildAttachment: _buildAttachments,
    );
  }

  Widget _buildAttachments(BuildContext context) {
    final existing = (widget.data?['attachments'] ?? []) as List<dynamic>;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(existing.length, (index) {
        final item = existing[index];

        if (item['is_add_button'] == true) {
          return const SizedBox.shrink();
        }

        final bool isNew = item.containsKey('path');
        final String? filePath = isNew ? item['path'] : item['file_path'];

        final String fileName = isNew
            ? item['name']
            : (item['file_name'] ?? filePath?.split('/').last ?? '');

        final String extension = fileName.split('.').last.toLowerCase();

        final String baseUrl = '${dotenv.env['IMAGE_URL_DEV']}';

        Widget previewWidget;

        if (extension == 'pdf') {
          previewWidget = const Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
            size: 60,
          );
        } else if (isNew && filePath != null) {
          previewWidget = Image.file(
            File(filePath),
            fit: BoxFit.cover,
          );
        } else if (filePath != null) {
          final bool isImage =
              ['png', 'jpg', 'jpeg', 'gif'].contains(extension);

          if (isImage) {
            previewWidget = Image.network(
              '$baseUrl$filePath',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
            );
          } else {
            previewWidget = const Icon(Icons.insert_drive_file, size: 60);
          }
        } else {
          previewWidget = const Icon(Icons.insert_drive_file, size: 60);
        }

        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  if (['png', 'jpg', 'jpeg', 'gif'].contains(extension) &&
                      filePath != null) {
                    showImageDialog(
                      context,
                      isNew,
                      filePath,
                      baseUrl,
                    );
                  }
                },
                child: previewWidget,
              ),
            ),
          ],
        );
      }),
    );
  }
}
