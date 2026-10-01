import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
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
  final TextEditingController _actionPlanController = TextEditingController();
  final TextEditingController _preventivePlanController =
      TextEditingController();
  bool _saving = false;

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

  Future<void> _save() async {
    if (_saving || !_canSave) return;
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
        message: _errorMessage(e),
      );
    }
  }

  String _errorMessage(Object error) {
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  bool get _canSave {
    return _reasonController.text.trim().isNotEmpty &&
        _actionPlanController.text.trim().isNotEmpty &&
        _preventivePlanController.text.trim().isNotEmpty;
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
