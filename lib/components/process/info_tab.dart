// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class InfoTab extends StatefulWidget {
  final data;
  final label;
  final isTablet;
  final withNote;

  const InfoTab(
      {super.key, this.isTablet, this.data, this.label, this.withNote = false});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildWorkOrderCard(widget.isTablet),
    );
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
            padding: CustomTheme().padding('card'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      padding: CustomTheme().padding('card'),
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
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
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
                  padding: CustomTheme().padding('card'),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    size: isTablet ? 28 : 24,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['wo_no']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize:
                              CustomTheme().fontSize(isTablet ? '2xl' : 'xl'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.data['created_at'] != null
                            ? DateFormat("dd MMM yyyy").format(
                                DateTime.parse(widget.data['created_at']))
                            : DateFormat("dd MMM yyyy")
                                .format(DateTime.parse(widget.data['wo_date'])),
                        style: TextStyle(
                          fontSize:
                              CustomTheme().fontSize(isTablet ? 'md' : 'sm'),
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: CustomTheme().fontWeight('semibold'),
                        ),
                      ),
                    ],
                  ),
                ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),
          _buildStatusBadge(isTablet),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isTablet) {
    return CustomBadge(
      title: widget.data['status']?.toString() ?? '-',
      withStatus: true,
      status: widget.data['status']?.toString() ?? '-',
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
                    label: 'Qty Greige',
                    value: _formatGreigeQty(),
                    isTablet: isTablet,
                  ),
                ),
                _buildVerticalDivider(),
              ],
            )
          : Column(
              children: [
                _buildQuickInfoItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Qty Greige',
                  value: _formatGreigeQty(),
                  isTablet: isTablet,
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [],
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
                    label: 'Qty Greige',
                    value:
                        '${formatNumber(widget.data['greige_qty'])} ${widget.data['greige_unit']?['code']}',
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.withNote == true)
          Expanded(
            child: Column(
              children: [
                _buildInfoSection(
                  title: 'Catatan Work Order',
                  icon: Icons.description_outlined,
                  children: [
                    _buildInfo(
                      value: _getNoteContentByLabel(
                        notes: widget.data['notes'],
                        label: widget.label,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
      ].separatedBy(CustomTheme().hGap('xl')),
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
              label: 'Qty Greige',
              value:
                  '${formatNumber(widget.data['greige_qty'])} ${widget.data['greige_unit']?['code']}',
            ),
          ],
        ),
        if (widget.withNote == true)
          _buildInfoSection(
            title: 'Catatan Work Order',
            icon: Icons.description_outlined,
            children: [
              _buildInfo(
                  value: widget.data['notes'] is Map
                      ? htmlToPlainText(widget.data['notes'][widget.label])
                      : 'No Data')
            ],
          ),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ].separatedBy(CustomTheme().hGap('lg')),
            ),
            const Divider(height: 1),
            ...children,
          ].separatedBy(
            CustomTheme().vGap('xl'),
          ),
        ));
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[800],
            ),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('lg')),
    );
  }

  String _getNoteContentByLabel({
    required dynamic notes,
    required String label,
  }) {
    if (notes == null || notes is! List) return 'No Data';

    final note = notes.whereType<Map<String, dynamic>>().firstWhere(
          (n) => n['label'] == label,
          orElse: () => {},
        );

    final content = note['content'];

    if (content == null || content.toString().isEmpty) {
      return 'No Data';
    }

    return htmlToPlainText(content.toString());
  }

  Widget _buildInfo({
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.grey[800],
          ),
        ),
      ],
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
}
