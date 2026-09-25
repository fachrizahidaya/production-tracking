import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/dialog/multi_select_dialog.dart';
import 'package:textile_tracking/components/master/dialog/reason_option_dialog.dart';
import 'package:textile_tracking/components/master/form/multi_select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/screens/report/rework/rework_edit.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ReworkDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ReworkDetailScreen({super.key, required this.data});

  @override
  State<ReworkDetailScreen> createState() => _ReworkDetailScreenState();
}

class _ReworkDetailScreenState extends State<ReworkDetailScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();
  final ReportService _reportService = ReportService();
  List<Map<String, dynamic>> _reasonOptions = [];
  List<Map<String, dynamic>> _selectedReasons = [];
  bool _loadingReasons = false;
  bool _saving = false;
  int _waitingStep = 0;

  @override
  void initState() {
    super.initState();
    _reasonController.text = widget.data['reason']?.toString() ?? '';
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
    final reasons = widget.data['reasons'];
    if (reasons is List) {
      _selectedReasons = reasons
          .map((reason) => {
                'value': reason.toString(),
                'label': reason.toString(),
              })
          .toList();
    }
    if (_isWaiting) _loadReasonOptions();
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

  bool get _isWaiting {
    final status = widget.data['status']?.toString().toLowerCase();
    return status == 'menunggu' || status == 'waiting';
  }

  bool get _useEditScreen {
    return _isCompleted;
  }

  Future<void> _loadReasonOptions() async {
    setState(() => _loadingReasons = true);
    try {
      final options = await _reportService.getReworkReasonOptions();
      final optionValues = options.map((item) => item['value']).toSet();
      final existing = _selectedReasons
          .where((item) => !optionValues.contains(item['value']))
          .toList();
      if (!mounted) return;
      setState(() {
        _reasonOptions = [...options, ...existing];
        _loadingReasons = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingReasons = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil pilihan alasan: $e')),
      );
    }
  }

  Future<void> _selectReason() async {
    if (_loadingReasons) return;
    final selectedValues =
        _selectedReasons.map((item) => item['value']).toSet();
    final available = _reasonOptions
        .where((item) => !selectedValues.contains(item['value']))
        .toList();
    final selected = await showDialog<List<dynamic>>(
      context: context,
      builder: (context) => MultiSelectDialog(
        items: available,
        initialSelectedIds: const [],
        title: 'Pilih Alasan Rework',
      ),
    );
    if (selected == null || !mounted) return;

    final updated = [..._selectedReasons];
    for (final value in selected) {
      final option = available.firstWhere(
        (item) => item['value'] == value,
        orElse: () => {'value': value, 'label': value},
      );
      if (!updated.any((item) => item['value'] == option['value'])) {
        updated.add(option);
      }
    }
    await _persistReasons(updated);
  }

  Future<void> _removeReason(Map<String, dynamic> item) async {
    final updated = _selectedReasons
        .where((reason) => reason['value'] != item['value'])
        .toList();

    if (updated.isEmpty) {
      setState(() => _selectedReasons = updated);
      return;
    }

    await _persistReasons(updated);
  }

  Future<void> _persistReasons(List<Map<String, dynamic>> reasons) async {
    final previous = _selectedReasons;
    setState(() => _selectedReasons = reasons);
    try {
      await _reportService.updateReworkReasons(
        id: widget.data['id'],
        reasons: reasons.map((item) => item['value'].toString()).toList(),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _selectedReasons = previous);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan alasan rework: $e')),
      );
    }
  }

  Future<void> _addReasonOption() async {
    final label = await showDialog<String>(
      context: context,
      builder: (context) => const ReasonOptionDialog(),
    );

    if (label == null || label.trim().isEmpty || !mounted) return;
    try {
      final option = await _reportService.createReworkReasonOption(label);
      if (!mounted) return;
      setState(() => _reasonOptions.add(option));
      await _persistReasons([..._selectedReasons, option]);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah alasan: $e')),
      );
    }
  }

  Future<void> _openEditScreen() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ReworkEditScreen(data: widget.data),
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
        title: 'Detail Evaluasi Rework',
        onReturn: () => Navigator.pop(context),
        onEdit: _useEditScreen ? _openEditScreen : null,
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildSummaryRow(
                              'WO / Lot',
                              _value('woNo'),
                              valueColor: const Color(0xFF234393),
                              valueWeight: FontWeight.w600,
                            ),
                          ),
                          // if (_useEditScreen) _buildEditButton(),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _buildSummaryRow(
                        'Dyeing',
                        _value('dyeingProcessNo'),
                        valueColor: const Color(0xFF234393),
                        valueWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 18),
                      _buildSummaryRow(
                        'Tgl rework',
                        _formatDateTime(
                          _value(_isCompleted ? 'completedAt' : 'startedAt'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildSummaryRow(
                        'Status',
                        '',
                        trailing: _buildStatusBadge(_value('status')),
                      ),
                      const SizedBox(height: 18),
                      _buildSummaryRow(
                        'Diisi oleh',
                        _value('submittedBy'),
                      ),
                      const SizedBox(height: 26),
                      _buildCategoryCard(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _useEditScreen
                  ? _buildReadOnlyCard(
                      'Alasan dan Penyebab', _reasonController.text)
                  : _isWaiting
                      ? _buildWaitingForm()
                      : _buildFormCard(
                          label: 'Alasan',
                          child: TextField(
                            controller: _reasonController,
                            minLines: 3,
                            maxLines: 5,
                            decoration: CustomTheme().inputDecoration(
                              'Masukkan alasan rework',
                            ),
                          ),
                        ),
              const SizedBox(height: 16),
              if (!_isWaiting) ...[
                _useEditScreen
                    ? _buildReadOnlyCard(
                        'Rencana Tindakan', _actionPlanController.text)
                    : _buildEditorForm(
                        label: 'Action Plan',
                        controller: _actionPlanController,
                      ),
                const SizedBox(height: 16),
                _useEditScreen
                    ? _buildReadOnlyCard(
                        'Rencana Pencegahan', _preventivePlanController.text)
                    : _buildEditorForm(
                        label: 'Preventif Plan',
                        controller: _preventivePlanController,
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _value(String key) => widget.data[key]?.toString() ?? '-';

  Widget _buildWaitingForm() {
    switch (_waitingStep) {
      case 1:
        return _buildWaitingActionStep();
      case 2:
        return _buildWaitingPreventiveStep();
      default:
        return _buildWaitingReasonStep();
    }
  }

  Widget _buildWaitingReasonStep() {
    return _buildFormCard(
      label: 'Alasan',
      child: Column(
        children: [
          if (_selectedReasons.isNotEmpty) ...[
            _buildSelectedReasons(),
            const SizedBox(height: 12),
          ],
          MultiSelectForm(
            label: 'Alasan Rework',
            selectedValues:
                _selectedReasons.map((item) => item['value']).toList(),
            selectedItems: const [],
            selectedLabel: '',
            onTap: _selectReason,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _addReasonOption,
              icon: const Icon(Icons.add),
              label: const Text('Tambah alasan baru'),
            ),
          ),
          const SizedBox(height: 8),
          _buildNextButton(
            enabled: _selectedReasons.isNotEmpty,
            onPressed: () => setState(() => _waitingStep = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedReasons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alasan terpilih',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedReasons
                .map(
                  (item) => InputChip(
                    label: Text(item['label'].toString()),
                    onDeleted: () => _removeReason(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingActionStep() {
    return _buildEditorForm(
      label: 'Action Plan',
      controller: _actionPlanController,
      footer: _buildStepButtons(
        nextLabel: 'Selanjutnya',
        nextEnabled: _actionPlanController.text.trim().isNotEmpty,
        onNext: () => setState(() => _waitingStep = 2),
      ),
    );
  }

  Widget _buildWaitingPreventiveStep() {
    return _buildEditorForm(
      label: 'Preventif Plan',
      controller: _preventivePlanController,
      footer: _buildStepButtons(
        nextLabel: 'Simpan',
        nextEnabled:
            _preventivePlanController.text.trim().isNotEmpty && !_saving,
        onNext: _saveWaitingForm,
      ),
    );
  }

  Widget _buildNextButton({
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: const Text('Selanjutnya'),
      ),
    );
  }

  Widget _buildStepButtons({
    required String nextLabel,
    required bool nextEnabled,
    required VoidCallback onNext,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _saving ? null : () => setState(() => _waitingStep--),
              child: const Text('Kembali'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: nextEnabled ? onNext : null,
              child: _saving && nextLabel == 'Simpan'
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(nextLabel),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveWaitingForm() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await _reportService.updateReworkDetail(
        id: widget.data['id'],
        reasons: _selectedReasons
            .map((reason) => reason['value'].toString())
            .toList(),
        actionPlan: _actionPlanController.text,
        preventivePlan: _preventivePlanController.text,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan evaluasi rework: $e')),
      );
    }
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueWeight,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 168,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ),
        Expanded(
          child: trailing ??
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? const Color(0xFF292A2F),
                  fontSize: 16,
                  fontWeight: valueWeight,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard() {
    final categories = _reworkCategories();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: 64,
              //   height: 64,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF9F9FB),
              //     border: Border.all(color: Colors.grey.shade300),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Icon(Icons.sell_outlined, color: Colors.grey.shade600),
              // ),
              // const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KATEGORI REWORK',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _categoryTitle(categories),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade300),
          if (categories.isNotEmpty)
            ...categories.asMap().entries.map(
                  (entry) => _buildCategoryItem(
                    entry.value,
                    isLast: entry.key == categories.length - 1,
                  ),
                )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _value('category'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _reworkCategories() {
    final dyeing = widget.data['dyeing'];
    final raw = widget.data['rework_categories'] ??
        (dyeing is Map ? dyeing['rework_categories'] : null);
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _categoryTitle(List<Map<String, dynamic>> categories) {
    const repairTypes = {
      'perbaikan_warna',
      'perbaikan_noda',
      'pelemas_ulang',
    };
    if (categories.isNotEmpty &&
        categories.every(
          (item) => repairTypes.contains(item['type']?.toString()),
        )) {
      return 'Perbaikan';
    }
    return _value('category');
  }

  Widget _buildCategoryItem(
    Map<String, dynamic> category, {
    required bool isLast,
  }) {
    final label = category['label']?.toString() ?? '-';
    final methods = category['methods'] is List
        ? (category['methods'] as List)
            .whereType<Map>()
            .map((method) => method['label']?.toString() ?? '')
            .where((method) => method.isNotEmpty)
            .toList()
        : <String>[];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletText(label),
          for (final method in methods)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: _buildBulletText(
                method,
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBulletText(
    String text, {
    Color color = const Color(0xFF292A2F),
    double fontSize = 17,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 18,
          child: Text('•', style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
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

  Widget _buildFormCard({required String label, required Widget child}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyCard(String label, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: CustomTheme().cardTheme(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 17, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorForm({
    required String label,
    required TextEditingController controller,
    Widget? footer,
  }) {
    return _buildFormCard(
      label: label,
      child: Column(
        children: [
          TextField(
            controller: controller,
            minLines: 6,
            maxLines: 12,
            decoration: CustomTheme().inputDecoration('Masukkan $label'),
            onChanged: (_) => setState(() {}),
          ),
          if (footer != null) ...[
            const SizedBox(height: 16),
            footer,
          ],
        ],
      ),
    );
  }
}
