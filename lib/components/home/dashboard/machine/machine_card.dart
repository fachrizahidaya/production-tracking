// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? CustomTheme().buttonColor('primary')
                    : Colors.grey[200]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? CustomTheme().buttonColor('primary').withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isSelected ? 12 : 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  _buildHeader(isTablet),

                  // Content Section
                  Padding(
                    padding: CustomTheme().padding('card'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Machine Info Row
                        _buildMachineInfo(isTablet),

                        // Stats Section

                        // Current Job (if any)
                        if (_hasCurrentJob()) ...[
                          _buildCurrentJob(context, isTablet),
                        ],
                      ].separatedBy(CustomTheme().vGap('lg')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Header Section dengan status dan nama mesin
  Widget _buildHeader(bool isTablet) {
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
              size: isTablet ? 28 : 24,
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
                          fontSize: CustomTheme().fontSize('sm'),
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

  /// Machine Info Section
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
        // Capacity

        // Last Maintenance
      ],
    );
  }

  /// Info Item Widget
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
              size: isTablet ? 16 : 14,
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
                    fontSize: CustomTheme().fontSize('sm'),
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('sm'),
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

    if (currentJob == null) return const SizedBox.shrink();

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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.play_circle_outline,
                  size: isTablet ? 18 : 16,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Sedang Dikerjakan',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
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
                      fontSize: CustomTheme().fontSize('sm'),
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
                        size: isTablet ? 24 : 20,
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

  /// Helper Methods
  bool _hasCurrentJob() {
    return data['used_by']?.length != 0;
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
    if (type.contains('long sitting')) return Icons.content_paste_outlined;
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

/// Grid Layout untuk Machine Cards
class MachineCardGrid extends StatelessWidget {
  final List<dynamic> machines;
  final Function(dynamic)? onItemTap;
  final int? selectedIndex;

  const MachineCardGrid({
    super.key,
    required this.machines,
    this.onItemTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final crossAxisCount = isTablet ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isTablet ? 16 : 12,
            mainAxisSpacing: isTablet ? 16 : 12,
            childAspectRatio: isTablet ? 1.1 : 0.95,
          ),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            return MachineCard(
              data: machines[index],
              isSelected: selectedIndex == index,
              onTap: () => onItemTap?.call(machines[index]),
            );
          },
        );
      },
    );
  }
}

/// Compact Machine Card untuk List View
class CompactMachineCard extends StatelessWidget {
  final dynamic data;
  final VoidCallback? onTap;

  const CompactMachineCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;
        final status = data['status']?.toString().toLowerCase() ?? 'idle';
        final statusColor = _getStatusColor(status);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 10 : 8),
            padding: EdgeInsets.all(isTablet ? 14 : 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Status Indicator
                Container(
                  width: 4,
                  height: isTablet ? 50 : 45,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: isTablet ? 14 : 12),

                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.precision_manufacturing_outlined,
                    size: isTablet ? 24 : 20,
                    color: statusColor,
                  ),
                ),
                SizedBox(width: isTablet ? 14 : 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['name']?.toString() ?? 'Mesin',
                        style: TextStyle(
                          fontSize: isTablet ? 15 : 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              data['code']?.toString() ?? '-',
                              style: TextStyle(
                                fontSize: isTablet ? 11 : 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          if (data['location'] != null) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: isTablet ? 14 : 12,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              data['location'].toString(),
                              style: TextStyle(
                                fontSize: isTablet ? 11 : 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 10 : 8,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusLabel(status),
                        style: TextStyle(
                          fontSize: isTablet ? 11 : 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                SizedBox(width: isTablet ? 10 : 8),
                Icon(
                  Icons.chevron_right,
                  size: isTablet ? 24 : 20,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
      case 'active':
        return Colors.green;
      case 'idle':
      case 'standby':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      case 'offline':
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'running':
      case 'active':
        return 'Running';
      case 'idle':
      case 'standby':
        return 'Idle';
      case 'maintenance':
        return 'Maintenance';
      case 'offline':
      case 'error':
        return 'Offline';
      default:
        return 'Unknown';
    }
  }
}
