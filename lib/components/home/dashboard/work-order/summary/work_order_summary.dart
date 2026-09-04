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
      case 'Semua':
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

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  String _formatDate(dynamic date) {
    if (date == null) return '-';

    DateTime? parsedDate;

    if (date is DateTime) {
      parsedDate = date;
    } else {
      parsedDate = DateTime.tryParse(date.toString());
    }

    if (parsedDate == null) {
      return date.toString();
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${parsedDate.day} '
        '${months[parsedDate.month - 1]} '
        '${parsedDate.year}';
  }

  Widget _buildDateRange() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_month_outlined,
          size: 30,
          color: CustomTheme().colors('text-secondary'),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            '${_formatDate(widget.dariTanggal)} - '
            '${_formatDate(widget.sampaiTanggal)}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: CustomTheme().colors('text-primary'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeContent() {
    if (widget.isFetching == true) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Padding(
            padding: CustomTheme().padding('content'),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (widget.data == null || widget.data!.isEmpty) {
      return NoData();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final items = widget.data!.map<Widget>((item) {
      final mappedItem = _mapApiToSummaryCard(item);

      return SummaryCard(
        data: mappedItem,
        showProgress: _showProgress,
        filter: processFilters[selectedIndex],
        isMobile: isMobile,
      );
    }).toList();

    // =========================
    // MOBILE
    // =========================
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              items[i],
            ],
          ],
        ),
      );
    }

    // =========================
    // TABLET
    // =========================
    final isSingleItem = widget.data!.length == 1;
    final screenWidthTablet = screenWidth * 0.95;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: isSingleItem
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      child: Row(
        children: widget.data!.map<Widget>((item) {
          final mappedItem = _mapApiToSummaryCard(item);

          return Padding(
            padding: CustomTheme().padding('card'),
            child: SizedBox(
              width: isSingleItem ? screenWidthTablet : 500,
              child: SummaryCard(
                data: mappedItem,
                showProgress: _showProgress,
                filter: processFilters[selectedIndex],
                isMobile: false,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Column(
      children: [
        DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                context,
                isMobile: isMobile,
                isTablet: isTablet,
              ),
              const Divider(),
              _buildSwipeContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required bool isMobile,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 20,
        isMobile ? 16 : 20,
        isMobile ? 16 : 20,
        isMobile ? 16 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // TITLE
          // =========================
          Text(
            'Perkembangan Proses Produksi',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isMobile
                  ? 16
                  : isTablet
                      ? 18
                      : 24,
              fontWeight: CustomTheme().fontWeight('bold'),
              color: CustomTheme().colors('text-primary'),
            ),
          ),

          const SizedBox(height: 4),

          // =========================
          // SUBTITLE
          // =========================
          Text(
            'Status tahapan work order',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isMobile
                  ? 12
                  : isTablet
                      ? 16
                      : 14,
              color: CustomTheme().colors('text-secondary'),
            ),
          ),

          SizedBox(
            height: isMobile ? 24 : 28,
          ),

          // =========================
          // DATE RANGE
          // =========================
          // Center(
          //   child: _buildDateRange(),
          // ),

          SizedBox(
            height: isMobile ? 20 : 24,
          ),

          // =========================
          // FILTER + REFRESH
          // =========================
          Center(
            child: _buildActionButtons(
              isMobile: isMobile,
              isTablet: isTablet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required bool isMobile,
    required bool isTablet,
  }) {
    final buttonWidth = isMobile
        ? 130.0
        : isTablet
            ? 140.0
            : 150.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: buttonWidth,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: _openFilter,
            icon: const Icon(
              Icons.tune_outlined,
              size: 20,
            ),
            label: const Text(
              'Filter',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: buttonWidth,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: widget.handleRefetch,
            icon: const Icon(
              Icons.refresh_outlined,
              size: 20,
            ),
            label: const Text(
              'Refresh',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // TITLE
          // =========================
          Text(
            'Status Proses Produksi',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24,
              fontWeight: CustomTheme().fontWeight('bold'),
              color: CustomTheme().colors('text-primary'),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Tracking progres setiap tahap work order',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: CustomTheme().colors('text-secondary'),
            ),
          ),

          const SizedBox(height: 28),

          // =========================
          // DATE
          // =========================
          // Center(
          //   child: _buildDateRange(),
          // ),

          const SizedBox(height: 20),

          // =========================
          // FILTER + REFRESH
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton(),
              const SizedBox(width: 10),
              _buildRefreshButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      onPressed: _openFilter,
      icon: const Icon(
        Icons.tune_outlined,
        size: 20,
      ),
      label: const Text('Filter'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return OutlinedButton.icon(
      onPressed: widget.handleRefetch,
      icon: const Icon(
        Icons.refresh_outlined,
        size: 20,
      ),
      label: const Text('Refresh'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
