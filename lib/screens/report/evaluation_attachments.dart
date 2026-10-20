import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';

List<Map<String, dynamic>> parseEvaluationAttachments(dynamic raw) {
  if (raw is! List) return [];
  return raw
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .where((item) => evaluationAttachmentSource(item) != null)
      .toList();
}

bool sameEvaluationAttachments(
  List<Map<String, dynamic>> left,
  List<Map<String, dynamic>> right,
) {
  if (left.length != right.length) return false;
  for (var i = 0; i < left.length; i++) {
    if (left[i]['id']?.toString() != right[i]['id']?.toString()) return false;
    if (left[i]['path']?.toString() != right[i]['path']?.toString()) {
      return false;
    }
    if ((left[i]['isNew'] == true) != (right[i]['isNew'] == true)) {
      return false;
    }
  }
  return true;
}

bool evaluationAttachmentIsLocal(Map<String, dynamic> item) =>
    item['isNew'] == true;

String? evaluationAttachmentSource(Map<String, dynamic> item) {
  if (evaluationAttachmentIsLocal(item)) {
    final path = item['path']?.toString().trim() ?? '';
    return path.isEmpty ? null : path;
  }

  for (final key in ['file_path', 'file_url', 'url', 'path']) {
    final value = item[key]?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return null;
}

String? evaluationAttachmentUrl(Map<String, dynamic> item) {
  final source = evaluationAttachmentSource(item);
  if (source == null || evaluationAttachmentIsLocal(item)) return source;
  if (source.startsWith('http://') || source.startsWith('https://')) {
    return source;
  }

  final base = dotenv.env['IMAGE_URL'] ?? '';
  if (base.isEmpty) return source;
  if (base.endsWith('/') && source.startsWith('/')) {
    return '$base${source.substring(1)}';
  }
  if (!base.endsWith('/') && !source.startsWith('/')) return '$base/$source';
  return '$base$source';
}

class EvaluationAttachmentEditor extends StatefulWidget {
  final List<Map<String, dynamic>> attachments;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const EvaluationAttachmentEditor({
    super.key,
    required this.attachments,
    required this.onChanged,
  });

  @override
  State<EvaluationAttachmentEditor> createState() =>
      _EvaluationAttachmentEditorState();
}

class _EvaluationAttachmentEditorState
    extends State<EvaluationAttachmentEditor> {
  Future<File?> _compressImage(String path) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 70,
    );
    if (result != null) return File(result.path);
    return File(path);
  }

  Widget _attachmentImage(
    Map<String, dynamic> item, {
    BoxFit fit = BoxFit.cover,
  }) {
    final source = evaluationAttachmentUrl(item);
    if (source == null) {
      return const Icon(Icons.broken_image_outlined, color: Colors.white70);
    }

    if (evaluationAttachmentIsLocal(item)) {
      return Image.file(
        File(source),
        fit: fit,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image_outlined, color: Colors.white70),
      );
    }

    return Image.network(
      source,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image_outlined, color: Colors.white70),
    );
  }

  Future<ImageSource?> _showImageSourceSheet({required String title}) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ImageSourceButton(
                        icon: Icons.photo_camera_outlined,
                        label: 'Ambil gambar',
                        onTap: () =>
                            Navigator.pop(sheetContext, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ImageSourceButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Dari galeri',
                        onTap: () =>
                            Navigator.pop(sheetContext, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _pickPhoto(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (image == null) return null;

    final file = await _compressImage(image.path);
    if (file == null) return null;

    return {
      'name': file.path.split('/').last,
      'path': file.path,
      'extension': 'jpg',
      'isNew': true,
    };
  }

  void _showError(Object error) {
    if (!mounted) return;
    final message =
        error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _addAttachment() async {
    try {
      final source = await _showImageSourceSheet(title: 'Tambah Foto');
      if (source == null || !mounted) return;
      final photo = await _pickPhoto(source);
      if (photo == null || !mounted) return;
      widget.onChanged([...widget.attachments, photo]);
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _replaceAttachment(int index) async {
    if (index < 0 || index >= widget.attachments.length) return;
    try {
      final source = await _showImageSourceSheet(title: 'Ganti Foto');
      if (source == null || !mounted) return;
      final photo = await _pickPhoto(source);
      if (photo == null || !mounted) return;
      final next = List<Map<String, dynamic>>.from(widget.attachments);
      next[index] = photo;
      widget.onChanged(next);
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _deleteAttachment(int index) async {
    if (index < 0 || index >= widget.attachments.length) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Foto'),
        content: const Text('Hapus lampiran foto ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final next = List<Map<String, dynamic>>.from(widget.attachments);
    next.removeAt(index);
    widget.onChanged(next);
  }

  Future<void> _viewAttachment(int index) async {
    if (index < 0 || index >= widget.attachments.length) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: _attachmentImage(
                        widget.attachments[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await _replaceAttachment(index);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Ganti'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await _deleteAttachment(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Hapus'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAttachmentActions(int index) async {
    if (index < 0 || index >= widget.attachments.length) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ColoredBox(
                      color: Colors.black,
                      child: _attachmentImage(
                        widget.attachments[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: const Text('Lihat gambar'),
                onTap: () => Navigator.pop(sheetContext, 'view'),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Ganti gambar'),
                onTap: () => Navigator.pop(sheetContext, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Hapus gambar',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(sheetContext, 'delete'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;
    if (action == 'view') await _viewAttachment(index);
    if (action == 'edit') await _replaceAttachment(index);
    if (action == 'delete') await _deleteAttachment(index);
  }

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.photo_library_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 8.0;
          final columns = constraints.maxWidth < 280 ? 2 : 3;
          final tileSize =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.attachments.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemBuilder: (context, index) {
              if (index == widget.attachments.length) {
                return _AddPhotoTile(size: tileSize, onTap: _addAttachment);
              }

              return GestureDetector(
                onTap: () => _showAttachmentActions(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: Colors.grey.shade200,
                        child: _attachmentImage(widget.attachments[index]),
                      ),
                      const Positioned(
                        right: 6,
                        bottom: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EvaluationAttachmentGallery extends StatelessWidget {
  final dynamic attachments;

  const EvaluationAttachmentGallery({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    final items = parseEvaluationAttachments(attachments);

    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.photo_library_outlined,
      child: items.isEmpty
          ? Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tidak ada lampiran',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('base'),
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final columns = constraints.maxWidth < 280 ? 2 : 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemBuilder: (context, index) {
                    final url = evaluationAttachmentUrl(items[index]);
                    return GestureDetector(
                      onTap: url == null
                          ? null
                          : () => showImageDialog(
                                context: context,
                                isNew: false,
                                filePath: url,
                              ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColoredBox(
                          color: Colors.grey.shade200,
                          child: url == null
                              ? const Icon(Icons.broken_image_outlined)
                              : Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F6FB),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 96,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF4561DB)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _AddPhotoTile({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade700),
              const SizedBox(height: 6),
              Text(
                'Tambah\nfoto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
