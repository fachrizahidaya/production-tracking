import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/dasboard_card.dart';

class WorkOrderStatus extends StatefulWidget {
  const WorkOrderStatus({super.key});

  @override
  State<WorkOrderStatus> createState() => _WorkOrderStatusState();
}

class _WorkOrderStatusState extends State<WorkOrderStatus> {
  @override
  Widget build(BuildContext context) {
    return DasboardCard()
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     CustomTitle(text: 'Work Order Status'),
        //     SizedBox(
        //       height: 200,
        //     )
        //   ].separatedBy(SizedBox(
        //     height: 16,
        //   )),
        // )
        ;
  }
}
