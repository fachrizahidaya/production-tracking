import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/spk/tab/spk_document_card.dart';

class NoteAttachmentSpk extends StatelessWidget {
  final documents;

  const NoteAttachmentSpk({
    super.key,
    this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return documents.isEmpty
        ? NoData()
        : ListView.separated(
            padding: CustomTheme().padding('content'),
            separatorBuilder: (_, __) => CustomTheme().vGap('2xl'),
            itemCount: documents.length,
            itemBuilder: (_, index) {
              return SpkDocumentCard(
                item: documents[index],
              );
            },
          );
  }
}
