// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/machine/card_content.dart';
import 'package:textile_tracking/components/home/dashboard/machine/card_header.dart';
import 'package:textile_tracking/components/master/theme.dart';

class MachineCard extends StatelessWidget {
  final dynamic data;
  final bool isPortrait;
  final VoidCallback? onTap;
  final bool isSelected;

  const MachineCard({
    super.key,
    required this.data,
    this.isPortrait = true,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final usedBy = data['used_by'];

    final currentJob = usedBy is List && usedBy.isNotEmpty ? usedBy[0] : null;

    final bool isUsed = currentJob != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isUsed ? Colors.orange.withOpacity(0.3) : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMachineHeader(context),
            const SizedBox(height: 12),
            _buildStatus(context, currentJob),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineHeader(BuildContext context) {
    final type = data['process_type']?.toString().toLowerCase() ?? '';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getMachineIcon(type),
            size: 22,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['name']?.toString() ?? 'Mesin',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  if (data['code'] != null)
                    Flexible(
                      child: Text(
                        data['code'].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (data['type'] != null) ...[
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '• ${data['type']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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
    );
  }

  Widget _buildStatus(
    BuildContext context,
    dynamic currentJob,
  ) {
    final bool isUsed = currentJob != null;

    if (!isUsed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.06),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 18,
              color: Colors.green[600],
            ),
            const SizedBox(width: 7),
            Text(
              'Tersedia',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(7),
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => WorkOrderDetail(
      //         id: currentJob['wo_id'].toString(),
      //       ),
      //     ),
      //   );
      // },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.06),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              size: 18,
              color: Colors.orange[700],
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diproses',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange[700],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentJob['wo_no']?.toString() ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMachineIcon(String type) {
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
