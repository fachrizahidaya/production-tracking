import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/screens/report/gsm/gsm_edit.dart';
import 'package:textile_tracking/screens/report/gsm/gsm_list.dart';
import 'package:textile_tracking/screens/report/service.dart';

class GsmDetailLoadingScreen extends StatefulWidget {
  final dynamic id;
  final bool returnToList;

  const GsmDetailLoadingScreen({
    super.key,
    required this.id,
    this.returnToList = false,
  });

  @override
  State<GsmDetailLoadingScreen> createState() => _GsmDetailLoadingScreenState();
}

class _GsmDetailLoadingScreenState extends State<GsmDetailLoadingScreen> {
  final ReportService _reportService = ReportService();
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() => _error = null);

    try {
      final data = await _reportService.getGsmDetail(widget.id);
      if (!mounted) return;

      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => isWaiting
              ? GsmEditScreen(data: data)
              : GsmDetailScreen(data: data),
        ),
      );

      if (!mounted) return;
      if (widget.returnToList) {
        _replaceWithGsmList(
          saved: updated == true,
          woNo: data['woNo']?.toString(),
        );
      } else {
        Navigator.pop(context, updated);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  void _replaceWithGsmList({bool saved = false, String? woNo}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GsmList(
          savedWoNo: saved ? woNo : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi GSM',
        onReturn: widget.returnToList
            ? _replaceWithGsmList
            : () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: Center(
        child: _error == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Gagal mengambil detail GSM',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadDetail,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class GsmDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const GsmDetailScreen({super.key, required this.data});

  @override
  State<GsmDetailScreen> createState() => _GsmDetailScreenState();
}

class _GsmDetailScreenState extends State<GsmDetailScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _reasonController.text = widget.data['reason']?.toString() ?? '';
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _actionPlanController.dispose();
    _preventivePlanController.dispose();
    super.dispose();
  }

  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
    return status == 'selesai' || status == 'completed';
  }

  Future<void> _openEditScreen() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => GsmEditScreen(data: widget.data),
      ),
    );

    if (updated == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi GSM',
        onReturn: () => Navigator.pop(context),
        onEdit: _isCompleted ? _openEditScreen : null,
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildOverviewCard(),
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
                'Alasan dan Penyebab',
                _reasonController.text,
                updatedAt: widget.data['reason_updated_at']?.toString(),
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
                'Rencana Tindakan',
                _actionPlanController.text,
                updatedAt: widget.data['action_plan_updated_at']?.toString(),
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
                'Rencana Pencegahan',
                _preventivePlanController.text,
                updatedAt:
                    widget.data['preventive_plan_updated_at']?.toString(),
              ),
              if (_histories.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildHistoryCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      decoration: CustomTheme().cardTheme(),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _value('woNo'),
            style: const TextStyle(
              color: Color(0xFF234393),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildOverviewItem(
            label: 'Packing GSM',
            value: _formatGsmNumber(_raw('packingGsm')),
          ),
          const SizedBox(height: 12),
          _buildOverviewItem(
            label: 'Material GSM',
            value: _formatGsmNumber(_raw('materialGsm')),
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _formatDateTime(
                    _value(_isCompleted ? 'completedAt' : 'startedAt'),
                  ),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
              _buildStatusBadge(_value('status')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF3E3F49),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialItem() {
    final code = _value('topMaterialCode');
    final name = _value('topMaterialName');

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
          code == '-' ? _value('material') : code,
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

  String _value(String key) => widget.data[key]?.toString() ?? '-';

  dynamic _raw(String key) => widget.data[key];

  String _formatGsmNumber(dynamic value) {
    if (value == null || value.toString().trim().isEmpty || value == '-') {
      return '-';
    }
    final parsed = num.tryParse(value.toString().replaceAll(',', '.'));
    if (parsed == null) return value.toString();
    return formatNumber(parsed);
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
      case 'selesai':
      case 'completed':
        return const Color(0xFFEBFDF4);
      case 'diproses':
      case 'in_progress':
        return Colors.orange;
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
      case 'selesai':
      case 'completed':
        return const Color(0xFF15803D);
      case 'menunggu':
      case 'waiting':
        return const Color(0xFFA16207);
      default:
        return _getStatusColor(status);
    }
  }

  String _formatDateTime(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    final local = date.toLocal();
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
        '${local.hour.toString().padLeft(2, '0')}.${local.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildReadOnlyCard(
    String label,
    String value, {
    String? updatedAt,
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TemplateCard(
        title: label,
        icon: Icons.description_outlined,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.isEmpty ? '-' : value,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('base'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[800],
                ),
              ),
              if (hasUpdatedAt) ...[
                const SizedBox(height: 8),
                Text(
                  _formatDateTime(updatedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _histories {
    final raw = widget.data['histories'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _historyFieldLabel(String? field) {
    switch (field) {
      case 'reason':
        return 'Alasan dan Penyebab';
      case 'action_plan':
        return 'Rencana Tindakan';
      case 'preventive_plan':
        return 'Rencana Pencegahan';
      default:
        return field?.toString() ?? '-';
    }
  }

  Widget _buildHistoryCard() {
    final histories = _histories;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TemplateCard(
        title: 'Riwayat Perubahan',
        icon: Icons.history_outlined,
        child: Column(
          children: [
            for (int i = 0; i < histories.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _buildHistoryItem(histories[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    final oldValue = _historyDisplayValue(history['old_value']);
    final newValue = _historyDisplayValue(history['new_value']);
    final hasOldValue = history['old_value'] != null && oldValue.isNotEmpty;
    final changedBy = history['changed_by'];
    final changedByName =
        changedBy is Map ? (changedBy['name']?.toString() ?? '-') : '-';
    final createdAt = history['created_at']?.toString();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _historyFieldLabel(history['field']?.toString()),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          if (hasOldValue) ...[
            Text(
              oldValue,
              style: TextStyle(
                fontSize: CustomTheme().fontSize('base'),
                color: Colors.grey.shade500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            newValue.isEmpty ? '-' : newValue,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('base'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'oleh $changedByName, ',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                createdAt == null || createdAt.isEmpty
                    ? '-'
                    : _formatDateTime(createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _historyDisplayValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value.map((item) => item.toString()).join(', ').trim();
    }
    return value.toString().trim();
  }
}
