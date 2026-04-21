// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/work-order/item/process/card_content.dart';
import 'package:textile_tracking/components/work-order/item/process/card_header.dart';

class ProcessItem extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final bool isExpanded;
  final bool showDetails;
  final allProcesses;

  const ProcessItem({
    super.key,
    required this.item,
    this.onTap,
    this.isExpanded = false,
    this.showDetails = true,
    this.allProcesses,
  });

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem> {
  @override
  void initState() {
    super.initState();
  }

  String getProcessStatus(String key) {
    final process = widget.allProcesses.firstWhere(
      (e) => e['key'] == key,
      orElse: () => <String, dynamic>{},
    );

    final data = process['data'] ?? [];

    if (data.isEmpty) return 'Menunggu Diproses';

    return data.first['status'] ?? 'Menunggu Diproses';
  }

  bool shouldSkipProcess(String key) {
    final sortingStatus = getProcessStatus('sorting');
    final printingStatus = getProcessStatus('printing');
    final embroideryData = widget.allProcesses.firstWhere(
          (e) => e['key'] == 'embroidery',
          orElse: () => <String, dynamic>{},
        )['data'] ??
        [];

    final printingData = widget.allProcesses.firstWhere(
          (e) => e['key'] == 'printing',
          orElse: () => <String, dynamic>{},
        )['data'] ??
        [];

    if (key == 'embroidery' || key == 'printing') {
      if ((sortingStatus == 'Diproses' || sortingStatus == 'Selesai') &&
          embroideryData.isEmpty &&
          printingData.isEmpty) {
        return true;
      }
    }

    if (key == 'sorting') {
      if (printingStatus == 'Diproses' || printingStatus == 'Selesai') {
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final data = widget.item['data'] ?? [];
        final hasData = data.isNotEmpty;
        final processKey = widget.item['key'];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardHeader(
                  data: data,
                  item: widget.item,
                  isTablet: isTablet,
                  hasData: hasData,
                  getProcessIcon: _getProcessIcon,
                  showDetails: widget.showDetails,
                  shouldSkipProcess: shouldSkipProcess,
                ),
                if (hasData)
                  CardContent(
                    data: ['dyeing', 'press', 'tumbler'].contains(processKey)
                        ? data
                        : data.first,
                    isTablet: isTablet,
                    processKey: processKey,
                  )
                else
                  Expanded(child: NoData())
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getProcessIcon(String? label) {
    if (label == null) return Icons.settings_outlined;

    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('dyeing')) return Icons.invert_colors_on_outlined;
    if (lowerLabel.contains('press')) return Icons.layers_outlined;
    if (lowerLabel.contains('tumbler')) return Icons.dry_cleaning_outlined;
    if (lowerLabel.contains('stenter')) return Icons.air;
    if (lowerLabel.contains('long slitting')) {
      return Icons.content_paste_outlined;
    }
    if (lowerLabel.contains('long hemming')) return Icons.cut_outlined;
    if (lowerLabel.contains('cross cutting')) return Icons.cut_outlined;
    if (lowerLabel.contains('sewing')) return Icons.link_outlined;
    if (lowerLabel.contains('embroidery')) return Icons.color_lens_outlined;
    if (lowerLabel.contains('printing')) return Icons.print_outlined;
    if (lowerLabel.contains('sorting')) return Icons.sort_outlined;
    if (lowerLabel.contains('packing')) return Icons.inventory_2_outlined;

    return Icons.settings_outlined;
  }
}
