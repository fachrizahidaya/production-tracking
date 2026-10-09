import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
import 'package:textile_tracking/screens/report/evaluation_attachments.dart';
=======
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
=======
>>>>>>> 85966df (fix: detail evaluasi)
import 'package:textile_tracking/screens/report/bs/bs_edit.dart';
>>>>>>> aa02f1b (feat: evaluasi bs)
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
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final message = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isWaiting ? BsEditScreen(data: data) : BsDetailScreen(data: data),
=======
      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => BsDetailScreen(data: data),
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isWaiting ? BsEditScreen(data: data) : BsDetailScreen(data: data),
>>>>>>> 85966df (fix: detail evaluasi)
        ),
      );

      if (!mounted) return;
      if (widget.returnToList) {
<<<<<<< HEAD
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
>>>>>>> aa02f1b (feat: evaluasi bs)
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

<<<<<<< HEAD
  void _replaceWithBsList({String? message}) {
=======
  void _replaceWithBsList({bool saved = false, String? woNo}) {
>>>>>>> aa02f1b (feat: evaluasi bs)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BsList(
<<<<<<< HEAD
          savedMessage: message,
=======
          savedWoNo: saved ? woNo : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
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
  final TextEditingController _preventivePlanController =
      TextEditingController();
=======
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final ReportService _reportService = ReportService();
  bool _saving = false;
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> 85966df (fix: detail evaluasi)
=======
  int _selectedHistoryIndex = 0;
>>>>>>> d256f82 (fix: UI evaluasi)
=======
>>>>>>> 991dab5 (fix: evaluasi)

  @override
  void initState() {
    super.initState();
    _reasonController.text = widget.data['reason']?.toString() ?? '';
<<<<<<< HEAD
=======
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
>>>>>>> aa02f1b (feat: evaluasi bs)
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
<<<<<<< HEAD
=======
    _actionPlanController.dispose();
>>>>>>> aa02f1b (feat: evaluasi bs)
    _preventivePlanController.dispose();
    super.dispose();
  }

  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d256f82 (fix: UI evaluasi)
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
>>>>>>> d256f82 (fix: UI evaluasi)
  }

  Future<void> _openEditScreen() async {
    final updated = await Navigator.push<bool>(
>>>>>>> aa02f1b (feat: evaluasi bs)
      context,
      MaterialPageRoute(
        builder: (context) => BsEditScreen(data: widget.data),
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
    }
  }

=======
>>>>>>> 85966df (fix: detail evaluasi)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi BS',
        onReturn: () => Navigator.pop(context),
<<<<<<< HEAD
<<<<<<< HEAD
        onEdit: _isCompleted ? _openEditScreen : null,
=======
        onEdit: _useEditScreen ? _openEditScreen : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
        onEdit: _isCompleted ? _openEditScreen : null,
>>>>>>> 85966df (fix: detail evaluasi)
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
=======
>>>>>>> 85966df (fix: detail evaluasi)
              _buildReadOnlyCard(
                'Alasan dan Penyebab',
                _reasonController.text,
                updatedAt: widget.data['reason_updated_at']?.toString(),
<<<<<<< HEAD
                historyField: 'reason',
=======
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
                'Rencana Tindakan',
                _actionPlanController.text,
                updatedAt: widget.data['action_plan_updated_at']?.toString(),
<<<<<<< HEAD
>>>>>>> 85966df (fix: detail evaluasi)
=======
                historyField: 'action_plan',
>>>>>>> 991dab5 (fix: evaluasi)
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: EvaluationAttachmentGallery(
                  attachments: widget.data['attachments'],
                ),
              ),
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
>>>>>>> 85966df (fix: detail evaluasi)
              if (_histories.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildHistoryCard(),
              ],
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
              _buildHistoryCard(),
>>>>>>> d256f82 (fix: UI evaluasi)
=======
                historyField: 'preventive_plan',
              ),
>>>>>>> 991dab5 (fix: evaluasi)
            ],
          ),
        ),
      ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
      bottomNavigationBar: _isWaiting ? _buildSaveBar() : null,
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> 85966df (fix: detail evaluasi)
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
          _buildQtyBsItem(),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
            label: 'Mulai Sortir',
=======
          _buildQtyBsItem(),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
<<<<<<< HEAD
            label: 'Mulai',
>>>>>>> d256f82 (fix: UI evaluasi)
=======
            label: 'Mulai Sortir',
>>>>>>> cfa5498 (fix: UI)
            person: _sorting['start_by'],
            time: _sorting['start_time']?.toString(),
          ),
          const SizedBox(height: 12),
          _buildProcessTimeItem(
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
          _buildOverviewItem(
            label: 'Qty BS',
            value: '${_value('qtyBs')} PCS',
            valueColor: const Color(0xFF234393),
=======
            label: 'Selesai',
=======
            label: 'Selesai Sortir',
>>>>>>> cfa5498 (fix: UI)
            person: _sorting['end_by'],
            time: _sorting['end_time']?.toString(),
>>>>>>> d256f82 (fix: UI evaluasi)
          ),
          const SizedBox(height: 12),
          _buildMaterialItem(),
          if (_isCompleted) ...[
            const SizedBox(height: 12),
            _buildSubmittedByItem(),
          ],
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
>>>>>>> aa02f1b (feat: evaluasi bs)
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
>>>>>>> 991dab5 (fix: evaluasi)
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
>>>>>>> cfa5498 (fix: UI)
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
>>>>>>> 991dab5 (fix: evaluasi)
=======
        ),
>>>>>>> cfa5498 (fix: UI)
      ],
    );
  }

<<<<<<< HEAD
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> 991dab5 (fix: evaluasi)
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
<<<<<<< HEAD
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

=======
>>>>>>> 85966df (fix: detail evaluasi)
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
            ...defects.asMap().entries.map(
                  (entry) => _buildDefectItem(
                    entry.value,
                    isLast: entry.key == defects.length - 1,
                  ),
                ),
>>>>>>> aa02f1b (feat: evaluasi bs)
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
  Widget _buildDefectItem(Map<String, dynamic> defect) {
=======
  Widget _buildDefectItem(
    Map<String, dynamic> defect, {
    required bool isLast,
  }) {
>>>>>>> aa02f1b (feat: evaluasi bs)
    final name = defect['defect_name']?.toString() ?? '-';
    final qty = defect['qty']?.toString() ?? '-';

    return Container(
<<<<<<< HEAD
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
=======
  Widget _buildDefectItem(Map<String, dynamic> defect) {
    final name = defect['defect_name']?.toString() ?? '-';
    final qty = defect['qty']?.toString() ?? '-';

<<<<<<< HEAD
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
>>>>>>> 85966df (fix: detail evaluasi)
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
            flex: 3,
            child: Text(
>>>>>>> d256f82 (fix: UI evaluasi)
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF292A2F),
                fontWeight: FontWeight.w600,
              ),
            ),
<<<<<<< HEAD
<<<<<<< HEAD
          ),
>>>>>>> aa02f1b (feat: evaluasi bs)
          Text(
            qty,
            style: TextStyle(
              color: Colors.grey.shade700,
<<<<<<< HEAD
              fontWeight: FontWeight.w700,
=======
              fontSize: 16,
              fontWeight: FontWeight.w600,
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
            const SizedBox(height: 8),
            Text(
=======
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
>>>>>>> d256f82 (fix: UI evaluasi)
              qty,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
>>>>>>> 85966df (fix: detail evaluasi)
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
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
=======
      case 'selesai':
      case 'completed':
        return const Color(0xFFEBFDF4);
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
>>>>>>> d256f82 (fix: UI evaluasi)
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
>>>>>>> d256f82 (fix: UI evaluasi)
      case 'selesai':
      case 'completed':
        return const Color(0xFF8697C6);
      case 'menunggu':
      case 'waiting':
<<<<<<< HEAD
        return const Color(0xFFA16207);
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
        return const Color(0xFF955B34);
>>>>>>> d256f82 (fix: UI evaluasi)
      default:
        return _getStatusColor(status);
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d256f82 (fix: UI evaluasi)
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
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> d256f82 (fix: UI evaluasi)
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

>>>>>>> aa02f1b (feat: evaluasi bs)
=======
>>>>>>> 85966df (fix: detail evaluasi)
  Widget _buildReadOnlyCard(
    String label,
    String value, {
    String? updatedAt,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 991dab5 (fix: evaluasi)
    String? historyField,
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
    final current = value.isEmpty ? '-' : value;
    final historyItems = historyField == null
        ? const <Map<String, dynamic>>[]
<<<<<<< HEAD
        : _fieldHistoryItems(historyField);
    final versions = _historyVersions(historyItems);
    final previousVersions = versions.length > 1
        ? versions.sublist(0, versions.length - 1)
        : const <Map<String, dynamic>>[];
    final latestVersion = versions.isNotEmpty ? versions.last : null;
    final latestMeta = latestVersion != null
        ? _historyActorMeta(latestVersion)
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);
=======
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
>>>>>>> aa02f1b (feat: evaluasi bs)
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
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);
>>>>>>> 991dab5 (fix: evaluasi)

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
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
=======
              for (final previous in previousItems) ...[
                Text(
                  _historyDisplayValue(previous['old_value']),
>>>>>>> 991dab5 (fix: evaluasi)
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('base'),
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
<<<<<<< HEAD
                  _historyActorMeta(previous),
=======
                  'Diubah oleh ${_personName(previous['changed_by'])}, '
                  '${_formatDateTime(previous['created_at']?.toString() ?? '-')}',
>>>>>>> 991dab5 (fix: evaluasi)
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
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
              Text(
                current,
>>>>>>> 991dab5 (fix: evaluasi)
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
>>>>>>> aa02f1b (feat: evaluasi bs)
=======
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
>>>>>>> 991dab5 (fix: evaluasi)
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
  List<Map<String, dynamic>> _fieldHistoryItems(String field) {
    Map<String, dynamic>? group;
    final expectedLabel = _historyFieldLabel(field).toLowerCase();
    for (final history in _histories) {
      final historyField = history['field']?.toString();
      final label = history['label']?.toString().trim().toLowerCase() ?? '';
      if (historyField == field || label == expectedLabel) {
=======
  List<Map<String, dynamic>> _previousHistoryItems(String field) {
    Map<String, dynamic>? group;
    for (final history in _histories) {
      final historyField = history['field']?.toString();
      final label = history['label']?.toString().trim() ?? '';
      if (historyField == field || label == _historyFieldLabel(field)) {
>>>>>>> 991dab5 (fix: evaluasi)
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
>>>>>>> d256f82 (fix: UI evaluasi)
=======
>>>>>>> 991dab5 (fix: evaluasi)
  }

  List<Map<String, dynamic>> _historyItems(Map<String, dynamic> group) {
    final raw = group['items'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
<<<<<<< HEAD
        .where((item) => item['new_value'] != null)
=======
        .where(
          (item) => item['old_value'] != null && item['new_value'] != null,
        )
>>>>>>> d256f82 (fix: UI evaluasi)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

<<<<<<< HEAD
<<<<<<< HEAD
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
>>>>>>> aa02f1b (feat: evaluasi bs)
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
  }
}
