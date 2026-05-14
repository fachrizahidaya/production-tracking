// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.attachment_outlined,
      child: widget.existingAttachment.isEmpty
          ? NoData()
          : Wrap(
              spacing: 8,
              runSpacing: 16,
              children: _buildAttachmentList(context),
            ),
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

      /// detect image
      final bool isImage =
          ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(extension);

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

      /// Preview
      Widget preview;

      if (isImage && isNew && filePath != null) {
        preview = Image.file(
          File(filePath),
          fit: BoxFit.cover,
        );
      } else if (isImage && filePath != null) {
        preview = Image.network(
          '$baseUrl$filePath',
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) =>
              const Icon(Icons.broken_image, size: 40),
        );
      } else {
        /// General document icon
        preview = Icon(
          Icons.description_outlined,
          size: 40,
          color: Colors.grey.shade700,
        );
      }

      return GestureDetector(
        onTap: filePath == null
            ? null
            : () async {
                /// IMAGE => SHOW PREVIEW
                if (isImage) {
                  showImageDialog(
                    context: context,
                    isNew: isNew,
                    filePath: isNew ? filePath : '$baseUrl$filePath',
                  );
                } else {
                  /// NON IMAGE => DOWNLOAD FILE
                  final url = '$baseUrl$filePath';

                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
        child: Container(
          padding: CustomTheme().padding('card'),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                clipBehavior: Clip.antiAlias,
                child: preview,
              ),

              const SizedBox(width: 12),

              /// File name + size
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
}
