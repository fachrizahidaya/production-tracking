import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardHeader extends StatelessWidget {
  final data;
  final getProcessIcon;
  final isTablet;
  final item;
  final showDetails;
  final hasData;
  const CardHeader(
      {super.key,
      this.data,
      this.getProcessIcon,
      this.isTablet,
      this.item,
      this.showDetails,
      this.hasData});

  @override
  Widget build(BuildContext context) {
    final bool hasProcessData = data.isNotEmpty;

    final String status = !hasProcessData
        ? 'Menunggu Diproses'
        : (data.first['status']?.toString() ?? 'Menunggu Diproses');

    final statusConfig = _getStatusConfig(status);

    return hasData
        ? Container(
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
                // Process Icon
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

                // Process Label & Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize:
                              CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                          color: Colors.grey[800],
                        ),
                      ),
                      Row(
                        children: [
                          // Status Indicator
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
                          Text(
                            statusConfig['label'],
                            style: TextStyle(
                              fontSize: CustomTheme().fontSize('sm'),
                              color: statusConfig['color'],
                              fontWeight: CustomTheme().fontWeight('bold'),
                            ),
                          ),
                          // Additional Info
                        ].separatedBy(CustomTheme().hGap('md')),
                      ),
                    ].separatedBy(CustomTheme().vGap('xs')),
                  ),
                ),

                // Expand/Action Button
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          )
        : Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.withOpacity(0.08),
                  Colors.orange.withOpacity(0.02),
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
                // Process Icon
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    getProcessIcon(item['label']),
                    size: isTablet ? 24 : 20,
                    color: Colors.orange,
                  ),
                ),

                // Process Label & Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize:
                              CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
                          fontWeight: CustomTheme().fontWeight('bold'),
                          color: Colors.grey[800],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            // statusConfig['label'],
                            'Menunggu Diproses',
                            style: TextStyle(
                              fontSize: CustomTheme().fontSize('sm'),
                              // color: statusConfig['color'],
                              fontWeight: CustomTheme().fontWeight('bold'),
                            ),
                          ),
                          // Additional Info
                        ].separatedBy(CustomTheme().hGap('md')),
                      ),
                    ].separatedBy(CustomTheme().vGap('xs')),
                  ),
                ),

                // Expand/Action Button
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
    } else {
      return {
        'label': 'Menunggu Diproses',
        'color': CustomTheme().colors('secondary'),
      };
    }
  }
}
