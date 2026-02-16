import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/summary_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

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
  int selectedIndex = 0;

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
      case 'Dilewati':
        return 'skipped';
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
    'Dilewati',
    'Diproses',
    'Menunggu Diproses',
  ];

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

  Map<String, dynamic> _mapApiToSummaryCard(Map<String, dynamic> item) {
    final waitingList = item['waiting'] as List? ?? [];
    final onProgressList = item['in_progress'] as List? ?? [];
    final finishedList = item['completed'] as List? ?? [];
    final skippedList = item['skipped'] as List? ?? [];

    return {
      'name': item['process_name'],
      'summary': {
        'completed': finishedList.length,
        'in_progress': onProgressList.length,
        'waiting': waitingList.length,
        'skipped': skippedList.length,
      },
      'waiting': waitingList,
      'in_progress': onProgressList,
      'completed': finishedList,
      'skipped': skippedList,
      'hasOverdueWaiting': _hasOverdueWaiting(waitingList),
    };
  }

  bool _hasOverdueWaiting(List waiting) {
    return waiting.any((wo) => wo['overdue'] == true);
  }

  Widget _buildSwipeContent() {
    if (widget.isFetching == true) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Padding(
            padding: CustomTheme().padding('content'),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (widget.data == null || widget.data!.isEmpty) {
      return NoData();
    }

    final isSingleItem = widget.data!.length == 1;
    final screenWidth = MediaQuery.of(context).size.width * 0.9;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: isSingleItem
          ? NeverScrollableScrollPhysics()
          : BouncingScrollPhysics(),
      child: Row(
        children: widget.data!.map<Widget>((item) {
          final mappedItem = _mapApiToSummaryCard(item);

          return Padding(
            padding: CustomTheme().padding('card'),
            child: SizedBox(
              width: isSingleItem ? screenWidth : 500,
              child: SummaryCard(
                data: mappedItem,
                showProgress: _showProgress,
                filter: processFilters[selectedIndex],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardCard(
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
                        Text(
                          'Perkembangan Proses Produksi',
                          style:
                              TextStyle(fontSize: CustomTheme().fontSize('lg')),
                        ),
                        Text(
                          'Status setiap tahapan Work Order',
                          style: TextStyle(
                              fontSize: CustomTheme().fontSize('md'),
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
              Divider(),
              _buildSwipeContent()
            ],
          ),
        ),
      ],
    );
  }
}
