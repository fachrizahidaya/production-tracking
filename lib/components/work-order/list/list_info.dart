import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:html/parser.dart' as html_parser;

class ListInfo extends StatefulWidget {
  final data;

  const ListInfo({
    super.key,
    this.data,
  });

  @override
  State<ListInfo> createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: _buildWorkOrderCard(isTablet),
        );
      },
    );

    // CustomCard(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 widget.data['wo_no']?.toString() ?? '-',
    //                 style: TextStyle(
    //                     fontSize: CustomTheme().fontSize('lg'),
    //                     fontWeight: CustomTheme().fontWeight('bold')),
    //               ),
    //               if (isPortrait)
    //                 CustomBadge(
    //                   title: widget.data['status'] ?? '-',
    //                   status: widget.data['status'],
    //                   withStatus: true,
    //                 ),
    //               Text(
    //                   'Dibuat pada ${widget.data['wo_date'] != null ? DateFormat("dd MMMM yyyy").format(DateTime.parse(widget.data['wo_date'])) : '-'} oleh ${widget.data['user']?['name'] ?? ''}')
    //             ].separatedBy(CustomTheme().vGap('sm')),
    //           ),
    //           if (!isPortrait)
    //             CustomBadge(
    //               title: widget.data['status'] ?? '-',
    //               status: widget.data['status'],
    //               withStatus: true,
    //             ),
    //         ],
    //       ),
    //       ViewText(
    //           viewLabel: 'Qty Greige',
    //           viewValue: widget.data['greige_qty'] != null &&
    //                   widget.data['greige_qty'].toString().isNotEmpty
    //               ? '${NumberFormat("#,###.#").format(double.tryParse(widget.data['greige_qty'].toString()) ?? 0)} ${widget.data['greige_unit']?['code'] ?? ''}'
    //               : '-')
    //     ].separatedBy(CustomTheme().vGap('xl')),
    //   ),
    // );
  }

  Widget _buildWorkOrderCard(bool isTablet) {
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
          _buildCardHeader(isTablet),
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickInfoRow(isTablet),
                SizedBox(height: isTablet ? 20 : 16),
                isTablet ? _buildTabletInfoLayout() : _buildMobileInfoLayout(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CustomTheme().buttonColor('primary'),
            CustomTheme().buttonColor('primary').withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    size: isTablet ? 28 : 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Work Order',
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 11,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.data['wo_no']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(isTablet),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isTablet) {
    final status = widget.data['status']?.toString().toLowerCase() ?? 'pending';
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 14 : 12,
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
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: statusConfig['textColor'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoRow(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withOpacity(0.1),
        ),
      ),
      child: isTablet
          ? Row(
              children: [
                Expanded(
                  child: _buildQuickInfoItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Jumlah Greige',
                    value: _formatGreigeQty(),
                    isTablet: isTablet,
                  ),
                ),
                _buildVerticalDivider(),
                Expanded(
                  child: _buildQuickInfoItem(
                    icon: Icons.person_outline,
                    label: 'Customer',
                    value: widget.data['customer']?['name']?.toString() ?? '-',
                    isTablet: isTablet,
                  ),
                ),
                _buildVerticalDivider(),
                Expanded(
                  child: _buildQuickInfoItem(
                    icon: Icons.support_agent_outlined,
                    label: 'Marketing',
                    value: widget.data['marketing']?['name']?.toString() ?? '-',
                    isTablet: isTablet,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _buildQuickInfoItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Jumlah Greige',
                  value: _formatGreigeQty(),
                  isTablet: isTablet,
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickInfoItem(
                        icon: Icons.person_outline,
                        label: 'Customer',
                        value:
                            widget.data['customer']?['name']?.toString() ?? '-',
                        isTablet: isTablet,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickInfoItem(
                        icon: Icons.support_agent_outlined,
                        label: 'Marketing',
                        value: widget.data['marketing']?['name']?.toString() ??
                            '-',
                        isTablet: isTablet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildQuickInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
    bool isFullWidth = false,
  }) {
    return Row(
      mainAxisAlignment:
          isFullWidth ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 13,
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
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[300],
    );
  }

  Widget _buildTabletInfoLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInfoSection(
                title: 'Informasi Greige',
                icon: Icons.layers_outlined,
                children: [
                  _buildInfoRow(
                    label: 'Jenis Greige',
                    value: widget.data['greige']?['name']?.toString() ?? '-',
                  ),
                  _buildInfoRow(
                    label: 'Lebar Greige',
                    value: widget.data['greige_width'] != null
                        ? '${widget.data['greige_width']} cm'
                        : '-',
                  ),
                  _buildInfoRow(
                    label: 'Gramasi',
                    value: widget.data['gramasi'] != null
                        ? '${widget.data['gramasi']} gsm'
                        : '-',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              _buildInfoSection(
                title: 'Informasi Order',
                icon: Icons.description_outlined,
                children: [
                  _buildInfoRow(
                    label: 'Jenis Order',
                    value: widget.data['order_type']?.toString() ?? '-',
                  ),
                  _buildInfoRow(
                    label: 'Warna',
                    value: widget.data['color']?.toString() ?? '-',
                  ),
                  _buildInfoRow(
                    label: 'Keterangan',
                    value: widget.data['remarks']?.toString() ?? '-',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileInfoLayout() {
    return Column(
      children: [
        _buildInfoSection(
          title: 'Informasi Greige',
          icon: Icons.layers_outlined,
          children: [
            _buildInfoRow(
              label: 'Jenis Greige',
              value: widget.data['greige']?['name']?.toString() ?? '-',
            ),
            _buildInfoRow(
              label: 'Lebar Greige',
              value: widget.data['greige_width'] != null
                  ? '${widget.data['greige_width']} cm'
                  : '-',
            ),
            _buildInfoRow(
              label: 'Gramasi',
              value: widget.data['gramasi'] != null
                  ? '${widget.data['gramasi']} gsm'
                  : '-',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoSection(
          title: 'Informasi Order',
          icon: Icons.description_outlined,
          children: [
            _buildInfoRow(
              label: 'Jenis Order',
              value: widget.data['order_type']?.toString() ?? '-',
            ),
            _buildInfoRow(
              label: 'Warna',
              value: widget.data['color']?.toString() ?? '-',
            ),
            _buildInfoRow(
              label: 'Keterangan',
              value: widget.data['remarks']?.toString() ?? '-',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: CustomTheme().buttonColor('primary'),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            ':',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatGreigeQty() {
    if (widget.data['greige_qty'] == null ||
        widget.data['greige_qty'].toString().isEmpty) {
      return '-';
    }

    final qty = widget.data['greige_qty'];
    final unit = widget.data['greige_unit']?['code'] ?? '';

    if (qty is num) {
      return '${NumberFormat("#,###.#").format(qty)} $unit'.trim();
    }
    return '$qty $unit'.trim();
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return {
          'label': 'Selesai',
          'icon': Icons.check_circle,
          'bgColor': Colors.white,
          'textColor': Colors.green[700],
        };
      case 'in_progress':
      case 'proses':
        return {
          'label': 'Dalam Proses',
          'icon': Icons.hourglass_top,
          'bgColor': Colors.white,
          'textColor': Colors.blue[700],
        };
      case 'pending':
      case 'menunggu':
        return {
          'label': 'Menunggu',
          'icon': Icons.schedule,
          'bgColor': Colors.white,
          'textColor': Colors.orange[700],
        };
      case 'rework':
        return {
          'label': 'Rework',
          'icon': Icons.replay,
          'bgColor': Colors.white,
          'textColor': Colors.red[700],
        };
      default:
        return {
          'label': status,
          'icon': Icons.info_outline,
          'bgColor': Colors.white,
          'textColor': Colors.grey[700],
        };
    }
  }
}
