import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/process_anomaly.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ProcessAnomalyList extends StatefulWidget {
  const ProcessAnomalyList({super.key});

  @override
  State<ProcessAnomalyList> createState() => _ProcessAnomalyListState();
}

class _ProcessAnomalyListState extends State<ProcessAnomalyList> {
  final ReportService _service = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<ProcessAnomalyItem> _items = [];
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
      final result = await _service.getProcessChainAnomalies(
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
        SnackBar(content: Text('Gagal mengambil anomali proses: $error')),
      );
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final result = await _service.getProcessChainAnomalies(
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
        title: 'Input Proses Anomali',
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
                  hintText: 'Cari WO atau proses...',
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

  Widget _buildCard(ProcessAnomalyItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.red.shade50,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Icon(Icons.warning_amber_outlined,
                //       color: Colors.red.shade600, size: 26),
                // ),
                // const SizedBox(width: 16),
                // Expanded(
                //   child: Text(
                //     item.title,
                //     style: TextStyle(
                //       color: Colors.red.shade700,
                //       fontSize: 18,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                Text(_formatDate(item.date),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.description,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
            const SizedBox(height: 18),
            Row(
              children: [
                // Icon(Icons.account_tree_outlined,
                //     color: Colors.grey.shade500, size: 24),
                // const SizedBox(width: 10),
                Expanded(
                  child: Text(item.processName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildReference('No. WO', item.woNo),
                // _buildStatus(item.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReference(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        children: [
          TextSpan(text: '$label  '),
          TextSpan(
            text: value,
            style: const TextStyle(
                color: Color(0xFF075E94), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(status,
          style: TextStyle(color: Colors.green.shade700, fontSize: 14)),
    );
  }

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
