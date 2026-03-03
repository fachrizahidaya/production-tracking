import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class GridProcess extends StatelessWidget {
  final buildSectionTitle;
  final isTablet;
  final getProcessConfig;
  final getProcessStatusConfig;
  final getOrderedProcessKeys;
  final processes;
  const GridProcess(
      {super.key,
      this.buildSectionTitle,
      this.getProcessConfig,
      this.getProcessStatusConfig,
      this.isTablet,
      this.getOrderedProcessKeys,
      this.processes});

  @override
  Widget build(BuildContext context) {
    final processKeys = getOrderedProcessKeys(processes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          icon: Icons.grid_view_outlined,
          title: 'Status Proses',
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 16 : 12),
        Wrap(
          spacing: isTablet ? 12 : 8,
          runSpacing: isTablet ? 12 : 8,
          children: processKeys.map((key) {
            final process = processes[key] ?? {};
            return _buildProcessGridItem(key, process, isTablet);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProcessGridItem(
      String processKey, Map<String, dynamic> process, bool isTablet) {
    final status = process['status']?.toString().toLowerCase() ?? 'pending';
    final statusConfig = getProcessStatusConfig(status);
    final processConfig = getProcessConfig(processKey);

    return Container(
      width: isTablet ? 160 : 140,
      padding: CustomTheme().padding(isTablet ? 'content' : 'card'),
      decoration: BoxDecoration(
        color: statusConfig['color'].withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusConfig['color'].withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: processConfig['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              processConfig['icon'],
              size: CustomTheme().iconSize(isTablet ? '2xl' : 'xl'),
              color: processConfig['color'],
            ),
          ),
          SizedBox(height: isTablet ? 10 : 8),
          // Title
          Text(
            processConfig['title'],
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isTablet ? 8 : 6),
          // Status
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusConfig['icon'],
                  size: isTablet ? 12 : 10,
                  color: statusConfig['color'],
                ),
                SizedBox(width: 4),
                Text(
                  statusConfig['label'],
                  style: TextStyle(
                    fontSize: isTablet ? 10 : 9,
                    fontWeight: FontWeight.w600,
                    color: statusConfig['color'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
