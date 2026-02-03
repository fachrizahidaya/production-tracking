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
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  @override
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
        onReturn: () {
          _handleCancel(context);
        },
      ),
      body: SafeArea(
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
              child: QuillHtmlEditor(
                minHeight: 100,
                hintText: "Tulis catatan...",
                controller: controller,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: CustomTheme().padding('card'),
            color: Colors.white,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isSubmitting,
              builder: (context, isSubmitting, _) {
                return Row(
                  children: [
                    Expanded(
                      child: CancelButton(
                        label: 'Kembali',
                        onPressed: () => _handleCancel(context),
                        customHeight: 48.0,
                      ),
                    ),
                    Expanded(
                        child: FormButton(
                      label: 'Simpan',
                      onPressed: () async {
                        final html = await controller.getText();
                        if (context.mounted) {
                          Navigator.pop(context, html);
                        }
                      },
                      customHeight: 48.0,
                    ))
                  ].separatedBy(CustomTheme().hGap('xl')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
