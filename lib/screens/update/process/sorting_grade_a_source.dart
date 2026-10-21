import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/env_config.dart';
import 'package:textile_tracking/screens/http_client.dart';

class SortingGradeASourceSection extends StatefulWidget {
  final List<Map<String, dynamic>> initialTransfers;
  final dynamic itemId;
  final dynamic excludeWoId;
  final dynamic sortingId;
  final num gradeAInput;
  final ValueChanged<num>? onTotalChanged;
  final ValueChanged<List<Map<String, dynamic>>>? onRowsChanged;
  final ValueChanged<bool>? onExceededChanged;

  const SortingGradeASourceSection({
    super.key,
    this.initialTransfers = const [],
    this.itemId,
    this.excludeWoId,
    this.sortingId,
    this.gradeAInput = 0,
    this.onTotalChanged,
    this.onRowsChanged,
    this.onExceededChanged,
  });

  @override
  State<SortingGradeASourceSection> createState() =>
      _SortingGradeASourceSectionState();
}

class _SourceRow {
  dynamic id;
  dynamic transferId;
  dynamic woId;
  dynamic fromSortingId;
  dynamic itemId;
  String woNo = '';
  String sortingNo = '';
  String lot = '';
  num availableQty = 0;
  num takenQty = 0;
  final TextEditingController qtyController = TextEditingController();

  String get label {
    if (woNo.isEmpty) return lot;
    if (lot.isEmpty) return woNo;
    return '$woNo / $lot';
  }

  void dispose() => qtyController.dispose();
}

class _SortingGradeASourceSectionState
    extends State<SortingGradeASourceSection> {
  final List<_SourceRow> _rows = [];
  List<Map<String, dynamic>>? _options;
  bool _loading = true;
  int _requestId = 0;
  final ValueNotifier<bool> _deleteLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _rows.addAll(widget.initialTransfers.map(_rowFromTransfer));
    _fetchOptions();
    if (_rows.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _notify();
      });
    }
  }

  @override
  void didUpdateWidget(covariant SortingGradeASourceSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId == widget.itemId &&
        oldWidget.excludeWoId == widget.excludeWoId &&
        oldWidget.sortingId == widget.sortingId) {
      return;
    }
    _options = null;
    _loading = true;
    _fetchOptions();
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    _deleteLoading.dispose();
    super.dispose();
  }

  num get _totalTaken =>
      _rows.fold<num>(0, (total, row) => total + row.takenQty);

  bool get _qtyExceeded => _rows.any(
        (row) => row.woId != null && row.takenQty > row.availableQty,
      );

  void _notify() {
    widget.onExceededChanged?.call(_qtyExceeded);
    widget.onTotalChanged?.call(_totalTaken);
    widget.onRowsChanged?.call(
      _rows
          .where((row) => row.woId != null || row.id != null)
          .map(
            (row) => <String, dynamic>{
              'id': row.id,
              'transfer_id': row.transferId,
              'wo_id': row.woId,
              'sorting_id': row.fromSortingId,
              'from_sorting_id': row.fromSortingId,
              'item_id': row.itemId ?? widget.itemId,
              'wo_no': row.woNo,
              'sorting_no': row.sortingNo,
              'lot': row.lot,
              'qty': row.takenQty,
              'available_qty': row.availableQty,
            },
          )
          .toList(),
    );
  }

  Future<void> _fetchOptions() async {
    final requestId = ++_requestId;
    try {
      final options = await _loadOptions();
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _options = options;
        _loading = false;
        _syncRowAvailability();
      });
      if (_rows.isNotEmpty) _notify();
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _options = [];
        _loading = false;
      });
    }
  }

  _SourceRow _rowFromTransfer(Map<String, dynamic> raw) {
    final row = _SourceRow();
    final qty = raw['qty'];
    row.transferId =
        raw['transfer_id'] ?? (raw['from_wo_id'] != null ? raw['id'] : null);
    row.id = raw['from_wo_id'] ?? raw['wo_id'] ?? raw['value'];
    row.woId = raw['from_wo_id'] ?? raw['wo_id'];
    row.fromSortingId = raw['sorting_id'] ?? raw['from_sorting_id'];
    row.itemId = raw['item_id'];
    row.woNo = (raw['from_wo_no'] ?? raw['wo_no'] ?? '').toString();
    row.sortingNo =
        (raw['from_sorting_no'] ?? raw['sorting_no'] ?? '').toString();
    row.takenQty = qty is num ? qty : num.tryParse('$qty') ?? 0;
    final available = raw['available_qty'];
    row.availableQty = available is num ? available : row.takenQty;
    row.qtyController.text = row.takenQty == 0 ? '' : row.takenQty.toString();
    return row;
  }

  void _syncRowAvailability() {
    final options = _options;
    if (options == null) return;

    for (final row in _rows) {
      Map<String, dynamic>? match;
      for (final option in options) {
        final sameSorting = row.fromSortingId != null &&
            option['from_sorting_id']?.toString() ==
                row.fromSortingId.toString();
        final sameWo = row.woId != null &&
            option['wo_id']?.toString() == row.woId.toString();
        if (sameSorting || sameWo) {
          match = option;
          break;
        }
      }
      if (match == null) continue;

      final available = match['qty'];
      if (available is num) row.availableQty = available;
      row.fromSortingId ??= match['sorting_id'] ?? match['from_sorting_id'];
      row.itemId ??= match['item_id'] ?? widget.itemId;
      if (row.woNo.isEmpty) {
        row.woNo = match['wo_no']?.toString() ?? '';
      }
      if (row.sortingNo.isEmpty) {
        row.sortingNo = match['sorting_no']?.toString() ?? '';
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadOptions() async {
    final query = <String, String>{};
    final itemId = widget.itemId?.toString().trim() ?? '';
    final excludeWoId = widget.excludeWoId?.toString().trim() ?? '';
    final sortingId = widget.sortingId?.toString().trim() ?? '';
    if (itemId.isNotEmpty) query['item_id'] = itemId;
    if (excludeWoId.isNotEmpty) query['exclude_wo_id'] = excludeWoId;
    if (sortingId.isNotEmpty) query['sorting_id'] = sortingId;

    final uri = Uri.parse('${EnvConfig.apiUrl}/sortings/grade-a-sources')
        .replace(queryParameters: query);
    final response = await HttpClient.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal mengambil sumber Grade A');
    }

    final decoded = jsonDecode(response.body);
    final rawList = decoded is List
        ? decoded
        : decoded is Map
            ? (decoded['data'] is List
                ? decoded['data']
                : decoded['data'] is Map
                    ? decoded['data']['data']
                    : null)
            : null;
    if (rawList is! List) return [];

    return rawList.whereType<Map>().map(_mapOption).where((item) {
      final id = item['wo_id']?.toString() ?? '';
      return id.isNotEmpty && id != excludeWoId;
    }).toList();
  }

  Map<String, dynamic> _mapOption(Map raw) {
    final item = Map<String, dynamic>.from(raw);
    final workOrder = item['work_order'] is Map
        ? Map<String, dynamic>.from(item['work_order'])
        : <String, dynamic>{};
    final woId = item['from_wo_id'] ??
        item['wo_id'] ??
        workOrder['id'] ??
        item['work_order_id'];
    final woNo =
        (item['from_wo_no'] ?? item['wo_no'] ?? workOrder['wo_no'] ?? '')
            .toString();
    final sorting = item['sorting'] is Map
        ? Map<String, dynamic>.from(item['sorting'])
        : <String, dynamic>{};
    final fromSortingId =
        item['sorting_id'] ?? item['from_sorting_id'] ?? sorting['id'];
    final sourceItemId = item['item_id'] ?? widget.itemId;
    final sortingNo =
        (item['from_sorting_no'] ?? sorting['sorting_no'] ?? '').toString();
    final lot = (item['lot'] ??
            item['lot_no'] ??
            item['spk_no'] ??
            item['no_lot'] ??
            '')
        .toString();
    final available = item['available_qty'] ??
        item['sisa_qty'] ??
        item['remaining_qty'] ??
        item['qty'];

    return {
      'value': woId,
      'wo_id': woId,
      'sorting_id': fromSortingId,
      'from_sorting_id': fromSortingId,
      'item_id': sourceItemId,
      'wo_no': woNo,
      'sorting_no': sortingNo,
      'lot': lot,
      'label': sortingNo.isEmpty ? woNo : '$woNo ($sortingNo)',
      'code': woNo,
      'qty': available is num
          ? available
          : num.tryParse(available?.toString() ?? '') ?? 0,
    };
  }

  Future<void> _pick(int index) async {
    if (_loading) return;
    if (_options == null) {
      setState(() => _loading = true);
      try {
        _options = await _loadOptions();
      } catch (error) {
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
        return;
      }
      if (!mounted) return;
      setState(() => _loading = false);
    }

    final row = _rows[index];
    final takenWoIds = _rows
        .where((item) => item != row && item.woId != null)
        .map((item) => item.woId.toString())
        .toSet();
    final options = _options!
        .where((item) => !takenWoIds.contains(item['wo_id'].toString()))
        .toList();

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (dialogContext) {
        return SelectDialog(
          label: 'WO / Lot',
          options: options,
          isAnyAdditionalData: false,
          selected: row.id?.toString() ?? '',
          handleChangeValue: (value) {
            setState(() {
              if (value is Map) {
                row.id = value['value'];
                row.transferId = null;
                row.woId = value['wo_id'];
                row.fromSortingId =
                    value['sorting_id'] ?? value['from_sorting_id'];
                row.itemId = value['item_id'] ?? widget.itemId;
                row.woNo = value['wo_no']?.toString() ?? '';
                row.sortingNo = value['sorting_no']?.toString() ?? '';
                row.lot = value['lot']?.toString() ?? '';
                row.availableQty = value['qty'] is num
                    ? value['qty'] as num
                    : num.tryParse('${value['qty']}') ?? 0;
              } else {
                row.id = null;
                row.transferId = null;
                row.woId = null;
                row.fromSortingId = null;
                row.itemId = null;
                row.woNo = '';
                row.sortingNo = '';
                row.lot = '';
                row.availableQty = 0;
                row.takenQty = 0;
                row.qtyController.clear();
              }
            });
            _notify();
          },
        );
      },
    );
  }

  bool get _canAddItem {
    final sourceCount = _options?.length ?? 0;
    return !_loading && sourceCount >= 1 && _rows.length < sourceCount;
  }

  void _addRow() {
    setState(() => _rows.add(_SourceRow()));
  }

  void _removeRow(int index) {
    final row = _rows[index];
    if (row.transferId != null) {
      _confirmDeleteSavedTransfer(index);
      return;
    }
    setState(() => _rows.removeAt(index).dispose());
    _notify();
  }

  void _confirmDeleteSavedTransfer(int index) {
    final row = _rows[index];
    final woNo = row.woNo.isEmpty ? 'WO ini' : row.woNo;

    showConfirmationDialog(
      context: context,
      title: 'Hapus Qty',
      message: 'Apakah Anda yakin ingin menghapus qty yang diambil dari $woNo?',
      isLoading: _deleteLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () => _deleteSavedTransfer(index),
    );
  }

  Future<void> _deleteSavedTransfer(int index) async {
    if (index < 0 || index >= _rows.length) return;
    final row = _rows[index];
    final sortingId = widget.sortingId;
    final transferId = row.transferId;
    if (sortingId == null || transferId == null) return;

    _deleteLoading.value = true;
    try {
      final response = await HttpClient.delete(
        Uri.parse(
          '${EnvConfig.apiUrl}/sortings/$sortingId/grade-a-transfers/$transferId',
        ),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        String message = 'Gagal menghapus qty yang diambil';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['message'] != null) {
            message = decoded['message'].toString();
          }
        } catch (_) {}
        throw Exception(message);
      }
      if (!mounted) return;
      Navigator.pop(context);
      if (index < _rows.length && _rows[index].transferId == transferId) {
        setState(() => _rows.removeAt(index).dispose());
        _notify();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      _deleteLoading.value = false;
    }
  }

  num _parseQty(String value) {
    final normalized = value.trim().replaceAll('.', '').replaceAll(',', '.');
    return num.tryParse(normalized) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
      title: 'Ambil Qty Grade A',
      icon: Icons.move_down_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < _rows.length; index++) _buildRow(index),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _canAddItem ? _addRow : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF1A8C76),
                disabledBackgroundColor:
                    const Color(0xFF1A8C76).withOpacity(0.4),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah Item'),
            ),
          ),
          // Text(
          //   'Grade A dari input: ${formatNumber(widget.gradeAInput)}',
          // ),
          // Text(
          //   'Grade A dari WO lain: ${formatNumber(_totalTaken)}',
          // ),
          // Text(
          //   'Total Grade A: ${formatNumber(widget.gradeAInput + _totalTaken)}',
          //   style: TextStyle(
          //     fontWeight: CustomTheme().fontWeight('semibold'),
          //     color: const Color(0xFF234393),
          //   ),
          // ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildRow(int index) {
    final row = _rows[index];
    final remaining = row.availableQty - row.takenQty;

    final exceeded = row.woId != null && row.takenQty > row.availableQty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: SelectForm(
                  label: 'WO / Lot',
                  required: false,
                  isDisabled: _loading,
                  selectedLabel: row.sortingNo.isEmpty
                      ? row.woNo
                      : '${row.woNo} (${row.sortingNo})',
                  selectedValue: row.id?.toString() ?? '',
                  onTap: () => _pick(index),
                ),
              ),
              Expanded(
                flex: 2,
                child: _readOnlyValue(
                  'Sisa Qty',
                  row.woId == null ? null : remaining,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextForm(
                  label: 'Qty diambil',
                  isNumber: true,
                  isDisabled: row.woId == null,
                  controller: row.qtyController,
                  initialValue:
                      row.takenQty == 0 ? '' : row.takenQty.toString(),
                  handleChange: (value) {
                    setState(() => row.takenQty = _parseQty(value));
                    _notify();
                  },
                ),
              ),
              IconButton(
                tooltip: 'Hapus',
                onPressed: () => _removeRow(index),
                icon: const Icon(
                  size: 25,
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              ),
            ].separatedBy(CustomTheme().hGap('md')),
          ),
          if (exceeded)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Qty diambil melebihi sisa qty',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(
                  width: 150,
                )
              ],
            ),
        ].separatedBy(CustomTheme().vGap('sm')),
      ),
    );
  }

  Widget _readOnlyValue(String label, num? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            // fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: CustomTheme().inputStaticDecorationDisabled(),
          child: Text(
            value == null ? '-' : formatNumber(value),
            style: TextStyle(),
          ),
        ),
      ],
    );
  }
}
