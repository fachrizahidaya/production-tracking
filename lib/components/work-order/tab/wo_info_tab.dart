import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
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
      return NoData();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final items = List<Map<String, dynamic>>.from(
          widget.data['items'] ?? [],
        );
        final itemChanges = items
            .expand(
              (item) => List<Map<String, dynamic>>.from(
                item['item_changes'] ?? [],
              ),
            )
            .toList();

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
                withSpk: true,
              ),
              if (itemChanges.isNotEmpty)
                TemplateCard(
                  title: 'Ganti Material',
                  icon: Icons.swap_horiz_outlined,
                  child: _buildMaterialChanges(itemChanges, isTablet),
                ),
              AttachmentTab(
                  existingAttachment: widget.data['attachments'] ?? [])
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
        );
      },
    );
  }

  Widget _buildMaterialChanges(
    List<Map<String, dynamic>> itemChanges,
    bool isTablet,
  ) {
    return Column(
      children: itemChanges
          .map((change) {
            final fromMaterial = _buildChangedMaterial(
              label: 'Dari',
              code: change['from_item_code']?.toString() ?? '-',
              name: change['from_item_name']?.toString() ?? '-',
              isTablet: isTablet,
              isPrevious: true,
            );
            final toMaterial = _buildChangedMaterial(
              label: 'Menjadi',
              code: change['to_item_code']?.toString() ?? '-',
              name: change['to_item_name']?.toString() ?? '-',
              isTablet: isTablet,
            );

            return Container(
              width: double.infinity,
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: isTablet
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: fromMaterial),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.arrow_forward, color: Colors.grey),
                        ),
                        Expanded(child: toMaterial),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fromMaterial,
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Icon(Icons.arrow_downward, color: Colors.grey),
                        ),
                        toMaterial,
                      ],
                    ),
            );
          })
          .toList()
          .separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildChangedMaterial({
    required String label,
    required String code,
    required String name,
    required bool isTablet,
    bool isPrevious = false,
  }) {
    final textDecoration =
        isPrevious ? TextDecoration.lineThrough : TextDecoration.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 11,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          code,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            fontWeight: FontWeight.w600,
            color: isPrevious ? Colors.grey.shade600 : Colors.grey.shade800,
            decoration: textDecoration,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            color: isPrevious ? Colors.grey.shade500 : Colors.grey.shade700,
            decoration: textDecoration,
          ),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }
}
