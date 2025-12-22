import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/card/summary_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderSummary extends StatefulWidget {
  final data;
  final handleRefetch;
  final handleProcess;
  final isFetching;
  final dariTanggal;
  final sampaiTanggal;
  final filterWidget;

  const WorkOrderSummary(
      {super.key,
      this.data,
      this.handleRefetch,
      this.isFetching,
      this.dariTanggal,
      this.filterWidget,
      this.sampaiTanggal,
      this.handleProcess});

  @override
  State<WorkOrderSummary> createState() => _WorkOrderSummaryState();
}

class _WorkOrderSummaryState extends State<WorkOrderSummary> {
  String selectedProcess = 'All';

  static const List<IconData> processIcons = [
    Icons.invert_colors_on_outlined,
    Icons.dry_outlined,
    Icons.dry_cleaning_outlined,
    Icons.air,
    Icons.cut_outlined,
    Icons.link_outlined,
    Icons.cut,
    Icons.link_outlined,
    Icons.numbers_outlined,
    Icons.print_outlined,
    Icons.sort,
    Icons.stacked_bar_chart_outlined,
    Icons.dangerous,
  ];

  String? _mapStatusFilter(String filter) {
    switch (filter) {
      case 'All':
        return '';
      case 'Selesai':
        return 'completed';
      case 'Diproses':
        return 'in_progress';
      case 'Menunggu Diproses':
        return 'waiting';
      default:
        return '';
    }
  }

  final List<String> processFilters = [
    'All',
    'Selesai',
    'Diproses',
    'Menunggu Diproses',
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: PaddingColumn.screen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Perkembangan Proses Produksi'),
                    Text(
                      'Status setiap tahapan Work Order',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: IconButton(
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.refresh_outlined,
                            ),
                          ],
                        ),
                        onPressed: () {
                          widget.handleRefetch();
                        },
                      ),
                    ),
                  ].separatedBy(CustomTheme().hGap('lg')),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: PaddingColumn.screen,
              child: Row(
                children: processFilters
                    .map((type) {
                      bool isSelected = selectedProcess == type;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedProcess = type;
                          });
                          final mappedStatus = _mapStatusFilter(type);

                          widget.handleRefetch(
                            status: mappedStatus,
                            fromDate: widget.dariTanggal,
                            toDate: widget.sampaiTanggal,
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                              width: 1.0,
                            ),
                          ),
                          elevation: isSelected ? 3 : 1,
                          color:
                              isSelected ? Colors.blue.shade50 : Colors.white,
                          child: Padding(
                            padding: PaddingColumn.screen,
                            child: Text(type),
                          ),
                        ),
                      );
                    })
                    .toList()
                    .separatedBy(CustomTheme().hGap('lg')),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: CustomTheme().padding('content'),
            child: SizedBox(
              height: 500,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = widget.data![index];
                        return SummaryCard(
                          data: item,
                          icon: item['name'] == 'Dyeing'
                              ? processIcons[0]
                              : item['name'] == 'Press'
                                  ? processIcons[1]
                                  : item['name'] == 'Tumbler'
                                      ? processIcons[2]
                                      : item['name'] == 'Stenter'
                                          ? processIcons[3]
                                          : item['name'] == 'Long Sitting'
                                              ? processIcons[4]
                                              : item['name'] == 'Long Hemming'
                                                  ? processIcons[5]
                                                  : item['name'] ==
                                                          'Cross Cutting'
                                                      ? processIcons[6]
                                                      : item['name'] == 'Sewing'
                                                          ? processIcons[7]
                                                          : item['name'] ==
                                                                  'Embroidery'
                                                              ? processIcons[8]
                                                              : item['name'] ==
                                                                      'Printing'
                                                                  ? processIcons[
                                                                      9]
                                                                  : item['name'] ==
                                                                          'Sorting'
                                                                      ? processIcons[
                                                                          10]
                                                                      : processIcons[
                                                                          11],
                        );
                      },
                      childCount: widget.data!.length,
                    ),
                  ),
                ],
              ),
              //    Column(
              //   children: widget.data!
              //       .map<Widget>((item) => SummaryCard(
              //             data: item,
              //             icon: item['name'] == 'Dyeing'
              //                 ? processIcons[0]
              //                 : item['name'] == 'Press'
              //                     ? processIcons[1]
              //                     : item['name'] == 'Tumbler'
              //                         ? processIcons[2]
              //                         : item['name'] == 'Stenter'
              //                             ? processIcons[3]
              //                             : item['name'] == 'Long Sitting'
              //                                 ? processIcons[4]
              //                                 : item['name'] == 'Long Hemming'
              //                                     ? processIcons[5]
              //                                     : item['name'] ==
              //                                             'Cross Cutting'
              //                                         ? processIcons[6]
              //                                         : item['name'] == 'Sewing'
              //                                             ? processIcons[7]
              //                                             : item['name'] ==
              //                                                     'Embroidery'
              //                                                 ? processIcons[8]
              //                                                 : item['name'] ==
              //                                                         'Printing'
              //                                                     ? processIcons[
              //                                                         9]
              //                                                     : item['name'] ==
              //                                                             'Sorting'
              //                                                         ? processIcons[
              //                                                             10]
              //                                                         : processIcons[
              //                                                             11],
              //           ))
              //       .toList(),
              // ),
            ),
          )
        ],
      ),
    );
  }
}
