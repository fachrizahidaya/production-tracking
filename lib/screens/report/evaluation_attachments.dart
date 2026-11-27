import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';

List<Map<String, dynamic>> parseEvaluationAttachments(dynamic raw) {
  if (raw is! List) return [];
  return raw
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .where((item) => evaluationAttachmentSource(item) != null)
      .toList();
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

bool evaluationAttachmentIsVideo(Map<String, dynamic> item) {
  final value = [
    item['mime_type'],
    item['mimeType'],
    item['type'],
    item['file_name'],
    item['name'],
    evaluationAttachmentSource(item),
  ].whereType<String>().join(' ').toLowerCase();
  return value.contains('video/') ||
      RegExp(r'\.(mp4|mov|m4v|avi|mkv|webm)(\?|$)').hasMatch(value);
}

String? _formatAttachmentSize(dynamic value) {
  final bytes = value is num ? value.toDouble() : double.tryParse('$value');
  if (bytes == null || bytes < 0) return null;
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
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
  bool _processingVideo = false;

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

  Future<File?> _compressVideo(String path) async {
    final info = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.MediumQuality,
      includeAudio: true,
      deleteOrigin: false,
      frameRate: 30,
    );
    final compressedPath = info?.path;
    return compressedPath == null ? File(path) : File(compressedPath);
  }

  Widget _attachmentPreview(
    Map<String, dynamic> item, {
    BoxFit fit = BoxFit.cover,
  }) {
    if (evaluationAttachmentIsVideo(item)) {
      return _VideoThumbnail(item: item, fit: fit);
    }
    return _attachmentImage(item, fit: fit);
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
                        label: title.toLowerCase().contains('video')
                            ? 'Ambil video'
                            : 'Ambil gambar',
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

    final fileExtension = image.path.split('.').last.toLowerCase();
    const allowed = {'jpg', 'jpeg', 'png', 'gif', 'webp'};
    if (!allowed.contains(fileExtension)) {
      throw Exception('Lampiran hanya boleh jpg, jpeg, png, gif, atau webp.');
    }

    final File file;
    if (fileExtension == 'gif' || fileExtension == 'webp') {
      file = File(image.path);
    } else {
      final compressed = await _compressImage(image.path);
      if (compressed == null) return null;
      file = compressed;
    }

    if (await file.length() > 10 * 1024 * 1024) {
      throw Exception('Ukuran foto maksimal 10MB.');
    }

    final name = file.path.split('/').last;
    return {
      'name': name,
      'path': file.path,
      'extension': name.split('.').last.toLowerCase(),
      'isNew': true,
    };
  }

  Future<Map<String, dynamic>?> _pickVideo(ImageSource source) async {
    final video = await ImagePicker().pickVideo(source: source);
    if (video == null) return null;

    if (mounted) setState(() => _processingVideo = true);
    try {
      final originalBytes = await File(video.path).length();
      final compressed = await _compressVideo(video.path);
      if (compressed == null) return null;
      final compressedBytes = await compressed.length();
      String toMb(int bytes) => (bytes / (1024 * 1024)).toStringAsFixed(2);
      debugPrint(
        '[BS Attachment] Video dipilih: ${video.path} | '
        'ukuran asli: $originalBytes bytes (${toMb(originalBytes)} MB) | '
        'ukuran setelah kompresi: $compressedBytes bytes '
        '(${toMb(compressedBytes)} MB)',
      );

      if (compressedBytes > 20 * 1024 * 1024) {
        throw Exception('Ukuran video maksimal 20MB setelah dikompres.');
      }

      String? thumbnailPath;
      try {
        final thumbnail = await VideoCompress.getFileThumbnail(
          compressed.path,
          quality: 70,
          position: 1000,
        );
        thumbnailPath = thumbnail.path;
      } catch (error) {
        debugPrint('[BS Attachment] Gagal membuat thumbnail video: $error');
      }

      final name = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      return {
        'name': name,
        'path': compressed.path,
        if (thumbnailPath != null) 'thumbnailPath': thumbnailPath,
        'extension': 'mp4',
        'mime_type': 'video/mp4',
        'isNew': true,
      };
    } finally {
      if (mounted) setState(() => _processingVideo = false);
    }
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
      final type = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Tambah foto'),
                onTap: () => Navigator.pop(sheetContext, 'photo'),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Tambah video'),
                onTap: () => Navigator.pop(sheetContext, 'video'),
              ),
            ],
          ),
        ),
      );
      if (type == null || !mounted) return;
      if (type == 'video' &&
          widget.attachments.where(evaluationAttachmentIsVideo).length >= 2) {
        _showError('Maksimal 2 video dapat dipilih.');
        return;
      }
      final source = await _showImageSourceSheet(
        title: type == 'video' ? 'Tambah Video' : 'Tambah Foto',
      );
      if (source == null || !mounted) return;
      final attachment =
          type == 'video' ? await _pickVideo(source) : await _pickPhoto(source);
      if (attachment == null || !mounted) return;
      widget.onChanged([...widget.attachments, attachment]);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await _deleteAttachment(index);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFD32F2F),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
                Expanded(
                  child: _AttachmentViewer(item: widget.attachments[index]),
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
                child: GestureDetector(
                  onTap: () => Navigator.pop(sheetContext, 'view'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ColoredBox(
                        color: Colors.black,
                        child: _attachmentPreview(
                          widget.attachments[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  evaluationAttachmentIsVideo(widget.attachments[index])
                      ? 'Hapus video'
                      : 'Hapus gambar',
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
    if (action == 'delete') await _deleteAttachment(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TemplateCard(
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
                    onTap: () => _viewAttachment(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(
                            color: Colors.grey.shade200,
                            child:
                                _attachmentPreview(widget.attachments[index]),
                          ),
                          Positioned(
                            left: 6,
                            bottom: 6,
                            child: _AttachmentSizeLabel(
                              item: widget.attachments[index],
                            ),
                          ),
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: GestureDetector(
                              onTap: () => _showAttachmentActions(index),
                              child: const DecoratedBox(
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (_processingVideo)
          Positioned.fill(
            child: ColoredBox(
              color: const Color.fromRGBO(0, 0, 0, 0.65),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Memproses video...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
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
              child: Text('Tidak ada lampiran',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('base'),
                    color: Colors.grey.shade600,
                  )),
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
                    final item = items[index];
                    final url = evaluationAttachmentUrl(item);
                    return GestureDetector(
                      onTap:
                          url == null ? null : () => _showViewer(context, item),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            evaluationAttachmentIsVideo(item)
                                ? _VideoThumbnail(item: item)
                                : url == null
                                    ? const ColoredBox(
                                        color: Colors.grey,
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                        ),
                                      )
                                    : Image.network(url,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.broken_image_outlined,
                                            )),
                            Positioned(
                              left: 6,
                              bottom: 6,
                              child: _AttachmentSizeLabel(item: item),
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

  void _showViewer(BuildContext context, Map<String, dynamic> item) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) => Dialog.fullscreen(
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
              Expanded(child: _AttachmentViewer(item: item)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentSizeLabel extends StatefulWidget {
  final Map<String, dynamic> item;

  const _AttachmentSizeLabel({required this.item});

  @override
  State<_AttachmentSizeLabel> createState() => _AttachmentSizeLabelState();
}

class _AttachmentSizeLabelState extends State<_AttachmentSizeLabel> {
  late final Future<int?> _sizeFuture = _loadSize();

  Future<int?> _loadSize() async {
    if (evaluationAttachmentIsLocal(widget.item)) {
      final path = widget.item['path']?.toString().trim() ?? '';
      if (path.isEmpty) return null;
      final file = File(path);
      if (!await file.exists()) return null;
      return file.length();
    }

    final value = widget.item['file_size'];
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _sizeFuture,
      builder: (context, snapshot) {
        final size = snapshot.data;
        final label = size == null ? null : _formatAttachmentSize(size);
        if (label == null) return const SizedBox.shrink();
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VideoThumbnail extends StatefulWidget {
  final Map<String, dynamic> item;
  final BoxFit fit;

  const _VideoThumbnail({required this.item, this.fit = BoxFit.cover});

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  File? _thumbnail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _createThumbnail();
  }

  Future<void> _createThumbnail() async {
    try {
      final existingThumbnail =
          widget.item['thumbnailPath']?.toString().trim() ?? '';
      if (existingThumbnail.isNotEmpty) {
        final file = File(existingThumbnail);
        if (await file.exists()) {
          if (mounted) setState(() => _thumbnail = file);
          return;
        }
      }

      final source = evaluationAttachmentUrl(widget.item);
      if (source == null || source.isEmpty) return;

      String localVideoPath;
      if (evaluationAttachmentIsLocal(widget.item)) {
        localVideoPath = source;
      } else {
        final response = await http.get(Uri.parse(source));
        if (response.statusCode < 200 || response.statusCode >= 300) return;
        final directory = await getTemporaryDirectory();
        final videoFile = File(
          '${directory.path}/bs_video_${source.hashCode.abs()}.mp4',
        );
        if (!await videoFile.exists()) {
          await videoFile.writeAsBytes(response.bodyBytes, flush: true);
        }
        localVideoPath = videoFile.path;
      }

      final thumbnail = await VideoCompress.getFileThumbnail(
        localVideoPath,
        quality: 70,
        position: 1000,
      );
      if (mounted) setState(() => _thumbnail = thumbnail);
    } catch (error) {
      debugPrint(
          '[BS Attachment] Gagal membuat thumbnail video existing: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        if (_thumbnail != null)
          Image.file(
            _thumbnail!,
            fit: widget.fit,
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Colors.black87,
            ),
          )
        else
          const ColoredBox(color: Colors.black87),
        if (_loading)
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          )
        else
          const Center(
            child: Icon(Icons.play_circle_fill, color: Colors.white, size: 42),
          ),
      ],
    );
  }
}

class _AttachmentViewer extends StatefulWidget {
  final Map<String, dynamic> item;

  const _AttachmentViewer({required this.item});

  @override
  State<_AttachmentViewer> createState() => _AttachmentViewerState();
}

class _AttachmentViewerState extends State<_AttachmentViewer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (evaluationAttachmentIsVideo(widget.item)) {
      final source = evaluationAttachmentUrl(widget.item);
      if (source != null) {
        _controller = evaluationAttachmentIsLocal(widget.item)
            ? VideoPlayerController.file(File(source))
            : VideoPlayerController.networkUrl(Uri.parse(source));
        _controller!.addListener(_onVideoChanged);
        _controller!.initialize().then((_) {
          if (mounted) setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoChanged);
    _controller?.dispose();
    super.dispose();
  }

  void _onVideoChanged() {
    if (mounted) setState(() {});
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!evaluationAttachmentIsVideo(widget.item)) {
      final source = evaluationAttachmentUrl(widget.item);
      return InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: source == null
              ? const Icon(Icons.broken_image, color: Colors.white)
              : evaluationAttachmentIsLocal(widget.item)
                  ? Image.file(File(source), fit: BoxFit.contain)
                  : Image.network(source, fit: BoxFit.contain),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final position = controller.value.position;
    final duration = controller.value.duration;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const controlsHeight = 58.0;
          final availableHeight = math.max(
            100.0,
            constraints.maxHeight - controlsHeight,
          );
          final aspectRatio = controller.value.aspectRatio;
          final videoHeight = math.min(
            availableHeight,
            constraints.maxWidth / aspectRatio,
          );
          final videoWidth = videoHeight * aspectRatio;

          return Center(
            child: SizedBox(
              width: videoWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(controller),
                        IconButton(
                          iconSize: 64,
                          color: Colors.white,
                          icon: Icon(controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill),
                          onPressed: () {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        bufferedColor: Colors.white54,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(position),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          _formatDuration(duration),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
