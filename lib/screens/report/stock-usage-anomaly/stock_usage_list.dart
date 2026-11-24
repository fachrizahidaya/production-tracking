import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/models/report/stock_usage_anomaly.dart';
import 'package:textile_tracking/screens/report/service.dart';

class StockUsageList extends StatefulWidget {
  const StockUsageList({super.key});

  @override
  State<StockUsageList> createState() => _StockUsageListState();
}

class _StockUsageListState extends State<StockUsageList> {
  final ReportService _service = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<StockUsageAnomalyItem> _items = [];
  final Map<String, bool> _checkedItems = {};
  Timer? _debounce;
  String _search = '';
  int _page = 1;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120) {
      _loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final search = value.trim();
      if (search == _search) return;
      _search = search;
      _loadList();
    });
  }

  Future<void> _loadList() async {
    final requestId = ++_requestId;
    if (!mounted) return;
    setState(() {
      _loading = true;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _service.getPackingGradeAUsageAnomalies(
        context: context,
        page: 1,
        perPage: 20,
        search: _search,
      );
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _items.addAll(result.data);
        _page = result.currentPage;
        _hasMore = result.currentPage < result.lastPage;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Gagal mengambil anomali pemakaian stok: $error')),
      );
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final result = await _service.getPackingGradeAUsageAnomalies(
        context: context,
        page: _page + 1,
        perPage: 20,
        search: _search,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(result.data);
        _page = result.currentPage;
        _hasMore = result.currentPage < result.lastPage;
        _loadingMore = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data berikutnya: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Stok Packing dipakai',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari WO, packing, atau item...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _search = '';
                            setState(() {});
                            _loadList();
                          },
                          icon: const Icon(Icons.close),
                        ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                  _onSearchChanged(value);
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadList,
                child: _loading
                    ? ListView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(
                            height: 240,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                      )
                    : _items.isEmpty
                        ? ListView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 600, child: NoData()),
                            ],
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            itemCount: _items.length + (_loadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _items.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return _buildCard(_items[index]);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(StockUsageAnomalyItem item) {
    final key = '${item.id ?? item.createdAt}-${item.fromPackingId}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.red.shade50,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Icon(Icons.warning_amber_rounded,
                //       color: Colors.red.shade600, size: 26),
                // ),
                // const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Stok packing dipakai',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(_formatDate(item.createdAt),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 18),
            _buildDescription(item),
            const SizedBox(height: 18),
            Row(
              children: [
                // Icon(Icons.inventory_2_outlined,
                //     color: Colors.grey.shade500, size: 24),
                // const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.itemCode,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(item.itemName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildMetric('QTY SORTIR', item.fromSortingQty)),
                    const SizedBox(width: 6),
                    Expanded(
                        child: _buildMetric('QTY PACKING', item.fromPackingQty,
                            valueColor: Colors.red.shade600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildMetric('QTY DIPAKAI', item.qty,
                            valueColor: Colors.red.shade600)),
                    const SizedBox(width: 6),
                    Expanded(
                        child: _buildMetric(
                            'QTY PACKING TUJUAN', item.toPackingQty)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReferenceWithStatus(
                    'Packing', item.fromPackingNo, item.fromPackingStatus),
                const SizedBox(height: 10),
                _buildReferenceWithStatus(
                    'Packing tujuan', item.toPackingNo, item.toPackingStatus),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReferenceWithStatus(
                    'WO', item.fromWoNo, item.fromWoStatus),
                const SizedBox(height: 10),
                _buildReferenceWithStatus(
                    'WO tujuan', item.toWoNo, item.toWoStatus),
              ],
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Checkbox(
            //       value: _checkedItems[key] ?? false,
            //       onChanged: (value) => setState(() {
            //         _checkedItems[key] = value ?? false;
            //       }),
            //     ),
            //     const Text('Sudah Dicek', style: TextStyle(fontSize: 16)),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(StockUsageAnomalyItem item) {
    final sorting = _asDouble(item.fromSortingQty);
    final used = _asDouble(item.qty);
    final percentage = sorting == 0 ? 0 : used / sorting * 100;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.grey.shade700,
        ),
        children: [
          const TextSpan(text: 'Qty Packing sumber '),
          TextSpan(
              text: '${formatNumber(item.fromPackingQty)} PCS',
              style: const TextStyle(
                  color: Color(0xFF3E3F49), fontWeight: FontWeight.w700)),
          const TextSpan(text: ' lebih rendah dari Sortir '),
          TextSpan(
              text: '${formatNumber(item.fromSortingQty)} PCS',
              style: const TextStyle(
                  color: Color(0xFF3E3F49), fontWeight: FontWeight.w700)),
          const TextSpan(text: ' (selisih '),
          TextSpan(
              text:
                  '${formatNumber(item.qty)} PCS, ${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(
                  color: Color(0xFF3E3F49), fontWeight: FontWeight.w700)),
          // const TextSpan(
          //     text: ') karena menyesuaikan qty packing yang dibutuhkan. Sisa '),
          // TextSpan(
          //     text: '${formatNumber(item.qty)} PCS',
          //     style: const TextStyle(
          //         color: Color(0xFF3E3F49), fontWeight: FontWeight.w700)),
          // const TextSpan(text: ' dipakai packing '),
          // TextSpan(
          //     text: item.toPackingNo,
          //     style: const TextStyle(
          //         color: Color(0xFF3E3F49), fontWeight: FontWeight.w700)),
          // const TextSpan(text: ' (WO '),
          // TextSpan(
          //     text: item.toWoNo,
          //     style: const TextStyle(
          //         color: Color(0xFF3E3F49), fontWeight: FontWeight.w700)),
          const TextSpan(text: ').'),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, dynamic value, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: formatNumber(value),
                    style: TextStyle(
                        color: valueColor ?? const Color(0xFF202124),
                        // fontSize: 18,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: ' PCS',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        // fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceWithStatus(String label, String value, String status) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        Text(label,
            style: TextStyle(
              color: Colors.grey.shade600,
            )),
        Text(value,
            style: const TextStyle(
                color: Color(0xFF075E94), fontWeight: FontWeight.w600)),
        // _buildStatus(status),
      ],
    );
  }

  Widget _buildStatus(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline,
              color: Colors.green.shade700, size: 17),
          const SizedBox(width: 4),
          Text(status,
              style: TextStyle(color: Colors.green.shade700, fontSize: 14)),
        ],
      ),
    );
  }

  double _asDouble(dynamic value) => double.tryParse('$value') ?? 0;

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value.isEmpty ? '-' : value;
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
      'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }
}
