// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class CardContent extends StatelessWidget {
  final data;
  final isTablet;
  const CardContent({super.key, this.data, this.isTablet});

  @override
  Widget build(BuildContext context) {
    final currentJob = data['used_by'] != null && data['used_by'].isNotEmpty
        ? data['used_by'][0]
        : null;

    if (currentJob == null) return SizedBox.shrink();

    return Padding(
      padding: CustomTheme().padding('card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Machine Info Row
          _buildMachineInfo(isTablet),

          // Current Job (if any)
          if (_hasCurrentJob()) ...[
            _buildCurrentJob(context, isTablet),
          ],
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  bool _hasCurrentJob() {
    return data['used_by']?.length != 0;
  }

  Widget _buildMachineInfo(bool isTablet) {
    return Row(
      children: [
        // Location
        if (data['location'] != null)
          Expanded(
            child: _buildInfoItem(
              icon: Icons.location_on_outlined,
              label: 'Lokasi',
              value: data['location'].toString(),
              isTablet: isTablet,
            ),
          ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: CustomTheme().buttonColor('primary').withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: isTablet
                  ? CustomTheme().iconSize('lg')
                  : CustomTheme().iconSize('md'),
              color: CustomTheme().buttonColor('primary'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ].separatedBy(CustomTheme().hGap('lg')),
      ),
    );
  }

  Widget _buildCurrentJob(BuildContext context, bool isTablet) {
    final currentJob = data['used_by'] != null && data['used_by'].isNotEmpty
        ? data['used_by'][0]
        : null;

    if (currentJob == null) return SizedBox.shrink();

    return Container(
      padding: CustomTheme().padding('card'),
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
                padding: CustomTheme().padding('process-content'),
                decoration: BoxDecoration(
                  color: CustomTheme().colors('Diproses'),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.access_time_outlined,
                  size: isTablet
                      ? CustomTheme().iconSize('xl')
                      : CustomTheme().iconSize('md'),
                  color: Colors.white,
                ),
              ),
              Text(
                'Diproses',
                style: TextStyle(
                  fontSize: isTablet
                      ? CustomTheme().fontSize('lg')
                      : CustomTheme().fontSize('md'),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
            ].separatedBy(CustomTheme().hGap('lg')),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkOrderDetail(
                    id: currentJob['wo_id'].toString(),
                  ),
                ),
              );
            },
            child: Container(
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WO No.',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('md'),
                      color: Colors.grey[500],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          currentJob['wo_no']?.toString() ?? '-',
                          style: TextStyle(
                            fontSize:
                                CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
                            fontWeight: CustomTheme().fontWeight('bold'),
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: isTablet
                            ? CustomTheme().iconSize('2xl')
                            : CustomTheme().iconSize('xl'),
                        color: Colors.grey[500],
                      ),
                    ].separatedBy(CustomTheme().hGap('xs')),
                  ),
                ].separatedBy(CustomTheme().vGap('xs')),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }
}
