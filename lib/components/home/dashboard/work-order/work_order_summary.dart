import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/summary_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
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
    return CustomCard(
      child: Column(
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
                  ].separatedBy(const SizedBox(width: 8)),
                )
              ],
            ),
          ),
          DefaultTabController(
            length: 12,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                  color: isSelected
                                      ? Colors.blue.shade50
                                      : Colors.white,
                                  child: Padding(
                                    padding: PaddingColumn.screen,
                                    child: Text(type),
                                  ),
                                ),
                              );
                            })
                            .toList()
                            .separatedBy(SizedBox(
                              width: 8,
                            )),
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      isScrollable: true,
                      tabs: widget.data
                          ?.map<Widget>(
                              (item) => Tab(text: item?['name'] ?? ''))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 800,
                    child: TabBarView(
                      children: widget.data
                          ?.map<Widget>((item) => SummaryCard(
                                completed: item?['completed'],
                                inProgress: item?['in_progress'],
                                waiting: item?['waiting'],
                                sumary: item?['summary'],
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
