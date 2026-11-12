import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/master/work_order_list.dart';
import 'package:textile_tracking/providers/api_client.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class WorkOrder extends StatefulWidget {
  const WorkOrder({super.key});

  @override
  State<WorkOrder> createState() => _WorkOrderState();
}

class _WorkOrderState extends State<WorkOrder> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<WorkOrderListItem> _items = [];
  final String _baseUrl = '${dotenv.env['API_URL']}/work-orders';

  Timer? _debounce;
  String _search = '';
  String? _status;
  DateTimeRange? _dateRange;
  int _page = 1;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
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
            _scrollController.position.maxScrollExtent - 160) {
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

  Future<WorkOrderListPage> _fetchPage(int page) async {
    final query = <String, String>{
      'page': page.toString(),
      'per_page': '20',
      if (_search.isNotEmpty) 'search': _search,
      if (_status != null) 'status': _status!,
      if (_dateRange != null) ...{
        'start_date': _dateOnly(_dateRange!.start),
        'end_date': _dateOnly(_dateRange!.end),
      },
    };
    final uri = Uri.parse(_baseUrl).replace(queryParameters: query);
    final response = await ApiClient.instance.get(context, uri);
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil Work Order (${response.statusCode})');
    }
    return WorkOrderListPage.fromJson(
      Map<String, dynamic>.from(jsonDecode(response.body) as Map),
    );
  }

  Future<void> _loadList() async {
    final requestId = ++_requestId;
    if (!mounted) return;
    setState(() {
      _loading = true;
      _loadingMore = false;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _fetchPage(1);
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
        SnackBar(content: Text('Gagal mengambil Work Order: $error')),
      );
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final result = await _fetchPage(_page + 1);
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

  Future<void> _openFilter() async {
    var tempRange = _dateRange;
    var tempStatus = _status;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Work Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tanggal Work Order',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final selected = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDateRange: tempRange,
                        );
                        if (selected != null) {
                          setSheetState(() => tempRange = selected);
                        }
                      },
                      icon: const Icon(Icons.date_range_outlined),
                      label: Text(
                        tempRange == null
                            ? 'Pilih rentang tanggal'
                            : '${_displayDate(tempRange!.start)} - ${_displayDate(tempRange!.end)}',
                      ),
                    ),
                    if (tempRange != null)
                      TextButton(
                        onPressed: () => setSheetState(() => tempRange = null),
                        child: const Text('Hapus tanggal'),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    ...['Diproses', 'Menunggu Diproses', 'Selesai'].map(
                      (status) => RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(status),
                        value: status,
                        groupValue: tempStatus,
                        onChanged: (value) =>
                            setSheetState(() => tempStatus = value),
                      ),
                    ),
                    RadioListTile<String?>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Semua status'),
                      value: null,
                      groupValue: tempStatus,
                      onChanged: (_) => setSheetState(() => tempStatus = null),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(sheetContext, {
                          'range': tempRange,
                          'status': tempStatus,
                        }),
                        child: const Text('Terapkan'),
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

    if (!mounted || result == null) return;
    setState(() {
      _dateRange = result['range'] as DateTimeRange?;
      _status = result['status'] as String?;
    });
    await _loadList();
  }

  void _openDetail(WorkOrderListItem item) {
    if (item.id == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkOrderDetail(id: item.id.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Work Order',
        onReturn: () => Navigator.pop(context),
        actions: [
          IconButton(
            tooltip: 'Filter',
            onPressed: _openFilter,
            icon: Badge(
              isLabelVisible: _status != null || _dateRange != null,
              smallSize: 8,
              child: const Icon(Icons.filter_list_outlined),
            ),
          ),
        ],
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
                onChanged: (value) {
                  setState(() {});
                  _onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari nomor WO, SPK, atau desain...',
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
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadList,
                child: _loading
                    ? ListView(
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
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 500, child: NoData()),
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
                                    child: CircularProgressIndicator(),
                                  ),
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

  Widget _buildCard(WorkOrderListItem item) {
    final statusColor = _statusColor(item.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _openDetail(item),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: CustomTheme().cardTheme(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.woNo,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _buildStatusBadge(item.status, statusColor),
                  ],
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.calendar_today_outlined, 'Tanggal',
                    _displayDateFromString(item.woDate)),
                if (item.userName != null && item.userName!.isNotEmpty)
                  _buildInfoRow(
                      Icons.person_outline, 'Dibuat oleh', item.userName!),
                if (item.spkNumbers.isNotEmpty)
                  _buildInfoRow(Icons.description_outlined, 'No. SPK',
                      item.spkNumbers.join(', ')),
                if (item.designs.isNotEmpty)
                  _buildInfoRow(Icons.palette_outlined, 'Desain',
                      item.designs.join(', ')),
                if (item.urgent) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.priority_high_rounded,
                          color: Colors.red.shade700, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        item.urgentNote?.isNotEmpty == true
                            ? 'Urgent: ${item.urgentNote}'
                            : 'Urgent',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: Colors.grey.shade600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade700;
      case 'Diproses':
        return Colors.orange.shade800;
      case 'Menunggu Diproses':
        return Colors.blueGrey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _displayDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _displayDateFromString(String value) {
    final date = DateTime.tryParse(value);
    return date == null ? '-' : _displayDate(date.toLocal());
  }
}
