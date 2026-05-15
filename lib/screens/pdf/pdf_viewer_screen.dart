import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String fileName;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.fileName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();

      final path = '${dir.path}/${widget.fileName}';

      await Dio().download(widget.url, path);

      setState(() {
        localPath = path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : localPath == null
              ? const Center(
                  child: Text('Gagal membuka PDF'),
                )
              : PDFView(
                  filePath: localPath!,
                ),
    );
  }
}
