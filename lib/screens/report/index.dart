// ignore_for_file: unnecessary_new

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/production_summary.dart';
import 'package:textile_tracking/models/report/sorting_result.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _reportService = ReportService();
  ProductionSummary? productionSummary;
  SortingResult? sortingResult;
  bool isLoading = false;
  final ScrollController _sortingScrollController = ScrollController();
  final TextEditingController _sortingSearchController =
      TextEditingController();

  final DateTime now = DateTime.now();

  late DateTime startDate = DateTime(
    now.year,
    now.month,
    1,
  );
  late DateTime endDate = DateTime(now.year, now.month, now.day);
  DateTime? sortingStartDate;
  DateTime? sortingEndDate;
  Timer? _sortingSearchDebounce;

  final List<SortingResultItem> _sortingItems = [];

  int _sortingPage = 1;
  bool _sortingLoading = false;
  bool _sortingLoadingMore = false;
  bool _sortingHasMore = false;
  String sortingSort = 'wo_date';
  String sortingSearch = '';

  @override
  void initState() {
    super.initState();

    sortingStartDate = startDate;
    sortingEndDate = endDate;
    _sortingScrollController.addListener(_onSortingScroll);
    _loadProductionSummary();
    _loadSortingResult();
  }

  void _onSortingScroll() {
    if (!_sortingScrollController.hasClients) return;

    final position = _sortingScrollController.position;

    if (position.pixels >= position.maxScrollExtent - 100) {
      _loadMoreSortingResult();
    }
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

  Future<void> _loadMoreSortingResult() async {
    if (_sortingLoading || _sortingLoadingMore || !_sortingHasMore) {
      return;
    }

    setState(() {
      _sortingLoadingMore = true;
    });

    try {
      final nextPage = _sortingPage + 1;

      final result = await _reportService.getSortingResult(
          startDate: sortingStartDate,
          endDate: sortingEndDate,
          page: nextPage,
          perPage: 20,
          sort: sortingSort,
          search: sortingSearch);

      if (!mounted) return;

      setState(() {
        _sortingItems.addAll(result.data);

        _sortingPage = result.currentPage;

        _sortingHasMore = result.currentPage < result.lastPage;

        _sortingLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _sortingLoadingMore = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengambil data berikutnya: $e',
          ),
        ),
      );
    }
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
      _sortingPage = 1;
      _sortingHasMore = true;
      _sortingItems.clear();
    });

    try {
      final result = await _reportService.getSortingResult(
          startDate: sortingStartDate,
          endDate: sortingEndDate,
          page: 1,
          perPage: 20,
          sort: sortingSort,
          search: sortingSearch);

      if (!mounted) return;

      setState(() {
        sortingResult = result;
        _sortingItems.addAll(result.data);
        _sortingPage = result.currentPage;
        _sortingHasMore = result.currentPage < result.lastPage;
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

  @override
  void dispose() {
    super.dispose();
    _sortingScrollController.dispose();
    _sortingSearchController.dispose();
    _sortingSearchDebounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan'),
        automaticallyImplyLeading: true,
        actions: [],
      ),
      backgroundColor: Color(0xFFf9fafc),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSortingDetail(),
            _buildSortingResult(),
            _buildTopBS()
          ],
        ),
      )),
    );
  }

  String _getDateRangeText() {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: InkWell(
              //         onTap: () async {},
              //         child: Container(
              //           decoration: CustomTheme().cardTheme(),
              //           child: Padding(
              //             padding: EdgeInsets.all(12),
              //             child: Text('Cari...'),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: 8,
              // ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDateRangePicker(
                            context: context,
                            firstDate: new DateTime(2019),
                            lastDate: new DateTime(2045),
                            initialDateRange:
                                DateTimeRange(start: startDate, end: endDate));

                        if (picked != null) {
                          setState(() {
                            startDate = picked.start;
                            endDate = picked.end;
                          });

                          await _loadProductionSummary();
                        }
                      },
                      child: Container(
                        decoration: CustomTheme().cardTheme(),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(_getDateRangeText()),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Expanded(
                  //   child: InkWell(
                  //     onTap: () async {},
                  //     child: Container(
                  //       decoration: CustomTheme().cardTheme(),
                  //       child: Padding(
                  //         padding: EdgeInsets.all(12),
                  //         child: Icon(
                  //           Icons.tune_outlined,
                  //           size: 18,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 8,
                  // ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {},
                      child: Container(
                        decoration: CustomTheme().cardTheme(),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.download_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total WO / Lot',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.chevron_right_outlined)
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          formatNumber(productionSummary?.totalWo),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  formatNumber(
                                      productionSummary?.totalActiveWO),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('aktif',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            ),
                            Text('・'),
                            Row(
                              children: [
                                Text(
                                    formatNumber(
                                        productionSummary?.totalDoneWO),
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('selesai',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'WO / Lot Aktif',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.chevron_right_outlined)
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          formatNumber(productionSummary?.totalActiveWO),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Sedang diproses',
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'WO / Lot Selesai',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.chevron_right_outlined)
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          formatNumber(productionSummary?.totalDoneWO),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('Dari',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  formatNumber(productionSummary?.totalWo),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('total WO / Lot',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'WO / Lot Aktif',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.chevron_right_outlined)
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          formatNumber(productionSummary?.reworkCount),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Dari total Wo / Lot',
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty Proses',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              formatNumber(productionSummary?.totalProcessQty),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('PCS',
                                style: TextStyle(fontWeight: FontWeight.w300))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('Dari total qty SPK',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  formatNumber(productionSummary?.totalSpkQty),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('PCS',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty Packing',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              formatNumber(productionSummary?.totalPackingQty),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'PCS',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text('Dari total sortir Grade A',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  formatNumber(productionSummary?.gradeAQty),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('PCS',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                  decoration: CustomTheme().cardTheme(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rincian Sortir',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total: ${formatNumber(productionSummary?.totalSortingQty)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'PCS',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Grade A',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  formatNumber(productionSummary?.gradeAQty),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'PCS',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grade B',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Text(
                                  formatNumber(productionSummary?.gradeBQty),
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'PCS',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grade BS',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Text(
                                  formatNumber(productionSummary?.gradeBSQty),
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'PCS',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortingResult() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
          decoration: CustomTheme().cardTheme(),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil Sortir per WO',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Container(
                          decoration: CustomTheme().cardTheme(),
                          child: TextField(
                              controller: _sortingSearchController,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: 'Cari...',
                                prefixIcon: Icon(Icons.search),
                                suffixIcon:
                                    _sortingSearchController.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () async {
                                              _sortingSearchController.clear();
                                              setState(() {
                                                sortingSearch = '';
                                              });
                                              await _loadSortingResult();
                                            },
                                            icon: Icon(Icons.close))
                                        : null,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                              onChanged: _onSortingSearchChanged),
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: _showSortingFilter,
                        child: Container(
                          decoration: CustomTheme().cardTheme(),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.tune_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 500,
                  child: _sortingLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _sortingItems.isEmpty
                          ? NoData()
                          : ListView.builder(
                              controller: _sortingScrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _sortingItems.length +
                                  (_sortingLoadingMore ? 1 : 0),
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                              itemBuilder: (context, index) {
                                if (index >= _sortingItems.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final item = _sortingItems[index];

                                return _buildSortingResultCard(item);
                              },
                            ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildSortingResultCard(SortingResultItem item) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.woNo,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              _buildSortingRow('Grade A', item.gradeA),
              SizedBox(
                height: 6,
              ),
              _buildSortingRow(
                'Grade B',
                item.gradeB,
              ),
              SizedBox(height: 6),
              _buildSortingRow(
                'Grade BS',
                item.gradeBS,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Qty'),
                      Row(
                        children: [
                          Text(formatNumber(item.totalQty)),
                          SizedBox(
                            width: 2,
                          ),
                          Text('PCS'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Qty WO'),
                      Row(
                        children: [
                          Text(formatNumber(item.woQty)),
                          SizedBox(
                            width: 2,
                          ),
                          Text('PCS'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selisih'),
                      Row(
                        children: [
                          Text(formatNumber(item.diff)),
                          SizedBox(
                            width: 2,
                          ),
                          Text('PCS'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBS() {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Container(
          decoration: CustomTheme().cardTheme(),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text('tes'),
              ],
            ),
          ),
        ));
  }

  Widget _buildSortingRow(
    String title,
    num value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          children: [
            Text(
              formatNumber(value),
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2),
            Text('PCS'),
          ],
        ),
      ],
    );
  }
}
