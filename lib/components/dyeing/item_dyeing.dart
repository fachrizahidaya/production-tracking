import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/custom_card.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemDyeing extends StatelessWidget {
  final item;
  final useCustomSize;
  final customWidth;
  final customHeight;

  const ItemDyeing(
      {super.key,
      this.item,
      this.customHeight,
      this.customWidth,
      this.useCustomSize});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return CustomCard(
        useCustomSize: useCustomSize,
        customWidth: customWidth,
        customHeight: customHeight,
        child: Padding(
            padding: PaddingColumn.screen,
            child: !isMobile
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${item.dyeing_no!}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (item.rework == true)
                                Icon(
                                  Icons.replay_outlined,
                                  size: 16,
                                )
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                          CustomBadge(
                              withStatus: true,
                              status: item.status,
                              title: item.status!,
                              withDifferentColor: true,
                              color: item.status == 'Diproses'
                                  ? Color(0xFFfff3c6)
                                  : Color(0xffd1fae4)),
                        ],
                      ),
                      Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${item.work_orders['wo_no']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              // Icon(
                              //   Icons.timelapse_outlined,
                              //   size: 14,
                              // ),
                              Text(
                                "Waktu Dibuat: ${formatDateSafe(item.start_time)}"
                                "${item.start_by != null && item.start_by['name'] != null ? ", ${item.start_by['name']}" : ""}",
                              ),
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_laundry_service_outlined,
                                size: 14,
                              ),
                              Text(
                                '${item.machine['name']}',
                              ),
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                          Row(
                            children: [
                              // Icon(
                              //   Icons.playlist_add_check_outlined,
                              //   size: 14,
                              // ),
                              Text(
                                "Waktu Selesai: ${formatDateSafe(item.end_time)}"
                                "${item.end_by != null && item.end_by['name'] != null ? ", ${item.end_by['name']}" : ""}",
                              ),
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${item.dyeing_no!}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (item.rework == true)
                                Icon(
                                  Icons.replay_outlined,
                                  size: 16,
                                )
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                          CustomBadge(
                              withStatus: true,
                              status: item.status,
                              title: item.status!,
                              withDifferentColor: true,
                              color: item.status == 'Diproses'
                                  ? Color(0xFFfff3c6)
                                  : Color(0xffd1fae4)),
                        ],
                      ),
                      Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${item.work_orders['wo_no']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_laundry_service_outlined,
                                    size: 14,
                                  ),
                                  Text(
                                    '${item.machine['name']}',
                                  ),
                                ].separatedBy(SizedBox(
                                  width: 4,
                                )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Waktu Dibuat: ${formatDateSafe(item.start_time)}"
                                "${item.start_by != null && item.start_by['name'] != null ? ", ${item.start_by['name']}" : ""}",
                              ),
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                          Row(
                            children: [
                              Text(
                                "Waktu Selesai: ${formatDateSafe(item.end_time)}"
                                "${item.end_by != null && item.end_by['name'] != null ? ", ${item.end_by['name']}" : ""}",
                              ),
                            ].separatedBy(SizedBox(
                              width: 4,
                            )),
                          ),
                        ].separatedBy(SizedBox(
                          height: 4,
                        )),
                      ),
                    ],
                  )));
  }
}
