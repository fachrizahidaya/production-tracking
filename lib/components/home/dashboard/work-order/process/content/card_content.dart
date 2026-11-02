import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final isTablet;
  final item;
  final showTimeline;

  const CardContent({
    super.key,
    this.isTablet,
    this.item,
    this.showTimeline,
  });

  @override
  Widget build(BuildContext context) {
    final List items = item['items'] ?? [];

    if (items.isEmpty) return const SizedBox.shrink();

    final remaining = items.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMaterialItem(items.first),
          if (remaining > 0) ...[
            const SizedBox(height: 6),
            Text(
              '... dan $remaining material lainnya',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMaterialItem(dynamic material) {
    final name = material['item_name']?.toString() ?? '-';
    final code = material['item_code']?.toString() ?? '-';
    final spkNo = material['spk_no']?.toString() ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Material',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            code,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF3E3F49),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          if (name != '-') ...[
            const SizedBox(height: 2),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                height: 1.25,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'SPK',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            spkNo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF3E3F49),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
