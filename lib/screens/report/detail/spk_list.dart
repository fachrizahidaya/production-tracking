import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/spk_list.dart';
import 'package:textile_tracking/screens/report/service.dart';

class SpkListDetailScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String sort;
  final String search;
  final dynamic formatNumber;
  final formatDate;

  const SpkListDetailScreen(
      {super.key,
      required this.endDate,
      this.formatNumber,
      this.search = '',
      required this.sort,
      required this.startDate,
      this.formatDate});

  @override
  State<SpkListDetailScreen> createState() => _SpkListDetailScreenState();
}

class _SpkListDetailScreenState extends State<SpkListDetailScreen> {
  final ReportService _reportService = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<SpkListItem> _items = [];

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
    _loadSpkList();
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
      _loadMoreSpkList();
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

        await _loadSpkList();
      },
    );
  }

  Future<void> _loadSpkList() async {
    if (_loading) return;

    setState(() {
      _loading = true;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _reportService.getSpkList(
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

  Future<void> _loadMoreSpkList() async {
    if (_loading || _loadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      final nextPage = _page + 1;

      final result = await _reportService.getSpkList(
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
      _startDate = result['start'];
      _endDate = result['end'];
      _sort = result['sort'];
    });

    await _loadSpkList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SPK',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: Color(0xFFf9fafc),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                                  await _loadSpkList();
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
                      decoration: CustomTheme().cardTheme(),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.tune_outlined, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _items.isEmpty
                      ? NoData()
                      : ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _items.length + (_loadingMore ? 1 : 0),
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                          itemBuilder: (context, index) {
                            if (index >= _items.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return _buildSpkListCard(_items[index]);
                          },
                        ),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildSpkListCard(SpkListItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.spkNo,
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
            const SizedBox(height: 14),
            _buildInfoPair(
              'Tanggal',
              widget.formatDate(DateTime.parse(item.date)),
              'Qty WO',
              widget.formatNumber(item.woQty),
            ),
            const SizedBox(height: 14),
            _buildInfoPair(
              'Total Sortir',
              widget.formatNumber(item.sortingQty),
              'Total Packing',
              widget.formatNumber(item.packingQty),
            ),
            const SizedBox(height: 14),
            _buildInfoPair(
              'Grade A',
              widget.formatNumber(item.gradeA),
              'Grade B',
              widget.formatNumber(item.gradeB),
            ),
            const SizedBox(height: 14),
            _buildInfoPair(
              'Grade BS',
              widget.formatNumber(item.gradeBs),
              'Berat 1 Lusin',
              widget.formatNumber(item.dozenWeight),
            ),
            const SizedBox(height: 14),
            _buildInfoPair(
              'Berat Grade A',
              widget.formatNumber(item.gradeAWeight),
              'Total Berat',
              widget.formatNumber(item.weight),
            ),
            // const SizedBox(height: 14),
            // _buildTotalWeight(item.weight),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPair(
    String firstLabel,
    dynamic firstValue,
    String secondLabel,
    dynamic secondValue,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildInfo(firstLabel, firstValue)),
        const SizedBox(width: 16),
        Expanded(child: _buildInfo(secondLabel, secondValue)),
      ],
    );
  }

  Widget _buildInfo(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);

    return Container(
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
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
