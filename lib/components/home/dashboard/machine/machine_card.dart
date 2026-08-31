// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MachineCard extends StatelessWidget {
  final dynamic data;
  final bool isPortrait;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showStatus;

  const MachineCard({
    super.key,
    required this.data,
    this.isPortrait = true,
    this.onTap,
    this.isSelected = false,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final usedBy = data['used_by'];
    final currentJob = usedBy is List && usedBy.isNotEmpty ? usedBy[0] : null;
    final bool isUsed = currentJob != null;
    final woNo = currentJob?['wo_no']?.toString();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data['name']?.toString() ?? 'Mesin',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (data['code'] != null) ...[
              const SizedBox(height: 2),
              Text(
                data['code'].toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (showStatus && woNo != null && woNo.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'WO Diproses',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                woNo,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
=======
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        // Pastikan selalu bool
        final selected = isSelected == true;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(
              bottom: isTablet ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? CustomTheme().buttonColor('primary')
                    : Colors.grey[200]!,
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? CustomTheme().buttonColor('primary').withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: selected ? 12 : 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MachineCardHeader(
                    data: data,
                    isTablet: isTablet,
                  ),
                  MachineCardContent(
                    data: data,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
          ),
        );
      },
>>>>>>> 83d26bbb (fix: UI mobile dashboard)
    );
  }
}
