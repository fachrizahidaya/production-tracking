import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/models/report/gsm.dart';
import 'package:textile_tracking/screens/report/gsm/gsm_by_id.dart';
import 'package:textile_tracking/screens/report/service.dart';

class GsmList extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String sort;
  final String search;
  final String status;
  final String? savedWoNo;

  const GsmList(
      {super.key,
      this.startDate,
      this.endDate,
      this.sort = 'created_at',
      this.search = '',
      this.status = '',
      this.savedWoNo});

  @override
  State<GsmList> createState() => _GsmListState();
}

class _GsmListState extends State<GsmList> {
  final ReportService _reportService = ReportService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<GsmListItem> _items = [];

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
    _loadGsmList();
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
      _loadMoreGsmList();
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

        await _loadGsmList();
      },
    );
  }

  Future<void> _loadGsmList() async {
    final requestId = ++_requestId;

    if (!mounted) return;
    setState(() {
      _loading = true;
      _page = 1;
      _hasMore = true;
      _items.clear();
    });

    try {
      final result = await _reportService.getGsmList(
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
        SnackBar(content: Text('Gagal mengambil data GSM: $e')),
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
      final counts = await _reportService.getGsmStatusCounts();
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

  Future<void> _loadMoreGsmList() async {
    if (_loading || _loadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _loadingMore = true;
    });

    try {
      final nextPage = _page + 1;

      final result = await _reportService.getGsmList(
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

  Future<void> _refreshGsmList() async {
    await Future.wait([
      _loadGsmList(),
      _loadPendingCount(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Evaluasi GSM',
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
                                await _loadGsmList();
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
              onRefresh: _refreshGsmList,
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

                              return _buildGsmListCard(_items[index],
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
              await _loadGsmList();
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

  Widget _buildGsmListCard(GsmListItem item, {bool isFirst = false}) {
    final status = _display(item.status);
    final completed = _isCompleted(status);
    final date = completed ? item.endDate : item.startDate;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, isFirst ? 12 : 0, 0, 12),
      child: InkWell(
        onTap: () => _openGsmDetail(item),
        child: Container(
          decoration: CustomTheme().cardTheme(),
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
                    if (!_isWaitingStatus(status)) ...[
                      const SizedBox(height: 18),
                      _buildLabelValue('Diisi oleh:', _submittedBy(item)),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal GSM',
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

  Widget _buildInfoLine(GsmListItem item) {
    return Column(
      children: [
        _buildInfoItem(
          label: 'No Packing',
          value: _packingNo(item),
          valueColor: const Color(0xFF234393),
        ),
        const SizedBox(height: 12),
        _buildInfoItem(
          label: 'Packing GSM',
          value: _packingGsm(item),
        ),
        const SizedBox(height: 12),
        _buildInfoItem(
          label: 'Material GSM',
          value: _materialGsm(item),
        ),
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

  String _workOrderNo(GsmListItem item) => _display(
      _map(item.wo)['wo_no'] ?? _map(item.wo)['number'] ?? _map(item.wo)['no']);

  String _packingNo(GsmListItem item) {
    final packing = _map(item.packing);
    return _display(item.packingNo ??
        packing['packing_no'] ??
        packing['no'] ??
        packing['number']);
  }

  String _packingGsm(GsmListItem item) => _formatGsmNumber(item.packingGsm);

  String _materialGsm(GsmListItem item) => _formatGsmNumber(item.materialGsm);

  String _formatGsmNumber(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '-';
    final parsed = num.tryParse(value.toString().replaceAll(',', '.'));
    if (parsed == null) return _display(value);
    return formatNumber(parsed);
  }

  String _submittedBy(GsmListItem item) {
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

  Future<void> _openGsmDetail(GsmListItem item) async {
    if (item.id == null || item.id.toString().trim().isEmpty) return;

    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GsmDetailLoadingScreen(id: item.id),
      ),
    );

    if (updated == true && mounted) {
      await _loadGsmList();
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
    final backgroundColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusTextColor(status),
        ),
      ),
    );
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

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFF8697C6);
      case 'menunggu':
      case 'waiting':
        return const Color(0xFF955B34);
      default:
        return _getStatusColor(status);
    }
  }
}
