import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class MachineCard extends StatelessWidget {
  final Map data;
  final bool isPortrait;

  const MachineCard({
    super.key,
    required this.data,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    Widget text(String value, double width) {
      return isPortrait
          ? Text(value, overflow: TextOverflow.ellipsis)
          : Text(value, overflow: TextOverflow.ellipsis);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomCard(
        withBadgeBorder: true,
        withBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomBadge(
                          title: data['code'],
                          rework: true,
                          status: 'Menunggu Diproses',
                        ),
                      ],
                    ),
                    text(data['name'], 150),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    text(data['location'], 100),
                  ].separatedBy(CustomTheme().hGap('lg')),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: data['used_by']?.length != 0
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (data['used_by']?.length != 0)
                  ViewText<Map<String, dynamic>>(
                    viewLabel: 'Work Order',
                    viewValue: data['used_by'][0]?['wo_no']?.toString() ?? '-',
                    item: data['used_by'][0],
                    onItemTap: (context, workOrder) {
                      if (workOrder['wo_id'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkOrderDetail(
                              id: workOrder['wo_id'].toString(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                CustomBadge(
                  title: data['process_type'],
                  forMachine: true,
                ),
              ],
            ),
          ].separatedBy(CustomTheme().vGap('lg')),
        ),
      ),
    );
  }
}
