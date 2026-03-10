// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quill_html_editor_v3/quill_html_editor_v3.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TextEditor extends StatefulWidget {
  final initialHtml;
  final label;

  const TextEditor({super.key, required this.initialHtml, this.label});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final QuillEditorController controller = QuillEditorController();
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  bool _editorReady = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final html = widget.initialHtml?.trim();

      if (html != null && html.isNotEmpty) {
        await controller.setText(html);
      }
    });
  }

  Future<void> _handleCancel(BuildContext context) async {
    if (context.mounted) {
      showConfirmationDialog(
          context: context,
          isLoading: _isLoading,
          onConfirm: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            Navigator.pop(context);
            Navigator.pop(context);
          },
          title: 'Batal Membuat Catatan',
          message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
          buttonBackground: CustomTheme().buttonColor('danger'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.label,
        onReturn: () => _handleCancel(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: CustomTheme().padding('process-content'),
          child: Column(
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
                child: Padding(
                  padding: CustomTheme().padding('process-content'),
                  child: QuillHtmlEditor(
                    controller: controller,
                    minHeight: 100.0,
                    hintText: "Tulis catatan...",
                    onEditorCreated: () async {
                      _editorReady = true;

                      final html = widget.initialHtml?.trim();
                      if (html != null && html.isNotEmpty) {
                        await controller.setText(html);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.white,
            padding: CustomTheme().padding('card'),
            child: Row(
              children: [
                Expanded(
                  child: CancelButton(
                    label: 'Batal',
                    onPressed: () => _handleCancel(context),
                    customHeight: 56.0,
                    fontSize: CustomTheme().fontSize('xl'),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _isLoading,
                    builder: (context, loading, _) {
                      return FormButton(
                        label: 'Simpan',
                        onPressed: loading
                            ? null
                            : () async {
                                if (!_editorReady) return;
                                _isLoading.value = true;

                                final html = await controller.getText();
                                final isEmpty = html.trim().isEmpty ||
                                    html.trim() == "<p><br></p>";
                                if (isEmpty) {
                                  _isLoading.value = false;
                                  return;
                                }

                                if (context.mounted) {
                                  Navigator.pop(context, html);
                                }
                              },
                        customHeight: 56.0,
                        fontSize: CustomTheme().fontSize('xl'),
                        isDisabled: loading,
                        isLoading: loading,
                      );
                    },
                  ),
                ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),
        ),
      ),
    );
  }
}
