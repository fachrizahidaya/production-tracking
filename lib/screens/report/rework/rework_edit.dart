import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/multi_select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/evaluation_draft.dart';
import 'package:textile_tracking/screens/report/service.dart';

ButtonStyle _primarySheetButtonStyle() => ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4561DB),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

ButtonStyle _secondarySheetButtonStyle() => OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

class ReworkEditScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ReworkEditScreen({super.key, required this.data});

  @override
  State<ReworkEditScreen> createState() => _ReworkEditScreenState();
}

class _ReworkEditScreenState extends State<ReworkEditScreen> {
  final ReportService _reportService = ReportService();
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();
  bool _saving = false;
  bool _loadingReasons = true;
  int _visibleStep = 1;
  List<Map<String, dynamic>> _reasonOptions = [];
  List<Map<String, dynamic>> _selectedReasons = [];

  String get _draftType => 'rework';

  @override
  void initState() {
    super.initState();
    final reasons = widget.data['reasons'];
    if (reasons is List) {
      _selectedReasons = reasons
          .where((reason) => reason.toString().trim().isNotEmpty)
          .map((reason) => {
                'value': reason.toString(),
                'label': reason.toString(),
              })
          .toList();
    }
    _actionPlanController.text = _textValue(widget.data['actionPlan']);
    _preventivePlanController.text = _textValue(widget.data['preventivePlan']);
    _visibleStep = _stepFromValues();
    _actionPlanController.addListener(_persistDraft);
    _preventivePlanController.addListener(_persistDraft);
    _loadDraft();
    _loadReasonOptions();
  }

  @override
  void dispose() {
    _actionPlanController.removeListener(_persistDraft);
    _preventivePlanController.removeListener(_persistDraft);
    _actionPlanController.dispose();
    _preventivePlanController.dispose();
    super.dispose();
  }

  String _textValue(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text == '-' ? '' : text;
  }

  int _stepFromValues() {
    if (_textValue(_preventivePlanController.text).isNotEmpty) return 3;
    if (_textValue(_actionPlanController.text).isNotEmpty) return 2;
    return 1;
  }

  Future<void> _loadDraft() async {
    final draft = await EvaluationDraft.load(_draftType, widget.data['id']);
    if (!mounted || draft == null) return;

    setState(() {
      final reasons = draft['reasons'];
      if (reasons is List) {
        _selectedReasons = reasons
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
      if (draft.containsKey('actionPlan')) {
        _actionPlanController.text = draft['actionPlan']?.toString() ?? '';
      }
      if (draft.containsKey('preventivePlan')) {
        _preventivePlanController.text =
            draft['preventivePlan']?.toString() ?? '';
      }
      final savedStep = draft['visibleStep'];
      _visibleStep = math.max(
        _stepFromValues(),
        savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1,
      );
    });
  }

  Future<void> _persistDraft() async {
    await EvaluationDraft.save(_draftType, widget.data['id'], {
      'reasons': _selectedReasons,
      'actionPlan': _actionPlanController.text,
      'preventivePlan': _preventivePlanController.text,
      'visibleStep': _visibleStep,
    });
    if (mounted) setState(() {});
  }

  void _goNext() {
    if (_visibleStep >= 3 || !_canGoNext) return;
    setState(() => _visibleStep += 1);
    _persistDraft();
  }

  Future<void> _save() async {
    if (_saving || !_canSave) return;

    final warning = _planLengthWarning();
    if (warning != null) {
      await showAlertDialog(
        context: context,
        title: 'Peringatan',
        message: warning,
      );
      return;
    }

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
      await EvaluationDraft.clear(_draftType, widget.data['id']);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      await showAlertDialog(
        context: context,
        title: 'Gagal Menyimpan',
        message: _errorMessage(e),
      );
    }
  }

  String _errorMessage(Object error) {
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  bool get _canSave {
    return _selectedReasons.isNotEmpty &&
        _actionPlanController.text.trim().isNotEmpty &&
        _preventivePlanController.text.trim().isNotEmpty;
  }

  bool get _canGoNext {
    if (_visibleStep == 1) return _selectedReasons.isNotEmpty;
    if (_visibleStep == 2) {
      return _actionPlanController.text.trim().length >= 8;
    }
    return false;
  }

  String? _planLengthWarning() {
    final actionOk = _actionPlanController.text.trim().length >= 8;
    final preventiveOk = _preventivePlanController.text.trim().length >= 8;
    if (actionOk && preventiveOk) return null;
    if (!actionOk && !preventiveOk) {
      return 'Rencana Tindakan dan Rencana Pencegahan minimal 8 karakter.';
    }
    if (!actionOk) return 'Rencana Tindakan minimal 8 karakter.';
    return 'Rencana Pencegahan minimal 8 karakter.';
  }

  Future<void> _loadReasonOptions() async {
    try {
      final options = await _reportService.getReworkReasonOptions();
      final values = options.map((option) => option['value']).toSet();
      final selectedOnly = _selectedReasons
          .where((reason) => !values.contains(reason['value']))
          .toList();
      if (!mounted) return;
      setState(() {
        _reasonOptions = [...options, ...selectedOnly];
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
        _selectedReasons.map((reason) => reason['value'].toString()).toSet();
    final availableOptions = _reasonOptions
        .where((option) => !selectedValues.contains(option['value']))
        .toList();

    final selected = await _showReasonSelectionSheet(availableOptions);

    if (selected == null || !mounted) return;
    setState(() {
      for (final value in selected) {
        final option = availableOptions.firstWhere(
          (item) => item['value'] == value,
          orElse: () => {'value': value, 'label': value},
        );
        if (!_selectedReasons.any((item) => item['value'] == option['value'])) {
          _selectedReasons.add(option);
        }
      }
    });
    _persistDraft();
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
                              style: _secondarySheetButtonStyle(),
                              child: const Text('Batal'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(sheetContext, selectedIds),
                              style: _primarySheetButtonStyle(),
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

  Future<void> _addReasonOption() async {
    final label = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _EditReasonOptionSheet(),
    );

    if (label == null || label.trim().isEmpty || !mounted) return;
    try {
      final option = await _reportService.createReworkReasonOption(label);
      if (!mounted) return;
      setState(() {
        _reasonOptions.add(option);
        _selectedReasons.add(option);
      });
      _persistDraft();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah alasan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Evaluasi Rework',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Column(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildReasonForm(),
              ),
              if (_visibleStep >= 2) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildEditorForm(
                    label: 'Rencana Tindakan',
                    controller: _actionPlanController,
                  ),
                ),
              ],
              if (_visibleStep >= 3) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildEditorForm(
                    label: 'Rencana Pencegahan',
                    controller: _preventivePlanController,
                  ),
                ),
              ],
              if (_visibleStep < 3) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildNextButton(),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSaveBar(),
    );
  }

  Widget _buildSaveBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _canSave && !_saving ? _save : null,
            style: _primaryActionButtonStyle,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Simpan'),
          ),
        ),
      ),
    );
  }

  ButtonStyle get _primaryActionButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4561DB),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  Widget _buildReasonForm() {
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
                _selectedReasons.map((reason) => reason['value']).toList(),
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
                    onDeleted: () {
                      setState(() {
                        _selectedReasons.removeWhere(
                          (reason) => reason['value'] == item['value'],
                        );
                      });
                      _persistDraft();
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required String label, required Widget child}) {
    return TemplateCard(
      title: label,
      icon: Icons.description_outlined,
      child: child,
    );
  }

  Widget _buildEditorForm({
    required String label,
    required TextEditingController controller,
  }) {
    return _buildFormCard(
      label: label,
      child: TextField(
        controller: controller,
        minLines: 6,
        maxLines: 12,
        decoration: CustomTheme().inputDecoration('Masukkan $label'),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _canGoNext ? _goNext : null,
        style: _primaryActionButtonStyle,
        child: const Text('Selanjutnya'),
      ),
    );
  }

  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
    return status == 'direview' ||
        status == 'reviewed' ||
        status == 'selesai' ||
        status == 'completed';
  }

  String _value(String key) => widget.data[key]?.toString() ?? '-';

  Map<String, dynamic> get _dyeing {
    final dyeing = widget.data['dyeing'];
    return dyeing is Map ? Map<String, dynamic>.from(dyeing) : {};
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
          _buildDyeingReferenceLine(),
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

  Widget _buildDyeingReferenceLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDyeingReferenceItem(
          label: 'Rework Dyeing',
          value: _value('dyeingProcessNo'),
          valueColor: const Color(0xFF234393),
        ),
        const SizedBox(height: 12),
        _buildProcessTimeItem(
          label: 'Mulai Rework',
          person: _dyeing['start_by'],
          time: _dyeing['start_time']?.toString(),
        ),
        const SizedBox(height: 12),
        _buildProcessTimeItem(
          label: 'Selesai Rework',
          person: _dyeing['end_by'],
          time: _dyeing['end_time']?.toString(),
        ),
      ],
    );
  }

  Widget _buildDyeingReferenceItem({
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
          maxLines: 1,
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

  Widget _buildCategoryCard() {
    final categories = _reworkCategories();

    return TemplateCard(
      title: 'Kategori Rework',
      icon: Icons.local_offer_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _categoryTitle(categories),
            style: TextStyle(
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: Colors.grey[800],
            ),
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...categories.asMap().entries.map(
                  (entry) => _buildCategoryItem(
                    entry.value,
                    isLast: entry.key == categories.length - 1,
                  ),
                ),
          ],
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
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
}

class _EditReasonOptionSheet extends StatefulWidget {
  const _EditReasonOptionSheet();

  @override
  State<_EditReasonOptionSheet> createState() => _EditReasonOptionSheetState();
}

class _EditReasonOptionSheetState extends State<_EditReasonOptionSheet> {
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
                decoration: const InputDecoration(
                  hintText: 'Masukkan alasan rework',
                  border: OutlineInputBorder(),
                ).copyWith(errorText: _errorMessage),
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
                      style: _secondarySheetButtonStyle(),
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
                      style: _primarySheetButtonStyle(),
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
