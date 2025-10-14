import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;

class AttachmentItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final onDelete;

  const AttachmentItem({
    super.key,
    required this.item,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String baseUrl = '${dotenv.env['IMAGE_URL_DEV']}';
    final String filePath = item['file_path'] ?? '';
    final String fileName = item['file_name'] ?? 'Unknown file';
    final String imageUrl = '$baseUrl$filePath';

    final String extension = p.extension(filePath).toLowerCase();

    // Determine preview widget
    Widget previewWidget;
    if (extension == '.pdf') {
      previewWidget = Icon(
        Icons.picture_as_pdf,
        size: 60,
        color: Theme.of(context).colorScheme.secondary,
      );
    } else if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(extension)) {
      previewWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 60);
          },
        ),
      );
    } else {
      previewWidget = const Icon(Icons.insert_drive_file, size: 60);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          previewWidget,
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // if (onDelete != null) ...[
          //   const SizedBox(width: 8),
          //   IconButton(
          //     icon: const Icon(Icons.close, color: Colors.red),
          //     onPressed: onDelete,
          //   ),
          // ]
        ],
      ),
    );
  }
}
