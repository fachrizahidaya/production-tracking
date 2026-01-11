import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_detail_badge.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class DetailList extends StatefulWidget {
  final dynamic data;
  final String? processType;
  final VoidCallback? onRefresh;

  const DetailList({
    super.key,
    required this.data,
    this.processType,
    this.onRefresh,
  });

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final isLargeTablet = constraints.maxWidth > 900;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(isTablet),
              SizedBox(height: isTablet ? 24 : 16),

              // Main Content
              if (isTablet)
                _buildTabletLayout(isLargeTablet)
              else
                _buildMobileLayout(),
            ],
          ),
        );
      },
    );
  }

  /// Header Section dengan Work Order Info
  Widget _buildHeaderSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CustomTheme().buttonColor('primary'),
            CustomTheme().buttonColor('primary').withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CustomTheme().buttonColor('primary').withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Work Order',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data['work_orders']?['wo_number'] ?? '-',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(isTablet),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          // Quick Info Row
          _buildQuickInfoRow(isTablet),
        ],
      ),
    );
  }

  /// Status Badge
  Widget _buildStatusBadge(bool isTablet) {
    final status = widget.data['status'] ?? 'pending';
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: statusConfig['bgColor'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusConfig['icon'],
            size: isTablet ? 16 : 14,
            color: statusConfig['textColor'],
          ),
          const SizedBox(width: 6),
          Text(
            statusConfig['label'],
            style: TextStyle(
              fontSize: isTablet ? 13 : 11,
              fontWeight: FontWeight.w600,
              color: statusConfig['textColor'],
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Info Row di Header
  Widget _buildQuickInfoRow(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.calendar_today_outlined,
              label: 'Tanggal',
              value: widget.data['start_time'] != null
                  ? DateFormat("dd MMM yyyy")
                      .format(DateTime.parse(widget.data['start_time']))
                  : '-',
              isTablet: isTablet,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.inventory_2_outlined,
              label: 'Qty Greige',
              value: widget.data['work_orders']?['greige_qty'] != null
                  ? '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']?['code'] ?? ''}'
                  : '-',
              isTablet: isTablet,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.local_laundry_service_outlined,
              label: 'Mesin',
              value: widget.data['machine']?['name'] ?? '-',
              isTablet: isTablet,
            ),
          ),
        ],
      ),
    );
  }

  /// Quick Info Item
  Widget _buildQuickInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: isTablet ? 20 : 18,
          color: Colors.white.withOpacity(0.9),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 11 : 10,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 13 : 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Vertical Divider
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.2),
    );
  }

  /// Layout untuk Tablet
  Widget _buildTabletLayout(bool isLargeTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          flex: isLargeTablet ? 1 : 1,
          child: Column(
            children: [
              _buildInfoCard(
                title: 'Informasi Work Order',
                icon: Icons.description_outlined,
                child: _buildWorkOrderInfo(true),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Informasi Greige',
                icon: Icons.layers_outlined,
                child: _buildGreigeInfo(true),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Right Column
        Expanded(
          flex: isLargeTablet ? 1 : 1,
          child: Column(
            children: [
              _buildInfoCard(
                title: 'Informasi Proses',
                icon: Icons.settings_outlined,
                child: _buildProcessInfo(true),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Timeline',
                icon: Icons.timeline_outlined,
                child: _buildTimelineInfo(true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Layout untuk Mobile
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Informasi Work Order',
          icon: Icons.description_outlined,
          child: _buildWorkOrderInfo(false),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Informasi Greige',
          icon: Icons.layers_outlined,
          child: _buildGreigeInfo(false),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Informasi Proses',
          icon: Icons.settings_outlined,
          child: _buildProcessInfo(false),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: 'Timeline',
          icon: Icons.timeline_outlined,
          child: _buildTimelineInfo(false),
        ),
      ],
    );
  }

  /// Info Card Container
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        CustomTheme().buttonColor('primary').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  /// Work Order Info Section
  Widget _buildWorkOrderInfo(bool isTablet) {
    final items = [
      {
        'label': 'No. Work Order',
        'value': widget.data['work_orders']?['wo_no'] ?? '-',
        'id': widget.data['work_orders']?['id'] ?? '-',
        'icon': Icons.tag,
      },
      {
        'label': 'Customer',
        'value': widget.data['work_orders']?['customer']?['name'] ?? '-',
        'icon': Icons.person_outline,
      },
      {
        'label': 'Marketing',
        'value': widget.data['work_orders']?['marketing']?['name'] ?? '-',
        'icon': Icons.support_agent_outlined,
      },
      {
        'label': 'Jenis Order',
        'value': widget.data['work_orders']?['order_type'] ?? '-',
        'icon': Icons.category_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /// Greige Info Section
  Widget _buildGreigeInfo(bool isTablet) {
    final items = [
      {
        'label': 'Jenis Greige',
        'value': widget.data['work_orders']?['greige']?['name'] ?? '-',
        'icon': Icons.texture,
      },
      {
        'label': 'Qty Greige',
        'value': widget.data['work_orders']?['greige_qty'] != null
            ? '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']?['code'] ?? ''}'
            : '-',
        'icon': Icons.straighten,
      },
      {
        'label': 'Lebar Greige',
        'value': widget.data['work_orders']?['greige_width'] != null
            ? '${widget.data['work_orders']['greige_width']} cm'
            : '-',
        'icon': Icons.width_normal,
      },
      {
        'label': 'Gramasi',
        'value': widget.data['work_orders']?['gramasi'] != null
            ? '${widget.data['work_orders']['gramasi']} gsm'
            : '-',
        'icon': Icons.scale_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /// Process Info Section
  Widget _buildProcessInfo(bool isTablet) {
    final items = [
      {
        'label': 'Mesin',
        'value': widget.data['machine']?['name'] ?? '-',
        'icon': Icons.local_laundry_service_outlined,
      },
      {
        'label': 'Operator',
        'value': widget.data['operator']?['name'] ?? '-',
        'icon': Icons.engineering_outlined,
      },
      {
        'label': 'Shift',
        'value': widget.data['shift'] ?? '-',
        'icon': Icons.access_time_outlined,
      },
      {
        'label': 'Maklon',
        'value': widget.data['maklon'] == true
            ? (widget.data['maklon_name'] ?? 'Ya')
            : 'Tidak',
        'icon': Icons.business_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /// Timeline Info Section
  Widget _buildTimelineInfo(bool isTablet) {
    return Column(
      children: [
        _buildTimelineItem(
          icon: Icons.play_circle_outline,
          iconColor: Colors.blue,
          title: 'Mulai Proses',
          time: widget.data['start_time'],
          user: widget.data['start_by']?['name'],
          isFirst: true,
          isLast: widget.data['end_time'] == null,
        ),
        if (widget.data['end_time'] != null)
          _buildTimelineItem(
            icon: Icons.check_circle_outline,
            iconColor: Colors.green,
            title: 'Selesai Proses',
            time: widget.data['end_time'],
            user: widget.data['end_by']?['name'],
            isFirst: false,
            isLast: true,
          ),
      ],
    );
  }

  /// Info Grid Builder
  Widget _buildInfoGrid(List<Map<String, dynamic>> items, bool isTablet) {
    if (isTablet) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: items.map((item) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 100) / 4,
            child: _buildInfoItem(
              label: item['label'],
              value: item['value'],
              icon: item['icon'],
              id: item['id'].toString(),
              isTablet: isTablet,
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildInfoItem(
                  label: item['label'],
                  value: item['value'],
                  id: item['id'].toString(),
                  icon: item['icon'],
                  isTablet: isTablet,
                ),
              ))
          .toList(),
    );
  }

  /// Single Info Item
  Widget _buildInfoItem({
    required String label,
    required String value,
    required String id,
    required IconData icon,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: isTablet ? 18 : 16,
              color: CustomTheme().buttonColor('primary'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkOrderDetail(
                          id: id,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Timeline Item
  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    dynamic time,
    String? user,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey[300],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Timeline Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time != null
                            ? DateFormat("dd MMM yyyy, HH:mm")
                                .format(DateTime.parse(time))
                            : '-',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (user != null && user.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get Status Configuration
  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return {
          'label': 'Selesai',
          'icon': Icons.check_circle,
          'bgColor': Colors.green.withOpacity(0.2),
          'textColor': Colors.green[700],
        };
      case 'in_progress':
      case 'proses':
        return {
          'label': 'Dalam Proses',
          'icon': Icons.hourglass_top,
          'bgColor': Colors.blue.withOpacity(0.2),
          'textColor': Colors.blue[700],
        };
      case 'pending':
      case 'menunggu':
        return {
          'label': 'Menunggu',
          'icon': Icons.schedule,
          'bgColor': Colors.orange.withOpacity(0.2),
          'textColor': Colors.orange[700],
        };
      case 'rework':
        return {
          'label': 'Rework',
          'icon': Icons.replay,
          'bgColor': Colors.red.withOpacity(0.2),
          'textColor': Colors.red[700],
        };
      default:
        return {
          'label': status,
          'icon': Icons.info_outline,
          'bgColor': Colors.grey.withOpacity(0.2),
          'textColor': Colors.grey[700],
        };
    }
  }
}
