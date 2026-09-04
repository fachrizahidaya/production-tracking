import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/work-order/summary/summary_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderSummary extends StatefulWidget {
  final data;
  final greigeData;
  final handleRefetch;
  final dariTanggal;
  final sampaiTanggal;
  final filterWidget;
  final isFetching;
  final bool isMobile;
  final void Function(String startDate, String endDate)? onDateRangeSelected;

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 025659bb (fix: dashboard mobile)
  const WorkOrderSummary({
    super.key,
    this.data,
    this.greigeData,
    this.handleRefetch,
    this.dariTanggal,
    this.filterWidget,
    this.sampaiTanggal,
    this.isFetching,
    this.isMobile = true,
    this.onDateRangeSelected,
  });
<<<<<<< HEAD
=======
  const WorkOrderSummary(
      {super.key,
      this.data,
      this.greigeData,
      this.handleRefetch,
      this.dariTanggal,
      this.filterWidget,
      this.sampaiTanggal,
      this.isFetching});
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
=======
>>>>>>> 025659bb (fix: dashboard mobile)

  @override
  State<WorkOrderSummary> createState() => _WorkOrderSummaryState();
}

class _WorkOrderSummaryState extends State<WorkOrderSummary>
    with TickerProviderStateMixin {
  String selectedProcess = 'All';
  late TabController _tabController;
  int selectedIndex = 0;
<<<<<<< HEAD
<<<<<<< HEAD
  String selectedCategory = 'production';
=======
  int selectedSummaryIndex = 0;
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
=======
  String selectedCategory = 'production';
>>>>>>> 025659bb (fix: dashboard mobile)

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

  Future<void> _selectDateRange(BuildContext sheetContext) async {
    final now = DateTime.now();
    final start =
        _parseDate(widget.dariTanggal) ?? DateTime(now.year, now.month, 1);
    final end = _parseDate(widget.sampaiTanggal) ?? now;

    final picked = await showDateRangePicker(
      context: sheetContext,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(start: start, end: end),
    );

    if (picked == null) return;

    widget.onDateRangeSelected?.call(
      _toApiDate(picked.start),
      _toApiDate(picked.end),
    );

    if (sheetContext.mounted) {
      Navigator.pop(sheetContext);
    }
  }

  void _openDateFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 64.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: CustomTheme().padding('card-detail'),
                  child: Text(
                    'Filter Proses Produksi',
                    style: TextStyle(
                      height: 1,
                      fontSize: CustomTheme().fontSize('xl'),
                      fontWeight: CustomTheme().fontWeight('bold'),
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  padding: CustomTheme().padding('card-detail'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal',
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('md'),
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDateRange(sheetContext),
                        child: Container(
                          width: double.infinity,
                          decoration: CustomTheme().cardTheme(),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '${_formatDate(widget.dariTanggal)} - '
                            '${_formatDate(widget.sampaiTanggal)}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ].separatedBy(CustomTheme().vGap('xl')),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  bool get _isGreigeActive => selectedCategory == 'greige';

  bool get _isDateFiltered {
    final now = DateTime.now();
    final defaultStart = DateTime(now.year, now.month, 1);
    final start = _parseDate(widget.dariTanggal);
    final end = _parseDate(widget.sampaiTanggal);

    if (start == null || end == null) return false;

    final sameStart = start.year == defaultStart.year &&
        start.month == defaultStart.month &&
        start.day == defaultStart.day;
    final sameEnd =
        end.year == now.year && end.month == now.month && end.day == now.day;

    return !(sameStart && sameEnd);
  }

  List<dynamic> get _activeData {
    final data = _isGreigeActive ? widget.greigeData : widget.data;
    return data is List ? data : [];
  }

  Widget _buildHeaderIconButton({
    required Widget icon,
    required VoidCallback? onPressed,
    required bool isMobile,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: isMobile ? 20 : 24,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      visualDensity: VisualDensity.compact,
    );
  }

=======
=======
  bool get _hasProductionData => widget.data is List && widget.data.isNotEmpty;
=======
  bool get _isGreigeActive => selectedCategory == 'greige';
>>>>>>> 025659bb (fix: dashboard mobile)

  bool get _isDateFiltered {
    final now = DateTime.now();
    final defaultStart = DateTime(now.year, now.month, 1);
    final start = _parseDate(widget.dariTanggal);
    final end = _parseDate(widget.sampaiTanggal);

    if (start == null || end == null) return false;

    final sameStart = start.year == defaultStart.year &&
        start.month == defaultStart.month &&
        start.day == defaultStart.day;
    final sameEnd =
        end.year == now.year && end.month == now.month && end.day == now.day;

    return !(sameStart && sameEnd);
  }

>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)
  List<dynamic> get _activeData {
    final data = _isGreigeActive ? widget.greigeData : widget.data;
    return data is List ? data : [];
  }

<<<<<<< HEAD
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
=======
  Widget _buildHeaderIconButton({
    required Widget icon,
    required VoidCallback? onPressed,
    required bool isMobile,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: isMobile ? 20 : 24,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      visualDensity: VisualDensity.compact,
    );
  }

>>>>>>> 025659bb (fix: dashboard mobile)
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

  String? _processRoute(String? name) {
    if (name == null || name.isEmpty) return null;

    final key = name.trim().toLowerCase();

    const routes = {
      'dyeing': '/dyeings',
      'press': '/press',
      'tumbler': '/tumblers',
      'stenter': '/stenters',
      'long slitting': '/long-slittings',
      'long sitting': '/long-slittings',
      'long hemming': '/long-hemmings',
      'cross cutting': '/cross-cuttings',
      'sewing': '/sewings',
      'embroidery': '/embroideries',
      'sorting': '/sortings',
      'packing': '/packings',
      'printing': '/printings',
      'weaving': '/weavings',
      'sizing': '/sizings',
      'warping': '/warpings',
      'shearing': '/shearings',
      'dyeing preparation': '/dyeing-preparations',
      'persiapan dyeing': '/dyeing-preparations',
    };

    return routes[key];
  }

  void _navigateToProcess(BuildContext context, String? name) {
    final route = _processRoute(name);
    if (route == null) return;
    Navigator.pushNamed(context, route);
  }

  bool _hasOverdueWaiting(List waiting) {
    return waiting.any((wo) => wo['overdue'] == true);
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

>>>>>>> 260d45ce (fix: dashboard)
=======
>>>>>>> 025659bb (fix: dashboard mobile)
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
<<<<<<< HEAD
<<<<<<< HEAD
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}';
  }

  String _toApiDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    return DateTime.tryParse(date.toString());
=======
      'May',
=======
      'Mei',
>>>>>>> 025659bb (fix: dashboard mobile)
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${parsedDate.day} ${months[parsedDate.month - 1]} ${parsedDate.year}';
  }

<<<<<<< HEAD
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
>>>>>>> 260d45ce (fix: dashboard)
=======
  String _toApiDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    return DateTime.tryParse(date.toString());
>>>>>>> 025659bb (fix: dashboard mobile)
  }

  Widget _buildSwipeContent() {
    final isTablet = !widget.isMobile;
    final listHeight = isTablet
        ? (_showProgress ? 220.0 : 150.0)
        : (_showProgress ? 170.0 : 140.0);

    if (widget.isFetching == true) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Padding(
            padding: CustomTheme().padding('content'),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_activeData.isEmpty) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 025659bb (fix: dashboard mobile)
      return const SizedBox(
        height: 120,
        child: NoData(),
      );
<<<<<<< HEAD
    }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    return SizedBox(
      height: listHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth * (isTablet ? 0.55 : 0.68))
              .clamp(
                isTablet ? 360.0 : 220.0,
                isTablet ? 440.0 : 260.0,
              )
              .toDouble();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _activeData.length,
            itemBuilder: (context, index) {
              final mappedItem = _mapApiToSummaryCard(_activeData[index]);
              final isLast = index == _activeData.length - 1;

              return SizedBox(
                width: cardWidth,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, isLast ? 16 : 0, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SummaryCard(
                      data: mappedItem,
                      showProgress: _showProgress,
                      filter: processFilters[selectedIndex],
                      isGreige: _isGreigeActive,
                      onTap: () => _navigateToProcess(
                        context,
                        mappedItem['name']?.toString(),
                      ),
                    ),
                  ),
                ),
              );
            },
=======
=======
>>>>>>> 73378bdd (fix: UI mobile dashboard)
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
<<<<<<< HEAD
=======
>>>>>>> 3bba1171 (fix: filter summary)
=======
>>>>>>> 73378bdd (fix: UI mobile dashboard)
=======
>>>>>>> 51527bb3 (fix: filter summary)
    final isSingleItem = widget.data!.length == 1;
=======
      return NoData();
    }

    final isSingleItem = _activeData.length == 1;
>>>>>>> 720fcd7c (fix: dashboard work order summary untuk greige)
    final screenWidth = MediaQuery.of(context).size.width * 0.95;
=======
    }

    return SizedBox(
      height: listHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth * (isTablet ? 0.55 : 0.68))
              .clamp(
                isTablet ? 360.0 : 220.0,
                isTablet ? 440.0 : 260.0,
              )
              .toDouble();
>>>>>>> 025659bb (fix: dashboard mobile)

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _activeData.length,
            itemBuilder: (context, index) {
              final mappedItem = _mapApiToSummaryCard(_activeData[index]);
              final isLast = index == _activeData.length - 1;

<<<<<<< HEAD
          return Padding(
            padding: CustomTheme().padding('card'),
            child: SizedBox(
              width: isSingleItem ? screenWidth : 500,
              child: SummaryCard(
                data: mappedItem,
                showProgress: _showProgress,
                filter: processFilters[selectedIndex],
                isGreige: _isGreigeActive,
              ),
            ),
>>>>>>> d86a31e7 (fix: UI mobile dashboard)
=======
              return SizedBox(
                width: cardWidth,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, isLast ? 16 : 0, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SummaryCard(
                      data: mappedItem,
                      showProgress: _showProgress,
                      filter: processFilters[selectedIndex],
                      isGreige: _isGreigeActive,
                      onTap: () => _navigateToProcess(
                        context,
                        mappedItem['name']?.toString(),
                      ),
                    ),
                  ),
                ),
              );
            },
>>>>>>> 025659bb (fix: dashboard mobile)
          );
        },
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile: widget.isMobile),
            _buildCategoryTabs(),
          ],
<<<<<<< HEAD
        ),
        const SizedBox(height: 12),
        _buildSwipeContent(),
      ],
    );
  }

  void _openFilter() {
    if (widget.filterWidget == null) return;

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

  Widget _buildHeader({required bool isMobile}) {
    if (!isMobile) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Perkembangan Proses Produksi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: CustomTheme().fontWeight('bold'),
                      color: CustomTheme().colors('text-primary'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildTabletActionButtons(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              !_isGreigeActive
                  ? 'Status tahapan work order'
                  : 'Status tahapan order greige',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: CustomTheme().colors('text-secondary'),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              Text(
                'Perkembangan Proses Produksi',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: CustomTheme().fontWeight('bold'),
                  color: CustomTheme().colors('text-primary'),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                !_isGreigeActive
                    ? 'Status tahapan work order'
                    : 'Status tahapan order greige',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: CustomTheme().colors('text-secondary'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderIconButton(
                isMobile: true,
                onPressed: _openDateFilterSheet,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.tune_outlined),
                    if (_isDateFiltered)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: CustomTheme().buttonColor('danger'),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildHeaderIconButton(
                isMobile: true,
                onPressed: widget.handleRefetch,
                icon: const Icon(Icons.refresh_outlined),
              ),
=======
              _buildHeader(
                context,
                isMobile: isMobile,
                isTablet: isTablet,
              ),
              if (_hasProductionData && _hasGreigeData) _buildSummaryTabs(),
              const Divider(),
              _buildSwipeContent(),
>>>>>>> 260d45ce (fix: dashboard)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: OutlinedButton.icon(
            onPressed: _openFilter,
            icon: const Icon(Icons.tune_outlined, size: 20),
            label: const Text('Filter', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 40,
          child: OutlinedButton.icon(
            onPressed: widget.handleRefetch,
            icon: const Icon(Icons.refresh_outlined, size: 20),
            label: const Text('Refresh', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
=======
>>>>>>> 025659bb (fix: dashboard mobile)
        ),
        const SizedBox(height: 12),
        _buildSwipeContent(),
      ],
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildCategoryTabs() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              _buildCategoryTab(
                label: 'Produksi',
                value: 'production',
              ),
              const SizedBox(width: 8),
              _buildCategoryTab(
                label: 'Greige',
                value: 'greige',
              ),
            ],
          ),
=======
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
=======
  void _openFilter() {
    if (widget.filterWidget == null) return;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
>>>>>>> 025659bb (fix: dashboard mobile)
      ),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return widget.filterWidget!;
      },
    );
  }

  Widget _buildHeader({required bool isMobile}) {
    if (!isMobile) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Perkembangan Proses Produksi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: CustomTheme().fontWeight('bold'),
                      color: CustomTheme().colors('text-primary'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildTabletActionButtons(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              !_isGreigeActive
                  ? 'Status tahapan work order'
                  : 'Status tahapan order greige',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: CustomTheme().colors('text-secondary'),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perkembangan Proses Produksi',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: CustomTheme().fontWeight('bold'),
                  color: CustomTheme().colors('text-primary'),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                !_isGreigeActive
                    ? 'Status tahapan work order'
                    : 'Status tahapan order greige',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: CustomTheme().colors('text-secondary'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderIconButton(
                isMobile: true,
                onPressed: _openDateFilterSheet,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.tune_outlined),
                    if (_isDateFiltered)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: CustomTheme().buttonColor('danger'),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              _buildHeaderIconButton(
                isMobile: true,
                onPressed: widget.handleRefetch,
                icon: const Icon(Icons.refresh_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabletActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: OutlinedButton.icon(
            onPressed: _openFilter,
            icon: const Icon(Icons.tune_outlined, size: 20),
            label: const Text('Filter', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 40,
          child: OutlinedButton.icon(
            onPressed: widget.handleRefetch,
            icon: const Icon(Icons.refresh_outlined, size: 20),
            label: const Text('Refresh', style: TextStyle(fontSize: 14)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              _buildCategoryTab(
                label: 'Produksi',
                value: 'production',
              ),
              const SizedBox(width: 8),
              _buildCategoryTab(
                label: 'Greige',
                value: 'greige',
              ),
            ],
          ),
<<<<<<< HEAD
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
>>>>>>> 260d45ce (fix: dashboard)
=======
>>>>>>> 025659bb (fix: dashboard mobile)
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 025659bb (fix: dashboard mobile)
  Widget _buildCategoryTab({
    required String label,
    required String value,
  }) {
    final selected = selectedCategory == value;
    final color = CustomTheme().colors('primary');

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: selected
          ? null
          : () {
              setState(() {
                selectedCategory = value;
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
<<<<<<< HEAD
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
=======
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
>>>>>>> 260d45ce (fix: dashboard)
=======
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
>>>>>>> 025659bb (fix: dashboard mobile)
        ),
      ),
    );
  }
}
