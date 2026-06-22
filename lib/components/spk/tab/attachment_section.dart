import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/pdf/pdf_viewer_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentSection extends StatelessWidget {
  final List<Map<String, dynamic>> attachments;

  const AttachmentSection({
    super.key,
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.attachment_outlined,
      child: attachments.isEmpty
          ? NoData()
          : Wrap(
              spacing: 8,
              runSpacing: 16,
              children: _buildAttachmentList(
                context,
              ),
            ),
    );
  }

  List<Widget> _buildAttachmentList(
    BuildContext context,
  ) {
    final baseUrl = dotenv.env['IMAGE_URL'] ?? '';

    return attachments.map((item) {
      final String? filePath = item['file_path'];

      final String fileName =
          item['file_name'] ?? filePath?.split('/').last ?? '';

      final String extension = fileName.split('.').last.toLowerCase();

      final bool isPdf = extension == 'pdf';

      final bool isImage =
          ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(extension);

      final String fileSizeText = item['file_size'] != null
          ? formatBytes(item['file_size'])
          : 'Unknown size';

      Widget preview;

      if (isImage && filePath != null) {
        preview = Image.network(
          '$baseUrl$filePath',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image,
            size: 40,
          ),
        );
      } else {
        preview = Icon(
          isPdf ? Icons.picture_as_pdf : Icons.description_outlined,
          size: 40,
          color: Colors.grey.shade700,
        );
      }

      return GestureDetector(
        onTap: filePath == null
            ? null
            : () async {
                if (isImage) {
                  showImageDialog(
                    context: context,
                    isNew: false,
                    filePath: '$baseUrl$filePath',
                  );

                  return;
                }

                if (isPdf) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfViewerScreen(
                        url: '$baseUrl$filePath',
                        fileName: fileName,
                      ),
                    ),
                  );

                  return;
                }

                await launchUrl(
                  Uri.parse(
                    '$baseUrl$filePath',
                  ),
                  mode: LaunchMode.externalApplication,
                );
              },
        child: Container(
          width: 280,
          padding: CustomTheme().padding('card'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey.shade100,
                ),
                child: preview,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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
