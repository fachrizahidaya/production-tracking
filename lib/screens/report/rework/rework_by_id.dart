import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';
import 'package:textile_tracking/screens/report/rework/rework_edit.dart';
import 'package:textile_tracking/screens/report/rework/rework_list.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ReworkDetailLoadingScreen extends StatefulWidget {
  final dynamic id;
  final bool returnToList;

  const ReworkDetailLoadingScreen({
    super.key,
    required this.id,
    this.returnToList = false,
  });

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

      final status = data['status']?.toString().toLowerCase() ?? '';
      final isWaiting = status == 'menunggu' || status == 'waiting';

      final message = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => isWaiting
              ? ReworkEditScreen(data: data)
              : ReworkDetailScreen(data: data),
        ),
      );

      if (!mounted) return;
      if (widget.returnToList) {
        _replaceWithReworkList(message: message);
      } else {
        Navigator.pop(context, message);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  void _replaceWithReworkList({String? message}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ReworkList(
          savedMessage: message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Evaluasi Rework',
        onReturn: widget.returnToList
            ? _replaceWithReworkList
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
=======
import 'package:flutter_html/flutter_html.dart';
=======
>>>>>>> 41ded02d (fix: rework)
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/form/multi_select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
<<<<<<< HEAD
import 'package:textile_tracking/helpers/util/text_editor.dart';
>>>>>>> 5ad2d445 (feat: temporarily)
=======
import 'package:textile_tracking/screens/report/rework/rework_edit.dart';
import 'package:textile_tracking/screens/report/service.dart';
>>>>>>> 41ded02d (fix: rework)

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
<<<<<<< HEAD
=======
  final TextEditingController _actionPlanController = TextEditingController();
>>>>>>> 5ad2d445 (feat: temporarily)
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
<<<<<<< HEAD
  void initState() {
    super.initState();
    _reasonController.text = widget.data['reason']?.toString() ?? '';
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
=======
  void dispose() {
    _reasonController.dispose();
    _actionPlanController.dispose();
>>>>>>> 5ad2d445 (feat: temporarily)
    _preventivePlanController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
<<<<<<< HEAD
  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
    return status == 'direview' ||
        status == 'reviewed' ||
        status == 'selesai' ||
        status == 'completed';
  }

  Future<void> _openEditScreen() async {
    final message = await Navigator.push<String>(
=======
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
>>>>>>> 41ded02d (fix: rework)
      context,
      MaterialPageRoute(
        builder: (context) => ReworkEditScreen(data: widget.data),
      ),
    );

<<<<<<< HEAD
    if (message != null && message.trim().isNotEmpty && mounted) {
      Navigator.pop(context, message);
    }
  }

=======
>>>>>>> 5ad2d445 (feat: temporarily)
=======
    if (updated == true && mounted) {
      Navigator.pop(context, true);
    }
  }

>>>>>>> 41ded02d (fix: rework)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        title: 'Detail Evaluasi Rework',
=======
        title: 'Evaluasi Rework',
>>>>>>> 82bef6eb (fix: hide unnecessary)
        onReturn: () => Navigator.pop(context),
        onEdit: _isCompleted ? _openEditScreen : null,
=======
        title: 'Evaluasi Rework',
=======
        title: 'Detail Rework',
>>>>>>> a7b8052a (feat: rework report)
        onReturn: () => Navigator.pop(context),
>>>>>>> 5ad2d445 (feat: temporarily)
=======
        title: 'Detail Evaluasi Rework',
        onReturn: () => Navigator.pop(context),
        onEdit: _useEditScreen ? _openEditScreen : null,
>>>>>>> 41ded02d (fix: rework)
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
<<<<<<< HEAD
<<<<<<< HEAD
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
<<<<<<< HEAD
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
                'Alasan dan Penyebab',
                _reasonController.text,
                updatedAt: widget.data['reason_updated_at']?.toString(),
                historyField: 'reason',
              ),
              const SizedBox(height: 16),
              _buildReadOnlyCard(
                'Rencana Pencegahan',
                _preventivePlanController.text,
                updatedAt:
                    widget.data['preventive_plan_updated_at']?.toString(),
                historyField: 'preventive_plan',
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildAttachmentCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _attachments {
    final raw = widget.data['attachments'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) => _attachmentUrl(item) != null)
        .toList();
  }

  String? _attachmentUrl(Map<String, dynamic> item) {
    String? source;
    for (final key in ['file_path', 'file_url', 'url', 'path']) {
      final value = item[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        source = value;
        break;
      }
    }
    if (source == null) return null;
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return source;
    }

    final base = dotenv.env['IMAGE_URL'] ?? '';
    if (base.isEmpty) return source;
    if (base.endsWith('/') && source.startsWith('/')) {
      return '$base${source.substring(1)}';
    }
    if (!base.endsWith('/') && !source.startsWith('/')) return '$base/$source';
    return '$base$source';
  }

  void _viewAttachment(Map<String, dynamic> item) {
    final url = _attachmentUrl(item);
    if (url == null) return;
    showImageDialog(context: context, isNew: false, filePath: url);
  }

  Widget _buildAttachmentCard() {
    final attachments = _attachments;

    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.photo_library_outlined,
      child: attachments.isEmpty
          ? Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tidak ada lampiran',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('base'),
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final columns = constraints.maxWidth < 280 ? 2 : 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attachments.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemBuilder: (context, index) {
                    final item = attachments[index];
                    final url = _attachmentUrl(item);

                    return GestureDetector(
                      onTap: () => _viewAttachment(item),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColoredBox(
                          color: Colors.grey.shade200,
                          child: url == null
                              ? const Icon(Icons.broken_image_outlined)
                              : Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
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
          _buildDyeingReferenceLine(),
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

  String _value(String key) => widget.data[key]?.toString() ?? '-';

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
=======
          padding: const EdgeInsets.all(16),
=======
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
>>>>>>> 41ded02d (fix: rework)
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
=======
>>>>>>> bf6ce5bc (fix: rework)
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
>>>>>>> 5ad2d445 (feat: temporarily)
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
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

>>>>>>> bf6ce5bc (fix: rework)
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

>>>>>>> 41ded02d (fix: rework)
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
<<<<<<< HEAD
      padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
=======
      padding: const EdgeInsets.symmetric(vertical: 18),
>>>>>>> 41ded02d (fix: rework)
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
<<<<<<< HEAD
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
=======
  Widget _buildInfoItem(String label, String value) {
=======
>>>>>>> 41ded02d (fix: rework)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 18,
          child: Text('•', style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: Text(
<<<<<<< HEAD
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
>>>>>>> 5ad2d445 (feat: temporarily)
=======
            text,
            style: TextStyle(color: color, fontSize: fontSize),
>>>>>>> 41ded02d (fix: rework)
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> f248a3d8 (fix: rework)
    final backgroundColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
<<<<<<< HEAD
=======
    final color =
        status.toLowerCase() == 'selesai' ? Colors.green : Colors.orange;
=======
    final color = _getStatusColor(status);
>>>>>>> 41ded02d (fix: rework)

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: color.withValues(alpha: 0.1),
>>>>>>> 5ad2d445 (feat: temporarily)
=======
        color: color.withOpacity(0.1),
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> f248a3d8 (fix: rework)
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
<<<<<<< HEAD
<<<<<<< HEAD
          color: _getStatusTextColor(status),
=======
          color: color,
>>>>>>> 5ad2d445 (feat: temporarily)
=======
          color: _getStatusTextColor(status),
>>>>>>> f248a3d8 (fix: rework)
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'direview':
      case 'reviewed':
      case 'selesai':
      case 'completed':
        return const Color(0xFFF2F7FF);
=======
=======
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

>>>>>>> bf6ce5bc (fix: rework)
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
      case 'completed':
<<<<<<< HEAD
        return Colors.green;
>>>>>>> 41ded02d (fix: rework)
=======
        return const Color(0xFFEBFDF4);
>>>>>>> f248a3d8 (fix: rework)
      case 'diproses':
      case 'in_progress':
        return Colors.orange;
      case 'menunggu':
      case 'waiting':
<<<<<<< HEAD
<<<<<<< HEAD
        return const Color(0xFFFFFBEA);
=======
        return Colors.blue;
>>>>>>> 41ded02d (fix: rework)
=======
        return const Color(0xFFFFFBEA);
>>>>>>> f248a3d8 (fix: rework)
      case 'dilewati':
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
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
=======
  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
      case 'completed':
        return const Color(0xFF15803D);
      case 'menunggu':
      case 'waiting':
        return const Color(0xFFA16207);
>>>>>>> f248a3d8 (fix: rework)
      default:
        return _getStatusColor(status);
    }
  }

<<<<<<< HEAD
=======
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> f248a3d8 (fix: rework)
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
  Widget _buildReadOnlyCard(
    String label,
    String value, {
    String? updatedAt,
    String? historyField,
  }) {
    final hasUpdatedAt =
        updatedAt != null && updatedAt.trim().isNotEmpty && updatedAt != '-';
    final current = value.isEmpty ? '-' : value;
    final historyItems = historyField == null
        ? const <Map<String, dynamic>>[]
        : _fieldHistoryItems(historyField);
    final versions = _historyVersions(historyItems);
    final previousVersions = versions.length > 1
        ? versions.sublist(0, versions.length - 1)
        : const <Map<String, dynamic>>[];
    final latestVersion = versions.isNotEmpty ? versions.last : null;
    final latestMeta = latestVersion != null
        ? _historyActorMeta(latestVersion)
        : (hasUpdatedAt ? _formatDateTime(updatedAt!) : null);

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
              for (final previous in previousVersions) ...[
                Text(
                  previous['value'].toString(),
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('base'),
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _historyActorMeta(previous),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                current,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('base'),
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  color: Colors.grey[800],
                ),
              ),
              if (latestMeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  latestMeta,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
=======
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
>>>>>>> 5ad2d445 (feat: temporarily)
=======
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
>>>>>>> 41ded02d (fix: rework)
      ),
    );
  }

<<<<<<< HEAD
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

  List<Map<String, dynamic>> _fieldHistoryItems(String field) {
    Map<String, dynamic>? group;
    final expectedLabel = _historyFieldLabel(field).toLowerCase();
    for (final history in _histories) {
      final historyField = history['field']?.toString();
      final label = history['label']?.toString().trim().toLowerCase() ?? '';
      if (historyField == field || label == expectedLabel) {
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
  }

  List<Map<String, dynamic>> _historyItems(Map<String, dynamic> group) {
    final raw = group['items'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .where((item) => item['new_value'] != null)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

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
>>>>>>> 5ad2d445 (feat: temporarily)
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
