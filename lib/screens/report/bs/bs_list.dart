import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/models/report/bs.dart';
import 'package:textile_tracking/screens/report/bs/bs_by_id.dart';
import 'package:textile_tracking/screens/report/service.dart';

class BsList extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String sort;
  final String search;
  final String status;
  final String? savedWoNo;

  const BsList(
      {super.key,
      this.startDate,
      this.endDate,
      this.sort = 'created_at',
      this.search = '',
      this.status = '',
      this.savedWoNo});

  @override
  State<BsList> createState() => _BsListState();
}

class _BsListState extends State<BsList> {
  final ReportService _reportService = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<BsListItem> _items = [];

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
  int? _pendingCount;
  int? _completedCount;
  int? _allCount;
  bool _pendingCountLoading = true;
  bool _completedCountLoading = true;
  bool _allCountLoading = true;
  bool _showSavedDialogAfterLoad = false;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = widget.startDate ?? DateTime(now.year, now.month - 2, 1);
    _endDate = widget.endDate ?? DateTime(now.year, now.month, now.day);
    _sort = widget.sort;
    _search = widget.search;
    _status = widget.status.trim().isEmpty ? 'Menunggu' : widget.status.trim();
    _showSavedDialogAfterLoad = widget.savedWoNo != null;
    _searchController.text = widget.search;

    _scrollController.addListener(_onScroll);
    _loadBsList();
    _loadPendingCount();
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
      _loadMoreBsList();
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

        await _loadBsList();
      },
    );
  }

  Future<void> _loadBsList() async {
    final requestId = ++_requestId;

    if (!mounted) return;
    setState(() {
      _loading = true;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _reportService.getBsList(
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

      if (_showSavedDialogAfterLoad) {
        _showSavedDialogAfterLoad = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showSavedDialog(widget.savedWoNo!);
        });
      }
    } catch (e) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data BS: $e')),
      );
    }
  }

  Future<void> _loadPendingCount() async {
    if (mounted) {
      setState(() {
        _pendingCountLoading = true;
        _completedCountLoading = true;
        _allCountLoading = true;
      });
    }

    try {
      final counts = await _reportService.getBsStatusCounts();
      if (!mounted) return;
      setState(() {
        _pendingCount = counts['pending'];
        _completedCount = counts['reviewed'];
        _allCount = counts['all'];
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _pendingCount = null;
        _completedCount = null;
        _allCount = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _pendingCountLoading = false;
          _completedCountLoading = false;
          _allCountLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreBsList() async {
    if (_loading || _loadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      final nextPage = _page + 1;

      final result = await _reportService.getBsList(
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

  Future<void> _refreshBsList() async {
    await Future.wait([
      _loadBsList(),
      _loadPendingCount(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Evaluasi BS',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                Container(
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
                                await _loadBsList();
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
                _buildStatusTabs(),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshBsList,
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
                            SizedBox(
                              height: 600,
                              child: NoData(),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
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

                              return _buildBsListCard(_items[index],
                                  isFirst: index == 0);
                            },
                          ),
                        ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      )),
    );
  }

  Widget _buildStatusTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildStatusTab(
                label: 'Menunggu',
                status: 'Menunggu',
                count: _pendingCountLoading ? null : _pendingCount,
              ),
              const SizedBox(width: 8),
              _buildStatusTab(
                label: 'Direview',
                status: 'Direview',
                count: _completedCountLoading ? null : _completedCount,
              ),
              const SizedBox(width: 8),
              _buildStatusTab(
                label: 'Semua',
                status: 'all',
                count: _allCountLoading ? null : _allCount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTab({
    required String label,
    required String status,
    int? count,
  }) {
    final selected = _status == status;
    final color = CustomTheme().colors('primary');

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: selected
          ? null
          : () async {
              setState(() => _status = status);
              await _loadBsList();
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Text(
                '($count)',
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBsListCard(BsListItem item, {bool isFirst = false}) {
    final status = _display(item.status);
    final completed = _isCompleted(status);
    final date = completed ? item.endDate : item.startDate;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, isFirst ? 12 : 0, 0, 12),
      child: InkWell(
        onTap: () => _openBsDetail(item),
        child: Container(
          decoration: CustomTheme().cardTheme().copyWith(
                color: _getStatusColor(status),
                border: Border.all(
                  color: _getStatusBadgeColor(status).withOpacity(0.35),
                  width: 1,
                ),
              ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _workOrderNo(item),
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
              Divider(height: 24, color: Colors.grey.shade300),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoLine(item),
                    const SizedBox(height: 12),
                    _buildSubmittedByItem(
                      name: _isWaitingStatus(status) ? '-' : _submittedBy(item),
                      time: _isWaitingStatus(status)
                          ? null
                          : _formatDateTime(item.endDate),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _formatDateTime(date),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildInfoLine(BsListItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoItem(
          label: 'No. Sortir',
          value: _sortingNo(item),
          valueColor: const Color(0xFF234393),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Qty BS',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_qtyBs(item)} PCS',
                  style: const TextStyle(
                    color: Color(0xFFB42318),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (_bsRateLabel(item).isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildBsRateBadge(_bsRateLabel(item)),
            ],
          ],
        ),
        const SizedBox(height: 12),
        _buildMaterialItem(item),
      ],
    );
  }

  Widget _buildMaterialItem(BsListItem item) {
    final code = _itemCode(item);
    final name = _itemName(item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Material',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          code,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF3E3F49),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (name != '-') ...[
          const SizedBox(height: 2),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valueColor ?? const Color(0xFF3E3F49),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmittedByItem({
    required String name,
    String? time,
  }) {
    final hasTime = time != null && time.trim().isNotEmpty && time != '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diisi oleh',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            if (name != '-' || !hasTime)
              Text(
                name == '-' ? '-' : '$name${hasTime ? ', ' : ''}',
                style: const TextStyle(
                  color: Color(0xFF3E3F49),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (hasTime)
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ],
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

  String _workOrderNo(BsListItem item) => _display(
      _map(item.wo)['wo_no'] ?? _map(item.wo)['number'] ?? _map(item.wo)['no']);

  String _sortingNo(BsListItem item) {
    final sorting = _map(item.sorting);
    return _display(sorting['sorting_no'] ??
        sorting['no'] ??
        sorting['number'] ??
        item.sorting);
  }

  String _qtyBs(BsListItem item) => _display(item.qtyBs);

  Map<String, dynamic> _materialItem(BsListItem item) {
    final woItems = _map(item.wo)['items'];
    if (woItems is List && woItems.isNotEmpty) {
      return _map(woItems.first);
    }
    return _map(item.item);
  }

  String _itemCode(BsListItem item) => _display(
        _materialItem(item)['code'] ?? item.topMaterialCode ?? item.material,
      );

  String _itemName(BsListItem item) =>
      _display(_materialItem(item)['name'] ?? item.topMaterialName);

  String _bsRateLabel(BsListItem item) {
    final value = item.bsRate?.toString().trim() ?? '';
    if (value.isEmpty) return '';
    return '$value %';
  }

  Widget _buildBsRateBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFB42318),
        ),
      ),
    );
  }

  String _submittedBy(BsListItem item) {
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

  String _twoDigits(int number) => number.toString().padLeft(2, '0');

  bool _isCompleted(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'direview' ||
        normalized == 'reviewed' ||
        normalized == 'selesai' ||
        normalized == 'completed' ||
        normalized == 'complete';
  }

  bool _isWaitingStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'menunggu' || normalized == 'waiting';
  }

  Future<void> _openBsDetail(BsListItem item) async {
    if (item.id == null || item.id.toString().trim().isEmpty) return;

    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BsDetailLoadingScreen(id: item.id),
      ),
    );

    if (updated == true && mounted) {
      await _loadBsList();
      await _loadPendingCount();
      if (mounted) {
        await _showSavedDialog(_workOrderNo(item));
      }
    }
  }

  Future<void> _showSavedDialog(String woNo) {
    return showAlertDialog(
      context: context,
      title: 'Perubahan Tersimpan',
      message: 'Perubahan untuk WO No $woNo sudah tersimpan.',
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _getStatusBadgeColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusBadgeTextColor(status),
        ),
      ),
    );
  }

  Color _getStatusBadgeColor(String status) {
    switch (status.toLowerCase()) {
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return CustomTheme().colors('primary');
      case 'menunggu':
      case 'waiting':
        return const Color(0xFFFFD54F);
      default:
        return Colors.grey.shade600;
    }
  }

  Color _getStatusBadgeTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
      case 'waiting':
      default:
        return Colors.white;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
      case 'menunggu':
      case 'waiting':
        return const Color(0xFFFFFBEA);
      case 'dilewati':
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
