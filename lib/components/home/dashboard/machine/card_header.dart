import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class MachineCardHeader extends StatelessWidget {
  final dynamic data;
  final bool isTablet;
  final bool isMobile;

  const MachineCardHeader({
    super.key,
    required this.data,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getMachineStatus();
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.all(
        isMobile ? 12 : 16,
      ),
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
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              isMobile ? 9 : 12,
            ),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getMachineIcon(),
              size: isMobile ? 22 : 28,
              color: statusConfig['color'],
            ),
          ),
          SizedBox(width: isMobile ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name']?.toString() ?? 'Mesin',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          data['code']?.toString() ?? '-',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (data['type'] != null) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          data['type'].toString(),
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
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
    return {
      'label': '',
      'color': Colors.grey,
    };
  }

  IconData _getMachineIcon() {
    final type = data['process_type']?.toString().toLowerCase() ?? '';

    if (type.contains('dyeing')) {
      return Icons.invert_colors_on_outlined;
    }

    if (type.contains('press')) {
      return Icons.layers_outlined;
    }

    if (type.contains('tumbler')) {
      return Icons.dry_cleaning_outlined;
    }

    if (type.contains('stenter')) {
      return Icons.air;
    }

    if (type.contains('long slitting')) {
      return Icons.content_paste_outlined;
    }

    if (type.contains('long hemming')) {
      return Icons.cut_outlined;
    }

    if (type.contains('cross cutting')) {
      return Icons.cut_outlined;
    }

    if (type.contains('sewing')) {
      return Icons.link_outlined;
    }

    if (type.contains('embroidery')) {
      return Icons.color_lens_outlined;
    }

    if (type.contains('printing')) {
      return Icons.print_outlined;
    }

    if (type.contains('sorting')) {
      return Icons.sort_outlined;
    }

    if (type.contains('packing')) {
      return Icons.inventory_2_outlined;
    }

    return Icons.precision_manufacturing_outlined;
  }
}
