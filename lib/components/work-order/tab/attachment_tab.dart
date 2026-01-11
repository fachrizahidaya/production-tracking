import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

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
  @override
  Widget build(BuildContext context) {
    if (widget.existingAttachment.isEmpty) {
      return const NoData();
    }

    return Padding(
      padding: CustomTheme().padding('card'),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...List.generate(widget.existingAttachment.length, (index) {
            final item = widget.existingAttachment[index];

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
              previewWidget =
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 60);
            } else if (isNew && filePath != null) {
              previewWidget = Image.file(File(filePath), fit: BoxFit.cover);
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: previewWidget,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
