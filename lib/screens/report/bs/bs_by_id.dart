import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
import 'package:textile_tracking/screens/report/evaluation_attachments.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
import 'package:textile_tracking/screens/report/evaluation_attachments.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
=======
>>>>>>> 85966df (fix: detail evaluasi)
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> 20aa0b1 (feat: Lampiran untuk evaluasi)
>>>>>>> 7da43251 (feat: Lampiran untuk evaluasi)
=======
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
import 'package:textile_tracking/screens/report/evaluation_attachments.dart';
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final message = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isWaiting ? BsEditScreen(data: data) : BsDetailScreen(data: data),
<<<<<<< HEAD
=======
      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => BsDetailScreen(data: data),
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final message = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isWaiting ? BsEditScreen(data: data) : BsDetailScreen(data: data),
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final message = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isWaiting ? BsEditScreen(data: data) : BsDetailScreen(data: data),
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
        ),
      );

      if (!mounted) return;
      if (widget.returnToList) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> 6f3012ab (fix: attachment evaluation)
        _replaceWithBsList(message: message);
      } else {
        Navigator.pop(context, message);
=======
        _replaceWithBsList(
          saved: updated == true,
          woNo: data['woNo']?.toString(),
        );
      } else {
        Navigator.pop(context, updated);
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
        _replaceWithBsList(message: message);
      } else {
        Navigator.pop(context, message);
>>>>>>> 01aa2117 (fix: attachment evaluation)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
        _replaceWithBsList(message: message);
      } else {
        Navigator.pop(context, message);
>>>>>>> dc5b5fe (fix: attachment evaluation)
>>>>>>> 6f3012ab (fix: attachment evaluation)
=======
        _replaceWithBsList(message: message);
      } else {
        Navigator.pop(context, message);
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  void _replaceWithBsList({String? message}) {
=======
  void _replaceWithBsList({bool saved = false, String? woNo}) {
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
  void _replaceWithBsList({String? message}) {
>>>>>>> 01aa2117 (fix: attachment evaluation)
=======
=======
>>>>>>> 6f3012ab (fix: attachment evaluation)
  void _replaceWithBsList({String? message}) {
=======
  void _replaceWithBsList({bool saved = false, String? woNo}) {
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
  void _replaceWithBsList({String? message}) {
>>>>>>> dc5b5fe (fix: attachment evaluation)
>>>>>>> 6f3012ab (fix: attachment evaluation)
=======
  void _replaceWithBsList({String? message}) {
>>>>>>> 0ba64c26 (chore: adjust fase-2)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BsList(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          savedMessage: message,
=======
          savedWoNo: saved ? woNo : null,
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
          savedMessage: message,
>>>>>>> 01aa2117 (fix: attachment evaluation)
=======
=======
>>>>>>> 6f3012ab (fix: attachment evaluation)
          savedMessage: message,
=======
          savedWoNo: saved ? woNo : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
          savedMessage: message,
>>>>>>> dc5b5fe (fix: attachment evaluation)
>>>>>>> 6f3012ab (fix: attachment evaluation)
=======
          savedMessage: message,
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> 754b7cda (fix: remove rencana tindakan)
  final TextEditingController _preventivePlanController =
      TextEditingController();
=======
  final TextEditingController _actionPlanController = TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
  final TextEditingController _preventivePlanController =
      TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final ReportService _reportService = ReportService();
  bool _saving = false;
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
  int _selectedHistoryIndex = 0;
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 0e409703 (fix: evaluasi)
=======
=======
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
>>>>>>> 754b7cda (fix: remove rencana tindakan)
  final TextEditingController _preventivePlanController =
      TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final ReportService _reportService = ReportService();
  bool _saving = false;
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> 85966df (fix: detail evaluasi)
<<<<<<< HEAD
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
=======
  int _selectedHistoryIndex = 0;
>>>>>>> d256f82 (fix: UI evaluasi)
<<<<<<< HEAD
>>>>>>> db08c830 (fix: UI evaluasi)
=======
=======
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
  final TextEditingController _preventivePlanController =
      TextEditingController();
>>>>>>> 0ba64c26 (chore: adjust fase-2)

  @override
  void initState() {
    super.initState();
    _reasonController.text = widget.data['reason']?.toString() ?? '';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
=======
=======
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
>>>>>>> 754b7cda (fix: remove rencana tindakan)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
    _actionPlanController.dispose();
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
=======
=======
    _actionPlanController.dispose();
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
    _actionPlanController.dispose();
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
>>>>>>> 754b7cda (fix: remove rencana tindakan)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
    _preventivePlanController.dispose();
    super.dispose();
  }

  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
    return status == 'direview' ||
        status == 'reviewed' ||
        status == 'selesai' ||
        status == 'completed';
  }

  Future<void> _openEditScreen() async {
    final message = await Navigator.push<String>(
<<<<<<< HEAD
=======
    return status == 'selesai' || status == 'completed';
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
  }

  Future<void> _openEditScreen() async {
<<<<<<< HEAD
    final updated = await Navigator.push<bool>(
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
    final message = await Navigator.push<String>(
>>>>>>> 01aa2117 (fix: attachment evaluation)
=======
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
  }

  Future<void> _openEditScreen() async {
<<<<<<< HEAD
    final updated = await Navigator.push<bool>(
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
    final message = await Navigator.push<String>(
>>>>>>> dc5b5fe (fix: attachment evaluation)
>>>>>>> 6f3012ab (fix: attachment evaluation)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      context,
      MaterialPageRoute(
        builder: (context) => BsEditScreen(data: widget.data),
      ),
    );

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> 6f3012ab (fix: attachment evaluation)
    if (message != null && message.trim().isNotEmpty && mounted) {
      Navigator.pop(context, message);
=======
    if (updated == true && mounted) {
      Navigator.pop(context, true);
<<<<<<< HEAD
<<<<<<< HEAD
=======
    if (message != null && message.trim().isNotEmpty && mounted) {
      Navigator.pop(context, message);
>>>>>>> 01aa2117 (fix: attachment evaluation)
=======
=======
=======
    if (message != null && message.trim().isNotEmpty && mounted) {
      Navigator.pop(context, message);
>>>>>>> dc5b5fe (fix: attachment evaluation)
>>>>>>> 6f3012ab (fix: attachment evaluation)
    }
  }

<<<<<<< HEAD
  Future<void> _saveWaitingForm() async {
    if (_saving || !_canSaveWaiting) return;
    setState(() => _saving = true);
    try {
      await _reportService.updateBsDetail(
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
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Future<void> _saveWaitingForm() async {
    if (_saving || !_canSaveWaiting) return;
    setState(() => _saving = true);
    try {
      await _reportService.updateBsDetail(
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
>>>>>>> b2b87875 (feat: evaluasi bs)
    }
  }

=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
=======
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
    if (message != null && message.trim().isNotEmpty && mounted) {
      Navigator.pop(context, message);
    }
  }

>>>>>>> 0ba64c26 (chore: adjust fase-2)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi BS',
        onReturn: () => Navigator.pop(context),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        onEdit: _isCompleted ? _openEditScreen : null,
=======
        onEdit: _useEditScreen ? _openEditScreen : null,
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
        onEdit: _isCompleted ? _openEditScreen : null,
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
        onEdit: _isCompleted ? _openEditScreen : null,
=======
        onEdit: _useEditScreen ? _openEditScreen : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
        onEdit: _isCompleted ? _openEditScreen : null,
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
        onEdit: _isCompleted ? _openEditScreen : null,
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
              _buildReadOnlyCard(
                'Alasan dan Penyebab',
                _reasonController.text,
                updatedAt: widget.data['reason_updated_at']?.toString(),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                historyField: 'reason',
=======
=======
                historyField: 'reason',
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
=======
>>>>>>> a087f712 (fix: bs dan gsm)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
                historyField: 'reason',
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
<<<<<<< HEAD
<<<<<<< HEAD
                'Rencana Tindakan',
                _actionPlanController.text,
                updatedAt: widget.data['action_plan_updated_at']?.toString(),
<<<<<<< HEAD
>>>>>>> 85966df (fix: detail evaluasi)
<<<<<<< HEAD
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
=======
                historyField: 'action_plan',
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
<<<<<<< HEAD
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
=======
=======
>>>>>>> c675884 (fix: remove rencana tindakan)
>>>>>>> 754b7cda (fix: remove rencana tindakan)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
                'Rencana Pencegahan',
                _preventivePlanController.text,
                updatedAt:
                    widget.data['preventive_plan_updated_at']?.toString(),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
                historyField: 'preventive_plan',
              ),
              const SizedBox(height: 16),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
=======
>>>>>>> 20aa0b1 (feat: Lampiran untuk evaluasi)
>>>>>>> 7da43251 (feat: Lampiran untuk evaluasi)
=======
                historyField: 'preventive_plan',
              ),
              const SizedBox(height: 16),
>>>>>>> 0ba64c26 (chore: adjust fase-2)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: EvaluationAttachmentGallery(
                  attachments: widget.data['attachments'],
                ),
              ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> 7da43251 (feat: Lampiran untuk evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
              ),
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
              ),
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
              if (_histories.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildHistoryCard(),
              ],
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
              _buildHistoryCard(),
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
                historyField: 'preventive_plan',
              ),
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
              _buildHistoryCard(),
>>>>>>> d256f82 (fix: UI evaluasi)
<<<<<<< HEAD
>>>>>>> db08c830 (fix: UI evaluasi)
=======
=======
                historyField: 'preventive_plan',
              ),
>>>>>>> 991dab5 (fix: evaluasi)
<<<<<<< HEAD
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
>>>>>>> 20aa0b1 (feat: Lampiran untuk evaluasi)
>>>>>>> 7da43251 (feat: Lampiran untuk evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
            ],
          ),
        ),
      ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
      bottomNavigationBar: _isWaiting ? _buildSaveBar() : null,
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
=======
      bottomNavigationBar: _isWaiting ? _buildSaveBar() : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
      bottomNavigationBar: _isWaiting ? _buildSaveBar() : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
          _buildQtyBsItem(),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Mulai Sortir',
<<<<<<< HEAD
=======
          _buildQtyBsItem(),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
            label: 'Mulai',
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
            label: 'Mulai Sortir',
>>>>>>> 9b746b6d (fix: UI)
=======
            label: 'Mulai',
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
=======
            label: 'Mulai',
>>>>>>> d256f82 (fix: UI evaluasi)
=======
            label: 'Mulai Sortir',
>>>>>>> cfa5498 (fix: UI)
>>>>>>> c3018adf (fix: UI)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
            person: _sorting['start_by'],
            time: _sorting['start_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> c3018adf (fix: UI)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
            label: 'Selesai Sortir',
            person: _sorting['end_by'],
            time: _sorting['end_time']?.toString(),
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
                  borderRadius: BorderRadius.circular(12),
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
<<<<<<< HEAD
=======
          _buildOverviewItem(
            label: 'Qty BS',
            value: '${_value('qtyBs')} PCS',
            valueColor: const Color(0xFF234393),
<<<<<<< HEAD
<<<<<<< HEAD
=======
            label: 'Selesai',
=======
            label: 'Selesai Sortir',
>>>>>>> 9b746b6d (fix: UI)
            person: _sorting['end_by'],
            time: _sorting['end_time']?.toString(),
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
=======
            label: 'Selesai',
=======
            label: 'Selesai Sortir',
>>>>>>> cfa5498 (fix: UI)
            person: _sorting['end_by'],
            time: _sorting['end_time']?.toString(),
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
          if (_isCompleted) ...[
            const SizedBox(height: 12),
            _buildSubmittedByItem(),
          ],
<<<<<<< HEAD
=======
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> db08c830 (fix: UI evaluasi)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
<<<<<<< HEAD
<<<<<<< HEAD
                      'Tanggal',
=======
                      'Tanggal BS',
>>>>>>> db08c830 (fix: UI evaluasi)
=======
                      'Tanggal',
>>>>>>> bdfa7c36 (fix: edit ui tanggal)
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
<<<<<<< HEAD
=======
                child: Text(
                  _formatDateTime(
                    _value(_isCompleted ? 'completedAt' : 'startedAt'),
                  ),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
                ),
              ),
              _buildStatusBadge(_value('status')),
            ],
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8eee7be2 (fix: bs dan gsm)
          ),
        ],
      ),
>>>>>>> b2b87875 (feat: evaluasi bs)
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
                  borderRadius: BorderRadius.circular(12),
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
=======
=======
=======
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
          ),
        ],
      ),
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
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
                  borderRadius: BorderRadius.circular(12),
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
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9b746b6d (fix: UI)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
>>>>>>> cfa5498 (fix: UI)
>>>>>>> c3018adf (fix: UI)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
        ),
<<<<<<< HEAD
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
<<<<<<< HEAD
>>>>>>> 0e409703 (fix: evaluasi)
=======
        ),
>>>>>>> 9b746b6d (fix: UI)
=======
>>>>>>> 991dab5 (fix: evaluasi)
<<<<<<< HEAD
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
        ),
>>>>>>> cfa5498 (fix: UI)
>>>>>>> c3018adf (fix: UI)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      ],
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 0e409703 (fix: evaluasi)
=======
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
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
<<<<<<< HEAD
=======
=======
=======
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
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
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
<<<<<<< HEAD
>>>>>>> b25dc8bc (fix: detail evaluasi)
            ...defects.asMap().entries.map(
                  (entry) => _buildDefectItem(
                    entry.value,
                    isLast: entry.key == defects.length - 1,
                  ),
                ),
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
=======
>>>>>>> d256f82 (fix: UI evaluasi)
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
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
  Widget _buildDefectItem(Map<String, dynamic> defect) {
=======
  Widget _buildDefectItem(
    Map<String, dynamic> defect, {
    required bool isLast,
  }) {
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
  Widget _buildDefectItem(Map<String, dynamic> defect) {
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
=======
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 18,
            child: Text('•', style: TextStyle(fontSize: 20)),
          ),
          Expanded(
            child: Text(
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
  Widget _buildDefectItem(Map<String, dynamic> defect) {
    final name = defect['defect_name']?.toString() ?? '-';
    final qty = defect['qty']?.toString() ?? '-';

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
<<<<<<< HEAD
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
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
            child: Text(
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 85966df (fix: detail evaluasi)
<<<<<<< HEAD
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
=======
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
            child: Text(
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF292A2F),
<<<<<<< HEAD
<<<<<<< HEAD
=======
                fontSize: 14,
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
                fontWeight: FontWeight.w600,
              ),
            ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
          ),
>>>>>>> b2b87875 (feat: evaluasi bs)
          Text(
            qty,
            style: TextStyle(
              color: Colors.grey.shade700,
<<<<<<< HEAD
              fontWeight: FontWeight.w700,
=======
              fontSize: 16,
              fontWeight: FontWeight.w600,
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
            const SizedBox(height: 8),
            Text(
=======
          ),
          const SizedBox(width: 8),
<<<<<<< HEAD
          Expanded(
            child: Text(
>>>>>>> e7b9ec75 (fix: UI evaluasi)
              qty,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
=======
              name,
              style: const TextStyle(
                color: Color(0xFF292A2F),
                fontSize: 17,
              ),
            ),
          ),
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
          Text(
            qty,
            style: TextStyle(
              color: Colors.grey.shade700,
<<<<<<< HEAD
              fontWeight: FontWeight.w700,
<<<<<<< HEAD
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
=======
              fontSize: 16,
              fontWeight: FontWeight.w600,
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
            const SizedBox(height: 8),
            Text(
=======
          ),
          const SizedBox(width: 8),
<<<<<<< HEAD
          Expanded(
            child: Text(
>>>>>>> d256f82 (fix: UI evaluasi)
              qty,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
>>>>>>> 85966df (fix: detail evaluasi)
<<<<<<< HEAD
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
=======
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
          Text(
            qty,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
<<<<<<< HEAD
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
<<<<<<< HEAD
=======
      case 'selesai':
      case 'completed':
        return const Color(0xFFEBFDF4);
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFF8697C6);
      case 'menunggu':
      case 'waiting':
        return const Color(0xFF955B34);
<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
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
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
        return const Color(0xFF955B34);
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
=======
=======
      case 'direview':
      case 'reviewed':
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
      case 'selesai':
      case 'completed':
        return const Color(0xFF8697C6);
      case 'menunggu':
      case 'waiting':
<<<<<<< HEAD
        return const Color(0xFFA16207);
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
        return const Color(0xFF955B34);
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
      default:
        return _getStatusColor(status);
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
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

<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> d9ba4836 (fix: detail evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
  Widget _buildReadOnlyCard(
    String label,
    String value, {
    String? updatedAt,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
    String? historyField,
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
    final current = value.isEmpty ? '-' : value;
    final historyItems = historyField == null
        ? const <Map<String, dynamic>>[]
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
        : _fieldHistoryItems(historyField);
    final versions = _historyVersions(historyItems);
    final previousVersions = versions.length > 1
        ? versions.sublist(0, versions.length - 1)
        : const <Map<String, dynamic>>[];
    final latestVersion = versions.isNotEmpty ? versions.last : null;
    final latestMeta = latestVersion != null
        ? _historyActorMeta(latestVersion)
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);
<<<<<<< HEAD
=======
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
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
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
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
>>>>>>> d39c264 (fix: bs dan gsm)
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> a087f712 (fix: bs dan gsm)
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
=======
              for (final previous in previousItems) ...[
                Text(
                  _historyDisplayValue(previous['old_value']),
<<<<<<< HEAD
>>>>>>> 0e409703 (fix: evaluasi)
=======
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
>>>>>>> 991dab5 (fix: evaluasi)
<<<<<<< HEAD
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> a087f712 (fix: bs dan gsm)
                  _historyActorMeta(previous),
=======
                  'Diubah oleh ${_personName(previous['changed_by'])}, '
                  '${_formatDateTime(previous['created_at']?.toString() ?? '-')}',
<<<<<<< HEAD
>>>>>>> 0e409703 (fix: evaluasi)
=======
                  _historyActorMeta(previous),
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
>>>>>>> 991dab5 (fix: evaluasi)
<<<<<<< HEAD
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
                  _historyActorMeta(previous),
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
                  _historyActorMeta(previous),
>>>>>>> 0ba64c26 (chore: adjust fase-2)
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                current,
<<<<<<< HEAD
=======
              Text(
                value.isEmpty ? '-' : value,
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
              Text(
                current,
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
              Text(
                current,
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('base'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[800],
                ),
              ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
<<<<<<< HEAD
=======
              if (hasUpdatedAt) ...[
                const SizedBox(height: 8),
                Text(
                  _formatDateTime(updatedAt),
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> a087f712 (fix: bs dan gsm)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
  List<Map<String, dynamic>> _fieldHistoryItems(String field) {
    Map<String, dynamic>? group;
    final expectedLabel = _historyFieldLabel(field).toLowerCase();
    for (final history in _histories) {
      final historyField = history['field']?.toString();
      final label = history['label']?.toString().trim().toLowerCase() ?? '';
      if (historyField == field || label == expectedLabel) {
<<<<<<< HEAD
=======
  List<Map<String, dynamic>> _previousHistoryItems(String field) {
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
=======
=======
  List<Map<String, dynamic>> _fieldHistoryItems(String field) {
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
    Map<String, dynamic>? group;
    final expectedLabel = _historyFieldLabel(field).toLowerCase();
    for (final history in _histories) {
      final historyField = history['field']?.toString();
<<<<<<< HEAD
      final label = history['label']?.toString().trim() ?? '';
      if (historyField == field || label == _historyFieldLabel(field)) {
>>>>>>> 991dab5 (fix: evaluasi)
<<<<<<< HEAD
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
      final label = history['label']?.toString().trim().toLowerCase() ?? '';
      if (historyField == field || label == expectedLabel) {
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
  String _historyGroupLabel(Map<String, dynamic> group) {
    final label = group['label']?.toString().trim() ?? '';
    return label.isNotEmpty
        ? label
        : _historyFieldLabel(group['field']?.toString());
<<<<<<< HEAD
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 0e409703 (fix: evaluasi)
=======
>>>>>>> d256f82 (fix: UI evaluasi)
<<<<<<< HEAD
>>>>>>> db08c830 (fix: UI evaluasi)
=======
=======
>>>>>>> 991dab5 (fix: evaluasi)
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
  }

  List<Map<String, dynamic>> _historyItems(Map<String, dynamic> group) {
    final raw = group['items'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> a087f712 (fix: bs dan gsm)
        .where((item) => item['new_value'] != null)
=======
        .where(
          (item) => item['old_value'] != null && item['new_value'] != null,
        )
<<<<<<< HEAD
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
        .where((item) => item['new_value'] != null)
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
>>>>>>> d256f82 (fix: UI evaluasi)
<<<<<<< HEAD
>>>>>>> db08c830 (fix: UI evaluasi)
=======
=======
        .where((item) => item['new_value'] != null)
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
        .where((item) => item['new_value'] != null)
>>>>>>> 0ba64c26 (chore: adjust fase-2)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8eee7be2 (fix: bs dan gsm)
=======
>>>>>>> db08c830 (fix: UI evaluasi)
=======
>>>>>>> bd0b8f00 (fix: evaluasi)
=======
=======
>>>>>>> d39c264 (fix: bs dan gsm)
>>>>>>> a087f712 (fix: bs dan gsm)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
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
<<<<<<< HEAD
=======
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
  Widget _buildHistoryCard() {
    final histories = _histories;
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
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
>>>>>>> db08c830 (fix: UI evaluasi)

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: TemplateCard(
        title: 'Riwayat Perubahan',
        icon: Icons.history_outlined,
        child: Column(
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
          children: [
            for (int i = 0; i < histories.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _buildHistoryItem(histories[i]),
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
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
>>>>>>> db08c830 (fix: UI evaluasi)
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
<<<<<<< HEAD
<<<<<<< HEAD
    final oldValue = _historyDisplayValue(history['old_value']);
    final newValue = _historyDisplayValue(history['new_value']);
    final hasOldValue = history['old_value'] != null && oldValue.isNotEmpty;
=======
    final newValue = history['new_value']?.toString().trim();
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
    final oldValue = _historyDisplayValue(history['old_value']);
    final newValue = _historyDisplayValue(history['new_value']);
    final hasOldValue = history['old_value'] != null && oldValue.isNotEmpty;
>>>>>>> b25dc8bc (fix: detail evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
          Text(
            _historyFieldLabel(history['field']?.toString()),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
=======
>>>>>>> db08c830 (fix: UI evaluasi)
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
<<<<<<< HEAD
            (newValue == null || newValue.isEmpty) ? '-' : newValue,
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
            newValue.isEmpty ? '-' : newValue,
>>>>>>> b25dc8bc (fix: detail evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
>>>>>>> b25dc8bc (fix: detail evaluasi)
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
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
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
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
<<<<<<< HEAD
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
=======
>>>>>>> 991dab5 (fix: evaluasi)
  String _historyDisplayValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value.map((item) => item.toString()).join(', ').trim();
    }
    return value.toString().trim();
>>>>>>> 85966df (fix: detail evaluasi)
>>>>>>> b25dc8bc (fix: detail evaluasi)
=======
>>>>>>> 0ba64c26 (chore: adjust fase-2)
  }
}
