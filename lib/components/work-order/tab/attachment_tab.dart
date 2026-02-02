// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';

class AttachmentTab extends StatefulWidget {
  final Map<String, dynamic>? data;
  final refetch;
  final hasMore;
  final existingAttachment;

  const AttachmentTab(
      {super.key,
      this.data,
      this.refetch,
      this.hasMore,
      this.existingAttachment});

  @override
  State<AttachmentTab> createState() => _AttachmentTabState();
}

class _AttachmentTabState extends State<AttachmentTab> {
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

  List<Widget> _buildAttachmentList(BuildContext context) {
    final existingAttachments =
        (widget.existingAttachment ?? []) as List<dynamic>;

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
        preview = const Icon(Icons.picture_as_pdf, color: Colors.red, size: 60);
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
                showImageDialog(
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
    return Row(
      children: [
        Expanded(
          child: TemplateCard(
            title: 'Lampiran',
            icon: Icons.attachment_outlined,
            child: widget.existingAttachment.isEmpty
                ? NoData()
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildAttachmentList(context),
                  ),
          ),
        ),
      ],
    );
  }
}
