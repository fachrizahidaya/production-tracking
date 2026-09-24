import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/text_editor.dart';

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

  @override
  void dispose() {
    _reasonController.dispose();
    _actionPlanController.dispose();
    _preventivePlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Rework',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: CustomTheme().cardTheme(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.data['reworkNo'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(widget.data['status']),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem('No. WO', widget.data['woNo']),
                    const Divider(height: 24),
                    _buildInfoItem(
                      'No. Proses Dyeing',
                      widget.data['dyeingProcessNo'],
                    ),
                    const Divider(height: 24),
                    _buildInfoItem(
                      'Waktu Mulai Rework',
                      widget.data['startedAt'],
                    ),
                    const Divider(height: 24),
                    _buildInfoItem('Qty', widget.data['qty']),
                    const Divider(height: 24),
                    _buildInfoItem(
                      'Produk Setengah Jadi',
                      widget.data['semiFinishedProduct'],
                    ),
                    const Divider(height: 24),
                    _buildInfoItem(
                      'Kategori Rework',
                      widget.data['category'],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildFormCard(
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
              _buildEditorForm(
                label: 'Action Plan',
                controller: _actionPlanController,
              ),
              const SizedBox(height: 16),
              _buildEditorForm(
                label: 'Preventif Plan',
                controller: _preventivePlanController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color =
        status.toLowerCase() == 'selesai' ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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

  Widget _buildFormCard({required String label, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildEditorForm({
    required String label,
    required TextEditingController controller,
  }) {
    return _buildFormCard(
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => TextEditor(
                initialHtml:
                    controller.text.isEmpty ? '<p></p>' : controller.text,
                label: label,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              controller.text = result;
            });
          }
        },
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: controller.text.isEmpty
              ? Text(
                  'Tambahkan $label',
                  style: TextStyle(color: Colors.grey.shade500),
                )
              : Html(
                  data: controller.text,
                  style: {'*': Style(margin: Margins.zero)},
                ),
        ),
      ),
    );
  }
}
