import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';

class NoteItem extends StatelessWidget {
  final data;
  final label;
  const NoteItem({super.key, this.data, this.label});

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
        title: 'Catatan dari Work Order',
        icon: Icons.description_outlined,
        child: _buildTabletInfoLayout());
  }

  Widget _buildTabletInfoLayout() {
    final noteValue = _getNoteContentByLabel(
      notes: data['notes'],
      label: label,
    );

    return _buildInfoSection(
      child: Padding(
        padding: CustomTheme().padding('note-process'),
        child: noteValue == null ? NoData() : _buildInfo(value: noteValue),
      ),
    );
  }

  Widget _buildInfoSection({
    required child,
  }) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: child,
      )
    ]);
  }

  String? _getNoteContentByLabel({
    required dynamic notes,
    required String label,
  }) {
    if (notes == null || notes is! List) return null;

    final note = notes.whereType<Map<String, dynamic>>().firstWhere(
          (n) => n['label'] == label,
          orElse: () => {},
        );

    final content = note['content'];

    if (content == null || content.toString().trim().isEmpty) {
      return null;
    }

    return htmlToPlainText(content.toString());
  }

  Widget _buildInfo({
    required String value,
  }) {
    return Text(
      value,
      style: TextStyle(
        fontSize: CustomTheme().fontSize('lg'),
      ),
    );
  }
}
