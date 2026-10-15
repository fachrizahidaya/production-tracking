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
<<<<<<< HEAD
    final usedBy = data['used_by'];
<<<<<<< HEAD
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
=======
    final usedBy = data['used_by'];
>>>>>>> 260d45ce (fix: dashboard)

=======
>>>>>>> 025659bb (fix: dashboard mobile)
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
<<<<<<< HEAD
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
<<<<<<< HEAD
          ),
        );
      },
>>>>>>> 83d26bbb (fix: UI mobile dashboard)
=======
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey[500],
            ),
=======
>>>>>>> 025659bb (fix: dashboard mobile)
          ],
        ),
      ),
>>>>>>> 260d45ce (fix: dashboard)
    );
  }
}
