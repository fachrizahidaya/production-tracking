// ignore_for_file: unnecessary_new

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/production_summary.dart';
import 'package:textile_tracking/models/report/production_trend.dart';
import 'package:textile_tracking/models/report/rework_comparison.dart';
import 'package:textile_tracking/models/report/sorting_result.dart';
import 'package:textile_tracking/models/report/spk_list.dart';
import 'package:textile_tracking/models/report/spk_summary.dart';
import 'package:textile_tracking/models/report/top_bs.dart';
import 'package:textile_tracking/models/report/wo_list.dart';
import 'package:textile_tracking/screens/report/detail/spk_list.dart';
import 'package:textile_tracking/screens/report/detail/wo_list.dart';
import 'package:textile_tracking/screens/report/normal-rework/normal_rework.dart';
import 'package:textile_tracking/screens/report/production-trend/production_trend.dart';
import 'package:textile_tracking/screens/report/rework/rework_list.dart';
import 'package:textile_tracking/screens/report/service.dart';
import 'package:textile_tracking/screens/report/sorting-detail/sorting_detail.dart';
import 'package:textile_tracking/screens/report/detail/sorting_result.dart';
import 'package:textile_tracking/screens/report/sorting-result/sorting_result.dart';
import 'package:textile_tracking/screens/report/spk-list/spk_list.dart';
import 'package:textile_tracking/screens/report/spk-summary/spk_summary.dart';
import 'package:textile_tracking/screens/report/top-bs/top_bs.dart';
import 'package:textile_tracking/screens/report/wo-list/wo_list.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _reportService = ReportService();
  final Map<String, bool> _reportWidgets = {
    'sortingDetail': true,
    'sortingResult': true,
    'topBs': true,
    'woList': true,
    'spkSummary': true,
    'spkList': true,
    'productionTrend': true,
    'normalRework': true,
  };
  ProductionSummary? productionSummary;
  SortingResult? sortingResult;
  TopBs? topBs;
  SpkSummary? spkSummary;
  ProductionTrend? productionTrend;
  ReworkComparison? reworkComparison;
  WoList? woList;
  SpkList? spkList;
  bool isLoading = false;
  final ScrollController _sortingScrollController = ScrollController();
  final ScrollController _topBsScrollController = ScrollController();
  final TextEditingController _sortingSearchController =
      TextEditingController();
  final ScrollController _woScrollController = ScrollController();
  final ScrollController _spkScrollController = ScrollController();
  final TextEditingController _woSearchController = TextEditingController();
  final TextEditingController _spkSearchController = TextEditingController();

  final DateTime now = DateTime.now();

  DateTime? sortingStartDate;
  DateTime? sortingEndDate;
  late DateTime startDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime endDate = DateTime(now.year, now.month, now.day);

  late DateTime topBsStartDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime topBsEndDate = DateTime(now.year, now.month, now.day);
  late DateTime spkSummaryStartDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime spkSummaryEndDate = DateTime(now.year, now.month, now.day);
  late DateTime productionTrendStartDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime productionTrendEndDate = DateTime(now.year, now.month, now.day);
  late DateTime reworkComparisonStartDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime reworkComparisonEndDate =
      DateTime(now.year, now.month, now.day);
  late DateTime woListStartDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime woListEndDate = DateTime(now.year, now.month, now.day);
  late DateTime spkListStartDate = DateTime(
    now.year,
    now.month - 2,
    1,
  );
  late DateTime spkListEndDate = DateTime(now.year, now.month, now.day);
  Timer? _sortingSearchDebounce;
  Timer? _woSearchDebounce;
  Timer? _spkSearchDebounce;

  final List<SortingResultItem> _sortingItems = [];
  final List<TopBsItem> _topBsItems = [];
  final List<ReworkComparisonItem> _reworkComparisonItems = [];
  final List<WoListItem> _woItems = [];
  final List<SpkListItem> _spkItems = [];

  bool _sortingLoading = false;
  String sortingSort = 'wo_date';
  String sortingSearch = '';
  bool _topBsLoading = false;
  bool productionTrendLoading = false;
  bool _reworkComparisonLoading = false;
  int _woPage = 1;
  bool _woLoading = false;
  bool _woLoadingMore = false;
  bool _woHasMore = false;
  String woSort = 'wo_date';
  String woSearch = '';
  int _spkPage = 1;
  bool _spkLoading = false;
  bool _spkLoadingMore = false;
  bool _spkHasMore = false;
  String spkSort = 'wo_date';
  String spkSearch = '';

  num productionTrendGradeA = 0;
  num productionTrendGradeB = 0;
  num productionTrendGradeBS = 0;
  num productionTrendTotal = 0;

  @override
  void initState() {
    super.initState();

    sortingStartDate = startDate;
    sortingEndDate = endDate;
    woListStartDate = startDate;
    woListEndDate = endDate;

    _topBsScrollController.addListener(_onTopBsScroll);
    _woScrollController.addListener(_onWoScroll);
    _spkScrollController.addListener(_onSpkScroll);
    _loadProductionSummary();
    _loadSortingResult();
    _loadTopBs();
    _loadSpkSummary();
    _loadProductionTrend();
    _loadReworkComparison();
    _loadWoList();
    _loadSpkList();
  }

  void _onTopBsScroll() {
    if (!_sortingScrollController.hasClients) return;
  }

  void _onWoScroll() {
    if (!_woScrollController.hasClients) return;
  }

  void _onSpkScroll() {
    if (!_spkScrollController.hasClients) return;

    final position = _spkScrollController.position;
  }

  void _onSortingSearchChanged(String value) {
    _sortingSearchDebounce?.cancel();

    _sortingSearchDebounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        final search = value.trim();

        if (search == sortingSearch) {
          return;
        }

        sortingSearch = search;

        await _loadSortingResult();
      },
    );
  }

  void _onWoSearchChanged(String value) {
    _woSearchDebounce?.cancel();

    _woSearchDebounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        final search = value.trim();

        if (search == woSearch) {
          return;
        }

        woSearch = search;

        await _loadWoList();
      },
    );
  }

  void _onSpkSearchChanged(String value) {
    _spkSearchDebounce?.cancel();

    _spkSearchDebounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        final search = value.trim();

        if (search == spkSearch) {
          return;
        }

        spkSearch = search;

        await _loadSpkList();
      },
    );
  }

  Future<void> _loadProductionSummary() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _reportService.getProductionSummary(
          startDate: startDate, endDate: endDate);

      if (!mounted) return;

      setState(() {
        productionSummary = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data laporan: $e')));
    }
  }

  Future<void> _loadSortingResult() async {
    if (_sortingLoading) return;

    setState(() {
      _sortingLoading = true;
      _sortingItems.clear();
    });

    try {
      final result = await _reportService.getSortingResult(
          startDate: sortingStartDate,
          endDate: sortingEndDate,
          page: 1,
          perPage: 10,
          sort: sortingSort,
          search: sortingSearch);

      if (!mounted) return;

      setState(() {
        sortingResult = result;
        _sortingItems.addAll(result.data);
        _sortingLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _sortingLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data laporan: $e')));
    }
  }

  Future<void> _loadTopBs() async {
    if (_topBsLoading) return;

    setState(() {
      _topBsLoading = true;
      _topBsItems.clear();
    });

    try {
      final result = await _reportService.getTopBs(
        startDate: topBsStartDate,
        endDate: topBsEndDate,
      );

      if (!mounted) return;

      setState(() {
        topBs = result;
        _topBsItems.addAll(result.data);

        _topBsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _topBsLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil BS tertinggi: $e')));
    }
  }

  Future<void> _loadSpkSummary() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _reportService.getSpkSummary(
          startDate: spkSummaryStartDate, endDate: spkSummaryEndDate);

      if (!mounted) return;

      setState(() {
        spkSummary = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data spk: $e')));
    }
  }

  Future<void> _loadProductionTrend() async {
    setState(() {
      productionTrendLoading = true;
    });

    try {
      final result = await _reportService.getProductionTrend(
        startDate: productionTrendStartDate,
        endDate: productionTrendEndDate,
      );

      if (!mounted) return;

      num totalGradeA = 0;
      num totalGradeB = 0;
      num totalGradeBS = 0;

      for (final item in result.data) {
        totalGradeA += item.gradeA ?? 0;
        totalGradeB += item.gradeB ?? 0;
        totalGradeBS += item.gradeBS ?? 0;
      }

      setState(() {
        productionTrend = result;

        productionTrendGradeA = totalGradeA;
        productionTrendGradeB = totalGradeB;
        productionTrendGradeBS = totalGradeBS;

        productionTrendTotal = totalGradeA + totalGradeB + totalGradeBS;

        productionTrendLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        productionTrendLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengambil production trend: $e',
          ),
        ),
      );
    }
  }

  Future<void> _loadReworkComparison() async {
    if (_reworkComparisonLoading) return;

    setState(() {
      _reworkComparisonLoading = true;
      _reworkComparisonItems.clear();
    });

    try {
      final result = await _reportService.getReworkComparison(
        startDate: reworkComparisonStartDate,
        endDate: reworkComparisonEndDate,
      );

      if (!mounted) return;

      setState(() {
        reworkComparison = result;
        _reworkComparisonItems.addAll(result.data);

        _reworkComparisonLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _reworkComparisonLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil rework comparison: $e')));
    }
  }

  Future<void> _loadWoList() async {
    if (_woLoading) return;

    setState(() {
      _woLoading = true;

      _woItems.clear();
    });

    try {
      final result = await _reportService.getWoList(
          startDate: woListStartDate,
          endDate: woListEndDate,
          page: 1,
          perPage: 10,
          sort: woSort,
          search: woSearch);

      if (!mounted) return;

      setState(() {
        woList = result;
        _woItems.addAll(result.data);

        _woLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _woLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengambil data wo: $e')));
    }
  }

  Future<void> _loadSpkList() async {
    if (_spkLoading) return;

    setState(() {
      _spkLoading = true;

      _spkItems.clear();
    });

    try {
      final result = await _reportService.getSpkList(
          startDate: spkSummaryStartDate,
          endDate: spkSummaryEndDate,
          page: 1,
          perPage: 10,
          search: spkSearch);

      if (!mounted) return;

      setState(() {
        spkList = result;
        _spkItems.addAll(result.data);

        _spkLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _spkLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengambil spk: $e')));
    }
  }

  Future<void> _showSortingFilter() async {
    DateTime? tempStartDate = sortingStartDate ?? startDate;
    DateTime? tempEndDate = sortingEndDate ?? endDate;

    String tempSort = sortingSort;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Filter Hasil Sortir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Periode Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          initialDateRange:
                              tempStartDate != null && tempEndDate != null
                                  ? DateTimeRange(
                                      start: tempStartDate!,
                                      end: tempEndDate!,
                                    )
                                  : null,
                        );

                        if (picked != null) {
                          setModalState(() {
                            tempStartDate = picked.start;
                            tempEndDate = picked.end;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tanggal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${DateFormat('dd MMM yyyy').format(tempStartDate!)}'
                                    ' - '
                                    '${DateFormat('dd MMM yyyy').format(tempEndDate!)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Urutkan Berdasarkan',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            value: 'wo_date',
                            groupValue: tempSort,
                            title: const Text(
                              'Tanggal WO',
                            ),
                            subtitle: const Text(
                              'Urutan default',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            onChanged: (value) {
                              if (value == null) return;

                              setModalState(() {
                                tempSort = value;
                              });
                            },
                          ),
                          const Divider(
                            height: 1,
                          ),
                          RadioListTile<String>(
                            value: 'diff_qty_abs',
                            groupValue: tempSort,
                            title: const Text(
                              'Minus Qty Terbanyak',
                            ),
                            subtitle: const Text(
                              'Selisih qty terbesar terlebih dahulu',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            onChanged: (value) {
                              if (value == null) return;

                              setModalState(() {
                                tempSort = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            {
                              'start': tempStartDate,
                              'end': tempEndDate,
                              'sort': tempSort,
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: Text('Terapkan'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) return;

    setState(() {
      sortingStartDate = result['start'];
      sortingEndDate = result['end'];
      sortingSort = result['sort'];
    });

    await _loadSortingResult();
  }

  Future<void> _showWoFilter() async {
    DateTime? tempStartDate = woListStartDate ?? startDate;
    DateTime? tempEndDate = woListEndDate ?? endDate;

    String tempSort = woSort;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Filter Hasil Sortir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Periode Tanggal',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          initialDateRange:
                              tempStartDate != null && tempEndDate != null
                                  ? DateTimeRange(
                                      start: tempStartDate!,
                                      end: tempEndDate!,
                                    )
                                  : null,
                        );

                        if (picked != null) {
                          setModalState(() {
                            tempStartDate = picked.start;
                            tempEndDate = picked.end;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tanggal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${DateFormat('dd MMM yyyy').format(tempStartDate!)}'
                                    ' - '
                                    '${DateFormat('dd MMM yyyy').format(tempEndDate!)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            {
                              'start': tempStartDate,
                              'end': tempEndDate,
                              'sort': tempSort,
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: Text('Terapkan'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null) return;

    setState(() {
      woListStartDate = result['start'];
      woListEndDate = result['end'];
      woSort = result['sort'];
    });

    await _loadWoList();
  }

  void _showReportWidgetSettings() {
    const widgets = {
      // 'sortingDetail': 'Ringkasan Produksi',
      'sortingResult': 'Hasil Sortir per WO',
      'topBs': 'WO / Lot BS Tertinggi',
      'woList': 'Work Order',
      'spkSummary': 'Ringkasan SPK',
      'spkList': 'SPK',
      'productionTrend': 'Hasil Sortir per Grade',
      'normalRework': 'WO Normal & Rework',
    };

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Widget Laporan',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('lg'),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widgets.entries.map((entry) {
                        return SwitchListTile(
                          title: Text(entry.value),
                          value: _reportWidgets[entry.key] ?? true,
                          onChanged: (value) {
                            setState(() {
                              _reportWidgets[entry.key] = value;
                            });
                            setModalState(() {});
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _sortingScrollController.dispose();
    _woScrollController.dispose();
    _spkScrollController.dispose();
    _sortingSearchController.dispose();
    _woSearchController.dispose();
    _spkSearchController.dispose();
    _sortingSearchDebounce?.cancel();
    _woSearchDebounce?.cancel();
    _spkSearchDebounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Laporan',
        onReportSettings: _showReportWidgetSettings,
      ),
      backgroundColor: Color(0xFFf9fafc),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            //   child: Container(
            //     decoration: CustomTheme().cardTheme(),
            //     child: InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => ReworkList()),
            //         );
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Text('Ke Report Rework'),
            //             Icon(Icons.chevron_right),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            //   child: Container(
            //     decoration: CustomTheme().cardTheme(),
            //     child: InkWell(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => ReworkList()),
            //         );
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Text('Ke Report Packing'),
            //             Icon(Icons.chevron_right),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            if (_reportWidgets['sortingDetail'] == true) _buildSortingDetail(),
            if (_reportWidgets['sortingResult'] == true) _buildSortingResult(),
            if (_reportWidgets['topBs'] == true) _buildTopBS(),
            if (_reportWidgets['woList'] == true) _buildWoList(),
            if (_reportWidgets['spkSummary'] == true) _buildSpkSummary(),
            if (_reportWidgets['spkList'] == true) _buildSpkList(),
            if (_reportWidgets['productionTrend'] == true)
              _buildProductionTrend(),
            if (_reportWidgets['normalRework'] == true) _buildNormalAndRework(),
          ],
        ),
      )),
    );
  }

  String _getDateRangeText() {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  String _getDateRangeTopBsText() {
    return '${_formatDate(topBsStartDate)} - ${_formatDate(topBsEndDate)}';
  }

  String _getDateRangeSpkSummaryText() {
    return '${_formatDate(spkSummaryStartDate)} - ${_formatDate(spkSummaryEndDate)}';
  }

  String _getDateRangeProductionTrendText() {
    return '${_formatDate(productionTrendStartDate)} - ${_formatDate(productionTrendEndDate)}';
  }

  String _getDateRangeReworkComparisonText() {
    return '${_formatDate(reworkComparisonStartDate)} - ${_formatDate(reworkComparisonEndDate)}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatNumber(num? value, {int decimalDigits = 0}) {
    if (value == null) {
      return '-';
    }

    return NumberFormat(
            '#,##0${decimalDigits > 0 ? '.${'0' * decimalDigits}' : ''}',
            'id_ID')
        .format(value);
  }

  Widget _buildSortingDetail() {
    return SortingDetailComp(
      data: productionSummary,
      dateRangeText: _getDateRangeText(),
      formatNumber: formatNumber,
      onSelectDateRange: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2019),
          lastDate: DateTime(2045),
          initialDateRange: DateTimeRange(start: startDate, end: endDate),
        );

        if (picked != null) {
          setState(() {
            startDate = picked.start;
            endDate = picked.end;
          });

          await _loadProductionSummary();
        }
      },
    );
  }

  Widget _buildSortingResult() {
    return SortingResultComp(
      formatNumber: formatNumber,
      items: _sortingItems,
      loading: _sortingLoading,
      searchController: _sortingSearchController,
      scrollController: _sortingScrollController,
      showFilter: _showSortingFilter,
      onSeeAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SortingResultDetailScreen(
              startDate: sortingStartDate ?? startDate,
              endDate: sortingEndDate ?? endDate,
              sort: sortingSort,
              search: sortingSearch,
              formatNumber: formatNumber,
            ),
          ),
        );
      },
      onSearchChaged: _onSortingSearchChanged,
      onClearSearch: () async {
        _sortingSearchController.clear();
        setState(() {
          sortingSearch = '';
        });
        await _loadSortingResult();
      },
    );
  }

  Widget _buildTopBS() {
    return TopBsComp(
      items: _topBsItems,
      loading: _topBsLoading,
      scrollController: _topBsScrollController,
      dateRangeText: _getDateRangeTopBsText(),
      formatNumber: formatNumber,
      onSelectDateRange: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2019),
          lastDate: DateTime(2045),
          initialDateRange: DateTimeRange(
            start: topBsStartDate,
            end: topBsEndDate,
          ),
        );

        if (picked != null) {
          setState(() {
            topBsStartDate = picked.start;
            topBsEndDate = picked.end;
          });

          await _loadTopBs();
        }
      },
    );
  }

  Widget _buildSpkSummary() {
    return SpkSummaryComp(
      data: spkSummary,
      dateRangeText: _getDateRangeSpkSummaryText(),
      formatNumber: formatNumber,
      onSelectDateRange: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2019),
          lastDate: DateTime(2045),
          initialDateRange: DateTimeRange(
            start: spkSummaryStartDate,
            end: spkSummaryEndDate,
          ),
        );

        if (picked != null) {
          setState(() {
            spkSummaryStartDate = picked.start;
            spkSummaryEndDate = picked.end;
          });

          await Future.wait([
            _loadSpkSummary(),
            _loadSpkList(),
          ]);
        }
      },
    );
  }

  Widget _buildProductionTrend() {
    return ProductionTrendComp(
      dateRangeText: _getDateRangeProductionTrendText(),
      gradeA: productionTrendGradeA,
      gradeB: productionTrendGradeB,
      gradeBS: productionTrendGradeBS,
      formatNumber: formatNumber,
      onSelectDateRange: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2019),
          lastDate: DateTime(2045),
          initialDateRange: DateTimeRange(
            start: productionTrendStartDate,
            end: productionTrendEndDate,
          ),
        );

        if (picked != null) {
          setState(() {
            productionTrendStartDate = picked.start;
            productionTrendEndDate = picked.end;
          });

          await _loadProductionTrend();
        }
      },
    );
  }

  Widget _buildNormalAndRework() {
    return NormalReworkComp(
      dateRangeText: _getDateRangeReworkComparisonText(),
      normalCount: productionTrendGradeA,
      reworkCount: productionTrendGradeB,
      formatNumber: formatNumber,
      onSelectDateRange: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2019),
          lastDate: DateTime(2045),
          initialDateRange: DateTimeRange(
            start: reworkComparisonStartDate,
            end: reworkComparisonEndDate,
          ),
        );

        if (picked != null) {
          setState(() {
            reworkComparisonStartDate = picked.start;
            reworkComparisonEndDate = picked.end;
          });

          await _loadReworkComparison();
        }
      },
    );
  }

  Widget _buildWoList() {
    return WoListComp(
      items: _woItems,
      loading: _woLoading,
      loadingMore: _woLoadingMore,
      searchController: _woSearchController,
      scrollController: _woScrollController,
      onSearchChanged: _onWoSearchChanged,
      showFilter: _showWoFilter,
      formatDate: _formatDate,
      formatNumber: formatNumber,
      onSeeAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WoListDetailScreen(
              startDate: woListStartDate ?? startDate,
              endDate: woListEndDate ?? endDate,
              sort: woSort,
              search: woSearch,
              formatNumber: formatNumber,
              formatDate: _formatDate,
            ),
          ),
        );
      },
      onClearSearch: () async {
        _woSearchController.clear();
        setState(() {
          woSearch = '';
        });
        await _loadWoList();
      },
    );
  }

  Widget _buildSpkList() {
    return SpkListComp(
      items: _spkItems,
      loading: _spkLoading,
      loadingMore: _spkLoadingMore,
      searchController: _spkSearchController,
      scrollController: _spkScrollController,
      onSearchChanged: _onSpkSearchChanged,
      formatDate: _formatDate,
      formatNumber: formatNumber,
      onSeeAll: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpkListDetailScreen(
              startDate: spkListStartDate ?? startDate,
              endDate: spkListEndDate ?? endDate,
              sort: spkSort,
              search: spkSearch,
              formatNumber: formatNumber,
              formatDate: _formatDate,
            ),
          ),
        );
      },
      onClearSearch: () async {
        _spkSearchController.clear();
        setState(() {
          spkSearch = '';
        });
        await _loadSpkList();
      },
    );
  }
}
