import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/wo_list.dart';
import 'package:textile_tracking/screens/report/service.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class WoListDetailScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String sort;
  final String search;
  final dynamic formatNumber;
  final formatDate;

  const WoListDetailScreen(
      {super.key,
      required this.endDate,
      this.formatNumber,
      this.search = '',
      required this.sort,
      required this.startDate,
      this.formatDate});

  @override
  State<WoListDetailScreen> createState() => _WoListDetailScreenState();
}

class _WoListDetailScreenState extends State<WoListDetailScreen> {
  final ReportService _reportService = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<WoListItem> _items = [];

  Timer? _searchDebounce;
  late DateTime _startDate;
  late DateTime _endDate;
  late String _sort;
  String _search = '';
  int _page = 1;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _sort = widget.sort;
    _search = widget.search;
    _searchController.text = widget.search;

    _scrollController.addListener(_onScroll);
    _loadWoList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 100) {
      _loadMoreWoList();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      Duration(milliseconds: 500),
      () async {
        final search = value.trim();

        if (search == _search) {
          return;
        }

        _search = search;

        await _loadWoList();
      },
    );
  }

  Future<void> _loadWoList() async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _reportService.getWoList(
        startDate: _startDate,
        endDate: _endDate,
        page: 1,
        perPage: 20,
        sort: _sort,
        search: _search,
      );

      if (!mounted) return;

      setState(() {
        _items.addAll(result.data);
        _page = result.currentPage;
        _hasMore = result.currentPage < result.lastPage;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data laporan: $e')),
      );
    }
  }

  Future<void> _loadMoreWoList() async {
    if (_loading || _loadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      final nextPage = _page + 1;

      final result = await _reportService.getWoList(
        startDate: _startDate,
        endDate: _endDate,
        page: nextPage,
        perPage: 20,
        sort: _sort,
        search: _search,
      );

      if (!mounted) return;

      setState(() {
        _items.addAll(result.data);
        _page = result.currentPage;
        _hasMore = result.currentPage < result.lastPage;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingMore = false;
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

  Future<void> _showFilter() async {
    DateTime tempStartDate = _startDate;
    DateTime tempEndDate = _endDate;
    String tempSort = _sort;

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
                          initialDateRange: DateTimeRange(
                            start: tempStartDate,
                            end: tempEndDate,
                          ),
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
                                    '${DateFormat('dd MMM yyyy').format(tempStartDate)}'
                                    ' - '
                                    '${DateFormat('dd MMM yyyy').format(tempEndDate)}',
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
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Urutkan Berdasarkan',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.grey.shade300,
                    //     ),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       RadioListTile<String>(
                    //         value: 'wo_date',
                    //         groupValue: tempSort,
                    //         title: const Text(
                    //           'Tanggal WO',
                    //         ),
                    //         subtitle: const Text(
                    //           'Urutan default',
                    //         ),
                    //         contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 8,
                    //         ),
                    //         onChanged: (value) {
                    //           if (value == null) return;

                    //           setModalState(() {
                    //             tempSort = value;
                    //           });
                    //         },
                    //       ),
                    //       const Divider(
                    //         height: 1,
                    //       ),
                    //       RadioListTile<String>(
                    //         value: 'diff_qty_abs',
                    //         groupValue: tempSort,
                    //         title: const Text(
                    //           'Minus Qty Terbanyak',
                    //         ),
                    //         subtitle: const Text(
                    //           'Selisih qty terbesar terlebih dahulu',
                    //         ),
                    //         contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 8,
                    //         ),
                    //         onChanged: (value) {
                    //           if (value == null) return;

                    //           setModalState(() {
                    //             tempSort = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 24),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(
                    //         context,
                    //         {
                    //           'start': tempStartDate,
                    //           'end': tempEndDate,
                    //           'sort': tempSort,
                    //         },
                    //       );
                    //     },
                    //     child: const Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: 12,
                    //       ),
                    //       child: Text('Terapkan'),
                    //     ),
                    //   ),
                    // ),
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
      _startDate = result['start'];
      _endDate = result['end'];
      _sort = result['sort'];
    });

    await _loadWoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Work Order',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: CustomTheme().cardTheme(),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Cari...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () async {
                                  _searchController.clear();
                                  setState(() {
                                    _search = '';
                                  });
                                  await _loadWoList();
                                },
                                icon: const Icon(Icons.close),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        _onSearchChanged(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: _showFilter,
                    child: Container(
                      height: 51,
                      decoration: CustomTheme().cardTheme(),
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.tune_outlined, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _items.isEmpty
                    ? NoData()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _items.length + (_loadingMore ? 1 : 0),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          itemBuilder: (context, index) {
                            if (index >= _items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return _buildWoListCard(_items[index],
                                isFirst: index == 0);
                          },
                        ),
                      ),
          ),
          const SizedBox(height: 4),
        ],
      )),
    );
  }

  Widget _buildWoListCard(WoListItem item, {isFirst = false}) {
    final workOrderId = item.workOrderId?.toString() ?? '';

    return Padding(
      padding: EdgeInsets.fromLTRB(0, isFirst ? 12 : 0, 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: workOrderId.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkOrderDetail(
                            id: workOrderId,
                          ),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.woNo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(item.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Tanggal',
                      widget.formatDate(DateTime.parse(item.date)),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Qty WO',
                      widget.formatNumber(item.woQty),
                      unit: 'PCS',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Grade A',
                      widget.formatNumber(_getSortingGradeQty(item, 'A')),
                      unit: 'PCS',
                      percentage: _getSortingGradePercentage(item, 'A'),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Grade BS',
                      widget.formatNumber(_getSortingGradeQty(item, 'BS')),
                      unit: 'PCS',
                      percentage: _getSortingGradePercentage(item, 'BS'),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Total Sortir',
                      widget.formatNumber(item.sortingQty),
                      unit: 'PCS',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Total Packing',
                      widget.formatNumber(item.packingQty),
                      unit: 'PCS',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Berat 1 Lusin',
                      widget.formatNumber(item.weightPerDozen),
                      unit: 'KG',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Gramasi',
                      widget.formatNumber(item.gsm),
                      unit: 'GSM',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Berat Grade A',
                      widget.formatNumber(item.gradeAWeight),
                      unit: 'KG',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      'Total Berat',
                      widget.formatNumber(item.weight),
                      unit: 'KG',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic _getSortingGradeQty(WoListItem item, String grade) {
    if (item.sortingGrades is! List) return 0;

    for (final sortingGrade in item.sortingGrades) {
      if (sortingGrade is Map &&
          sortingGrade['grade']?.toString().trim().toUpperCase() == grade) {
        return sortingGrade['qty'] ?? 0;
      }
    }

    return 0;
  }

  double _getSortingGradePercentage(WoListItem item, String grade) {
    final gradeQty = double.tryParse(
          _getSortingGradeQty(item, grade).toString(),
        ) ??
        0;
    final totalSorting =
        double.tryParse(item.sortingQty?.toString() ?? '') ?? 0;

    if (totalSorting == 0) return 0;

    return gradeQty / totalSorting * 100;
  }

  Widget _buildInfoItem(
    String label,
    String value, {
    String? unit,
    double? percentage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  unit == null ? value : '$value $unit',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (percentage != null) ...[
                const SizedBox(width: 8),
                _buildPercentageBadge(percentage),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageBadge(double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${percentage.toStringAsFixed(2)}%',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
      case 'completed':
        return Colors.green;
      case 'diproses':
      case 'in_progress':
        return Colors.orange;
      case 'menunggu diproses':
      case 'waiting':
        return Colors.blue;
      case 'dilewati':
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
