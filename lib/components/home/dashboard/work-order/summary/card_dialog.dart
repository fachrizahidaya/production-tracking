import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/pulse_icon.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class CardDialog extends StatelessWidget {
  final title;
  final woList;
  const CardDialog({super.key, this.title, this.woList});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: screenWidth * 0.5,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 300,
            maxHeight: screenHeight * 0.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      title == 'Selesai'
                          ? Icons.task_alt_outlined
                          : title == 'Diproses'
                              ? Icons.access_time_outlined
                              : title == 'Dilewati'
                                  ? Icons.fast_forward_outlined
                                  : Icons.error_outline,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          height: 1),
                    ),
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ),
              Divider(),
              Flexible(
                child: woList.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada Work Order',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('lg'),
                            color: Colors.grey[500],
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: woList.length,
                        separatorBuilder: (_, __) => Divider(),
                        itemBuilder: (context, index) {
                          final wo = woList[index];
                          final woNo = wo['wo_no'] ?? '-';
                          final bool isUrgent = wo['urgent'] == true;
                          final bool isOverdue = wo['overdue'] == true;
                          final String overdueDays =
                              wo['overdue_days']?.toString() ?? '0';
                          final createdAt = wo['reference_date'];

                          return ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (isOverdue)
                                      PulseIcon(
                                        icon: Icons.circle,
                                        color: Colors.redAccent,
                                        size: CustomTheme().iconSize('sm'),
                                      ),
                                    Text(
                                      woNo,
                                      style: TextStyle(
                                        fontWeight: CustomTheme()
                                            .fontWeight('semibold'),
                                      ),
                                    ),
                                    if (isUrgent)
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    Spacer(),
                                    Text(
                                      createdAt != null
                                          ? DateFormat("dd MMM yyyy")
                                              .format(DateTime.parse(createdAt))
                                          : '-',
                                      style: TextStyle(
                                        fontSize: CustomTheme().fontSize('sm'),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ].separatedBy(CustomTheme().hGap('sm')),
                                ),
                                SizedBox(height: 4),
                                if (isOverdue)
                                  Row(
                                    children: [
                                      Text(
                                        'Terlambat $overdueDays hari',
                                        style: TextStyle(
                                          fontSize:
                                              CustomTheme().fontSize('sm'),
                                          color: Colors.redAccent,
                                          fontWeight: CustomTheme()
                                              .fontWeight('semibold'),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Harus segera diproses',
                                        style: TextStyle(
                                          fontSize:
                                              CustomTheme().fontSize('sm'),
                                          color: Colors.red,
                                          fontWeight: CustomTheme()
                                              .fontWeight('semibold'),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WorkOrderDetail(
                                    id: wo['wo_id'].toString(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
