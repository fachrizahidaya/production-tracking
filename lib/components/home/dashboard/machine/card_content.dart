// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class MachineCardContent extends StatelessWidget {
  final dynamic data;
  final bool isTablet;
  final bool isMobile;

  const MachineCardContent({
    super.key,
    required this.data,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final usedBy = data['used_by'];

    final currentJob = usedBy != null && usedBy is List && usedBy.isNotEmpty
        ? usedBy[0]
        : null;

    return Padding(
      padding: EdgeInsets.all(
        isMobile ? 12 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['location'] != null) _buildLocation(),
          if (currentJob != null) ...[
            SizedBox(height: isMobile ? 10 : 16),
            _buildCurrentJob(
              context,
              currentJob,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 9 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: CustomTheme().buttonColor('primary').withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: isMobile ? 16 : 20,
              color: CustomTheme().buttonColor('primary'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['location'].toString(),
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentJob(
    BuildContext context,
    dynamic currentJob,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  isMobile ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: CustomTheme().colors('Diproses'),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.access_time_outlined,
                  size: isMobile ? 16 : 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Diproses',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkOrderDetail(
                    id: currentJob['wo_id'].toString(),
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                isMobile ? 9 : 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WO No.',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentJob['wo_no']?.toString() ?? '-',
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: isMobile ? 20 : 24,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
