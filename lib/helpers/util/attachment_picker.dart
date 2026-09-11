// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';

class AttachmentPicker extends StatelessWidget {
  final List attachments;
  final Future<void> Function(ImageSource source) onAddAttachment;
  final Future<bool?> Function(Map item) onDeleteAttachment;
  final void Function(bool isNew, String path) onPreviewImage;

  const AttachmentPicker({
    super.key,
    required this.attachments,
    required this.onAddAttachment,
    required this.onDeleteAttachment,
    required this.onPreviewImage,
  });

  Future<void> _showSourcePicker(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                title: Text('Kamera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined),
                title: Text('Galeri'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      await onAddAttachment(source);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.attachment_outlined,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Row(
            children: [],
          ),
          ...List.generate(attachments.length, (index) {
            final item = attachments[index];

            if (item['is_add_button'] == true) {
              return GestureDetector(
                onTap: () => _showSourcePicker(context),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 32,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tambah\nLampiran',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final bool isNew = item.containsKey('path');
            final String? filePath = isNew ? item['path'] : item['file_path'];

            final String fileName = isNew
                ? item['name']
                : (item['file_name'] ?? filePath?.split('/').last ?? '');

            final extension = fileName.split('.').last.toLowerCase();

            Widget preview;
            if (extension == 'pdf') {
              preview = Icon(Icons.picture_as_pdf, color: Colors.red, size: 60);
            } else if (isNew && filePath != null) {
              preview = Image.file(File(filePath), fit: BoxFit.cover);
            } else if (filePath != null) {
              preview = Image.network(filePath, fit: BoxFit.cover);
            } else {
              preview = Icon(Icons.insert_drive_file);
            }

            return Stack(
              alignment: Alignment.topRight,
              children: [
                GestureDetector(
                  onTap: () {
                    if (['png', 'jpg', 'jpeg', 'gif'].contains(extension) &&
                        filePath != null) {
                      onPreviewImage(isNew, filePath);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: preview,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: () => onDeleteAttachment(item),
                    child: Container(
                      padding: CustomTheme().padding('process-content'),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.delete_outline,
                          color: Colors.white, size: 18),
                    ),
                  ),
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}
