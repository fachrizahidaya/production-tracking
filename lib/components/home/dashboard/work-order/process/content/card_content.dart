import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/content/grid_process.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/process/content/timeline_process.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatelessWidget {
  final isTablet;
  final item;
  final showTimeline;
  final bool showAllTimeline;
  final onExpandChanged;
  final collapsedTimelineCount;
  const CardContent(
      {super.key,
      this.isTablet,
      this.item,
      this.showTimeline,
      this.onExpandChanged,
      this.showAllTimeline = false,
      this.collapsedTimelineCount});

  @override
  Widget build(BuildContext context) {
    final processes = item['processes'] as Map<String, dynamic>? ?? {};
    return Padding(
      padding: CustomTheme().padding('content'),
      child: Column(
        children: [
          _buildMaterialSection(isTablet),
          showTimeline
              ? TimelineProcess(
                  showAllTimeline: showAllTimeline,
                  buildSectionTitle: _buildSectionTitle,
                  collapsedTimelineCount: collapsedTimelineCount,
                  getOrderedProcessKeys: _getOrderedProcessKeys,
                  getProcessConfig: _getProcessConfig,
                  isTablet: isTablet,
                  onExpandChanged: onExpandChanged,
                  getProcessStatusConfig: _getProcessStatusConfig,
                  processes: processes,
                )
              : GridProcess(
                  buildSectionTitle: _buildSectionTitle,
                  getOrderedProcessKeys: _getOrderedProcessKeys,
                  getProcessConfig: _getProcessConfig,
                  getProcessStatusConfig: _getProcessStatusConfig,
                  isTablet: isTablet,
                  processes: processes,
                ),
        ],
      ),
    );
  }

  Widget _buildMaterialSection(bool isTablet) {
    final List items = item['items'] ?? [];

    if (items.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.inventory_2_outlined,
          title: 'Material',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Column(
          children: items.map<Widget>((item) {
            return _buildMaterialCard(item, isTablet);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: CustomTheme().iconSize(isTablet ? 'xl' : 'lg'),
          color: CustomTheme().buttonColor('primary'),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.grey[800],
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildMaterialCard(dynamic item, bool isTablet) {
    final code = item['item_code'];
    final name = item['item_name'];
    final variants = item['variants'] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ].separatedBy(CustomTheme().hGap('md')),
          ),

          /// Variants
          if (variants.isNotEmpty) ...[
            SizedBox(height: isTablet ? 12 : 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: variants.map<Widget>((v) {
                return _buildVariantChip(v);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _getOrderedProcessKeys(Map<String, dynamic> processes) {
    final order = [
      'dyeing',
      'press',
      'tumbler',
      'stenter',
      'long_slitting',
      'long_hemming',
      'cross_cutting',
      'sewing',
      'embroidery',
      'printing',
      'sorting',
      'packing',
    ];
    final keys = processes.keys.toList();

    keys.sort((a, b) {
      final indexA = order.indexOf(a.toLowerCase());
      final indexB = order.indexOf(b.toLowerCase());
      if (indexA == -1 && indexB == -1) return a.compareTo(b);
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;
      return indexA.compareTo(indexB);
    });

    return keys;
  }

  Map<String, dynamic> _getProcessConfig(String processKey) {
    switch (processKey.toLowerCase()) {
      case 'dyeing':
        return {
          'title': 'Dyeing',
          'icon': Icons.invert_colors_on_outlined,
          'color': Colors.purple,
        };
      case 'press':
        return {
          'title': 'Press',
          'icon': Icons.layers_outlined,
          'color': Colors.teal,
        };
      case 'tumbler':
        return {
          'title': 'Tumbler',
          'icon': Icons.dry_cleaning_outlined,
          'color': Colors.indigo,
        };
      case 'stenter':
        return {
          'title': 'Stenter',
          'icon': Icons.air_outlined,
          'color': Colors.indigo,
        };
      case 'long_slitting':
        return {
          'title': 'Long Slitting',
          'icon': Icons.content_paste_outlined,
          'color': Colors.indigo,
        };
      case 'long_hemming':
        return {
          'title': 'Long Hemming',
          'icon': Icons.cut_outlined,
          'color': Colors.indigo,
        };
      case 'cross_cutting':
        return {
          'title': 'Cross Cutting',
          'icon': Icons.cut_outlined,
          'color': Colors.indigo,
        };
      case 'sewing':
        return {
          'title': 'Sewing',
          'icon': Icons.link_outlined,
          'color': Colors.pink,
        };
      case 'embroidery':
        return {
          'title': 'Embroidery',
          'icon': Icons.color_lens_outlined,
          'color': Colors.cyan,
        };
      case 'printing':
        return {
          'title': 'Printing',
          'icon': Icons.print_outlined,
          'color': Colors.pink,
        };
      case 'sorting':
        return {
          'title': 'Sorting',
          'icon': Icons.sort_outlined,
          'color': Colors.pink,
        };
      case 'packing':
        return {
          'title': 'Packing',
          'icon': Icons.inventory_2_outlined,
          'color': Colors.brown,
        };
      default:
        return {
          'title': _capitalizeFirst(processKey),
          'icon': Icons.settings_outlined,
          'color': Colors.blueGrey,
        };
    }
  }

  Map<String, dynamic> _getProcessStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return {
          'label': 'Selesai',
          'color': CustomTheme().colors('Selesai'),
          'icon': Icons.task_alt_outlined,
        };
      case 'in_progress':
      case 'Diproses':
        return {
          'label': 'Diproses',
          'color': CustomTheme().colors('Diproses'),
          'icon': Icons.access_time_outlined,
        };

      default:
        return {
          'label': 'Menunggu Diproses',
          'color': CustomTheme().colors('secondary'),
          'icon': Icons.error_outline,
        };
    }
  }

  Widget _buildVariantChip(dynamic variant) {
    return Container(
      padding: CustomTheme().padding('badge'),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        '${_capitalizeFirst(variant['type'])}: ${variant['value']}',
        style: TextStyle(
          fontSize: CustomTheme().fontSize('md'),
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
