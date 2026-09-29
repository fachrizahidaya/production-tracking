import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/form/multi_select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/screens/report/rework/rework_edit.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ReworkDetailLoadingScreen extends StatefulWidget {
  final dynamic id;

  const ReworkDetailLoadingScreen({super.key, required this.id});

  @override
  State<ReworkDetailLoadingScreen> createState() =>
      _ReworkDetailLoadingScreenState();
}

class _ReworkDetailLoadingScreenState extends State<ReworkDetailLoadingScreen> {
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
      final data = await _reportService.getReworkDetail(widget.id);
      if (!mounted) return;

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => ReworkDetailScreen(data: data),
        ),
      );

      if (!mounted) return;
      Navigator.pop(context, updated == true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi Rework',
        onReturn: () => Navigator.pop(context),
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
                      'Gagal mengambil detail rework',
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
    final selected = await _showReasonSelectionSheet(available);
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
    final label = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ReasonOptionSheet(),
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

  Future<List<dynamic>?> _showReasonSelectionSheet(
    List<Map<String, dynamic>> items,
  ) {
    return showModalBottomSheet<List<dynamic>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        var filteredItems = List<Map<String, dynamic>>.from(items);
        var selectedIds = <dynamic>[];

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(
                        'Pilih Alasan Rework',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Cari alasan',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final query = value.trim().toLowerCase();
                          setSheetState(() {
                            filteredItems = items
                                .where((item) => item['label']
                                    .toString()
                                    .toLowerCase()
                                    .contains(query))
                                .toList();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filteredItems.isEmpty
                          ? const Center(child: Text('Tidak ada alasan'))
                          : ListView.separated(
                              itemCount: filteredItems.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final id = item['value'];
                                return CheckboxListTile(
                                  value: selectedIds.contains(id),
                                  title: Text(item['label'].toString()),
                                  activeColor: Colors.green,
                                  onChanged: (_) {
                                    setSheetState(() {
                                      if (selectedIds.contains(id)) {
                                        selectedIds = List.from(selectedIds)
                                          ..remove(id);
                                      } else {
                                        selectedIds = List.from(selectedIds)
                                          ..add(id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(sheetContext),
                              child: const Text('Batal'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(sheetContext, selectedIds),
                              child: const Text('Terapkan'),
                            ),
                          ),
                        ],
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildOverviewCard(),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildCategoryCard(),
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

  Widget _buildOverviewCard() {
    return Container(
      decoration: CustomTheme().cardTheme(),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkOrderBadge(_value('woNo')),
          const SizedBox(height: 12),
          _buildDyeingReferenceLine(),
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

  Widget _buildDyeingReferenceLine() {
    return Column(
      children: [
        _buildDyeingReferenceItem(
          icon: Icons.replay_outlined,
          label: 'Rework Dyeing',
          value: _value('dyeingProcessNo'),
          valueColor: const Color(0xFF234393),
        ),
        const SizedBox(height: 12),
        _buildDyeingReferenceItem(
          icon: Icons.link_outlined,
          label: 'Referensi Dyeing',
          value: _detailReferenceNo,
        ),
      ],
    );
  }

  Widget _buildDyeingReferenceItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon(
        //   icon,
        //   size: 19,
        //   color: Colors.grey.shade500,
        // ),
        // const SizedBox(width: 10),
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

  String get _detailReferenceNo {
    final dyeing = widget.data['dyeing'];
    final raw = widget.data['rework_reference'] ??
        (dyeing is Map ? dyeing['rework_reference'] : null);
    final reference = raw is Map ? raw : <String, dynamic>{};
    final value =
        reference['dyeing_no'] ?? reference['no'] ?? reference['reference_no'];
    return value?.toString().trim().isNotEmpty == true ? value.toString() : '-';
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

  Widget _buildCategoryCard() {
    final categories = _reworkCategories();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: CustomTheme().cardTheme(),
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

  Widget _buildWorkOrderBadge(String woNo) {
    const color = Color(0xFF234393);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        woNo,
        style: const TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
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

class _ReasonOptionSheet extends StatefulWidget {
  const _ReasonOptionSheet();

  @override
  State<_ReasonOptionSheet> createState() => _ReasonOptionSheetState();
}

class _ReasonOptionSheetState extends State<_ReasonOptionSheet> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Alasan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: CustomTheme()
                    .inputDecoration('Masukkan alasan rework')
                    .copyWith(errorText: _errorMessage),
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final value = _controller.text.trim();
                        if (value.length < 3) {
                          setState(
                            () => _errorMessage = 'Minimal 3 karakter',
                          );
                          return;
                        }
                        Navigator.pop(context, value);
                      },
                      child: const Text('Tambah'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
