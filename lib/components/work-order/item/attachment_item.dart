import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:path/path.dart' as p;

class AttachmentItem extends StatelessWidget {
  final item;

  const AttachmentItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = '';
    final String filePath = item['file_path'] ?? '';
    final String imageUrl = '$baseUrl$filePath';

    final String extension = p.extension(filePath).toLowerCase();

    Widget previewWidget;
    if (extension == '.pdf') {
      previewWidget = const Icon(
        Icons.picture_as_pdf,
        size: 48,
        color: Colors.black,
      );
    } else if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(extension)) {
      previewWidget = Image.network(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 48);
        },
      );
    } else {
      previewWidget = const Icon(Icons.insert_drive_file, size: 48);
    }

    return CustomCard(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        previewWidget,
        Expanded(
          flex: 1,
          child: Text(
            item['file_name']!,
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    ));
  }
}
