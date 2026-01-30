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
                isTablet
                    ? _buildTabletInfoLayout(isTablet)
                    : _buildMobileInfoLayout(),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              widget.data['wo_no']?.toString() ?? '-',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: CustomTheme()
                                    .fontSize(isTablet ? '2xl' : 'xl'),
                                fontWeight: CustomTheme().fontWeight('bold'),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (widget.data['urgent'] == true) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.yellowAccent,
                              size: isTablet ? 22 : 18,
                            ),
                          ],
                        ],
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

  Widget _buildTabletInfoLayout(isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInfoSection(
                title: 'Qty Greige',
                icon: Icons.layers_outlined,
                isTablet: isTablet,
                children: [
                  _buildInfoRow(
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
                  title: 'Catatan dari Work Order',
                  icon: Icons.description_outlined,
                  isTablet: isTablet,
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
          title: 'Qty Greige',
          icon: Icons.layers_outlined,
          isTablet: false,
          children: [
            _buildInfoRow(
              value:
                  '${formatNumber(widget.data['greige_qty'])} ${widget.data['greige_unit']?['code']}',
            ),
          ],
        ),
        if (widget.withNote == true)
          _buildInfoSection(
            title: 'Catatan dari Work Order',
            icon: Icons.description_outlined,
            isTablet: false,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left icon (same as buildInfoItem)
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

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title like label
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    color: Colors.grey[600],
                  ),
                ),

                // Section content (like value area)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ].separatedBy(CustomTheme().vGap('sm')),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('md')),
      ),
    );
  }

  Widget _buildInfoRow({
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
}
