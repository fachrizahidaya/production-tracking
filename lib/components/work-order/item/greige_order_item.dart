// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/work-order/item/greige-order/card_content.dart';
import 'package:textile_tracking/components/work-order/item/greige-order/card_header.dart';

class GreigeOrderItem extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final bool isExpanded;
  final bool showDetails;

  const GreigeOrderItem({
    super.key,
    required this.item,
    this.isExpanded = false,
    this.onTap,
    this.showDetails = true,
  });

  @override
  State<GreigeOrderItem> createState() => _GreigeOrderItemState();
}

class _GreigeOrderItemState extends State<GreigeOrderItem> {
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
                offset: const Offset(0, 2),
              ),
            ],
          ),

          /// ✅ tinggi tetap supaya grid stabil
          constraints: BoxConstraints(
            minHeight: hasData ? 320 : 110,
            maxHeight: hasData ? 520 : 110,
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),

            /// ✅ biar content bisa scroll dan tidak overflow
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CardHeader(
                    data: data,
                    item: widget.item,
                    isTablet: isTablet,
                    hasData: hasData,
                    getProcessIcon: _getProcessIcon,
                    showDetails: widget.showDetails,
                  ),
                  if (hasData)
                    CardContent(
                      data: data.first,
                      isTablet: isTablet,
                      processKey: processKey,
                    )
                  else
                    SizedBox(
                      child: NoData(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getProcessIcon(String? key) {
    switch (key) {
      case 'warping':
        return Icons.view_column_outlined;
      case 'sizing':
        return Icons.straighten_outlined;
      case 'weaving':
        return Icons.grid_on_outlined;
      case 'shearing':
        return Icons.content_cut_outlined;
      default:
        return Icons.settings_outlined;
    }
  }
}
