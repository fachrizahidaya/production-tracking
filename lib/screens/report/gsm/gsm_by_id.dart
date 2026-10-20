import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/screens/report/evaluation_attachments.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
import 'package:textile_tracking/helpers/util/format_number.dart';
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
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

<<<<<<< HEAD
<<<<<<< HEAD
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final message = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => isWaiting
              ? GsmEditScreen(data: data)
              : GsmDetailScreen(data: data),
=======
      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => GsmDetailScreen(data: data),
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => isWaiting
              ? GsmEditScreen(data: data)
              : GsmDetailScreen(data: data),
>>>>>>> d9ba4836 (fix: detail evaluasi)
        ),
      );

      if (!mounted) return;
      if (widget.returnToList) {
<<<<<<< HEAD
        _replaceWithGsmList(message: message);
      } else {
        Navigator.pop(context, message);
=======
        _replaceWithGsmList(
          saved: updated == true,
          woNo: data['woNo']?.toString(),
        );
      } else {
        Navigator.pop(context, updated);
>>>>>>> b77e0195 (fix: bs, gsm, rework)
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

<<<<<<< HEAD
  void _replaceWithGsmList({String? message}) {
=======
  void _replaceWithGsmList({bool saved = false, String? woNo}) {
>>>>>>> b77e0195 (fix: bs, gsm, rework)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GsmList(
<<<<<<< HEAD
          savedMessage: message,
=======
          savedWoNo: saved ? woNo : null,
>>>>>>> b77e0195 (fix: bs, gsm, rework)
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
<<<<<<< HEAD
<<<<<<< HEAD
  final TextEditingController _preventivePlanController =
      TextEditingController();
=======
  final TextEditingController _actionPlanController = TextEditingController();
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
  final TextEditingController _preventivePlanController =
      TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final ReportService _reportService = ReportService();
  bool _saving = false;
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
  int _selectedHistoryIndex = 0;
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 0e409703 (fix: evaluasi)

  @override
  void initState() {
    super.initState();
    _reasonController.text = widget.data['reason']?.toString() ?? '';
<<<<<<< HEAD
<<<<<<< HEAD
=======
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
<<<<<<< HEAD
<<<<<<< HEAD
=======
    _actionPlanController.dispose();
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
    _preventivePlanController.dispose();
    super.dispose();
  }

  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
    return status == 'direview' ||
        status == 'reviewed' ||
        status == 'selesai' ||
        status == 'completed';
<<<<<<< HEAD
  }

  Future<void> _openEditScreen() async {
    final message = await Navigator.push<String>(
=======
    return status == 'selesai' || status == 'completed';
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
  }

  Future<void> _openEditScreen() async {
    final updated = await Navigator.push<bool>(
>>>>>>> b77e0195 (fix: bs, gsm, rework)
      context,
      MaterialPageRoute(
        builder: (context) => GsmEditScreen(data: widget.data),
      ),
    );

<<<<<<< HEAD
    if (message != null && message.trim().isNotEmpty && mounted) {
      Navigator.pop(context, message);
=======
    if (updated == true && mounted) {
      Navigator.pop(context, true);
    }
  }

<<<<<<< HEAD
  Future<void> _saveWaitingForm() async {
    if (_saving || !_canSaveWaiting) return;
    setState(() => _saving = true);
    try {
      await _reportService.updateGsmDetail(
        id: widget.data['id'],
        reason: _reasonController.text,
        actionPlan: _actionPlanController.text,
        preventivePlan: _preventivePlanController.text,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      await showAlertDialog(
        context: context,
        title: 'Gagal Menyimpan',
        message: e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
      );
>>>>>>> b77e0195 (fix: bs, gsm, rework)
    }
  }

=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi GSM',
        onReturn: () => Navigator.pop(context),
<<<<<<< HEAD
<<<<<<< HEAD
        onEdit: _isCompleted ? _openEditScreen : null,
=======
        onEdit: _useEditScreen ? _openEditScreen : null,
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
        onEdit: _isCompleted ? _openEditScreen : null,
>>>>>>> d9ba4836 (fix: detail evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
              _buildReadOnlyCard(
                'Alasan dan Penyebab',
                _reasonController.text,
                updatedAt: widget.data['reason_updated_at']?.toString(),
<<<<<<< HEAD
<<<<<<< HEAD
                historyField: 'reason',
=======
=======
                historyField: 'reason',
>>>>>>> 8eee7be2 (fix: bs dan gsm)
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
<<<<<<< HEAD
                'Rencana Tindakan',
                _actionPlanController.text,
                updatedAt: widget.data['action_plan_updated_at']?.toString(),
<<<<<<< HEAD
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
                historyField: 'action_plan',
>>>>>>> 0e409703 (fix: evaluasi)
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
                'Rencana Pencegahan',
                _preventivePlanController.text,
                updatedAt:
                    widget.data['preventive_plan_updated_at']?.toString(),
<<<<<<< HEAD
<<<<<<< HEAD
                historyField: 'preventive_plan',
              ),
              const SizedBox(height: 16),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: EvaluationAttachmentGallery(
                  attachments: widget.data['attachments'],
                ),
              ),
<<<<<<< HEAD
=======
              if (_useEditScreen) ...[
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
              ] else ...[
                _buildEditorForm(
                  label: 'Alasan dan Penyebab',
                  controller: _reasonController,
                ),
                const SizedBox(height: 16),
                _buildEditorForm(
                  label: 'Rencana Tindakan',
                  controller: _actionPlanController,
                ),
                const SizedBox(height: 16),
                _buildEditorForm(
                  label: 'Rencana Pencegahan',
                  controller: _preventivePlanController,
                ),
              ],
=======
              ),
>>>>>>> d9ba4836 (fix: detail evaluasi)
              if (_histories.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildHistoryCard(),
              ],
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
              _buildHistoryCard(),
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
                historyField: 'preventive_plan',
              ),
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
            ],
          ),
        ),
      ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
      bottomNavigationBar: _isWaiting ? _buildSaveBar() : null,
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
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
<<<<<<< HEAD
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
          if (_isCompleted) ...[
            const SizedBox(height: 12),
            _buildSubmittedByItem(),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatusBadge(_value('status')),
=======
            label: 'Packing GSM',
            value: _formatGsmNumber(_raw('packingGsm')),
=======
            label: 'No. Packing',
            value: _value('packingNo'),
            valueColor: const Color(0xFF234393),
>>>>>>> e7b9ec75 (fix: UI evaluasi)
          ),
          const SizedBox(height: 12),
          _buildOverviewItem(
            label: 'Packing GSM',
            value: _formatGsmNumber(_raw('packingGsm')),
            valueColor: const Color(0xFFB42318),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Mulai',
=======
>>>>>>> 9b746b6d (fix: UI)
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
          if (_isCompleted) ...[
            const SizedBox(height: 12),
            _buildSubmittedByItem(),
          ],
          const SizedBox(height: 12),
<<<<<<< HEAD
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
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
          Align(
            alignment: Alignment.centerRight,
            child: _buildStatusBadge(_value('status')),
>>>>>>> 8eee7be2 (fix: bs dan gsm)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0e409703 (fix: evaluasi)
  Widget _buildSubmittedByItem() {
    final name = _value('submittedBy');
    final time = _formatDateTime(_value('completedAt'));
    final hasTime = time.trim().isNotEmpty && time != '-';

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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9b746b6d (fix: UI)
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
<<<<<<< HEAD
        ),
=======
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF3E3F49),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (hasTime) ...[
          const SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
>>>>>>> 0e409703 (fix: evaluasi)
=======
        ),
>>>>>>> 9b746b6d (fix: UI)
      ],
    );
  }

<<<<<<< HEAD
=======
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> 0e409703 (fix: evaluasi)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
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
            onPressed: _canSaveWaiting && !_saving ? _saveWaitingForm : null,
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

>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
=======
      case 'selesai':
      case 'completed':
        return const Color(0xFFEBFDF4);
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFF8697C6);
      case 'menunggu':
      case 'waiting':
        return const Color(0xFF955B34);
=======
=======
      case 'direview':
      case 'reviewed':
>>>>>>> e7b9ec75 (fix: UI evaluasi)
      case 'selesai':
      case 'completed':
        return const Color(0xFF8697C6);
      case 'menunggu':
      case 'waiting':
<<<<<<< HEAD
        return const Color(0xFFA16207);
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
        return const Color(0xFF955B34);
>>>>>>> e7b9ec75 (fix: UI evaluasi)
      default:
        return _getStatusColor(status);
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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

<<<<<<< HEAD
=======
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
  Widget _buildFormCard({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TemplateCard(
        title: label,
        icon: Icons.description_outlined,
        child: child,
      ),
    );
  }

>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
  Widget _buildReadOnlyCard(
    String label,
    String value, {
    String? updatedAt,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0e409703 (fix: evaluasi)
    String? historyField,
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
    final current = value.isEmpty ? '-' : value;
    final historyItems = historyField == null
        ? const <Map<String, dynamic>>[]
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8eee7be2 (fix: bs dan gsm)
        : _fieldHistoryItems(historyField);
    final versions = _historyVersions(historyItems);
    final previousVersions = versions.length > 1
        ? versions.sublist(0, versions.length - 1)
        : const <Map<String, dynamic>>[];
    final latestVersion = versions.isNotEmpty ? versions.last : null;
    final latestMeta = latestVersion != null
        ? _historyActorMeta(latestVersion)
<<<<<<< HEAD
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);
=======
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
        : _previousHistoryItems(historyField);
    final previousItems = historyItems.where((item) {
      final oldValue = _historyDisplayValue(item['old_value']);
      return oldValue.isNotEmpty && oldValue != current;
    }).toList();
    final latestItem = historyItems.isNotEmpty ? historyItems.last : null;
    final latestMeta = latestItem != null
        ? 'Diubah oleh ${_personName(latestItem['changed_by'])}, '
            '${_formatDateTime(latestItem['created_at']?.toString() ?? '-')}'
=======
>>>>>>> 8eee7be2 (fix: bs dan gsm)
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);
>>>>>>> 0e409703 (fix: evaluasi)

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
=======
              for (final previous in previousItems) ...[
                Text(
                  _historyDisplayValue(previous['old_value']),
>>>>>>> 0e409703 (fix: evaluasi)
=======
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
>>>>>>> 8eee7be2 (fix: bs dan gsm)
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('base'),
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
<<<<<<< HEAD
<<<<<<< HEAD
                  _historyActorMeta(previous),
=======
                  'Diubah oleh ${_personName(previous['changed_by'])}, '
                  '${_formatDateTime(previous['created_at']?.toString() ?? '-')}',
>>>>>>> 0e409703 (fix: evaluasi)
=======
                  _historyActorMeta(previous),
>>>>>>> 8eee7be2 (fix: bs dan gsm)
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
              ],
<<<<<<< HEAD
              Text(
                current,
=======
              Text(
                value.isEmpty ? '-' : value,
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
              Text(
                current,
>>>>>>> 0e409703 (fix: evaluasi)
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('base'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[800],
                ),
              ),
<<<<<<< HEAD
<<<<<<< HEAD
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
=======
              if (hasUpdatedAt) ...[
                const SizedBox(height: 8),
                Text(
                  _formatDateTime(updatedAt),
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
>>>>>>> 0e409703 (fix: evaluasi)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  List<Map<String, dynamic>> _fieldHistoryItems(String field) {
    Map<String, dynamic>? group;
    final expectedLabel = _historyFieldLabel(field).toLowerCase();
    for (final history in _histories) {
      final historyField = history['field']?.toString();
      final label = history['label']?.toString().trim().toLowerCase() ?? '';
      if (historyField == field || label == expectedLabel) {
=======
  List<Map<String, dynamic>> _previousHistoryItems(String field) {
=======
  List<Map<String, dynamic>> _fieldHistoryItems(String field) {
>>>>>>> 8eee7be2 (fix: bs dan gsm)
    Map<String, dynamic>? group;
    final expectedLabel = _historyFieldLabel(field).toLowerCase();
    for (final history in _histories) {
      final historyField = history['field']?.toString();
<<<<<<< HEAD
      final label = history['label']?.toString().trim() ?? '';
      if (historyField == field || label == _historyFieldLabel(field)) {
>>>>>>> 0e409703 (fix: evaluasi)
=======
      final label = history['label']?.toString().trim().toLowerCase() ?? '';
      if (historyField == field || label == expectedLabel) {
>>>>>>> 8eee7be2 (fix: bs dan gsm)
        group = history;
        break;
      }
    }
    if (group == null) return [];

    final items = List<Map<String, dynamic>>.from(_historyItems(group));
    items.sort((a, b) {
      final aDate = DateTime.tryParse(a['created_at']?.toString() ?? '');
      final bDate = DateTime.tryParse(b['created_at']?.toString() ?? '');
      if (aDate == null || bDate == null) return 0;
      return aDate.compareTo(bDate);
    });
    return items;
<<<<<<< HEAD
=======
  String _historyGroupLabel(Map<String, dynamic> group) {
    final label = group['label']?.toString().trim() ?? '';
    return label.isNotEmpty
        ? label
        : _historyFieldLabel(group['field']?.toString());
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 0e409703 (fix: evaluasi)
  }

  List<Map<String, dynamic>> _historyItems(Map<String, dynamic> group) {
    final raw = group['items'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
<<<<<<< HEAD
<<<<<<< HEAD
        .where((item) => item['new_value'] != null)
=======
        .where(
          (item) => item['old_value'] != null && item['new_value'] != null,
        )
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
        .where((item) => item['new_value'] != null)
>>>>>>> 8eee7be2 (fix: bs dan gsm)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8eee7be2 (fix: bs dan gsm)
  List<Map<String, dynamic>> _historyVersions(
    List<Map<String, dynamic>> historyItems,
  ) {
    final versions = <Map<String, dynamic>>[];
    for (final item in historyItems) {
      final text = _historyDisplayValue(item['new_value']);
      if (text.isEmpty) continue;
      versions.add({
        'value': text,
        'isInitial': item['old_value'] == null,
        'changed_by': item['changed_by'],
        'created_at': item['created_at'],
      });
    }
    return versions;
  }

  String _historyActorMeta(Map<String, dynamic> version) {
    final isInitial = version['isInitial'] == true;
    final prefix = isInitial ? 'Diisi oleh' : 'Diubah oleh';
    return '$prefix ${_personName(version['changed_by'])}, '
        '${_formatDateTime(version['created_at']?.toString() ?? '-')}';
  }

  String _historyDisplayValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value.map((item) => item.toString()).join(', ').trim();
    }
    return value.toString().trim();
=======
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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

<<<<<<< HEAD
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
        onChanged: (_) => setState(() {}),
      ),
    );
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
=======
>>>>>>> 0e409703 (fix: evaluasi)
  String _historyDisplayValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value.map((item) => item.toString()).join(', ').trim();
    }
    return value.toString().trim();
>>>>>>> d9ba4836 (fix: detail evaluasi)
  }
}
