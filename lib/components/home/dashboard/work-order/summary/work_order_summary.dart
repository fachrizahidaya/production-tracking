import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/summary_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderSummary extends StatefulWidget {
  final data;
  final handleRefetch;
  final dariTanggal;
  final sampaiTanggal;
  final filterWidget;
  final isFetching;

  const WorkOrderSummary(
      {super.key,
      this.data,
      this.handleRefetch,
      this.dariTanggal,
      this.filterWidget,
      this.sampaiTanggal,
      this.isFetching});

  @override
  State<WorkOrderSummary> createState() => _WorkOrderSummaryState();
}

class _WorkOrderSummaryState extends State<WorkOrderSummary>
    with TickerProviderStateMixin {
  String selectedProcess = 'All';
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: processFilters.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      setState(() {
        selectedIndex = _tabController.index;
      });

      _refetchByTab(_tabController.index);
    });
    super.initState();
  }

  void _refetchByTab(int index) {
    final status = _mapStatusFilter(processFilters[index]);

    widget.handleRefetch(
      status: status,
      fromDate: widget.dariTanggal,
      toDate: widget.sampaiTanggal,
    );
  }

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
    'Semua',
    'Selesai',
    'Diproses',
    'Menunggu Diproses',
  ];

  int selectedIndex = 0;

  void _openFilter() {
    if (widget.filterWidget != null) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _showProgress {
    final filter = processFilters[selectedIndex];
    return filter == 'Semua';
  }

  Widget _buildProcessFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: CustomTheme().padding('badge'),
        child: Row(
          children: List.generate(processFilters.length, (index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });

                // _tabController.animateTo(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? CustomTheme().buttonColor('primary')
                        : Colors.grey.shade400,
                  ),
                  color: isSelected
                      ? CustomTheme().buttonColor('primary')
                      : Colors.white,
                  boxShadow: [CustomTheme().boxShadowTheme()],
                ),
                padding: CustomTheme().padding('badge'),
                child: Text(
                  processFilters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).separatedBy(CustomTheme().hGap('lg')),
        ),
      ),
    );
  }

  Widget _buildSwipeContent() {
    if (widget.isFetching == true) {
      return Center(
        child: Padding(
          padding: CustomTheme().padding('content'),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.data == null || widget.data!.isEmpty) {
      return NoData();
    }

    return
        // TabBarView(
        //   controller: _tabController,
        //   children:
        //   processFilters.map((filter) {
        //     return
        SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.data!.map<Widget>((item) {
          return Padding(
            padding: CustomTheme().padding('card'),
            child: SizedBox(
              width: 500,
              child: SummaryCard(
                data: item,
                showProgress: _showProgress,
                filter: processFilters[selectedIndex],
              ),
            ),
          );
        }).toList(),
      ),
    );
    //   }).toList(),
    // ),
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
          _buildProcessFilter(),
          Divider(),
          _buildSwipeContent()
        ],
      ),
    );
  }
}
