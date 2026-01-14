import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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
          width: 100,
          height: 100,
          color: Colors.white,
          child: preview,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.existingAttachment.isEmpty) {
      return const NoData();
    }

    return Padding(
      padding: CustomTheme().padding('content'),
      child: Row(
        children: [
          Expanded(
            child: CustomCard(
              child: widget.existingAttachment.isEmpty
                  ? NoData()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _buildAttachmentList(context),
                        ),
                      ].separatedBy(CustomTheme().vGap('lg')),
                    ),
            ),
          ),
        ],
      ),
    );
    // Stack(
    //   alignment: Alignment.topRight,
    //   children: [
    //     Container(
    //       width: 100,
    //       height: 100,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //       ),
    //       child: previewWidget,
    //     ),
    //   ],
    // );
  }
}
