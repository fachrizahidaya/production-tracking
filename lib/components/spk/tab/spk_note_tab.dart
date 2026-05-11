import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

class SpkNoteTab extends StatelessWidget {
  final Map<String, dynamic> data;

  const SpkNoteTab({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final notes = data['notes']?.toString() ?? '';

    if (data.isEmpty || notes.trim().isEmpty) {
      return NoData();
    }

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
      child: TemplateCard(
        title: 'Catatan',
        icon: Icons.note_outlined,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 120),
          child: Html(
            data: notes,
            style: {
              '*': Style(margin: Margins.zero),
            },
          ),
        ),
      ),
    );
  }
}
