import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:textile_tracking/components/master/container/template.dart';
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
  @override
  void initState() {
    super.initState();

    if (widget.form != null &&
        widget.form![widget.formKey] != null &&
        widget.controller.text.isEmpty) {
      widget.controller.text = widget.form![widget.formKey];
    }
  }

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Catatan',
      icon: Icons.note_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TextEditor(
                    initialHtml: widget.controller.text.isEmpty
                        ? "<p></p>"
                        : widget.controller.text,
                    label: widget.label,
                  ),
                ),
              );

              if (result != null) {
                widget.controller.text = result;

                if (widget.form != null) {
                  widget.form![widget.formKey] = result;
                }

                widget.onChanged?.call(result);

                setState(() {});
              }
            },
            child: Container(
              width: double.infinity,
              padding: CustomTheme().padding('card'),
              constraints: BoxConstraints(minHeight: 150.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Html(
                data: widget.controller.text.isNotEmpty
                    ? widget.controller.text
                    : "<p style='color:#999'>Tambah catatan</p>",
                style: {
                  "*": Style(margin: Margins.zero),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
