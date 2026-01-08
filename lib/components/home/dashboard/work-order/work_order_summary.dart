import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/card/summary_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
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

  void _openFilter() {
    if (widget.filterWidget != null) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return widget.filterWidget!;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: CustomTheme().padding('card'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Perkembangan Proses Produksi'),
                    Text(
                      'Status setiap tahapan Work Order',
                      style: TextStyle(
                          fontSize: CustomTheme().fontSize('sm'),
                          color: CustomTheme().colors('text-secondary')),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh_outlined,
                      ),
                      onPressed: () {
                        widget.handleRefetch();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                      ),
                      onPressed: () {
                        _openFilter();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: CustomTheme().padding('badge'),
              child: Row(
                children: processFilters
                    .map((type) {
                      bool isSelected = selectedProcess == type;

                      final mappedStatus = _mapStatusFilter(type);

                      widget.handleRefetch(
                        status: mappedStatus,
                        fromDate: widget.dariTanggal,
                        toDate: widget.sampaiTanggal,
                      );

                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedProcess = type;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                  color: isSelected
                                      ? CustomTheme().buttonColor('primary')
                                      : Colors.grey.shade400,
                                  width: 1),
                              color: isSelected
                                  ? CustomTheme().buttonColor('primary')
                                  : Colors.white,
                              boxShadow: [CustomTheme().boxShadowTheme()],
                            ),
                            padding: CustomTheme().padding('badge'),
                            child: Text(
                              type,
                              style: TextStyle(
                                  color: isSelected ? Colors.white : null),
                            ),
                          ));
                    })
                    .toList()
                    .separatedBy(CustomTheme().hGap('lg')),
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: 500,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = widget.data![index];
                      return Padding(
                        padding: CustomTheme().padding('badge'),
                        child: SummaryCard(
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
                        ),
                      );
                    },
                    childCount: widget.data!.length,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
