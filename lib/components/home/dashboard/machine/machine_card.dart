import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  _buildHeader(isTablet),

                  // Content Section
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Machine Info Row
                        _buildMachineInfo(isTablet),

                        SizedBox(height: isTablet ? 16 : 12),

                        // Stats Section
                        _buildStatsSection(isTablet),

                        // Current Job (if any)
                        if (_hasCurrentJob()) ...[
                          SizedBox(height: isTablet ? 16 : 12),
                          _buildCurrentJob(isTablet),
                        ],
                      ],
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
      padding: EdgeInsets.all(isTablet ? 16 : 12),
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
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getMachineIcon(),
              size: isTablet ? 28 : 24,
              color: statusConfig['color'],
            ),
          ),
          SizedBox(width: isTablet ? 14 : 12),

          // Machine Name & Code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name']?.toString() ?? 'Mesin',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data['code']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize: isTablet ? 11 : 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    if (data['type'] != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        data['type'].toString(),
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Status Badge
          _buildStatusBadge(status, statusConfig, isTablet),
        ],
      ),
    );
  }

  /// Status Badge
  Widget _buildStatusBadge(
      String status, Map<String, dynamic> config, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: config['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config['color'].withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isTablet ? 8 : 6,
            height: isTablet ? 8 : 6,
            decoration: BoxDecoration(
              color: config['color'],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: config['color'].withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            config['label'],
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: config['color'],
            ),
          ),
        ],
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
        if (data['capacity'] != null) ...[
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.speed_outlined,
              label: 'Kapasitas',
              value:
                  '${formatNumber(data['capacity'])} ${data['capacity_unit'] ?? 'unit'}',
              isTablet: isTablet,
            ),
          ),
        ],
        // Last Maintenance
        if (data['last_maintenance'] != null) ...[
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: _buildInfoItem(
              icon: Icons.build_outlined,
              label: 'Maintenance',
              value: _formatDate(data['last_maintenance']),
              isTablet: isTablet,
            ),
          ),
        ],
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
      padding: EdgeInsets.all(isTablet ? 12 : 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CustomTheme().buttonColor('primary').withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: isTablet ? 16 : 14,
              color: CustomTheme().buttonColor('primary'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 10 : 9,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 13 : 12,
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

  /// Stats Section
  Widget _buildStatsSection(bool isTablet) {
    final stats = data['stats'] ?? {};

    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: isTablet ? 18 : 16,
                color: CustomTheme().buttonColor('primary'),
              ),
              const SizedBox(width: 8),
              Text(
                'Statistik Produksi',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 14 : 12),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'Total Proses',
                  value: stats['total_process'] ?? 0,
                  color: Colors.blue,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Expanded(
                child: _buildStatItem(
                  label: 'Selesai',
                  value: stats['completed'] ?? 0,
                  color: Colors.green,
                  isTablet: isTablet,
                ),
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Expanded(
                child: _buildStatItem(
                  label: 'Dalam Proses',
                  value: stats['in_progress'] ?? 0,
                  color: Colors.orange,
                  isTablet: isTablet,
                ),
              ),
            ],
          ),

          // Efficiency Bar (if available)
          if (stats['efficiency'] != null) ...[
            SizedBox(height: isTablet ? 14 : 12),
            _buildEfficiencyBar(stats['efficiency'], isTablet),
          ],
        ],
      ),
    );
  }

  /// Stat Item Widget
  Widget _buildStatItem({
    required String label,
    required int value,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            formatNumber(value),
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 10 : 9,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Efficiency Bar
  Widget _buildEfficiencyBar(dynamic efficiency, bool isTablet) {
    final efficiencyValue = (efficiency is num)
        ? efficiency.toDouble()
        : double.tryParse(efficiency.toString()) ?? 0;
    final progress = (efficiencyValue / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Efisiensi Mesin',
              style: TextStyle(
                fontSize: isTablet ? 12 : 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${efficiencyValue.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: isTablet ? 13 : 12,
                fontWeight: FontWeight.bold,
                color: _getEfficiencyColor(progress),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: isTablet ? 8 : 6,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: isTablet ? 8 : 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getEfficiencyColor(progress),
                      _getEfficiencyColor(progress).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: _getEfficiencyColor(progress).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Current Job Section
  Widget _buildCurrentJob(bool isTablet) {
    final currentJob = data['current_job'];
    if (currentJob == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.play_circle_outline,
                  size: isTablet ? 18 : 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Sedang Dikerjakan',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
              const Spacer(),
              // Live indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: isTablet ? 10 : 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 10),

          // Job Details
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WO Number',
                            style: TextStyle(
                              fontSize: isTablet ? 10 : 9,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentJob['wo_no']?.toString() ?? '-',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (currentJob['qty'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              formatNumber(currentJob['qty']),
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              currentJob['unit']?.toString() ?? 'pcs',
                              style: TextStyle(
                                fontSize: isTablet ? 10 : 9,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (currentJob['customer'] != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: isTablet ? 14 : 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currentJob['customer'].toString(),
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper Methods
  bool _hasCurrentJob() {
    return data['current_job'] != null;
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
      case 'running':
      case 'active':
      case 'aktif':
        return {
          'label': 'Berjalan',
          'color': Colors.green,
        };
      case 'idle':
      case 'standby':
        return {
          'label': 'Idle',
          'color': Colors.blue,
        };
      case 'maintenance':
      case 'perbaikan':
        return {
          'label': 'Maintenance',
          'color': Colors.orange,
        };
      case 'offline':
      case 'error':
      case 'rusak':
        return {
          'label': 'Offline',
          'color': Colors.red,
        };
      default:
        return {
          'label': 'Unknown',
          'color': Colors.grey,
        };
    }
  }

  IconData _getMachineIcon() {
    final type = data['type']?.toString().toLowerCase() ?? '';

    if (type.contains('dyeing')) {
      return Icons.color_lens_outlined;
    }
    if (type.contains('printing')) {
      return Icons.print_outlined;
    }
    if (type.contains('finishing')) {
      return Icons.auto_fix_high_outlined;
    }
    if (type.contains('washing')) {
      return Icons.local_laundry_service_outlined;
    }
    if (type.contains('dryer')) {
      return Icons.dry_cleaning_outlined;
    }

    return Icons.precision_manufacturing_outlined;
  }

  Color _getEfficiencyColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.6) return Colors.blue;
    if (progress >= 0.4) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(dynamic date) {
    if (date == null) return '-';
    try {
      final dateTime = DateTime.parse(date.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date.toString();
    }
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
