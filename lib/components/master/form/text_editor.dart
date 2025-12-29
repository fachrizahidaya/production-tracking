// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';

class TextEditor extends StatefulWidget {
  final initialHtml;

  const TextEditor({super.key, required this.initialHtml});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final QuillEditorController controller = QuillEditorController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.initialHtml != null && widget.initialHtml!.trim().isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 150));
        await controller.setText(widget.initialHtml);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Catatan',
        onReturn: () {
          Navigator.pop(context);
        },
        isTextEditor: true,
        handleSave: () async {
          final html = await controller.getText();
          Navigator.pop(context, html);
        },
      ),
      body: Column(
        children: [
          ToolBar(
            controller: controller,
            toolBarConfig: const [
              ToolBarStyle.bold,
              ToolBarStyle.italic,
              ToolBarStyle.underline,
              ToolBarStyle.link,
              ToolBarStyle.listBullet,
              ToolBarStyle.listOrdered,
              ToolBarStyle.align,
              ToolBarStyle.color,
            ],
          ),
          Expanded(
            child: QuillHtmlEditor(
              minHeight: 100,
              hintText: "Tulis catatan...",
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
