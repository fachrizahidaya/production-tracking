import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/text_editor.dart';

class NoteEditor extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final form;
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
  void initState() {
    super.initState();

    // ✅ Load existing form data into controller
    if (widget.form != null &&
        widget.form![widget.formKey] != null &&
        widget.controller.text.isEmpty) {
      widget.controller.text = widget.form![widget.formKey];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            // Save current html
            setState(() {
              initialHtmlState = widget.controller.text.trim().isEmpty
                  ? "<p></p>"
                  : widget.controller.text;
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
            padding: CustomTheme().padding('card'),
            constraints: BoxConstraints(minHeight: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Html(
              data: widget.controller.text.isNotEmpty
                  ? widget.controller.text
                  : "<p style='color:#999'>Tap to add notes</p>",
              style: {
                "*": Style(margin: Margins.zero),
              },
            ),
          ),
        ),
      ],
    );
  }
}
