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

  const CardHeader({
    super.key,
    this.data,
    this.getProcessIcon,
    this.isTablet = false,
    this.item,
    this.showDetails = true,
    this.hasData = false,
    this.shouldSkipProcess,
  });

  @override
  Widget build(BuildContext context) {
    final key = item['key'];

    final bool hasProcessData = data != null && data is List && data.isNotEmpty;

    bool isSkipped = shouldSkipProcess(key);

    /// ✅ KHUSUS STENTER

    /// ✅ STATUS
    String status = '';

    if (isSkipped) {
      status = 'Dilewati';
    } else if (hasProcessData) {
      status = data.first['status']?.toString() ?? '';
    }

    final statusConfig = _getStatusConfig(status);

    final displayTitle = item['label'] == 'Sorting' ? 'Sortir' : item['label'];

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
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: statusConfig['color'].withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getProcessIcon(item['label']),
              size: isTablet ? 24 : 20,
              color: statusConfig['color'],
            ),
          ),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.grey[800],
                  ),
                ),

                /// ✅ STATUS HANYA MUNCUL JIKA ADA
                if (status.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: isTablet ? 8 : 6,
                        height: isTablet ? 8 : 6,
                        decoration: BoxDecoration(
                          color: statusConfig['color'],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: statusConfig['color'].withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          statusConfig['label'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('sm'),
                            color: statusConfig['color'],
                            fontWeight: CustomTheme().fontWeight('bold'),
                          ),
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
    if (status.contains('Selesai')) {
      return {
        'label': 'Selesai',
        'color': CustomTheme().colors('Selesai'),
      };
    } else if (status.contains('Dilewati')) {
      return {
        'label': 'Dilewati',
        'color': CustomTheme().colors('primary'),
      };
    } else if (status.contains('Diproses')) {
      return {
        'label': 'Diproses',
        'color': CustomTheme().colors('Diproses'),
      };
    }

    /// ✅ DEFAULT KOSONG
    return {
      'label': '',
      'color': Colors.grey,
    };
  }
}
