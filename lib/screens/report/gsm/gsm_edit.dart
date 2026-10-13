<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:math' as math;

=======
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======
import 'dart:math' as math;

>>>>>>> d256f82 (fix: UI evaluasi)
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d256f82 (fix: UI evaluasi)
import 'package:textile_tracking/helpers/util/evaluation_draft.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/screens/report/evaluation_attachments.dart';
=======
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======
import 'package:textile_tracking/helpers/util/format_number.dart';
>>>>>>> 7c2cdb6 (fix:)
import 'package:textile_tracking/screens/report/service.dart';

class GsmEditScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const GsmEditScreen({super.key, required this.data});

  @override
  State<GsmEditScreen> createState() => _GsmEditScreenState();
}

class _GsmEditScreenState extends State<GsmEditScreen> {
  final ReportService _reportService = ReportService();
  final TextEditingController _reasonController = TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
  final TextEditingController _preventivePlanController =
      TextEditingController();
  bool _saving = false;
  int _visibleStep = 1;
  List<Map<String, dynamic>> _attachments = [];

  String get _draftType => 'gsm';
=======
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();
  bool _saving = false;
<<<<<<< HEAD
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======
  int _visibleStep = 1;

  String get _draftType => 'gsm';
>>>>>>> d256f82 (fix: UI evaluasi)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
<<<<<<< HEAD
    _reasonController.text = _textValue(widget.data['reason']);
    _preventivePlanController.text = _textValue(widget.data['preventivePlan']);
    _attachments = parseEvaluationAttachments(widget.data['attachments']);
    _visibleStep = _stepFromValues();
    _reasonController.addListener(_persistDraft);
    _preventivePlanController.addListener(_persistDraft);
    _loadDraft();
=======
    _reasonController.text = widget.data['reason']?.toString() ?? '';
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======
    _reasonController.text = _textValue(widget.data['reason']);
    _preventivePlanController.text = _textValue(widget.data['preventivePlan']);
    _visibleStep = _stepFromValues();
    _reasonController.addListener(_persistDraft);
    _preventivePlanController.addListener(_persistDraft);
    _loadDraft();
>>>>>>> d256f82 (fix: UI evaluasi)
  }

  @override
  void dispose() {
<<<<<<< HEAD
<<<<<<< HEAD
    _reasonController.removeListener(_persistDraft);
    _preventivePlanController.removeListener(_persistDraft);
    _reasonController.dispose();
=======
=======
    _reasonController.removeListener(_persistDraft);
    _preventivePlanController.removeListener(_persistDraft);
>>>>>>> d256f82 (fix: UI evaluasi)
    _reasonController.dispose();
<<<<<<< HEAD
    _actionPlanController.dispose();
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
    _preventivePlanController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d256f82 (fix: UI evaluasi)
  String _textValue(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text == '-' ? '' : text;
  }

  int _stepFromValues() {
<<<<<<< HEAD
<<<<<<< HEAD
    if (_textValue(_preventivePlanController.text).isNotEmpty) return 2;
=======
    if (_textValue(_preventivePlanController.text).isNotEmpty) return 3;
    if (_textValue(_actionPlanController.text).isNotEmpty) return 2;
>>>>>>> d256f82 (fix: UI evaluasi)
=======
    if (_textValue(_preventivePlanController.text).isNotEmpty) return 2;
>>>>>>> c675884 (fix: remove rencana tindakan)
    return 1;
  }

  Future<void> _loadDraft() async {
    final draft = await EvaluationDraft.load(_draftType, widget.data['id']);
    if (!mounted || draft == null) return;

    setState(() {
      if (draft.containsKey('reason')) {
        _reasonController.text = draft['reason']?.toString() ?? '';
      }
<<<<<<< HEAD
<<<<<<< HEAD
=======
      if (draft.containsKey('actionPlan')) {
        _actionPlanController.text = draft['actionPlan']?.toString() ?? '';
      }
>>>>>>> d256f82 (fix: UI evaluasi)
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
      if (draft.containsKey('preventivePlan')) {
        _preventivePlanController.text =
            draft['preventivePlan']?.toString() ?? '';
      }
<<<<<<< HEAD
      if (draft.containsKey('attachments')) {
        final parsed = parseEvaluationAttachments(draft['attachments']);
        _attachments = parsed;
      }
      final savedStep = draft['visibleStep'];
      final parsedStep =
          savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1;
      _visibleStep = math.max(
        _stepFromValues(),
        parsedStep.clamp(1, 2),
=======
      final savedStep = draft['visibleStep'];
      final parsedStep =
          savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1;
      _visibleStep = math.max(
        _stepFromValues(),
<<<<<<< HEAD
        savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1,
>>>>>>> d256f82 (fix: UI evaluasi)
=======
        parsedStep >= 3 ? 2 : parsedStep.clamp(1, 2),
>>>>>>> c675884 (fix: remove rencana tindakan)
      );
    });
  }

  Future<void> _persistDraft() async {
    await EvaluationDraft.save(_draftType, widget.data['id'], {
      'reason': _reasonController.text,
<<<<<<< HEAD
<<<<<<< HEAD
      'preventivePlan': _preventivePlanController.text,
      'visibleStep': _visibleStep,
      'attachments': _attachments,
=======
      'actionPlan': _actionPlanController.text,
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
      'preventivePlan': _preventivePlanController.text,
      'visibleStep': _visibleStep,
>>>>>>> d256f82 (fix: UI evaluasi)
    });
    if (mounted) setState(() {});
  }

  void _goNext() {
<<<<<<< HEAD
<<<<<<< HEAD
    if (_visibleStep >= 2 || !_canGoNext) return;
=======
    if (_visibleStep >= 3 || !_canGoNext) return;
>>>>>>> d256f82 (fix: UI evaluasi)
=======
    if (_visibleStep >= 2 || !_canGoNext) return;
>>>>>>> c675884 (fix: remove rencana tindakan)
    setState(() => _visibleStep += 1);
    _persistDraft();
  }

<<<<<<< HEAD
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
      final message = await _reportService.updateGsmDetail(
        id: widget.data['id'],
        reason: _reasonController.text,
        actionPlan: '',
        preventivePlan: _preventivePlanController.text,
        attachments: _attachments,
      );
      await EvaluationDraft.clear(_draftType, widget.data['id']);

      if (!mounted) return;
      Navigator.pop(context, message);
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
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
      await _reportService.updateGsmDetail(
        id: widget.data['id'],
        reason: _reasonController.text,
        actionPlan: '',
        preventivePlan: _preventivePlanController.text,
      );
      await EvaluationDraft.clear(_draftType, widget.data['id']);

      if (!mounted) return;
      Navigator.pop(context, true);
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
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
<<<<<<< HEAD
    return _reasonController.text.trim().length >= 8 &&
        _preventivePlanController.text.trim().length >= 8;
  }

  bool get _canGoNext {
    if (_visibleStep == 1) return _reasonController.text.trim().length >= 8;
    return false;
  }

  String? _planLengthWarning() {
    final invalid = <String>[];
    if (_reasonController.text.trim().length < 8) {
      invalid.add('Alasan dan Penyebab');
    }
    if (_preventivePlanController.text.trim().length < 8) {
      invalid.add('Rencana Pencegahan');
    }
    if (invalid.isEmpty) return null;
    if (invalid.length == 1) return '${invalid.first} minimal 8 karakter.';
    return '${invalid[0]} dan ${invalid[1]} minimal 8 karakter.';
=======
    return _reasonController.text.trim().isNotEmpty &&
        _preventivePlanController.text.trim().isNotEmpty;
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
  }

  bool get _canGoNext {
    if (_visibleStep == 1) return _reasonController.text.trim().length >= 8;
    return false;
  }

  String? _planLengthWarning() {
    final invalid = <String>[];
    if (_reasonController.text.trim().length < 8) {
      invalid.add('Alasan dan Penyebab');
    }
    if (_preventivePlanController.text.trim().length < 8) {
      invalid.add('Rencana Pencegahan');
    }
    if (invalid.isEmpty) return null;
    if (invalid.length == 1) return '${invalid.first} minimal 8 karakter.';
    return '${invalid[0]} dan ${invalid[1]} minimal 8 karakter.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Evaluasi GSM',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
<<<<<<< HEAD
<<<<<<< HEAD
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
                child: _buildEditorForm(
                  label: 'Alasan dan Penyebab',
                  controller: _reasonController,
                ),
              ),
              if (_visibleStep >= 2) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildEditorForm(
<<<<<<< HEAD
                    label: 'Rencana Pencegahan',
                    controller: _preventivePlanController,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: EvaluationAttachmentEditor(
                    attachments: _attachments,
                    onChanged: (attachments) {
                      setState(() {
                        _attachments = attachments;
                      });
                      _persistDraft();
                    },
                  ),
                ),
              ],
              if (_visibleStep < 2) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildNextButton(),
                ),
              ],
=======
          padding: const EdgeInsets.all(16),
=======
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
>>>>>>> d256f82 (fix: UI evaluasi)
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildOverviewCard(),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildEditorForm(
                  label: 'Alasan dan Penyebab',
                  controller: _reasonController,
                ),
              ),
<<<<<<< HEAD
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======
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
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
                    label: 'Rencana Pencegahan',
                    controller: _preventivePlanController,
                  ),
                ),
              ],
              if (_visibleStep < 2) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildNextButton(),
                ),
              ],
>>>>>>> d256f82 (fix: UI evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d256f82 (fix: UI evaluasi)
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
<<<<<<< HEAD
      child: ElevatedButton(
        onPressed: _canGoNext ? _goNext : null,
        style: _primaryActionButtonStyle.copyWith(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
        ),
        child: const Text(
          'Selanjutnya',
          textAlign: TextAlign.center,
        ),
      ),
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
            label: 'No. Packing',
            value: _value('packingNo'),
            valueColor: const Color(0xFF234393),
          ),
          const SizedBox(height: 12),
          _buildOverviewItem(
            label: 'Packing GSM',
            value: _formatGsmNumber(_raw('packingGsm')),
            valueColor: const Color(0xFFB42318),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Mulai Packing',
            person: _packing['start_by'],
            time: _packing['start_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Selesai Packing',
            person: _packing['end_by'],
            time: _packing['end_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatusBadge(_value('status')),
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

  Map<String, dynamic> get _packing {
    final packing = widget.data['packing'];
    return packing is Map ? Map<String, dynamic>.from(packing) : {};
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
=======
        onChanged: (_) => setState(() {}),
=======
      height: 48,
      child: ElevatedButton(
        onPressed: _canGoNext ? _goNext : null,
        style: _primaryActionButtonStyle,
        child: const Text('Selanjutnya'),
>>>>>>> d256f82 (fix: UI evaluasi)
      ),
    );
  }
<<<<<<< HEAD
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
=======

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
            label: 'No. Packing',
            value: _value('packingNo'),
            valueColor: const Color(0xFF234393),
          ),
          const SizedBox(height: 12),
          _buildOverviewItem(
            label: 'Packing GSM',
            value: _formatGsmNumber(_raw('packingGsm')),
            valueColor: const Color(0xFFB42318),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Mulai Packing',
            person: _packing['start_by'],
            time: _packing['start_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Selesai Packing',
            person: _packing['end_by'],
            time: _packing['end_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatusBadge(_value('status')),
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

  Map<String, dynamic> get _packing {
    final packing = widget.data['packing'];
    return packing is Map ? Map<String, dynamic>.from(packing) : {};
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
>>>>>>> 7c2cdb6 (fix:)
}
