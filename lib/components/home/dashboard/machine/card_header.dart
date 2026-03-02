import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardHeader extends StatelessWidget {
  final data;
  final isTablet;
  const CardHeader({super.key, this.data, this.isTablet});

  @override
  Widget build(BuildContext context) {
    final status = _getMachineStatus();
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusConfig['color'].withOpacity(0.15),
            statusConfig['color'].withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: statusConfig['color'].withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Machine Icon
          Container(
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getMachineIcon(),
              size: isTablet
                  ? CustomTheme().iconSize('3xl')
                  : CustomTheme().iconSize('2xl'),
              color: statusConfig['color'],
            ),
          ),

          // Machine Name & Code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name']?.toString() ?? 'Mesin',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data['code']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('md'),
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    if (data['type'] != null) ...[
                      Text(
                        data['type'].toString(),
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('md'),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ].separatedBy(CustomTheme().hGap('lg')),
                ),
              ].separatedBy(CustomTheme().vGap('xs')),
            ),
          ),

          // Status Badge
        ].separatedBy(CustomTheme().hGap('lg')),
      ),
    );
  }

  String _getMachineStatus() {
    if (data['status'] != null) {
      return data['status'].toString().toLowerCase();
    }
    if (data['current_job'] != null) {
      return 'running';
    }
    return 'idle';
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      default:
        return {
          'label': '',
          'color': Colors.grey,
        };
    }
  }

  IconData _getMachineIcon() {
    final type = data['process_type']?.toString().toLowerCase() ?? '';

    if (type.contains('dyeing')) return Icons.invert_colors_on_outlined;
    if (type.contains('press')) return Icons.layers_outlined;
    if (type.contains('tumbler')) return Icons.dry_cleaning_outlined;
    if (type.contains('stenter')) return Icons.air;
    if (type.contains('long slitting')) return Icons.content_paste_outlined;
    if (type.contains('long hemming')) return Icons.cut_outlined;
    if (type.contains('cross cutting')) return Icons.cut_outlined;
    if (type.contains('sewing')) return Icons.link_outlined;
    if (type.contains('embroidery')) return Icons.color_lens_outlined;
    if (type.contains('printing')) return Icons.print_outlined;
    if (type.contains('sorting')) return Icons.sort_outlined;
    if (type.contains('packing')) return Icons.inventory_2_outlined;

    return Icons.precision_manufacturing_outlined;
  }
}
