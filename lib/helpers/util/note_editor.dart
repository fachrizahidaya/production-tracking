import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:textile_tracking/helpers/util/text_editor.dart';

class NoteEditor extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Map<String, dynamic>? form;
  final String formKey;
  final Function(String value)? onChanged;

  const NoteEditor({
    super.key,
    required this.controller,
    this.form,
    required this.formKey,
    required this.label,
    this.onChanged,
  });

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  String? initialHtmlState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            // Save current html
            setState(() {
              initialHtmlState = widget.controller.text.trim().isEmpty
                  ? "<p></p>"
                  : "<p>${widget.controller.text}</p>";
            });

            // Open the TextEditor
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TextEditor(
                  initialHtml: initialHtmlState,
                ),
              ),
            );

            // When user finishes editing
            if (result != null) {
              setState(() {
                widget.controller.text = result;
              });

              if (widget.form != null) {
                widget.form![widget.formKey] = result;
              }

              if (widget.onChanged != null) {
                widget.onChanged!(result);
              }
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minHeight: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Html(
              data: widget.controller.text,
              style: {
                "*": Style(
                  margin: Margins.zero,
                ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
