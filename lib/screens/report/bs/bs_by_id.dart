import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
import 'package:textile_tracking/screens/report/bs/bs_list.dart';
import 'package:textile_tracking/screens/report/service.dart';

class BsDetailLoadingScreen extends StatefulWidget {
  final dynamic id;
  final bool returnToList;

  const BsDetailLoadingScreen({
    super.key,
    required this.id,
    this.returnToList = false,
  });

  @override
  State<BsDetailLoadingScreen> createState() => _BsDetailLoadingScreenState();
}

class _BsDetailLoadingScreenState extends State<BsDetailLoadingScreen> {
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
      final data = await _reportService.getBsDetail(widget.id);
      if (!mounted) return;

      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isWaiting ? BsEditScreen(data: data) : BsDetailScreen(data: data),
        ),
      );

      if (!mounted) return;
      if (widget.returnToList) {
        _replaceWithBsList(
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

  void _replaceWithBsList({bool saved = false, String? woNo}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BsList(
          savedWoNo: saved ? woNo : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi BS',
        onReturn: widget.returnToList
            ? _replaceWithBsList
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
                      'Gagal mengambil detail BS',
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

class BsDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const BsDetailScreen({super.key, required this.data});

  @override
  State<BsDetailScreen> createState() => _BsDetailScreenState();
}

class _BsDetailScreenState extends State<BsDetailScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();
  int _selectedHistoryIndex = 0;

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
    return status == 'direview' ||
        status == 'reviewed' ||
        status == 'selesai' ||
        status == 'completed';
  }

  Future<void> _openEditScreen() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BsEditScreen(data: widget.data),
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
        title: 'Detail Evaluasi BS',
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildCategoryCard(),
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
              const SizedBox(height: 16),
              _buildHistoryCard(),
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
            label: 'No. Sortir',
            value: _value('sortingNo'),
            valueColor: const Color(0xFF234393),
          ),
          const SizedBox(height: 12),
          _buildQtyBsItem(),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Mulai',
            person: _sorting['start_by'],
            time: _sorting['start_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Selesai',
            person: _sorting['end_by'],
            time: _sorting['end_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal BS',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDateTime(
                        _value(_isCompleted ? 'completedAt' : 'startedAt'),
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(_value('status')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBsItem() {
    final rate = _value('bsRate');
    final hasRate = rate != '-' && rate.trim().isNotEmpty;

    return Column(
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
        Row(
          children: [
            Text(
              '${_value('qtyBs')} PCS',
              style: const TextStyle(
                color: Color(0xFFB42318),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasRate) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3F2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$rate %',
                  style: const TextStyle(
                    color: Color(0xFFB42318),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
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

  Widget _buildCategoryCard() {
    final defects = _defects();

    return Container(
      decoration: CustomTheme().cardTheme(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color:
                        CustomTheme().buttonColor('primary').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_offer_outlined,
                    size: 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Tipe BS',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          if (defects.isEmpty)
            Padding(
              padding: CustomTheme().padding('item-detail'),
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[800],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                children: [
                  for (int i = 0; i < defects.length; i += 2) ...[
                    if (i > 0) const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildDefectItem(defects[i])),
                        const SizedBox(width: 10),
                        Expanded(
                          child: i + 1 < defects.length
                              ? _buildDefectItem(defects[i + 1])
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _defects() {
    final raw = widget.data['defects'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Widget _buildDefectItem(Map<String, dynamic> defect) {
    final name = defect['defect_name']?.toString() ?? '-';
    final qty = defect['qty']?.toString() ?? '-';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF292A2F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              qty,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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

  Map<String, dynamic> get _sorting {
    final sorting = widget.data['sorting'];
    return sorting is Map ? Map<String, dynamic>.from(sorting) : {};
  }

  Widget _buildProcessTimeItem({
    required String label,
    required dynamic person,
    required String? time,
  }) {
    final name = _personName(person);
    final formattedTime = _formatProcessTime(time);

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
        Row(
          children: [
            if (name != '-' || formattedTime == null)
              Text(
                name == '-' ? '-' : '$name${formattedTime != null ? ', ' : ''}',
                style: const TextStyle(
                  color: Color(0xFF3E3F49),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (formattedTime != null)
              Text(
                formattedTime,
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

  String _personName(dynamic person) {
    if (person is Map) {
      final name = person['name'] ?? person['full_name'];
      if (name != null && name.toString().trim().isNotEmpty) {
        return name.toString();
      }
    }
    return '-';
  }

  String? _formatProcessTime(String? value) {
    if (value == null || value.trim().isEmpty || value.trim() == '-') {
      return null;
    }
    return _formatDateTime(value);
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

  String _historyGroupLabel(Map<String, dynamic> group) {
    final label = group['label']?.toString().trim() ?? '';
    return label.isNotEmpty
        ? label
        : _historyFieldLabel(group['field']?.toString());
  }

  List<Map<String, dynamic>> _historyItems(Map<String, dynamic> group) {
    final raw = group['items'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .where(
          (item) => item['old_value'] != null && item['new_value'] != null,
        )
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Widget _buildHistoryCard() {
    final histories = _histories
        .where((history) => _historyItems(history).isNotEmpty)
        .toList();
    final selectedIndex =
        _selectedHistoryIndex >= 0 && _selectedHistoryIndex < histories.length
            ? _selectedHistoryIndex
            : 0;
    final items = histories.isEmpty
        ? <Map<String, dynamic>>[]
        : _historyItems(histories[selectedIndex]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TemplateCard(
        title: 'Riwayat Perubahan',
        icon: Icons.history_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (histories.isEmpty)
              const NoData()
            else ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < histories.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(_historyGroupLabel(histories[i])),
                        selected: i == selectedIndex,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() => _selectedHistoryIndex = i);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              if (items.isNotEmpty) const SizedBox(height: 12),
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                _buildHistoryItem(items[i]),
              ],
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
