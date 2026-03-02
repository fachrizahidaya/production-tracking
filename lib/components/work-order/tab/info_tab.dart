// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class InfoTab extends StatefulWidget {
  final data;
  final label;
  final isTablet;

  const InfoTab({
    super.key,
    this.isTablet,
    this.data,
    this.label,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardHeader(isTablet),
      ],
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CustomTheme().buttonColor('primary').withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ]),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        if (widget.data['urgent'] == true) ...[
                          SizedBox(width: 6),
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent[100],
                            size:
                                CustomTheme().iconSize(isTablet ? '2xl' : 'xl'),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      widget.data['created_at'] != null
                          ? 'Dibuat oleh ${widget.data['user']['name']} pada ${DateFormat("dd MMM yyyy, HH.mm").format(DateTime.parse(widget.data['created_at']))}'
                          : DateFormat("dd MMM yyyy")
                              .format(DateTime.parse(widget.data['wo_date'])),
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(isTablet),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
          _buildQuickInfoRow(isTablet),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildQuickInfoRow(bool isTablet) {
    return Container(
      padding: CustomTheme().padding(isTablet ? 'content' : 'card'),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.business_outlined,
              label: 'Qty Greige',
              value:
                  '${formatNumber(widget.data['greige_qty'])} ${widget.data['greige_unit']?['code']}',
              isTablet: isTablet,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.access_time_outlined,
              label: 'Proses saat ini',
              value: widget.data['current_process'] ?? '-',
              isTablet: isTablet,
            ),
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
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: CustomTheme().iconSize(isTablet ? 'xl' : 'lg'),
          color: Colors.white,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.white),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStatusBadge(bool isTablet) {
    return CustomBadge(
      title: widget.data['status']?.toString() ?? '-',
      withStatus: true,
      status: widget.data['status']?.toString() ?? '-',
    );
  }
}
