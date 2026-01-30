import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/work-order/list/list_info.dart';
import 'package:textile_tracking/components/work-order/tab/attachment_tab.dart';
import 'package:textile_tracking/components/work-order/tab/item_tab.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WoInfoTab extends StatefulWidget {
  final data;
  final isLoading;

  const WoInfoTab({super.key, this.data, this.isLoading});

  @override
  State<WoInfoTab> createState() => _WoInfoTabState();
}

class _WoInfoTabState extends State<WoInfoTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.data.isEmpty) {
      return const NoData();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: CustomTheme().padding('content'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListInfo(
                data: widget.data,
              ),
              ItemTab(
                data: widget.data,
              ),
              AttachmentTab(
                  existingAttachment: widget.data['attachments'] ?? [])
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
        );
      },
    );
  }
}
