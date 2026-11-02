import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/models/master/work_order.dart';

class AbsorbWoQtySection extends StatefulWidget {
  final dynamic currentWoId;
  final num gradeAInput;
  final ValueChanged<num>? onTotalChanged;
  final ValueChanged<List<Map<String, dynamic>>>? onRowsChanged;

  const AbsorbWoQtySection({
    super.key,
    this.currentWoId,
    this.gradeAInput = 0,
    this.onTotalChanged,
    this.onRowsChanged,
  });

  @override
  State<AbsorbWoQtySection> createState() => _AbsorbWoQtySectionState();
}

class _AbsorbRow {
  dynamic woId;
  String label = '';
  num availableQty = 0;
  num takenQty = 0;
  final TextEditingController qtyController = TextEditingController();

  void dispose() => qtyController.dispose();
}

class _AbsorbWoQtySectionState extends State<AbsorbWoQtySection> {
  final List<_AbsorbRow> _rows = [_AbsorbRow()];
  List<Map<String, dynamic>>? _options;
  bool _loading = false;

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  num get _totalTaken =>
      _rows.fold<num>(0, (total, row) => total + row.takenQty);

  List<Map<String, dynamic>> get _selectedRows {
    return _rows
        .where((row) => row.woId != null)
        .map(
          (row) => <String, dynamic>{
            'wo_id': row.woId,
            'wo_no': row.label,
            'qty': row.takenQty,
          },
        )
        .toList();
  }

  void _notifyTotal() {
    widget.onTotalChanged?.call(_totalTaken);
    widget.onRowsChanged?.call(_selectedRows);
  }

  bool _isInProgress(dynamic status) {
    final value = status?.toString().trim().toLowerCase() ?? '';
    return value == 'diproses' || value == 'in_progress';
  }

  num _sourceQty(Map item) {
    for (final key in ['greige_qty', 'qty']) {
      final raw = item[key];
      if (raw is num) return raw;
      final text = raw?.toString().trim() ?? '';
      if (text.isEmpty) continue;
      final plain = num.tryParse(text);
      if (plain != null) return plain;
      final localized = num.tryParse(
        text.replaceAll('.', '').replaceAll(',', '.'),
      );
      if (localized != null) return localized;
    }
    return 0;
  }

  String _woLabel(Map item) {
    for (final key in ['wo_no', 'number', 'no', 'label']) {
      final value = item[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return 'WO ${item['id'] ?? ''}';
  }

  Future<List<Map<String, dynamic>>> _loadOptions() async {
    final service = WorkOrderService();
    await service.getDataList({
      'page': '1',
      'per_page': '100',
      'search': '',
    });

    final currentId = widget.currentWoId?.toString();
    return service.dataList.whereType<Map>().map((item) {
      final map = Map<String, dynamic>.from(item);
      return {
        'value': map['id'],
        'label': _woLabel(map),
        'qty': _sourceQty(map),
        'status': map['status'],
      };
    }).where((item) {
      final id = item['value']?.toString() ?? '';
      if (id.isEmpty) return false;
      if (currentId != null && id == currentId) return false;
      return _isInProgress(item['status']);
    }).map((item) {
      return {
        'value': item['value'],
        'label': item['label'],
        'qty': item['qty'],
      };
    }).toList();
  }

  Future<void> _pickWorkOrder(int index) async {
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
    final takenIds = _rows
        .where((item) => item.woId != null && item != row)
        .map((item) => item.woId.toString())
        .toSet();
    final options = _options!
        .where((item) => !takenIds.contains(item['value'].toString()))
        .toList();

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (dialogContext) {
        return SelectDialog(
          label: 'Work Order',
          options: options,
          selected: row.woId?.toString() ?? '',
          handleChangeValue: (value) {
            setState(() {
              if (value is Map) {
                row.woId = value['value'];
                row.label = value['label']?.toString() ?? '';
                row.availableQty = value['qty'] is num
                    ? value['qty'] as num
                    : num.tryParse('${value['qty']}') ?? 0;
              } else {
                row.woId = null;
                row.label = '';
                row.availableQty = 0;
                row.takenQty = 0;
                row.qtyController.clear();
              }
            });
            _notifyTotal();
          },
        );
      },
    );
  }

  void _addRow() {
    setState(() => _rows.add(_AbsorbRow()));
  }

  void _removeRow(int index) {
    setState(() {
      if (_rows.length == 1) {
        final row = _rows.first;
        row.woId = null;
        row.label = '';
        row.availableQty = 0;
        row.takenQty = 0;
        row.qtyController.clear();
        return;
      }
      _rows.removeAt(index).dispose();
    });
    _notifyTotal();
  }

  num _parseQty(String value) {
    final normalized = value.trim().replaceAll('.', '').replaceAll(',', '.');
    return num.tryParse(normalized) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Text(
          'Ambil qty dari WO lain',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < _rows.length; index++) ...[
          _buildRow(index),
          if (index != _rows.length - 1) const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add),
            label: const Text('Tambah WO'),
          ),
        ),
        Text(
          'Total qty diambil: ${formatNumber(_totalTaken)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _accumulationLine('Grade A dari input', widget.gradeAInput),
        const SizedBox(height: 8),
        _accumulationLine('Grade A dari WO lain', _totalTaken),
        const SizedBox(height: 8),
        _accumulationLine(
          'Total Grade A',
          widget.gradeAInput + _totalTaken,
          emphasize: true,
        ),
      ],
    );
  }

  Widget _accumulationLine(
    String label,
    num value, {
    bool emphasize = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: emphasize ? const Color(0xFF234393) : Colors.grey.shade700,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          formatNumber(value),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: emphasize ? const Color(0xFF234393) : const Color(0xFF3E3F49),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(int index) {
    final row = _rows[index];
    final remaining = row.availableQty - row.takenQty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectForm(
                  label: 'Work Order',
                  required: false,
                  isDisabled: _loading,
                  selectedValue: row.woId?.toString() ?? '',
                  selectedLabel: row.label,
                  onTap: () => _pickWorkOrder(index),
                ),
              ),
              IconButton(
                onPressed: () => _removeRow(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Hapus',
              ),
            ],
          ),
          if (row.woId != null) ...[
            const SizedBox(height: 12),
            TextForm(
              label: 'Qty diambil',
              isNumber: true,
              controller: row.qtyController,
              initialValue: row.takenQty == 0 ? '' : row.takenQty.toString(),
              handleChange: (value) {
                setState(() => row.takenQty = _parseQty(value));
                _notifyTotal();
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Sisa qty WO setelah diambil: ${formatNumber(remaining)}',
              style: TextStyle(
                color: remaining < 0 ? Colors.red.shade700 : Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
