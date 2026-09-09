// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardHeader extends StatelessWidget {
  final dynamic data;
  final dynamic getProcessIcon;
  final bool isTablet;
  final dynamic item;
  final bool showDetails;
  final bool hasData;
  final dynamic shouldSkipProcess;

  const CardHeader(
      {super.key,
      this.data,
      this.getProcessIcon,
      this.hasData = false,
      this.isTablet = false,
      this.item,
      this.shouldSkipProcess,
      this.showDetails = true});

  @override
  Widget build(BuildContext context) {
    final status = data is List && data.isNotEmpty
        ? data.first['status']?.toString() ?? ''
        : '';
    final statusConfig = _getStatusConfig(status);

    return Container(
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusConfig['color'].withOpacity(0.08),
            statusConfig['color'].withOpacity(0.02),
          ],
        ),
        border: hasData && showDetails
            ? Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getProcessIcon(item['key']),
              size: isTablet ? 24 : 20,
              color: statusConfig['color'],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['label']?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.grey[800],
                  ),
                ),
                if (status.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: isTablet ? 8 : 6,
                        height: isTablet ? 8 : 6,
                        decoration: BoxDecoration(
                          color: statusConfig['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('sm'),
                          color: statusConfig['color'],
                          fontWeight: CustomTheme().fontWeight('bold'),
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('md')),
                  ),
              ].separatedBy(CustomTheme().vGap('xs')),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    if (status == 'Selesai') {
      return {
        'color': CustomTheme().colors('Selesai'),
      };
    }
    if (status == 'Diproses') {
      return {
        'color': CustomTheme().colors('Diproses'),
      };
    }
    return {
      'color': Colors.grey,
    };
  }
}
