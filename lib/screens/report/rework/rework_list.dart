import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/report/rework.dart';
import 'package:textile_tracking/screens/report/rework/rework_by_id.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ReworkList extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String sort;
  final String search;
  final String status;

  const ReworkList(
      {super.key,
      this.startDate,
      this.endDate,
      this.sort = 'created_at',
      this.search = '',
      this.status = 'all'});

  @override
  State<ReworkList> createState() => _ReworkListState();
}

class _ReworkListState extends State<ReworkList> {
  final ReportService _reportService = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<ReworkListItem> _items = [];

  Timer? _searchDebounce;
  late DateTime _startDate;
  late DateTime _endDate;
  late String _sort;
  String _search = '';
  String _status = '';
  int _page = 1;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = false;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.startDate ?? DateTime(now.year, now.month - 2, 1);
    _endDate = widget.endDate ?? DateTime(now.year, now.month, now.day);
    _sort = widget.sort;
    _search = widget.search;
    _status = widget.status;
    _searchController.text = widget.search;

    _scrollController.addListener(_onScroll);
    _loadReworkList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 100) {
      _loadMoreReworkList();
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

        await _loadReworkList();
      },
    );
  }

  Future<void> _loadReworkList() async {
    final requestId = ++_requestId;

    if (!mounted) return;
    setState(() {
      _loading = true;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _reportService.getReworkList(
          startDate: _startDate,
          endDate: _endDate,
          page: 1,
          perPage: 20,
          sort: _sort,
          search: _search,
          status: _status);

      if (!mounted || requestId != _requestId) return;

      setState(() {
        _items.addAll(result.data);
        _page = result.currentPage;
        _hasMore = result.currentPage < result.lastPage;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data rework: $e')),
      );
    }
  }

  Future<void> _loadMoreReworkList() async {
    if (_loading || _loadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      final nextPage = _page + 1;

      final result = await _reportService.getReworkList(
          startDate: _startDate,
          endDate: _endDate,
          page: nextPage,
          perPage: 20,
          sort: _sort,
          search: _search,
          status: _status);

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
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Filter Evaluasi Rework',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Periode Tanggal',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange:
                          DateTimeRange(start: tempStartDate, end: tempEndDate),
                    );
                    if (picked != null) {
                      setModalState(() {
                        tempStartDate = picked.start;
                        tempEndDate = picked.end;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range_outlined, size: 20),
                        const SizedBox(width: 10),
                        Text(
                            '${_formatDateOnly(tempStartDate)} - ${_formatDateOnly(tempEndDate)}'),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Urutkan Berdasarkan',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Terbaru dibuat'),
                  value: 'created_at',
                  groupValue: tempSort,
                  onChanged: (value) {
                    if (value != null) setModalState(() => tempSort = value);
                  },
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Terbaru selesai'),
                  value: 'completed_at',
                  groupValue: tempSort,
                  onChanged: (value) {
                    if (value != null) setModalState(() => tempSort = value);
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, {
                      'start': tempStartDate,
                      'end': tempEndDate,
                      'sort': tempSort
                    }),
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted || result == null) return;
    setState(() {
      _startDate = result['start'] as DateTime;
      _endDate = result['end'] as DateTime;
      _sort = result['sort'] as String;
    });
    await _loadReworkList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Evaluasi Rework',
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
                                  await _loadReworkList();
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
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.tune_outlined, size: 18),
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

                            return _buildReworkListCard(_items[index],
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

  Widget _buildReworkListCard(ReworkListItem item, {bool isFirst = false}) {
    final status = _display(item.status);
    final completed = _isCompleted(status);
    final date = completed ? item.endDate : item.startDate;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, isFirst ? 12 : 0, 0, 12),
      child: Container(
        decoration: CustomTheme().cardTheme(),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openReworkDetail(item),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _reworkNo(item),
                          style: const TextStyle(
                            color: Color(0xFF234393),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF9AA1B2),
                        size: 28,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReferenceLine(item),
                      const SizedBox(height: 20),
                      _buildLabelValue(
                        'Kategori:',
                        _categories(item),
                        maxLines: 1,
                      ),
                      if (!_isWaitingStatus(status)) ...[
                        const SizedBox(height: 18),
                        _buildLabelValue('Diisi oleh:', _submittedBy(item)),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              _formatDateTime(date),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          _buildStatusBadge(status),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReferenceLine(ReworkListItem item) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        children: [
          TextSpan(
            text: _dyeingNo(item),
            style: const TextStyle(
              color: Color(0xFF234393),
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' · dari '),
          TextSpan(text: _reworkReferenceNo(item)),
        ],
      ),
    );
  }

  Widget _buildLabelValue(
    String label,
    String value, {
    int? maxLines,
  }) {
    return RichText(
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: const TextStyle(color: Color(0xFF3E3F49)),
          ),
        ],
      ),
    );
  }

  String _display(dynamic value) =>
      value?.toString().trim().isNotEmpty == true ? value.toString() : '-';

  Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};

  String _workOrderNo(ReworkListItem item) => _display(
      _map(item.wo)['wo_no'] ?? _map(item.wo)['number'] ?? _map(item.wo)['no']);

  String _reworkNo(ReworkListItem item) => _display(
            item.reworkNo,
          ) ==
          '-'
      ? _workOrderNo(item)
      : _display(item.reworkNo);

  String _dyeingNo(ReworkListItem item) =>
      _display(_map(item.dyeing)['dyeing_no'] ?? _map(item.dyeing)['no']);

  String _reworkReferenceNo(ReworkListItem item) {
    final reference = _map(item.reworkReference).isNotEmpty
        ? _map(item.reworkReference)
        : _map(_map(item.dyeing)['rework_reference']);
    return _display(reference['dyeing_no'] ??
        reference['no'] ??
        reference['reference_no'] ??
        item.reworkReference);
  }

  String _categories(ReworkListItem item) {
    final values = item.reworkCategories is List
        ? item.reworkCategories.whereType<Map>().toList()
        : <Map>[];
    if (values.isEmpty) return _display(item.reason);

    const repairTypes = {
      'perbaikan_warna',
      'perbaikan_noda',
      'pelemas_ulang',
    };
    final isRepair = values.every(
      (value) => repairTypes.contains(value['type']?.toString()),
    );
    final details = <String>[];

    for (final value in values) {
      final label = value['label']?.toString().trim();
      if (label == null || label.isEmpty) continue;

      final methods = value['methods'];
      final methodLabels = methods is List
          ? methods
              .whereType<Map>()
              .map((method) => method['label']?.toString().trim() ?? '')
              .where((method) => method.isNotEmpty)
              .toList()
          : <String>[];
      details.add(
          methodLabels.isEmpty ? label : '$label (${methodLabels.join(', ')})');
    }

    if (details.isEmpty) return '-';
    return isRepair ? 'Perbaikan · ${details.join(', ')}' : details.join(', ');
  }

  String _submittedBy(ReworkListItem item) {
    final submitted = _map(item.submitted);
    return _display(submitted['name'] ??
        submitted['full_name'] ??
        submitted['username'] ??
        item.submitted);
  }

  String _formatDateTime(dynamic value) {
    if (value == null || value.toString().isEmpty) return '-';
    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return _display(value);

    final local = parsed.toLocal();
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
    return '${local.day} ${months[local.month - 1]} ${local.year}, '
        '${_twoDigits(local.hour)}.${_twoDigits(local.minute)}';
  }

  String _formatDateOnly(DateTime date) {
    return '${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}';
  }

  String _twoDigits(int number) => number.toString().padLeft(2, '0');

  bool _isCompleted(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'selesai' ||
        normalized == 'completed' ||
        normalized == 'complete';
  }

  bool _isWaitingStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'menunggu' || normalized == 'waiting';
  }

  Future<void> _openReworkDetail(ReworkListItem item) async {
    if (item.id == null || item.id.toString().trim().isEmpty) return;

    try {
      final data = await _reportService.getReworkDetail(item.id);
      if (!mounted) return;

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => ReworkDetailScreen(data: data),
        ),
      );

      if (updated == true && mounted) {
        await _loadReworkList();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail rework: $e')),
      );
    }
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
      case 'menunggu':
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
