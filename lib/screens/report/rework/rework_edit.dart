<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:io';
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
import 'dart:io';
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

=======
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/form/multi_select_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/screens/report/service.dart';

<<<<<<< HEAD
>>>>>>> 41ded02d (fix: rework)
=======
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

>>>>>>> 7f4b7b66 (fix: flow submit form evaluasi rework)
class ReworkEditScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ReworkEditScreen({super.key, required this.data});

  @override
  State<ReworkEditScreen> createState() => _ReworkEditScreenState();
}

class _ReworkEditScreenState extends State<ReworkEditScreen> {
  final ReportService _reportService = ReportService();
<<<<<<< HEAD
<<<<<<< HEAD
=======
  final TextEditingController _actionPlanController = TextEditingController();
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
  final TextEditingController _preventivePlanController =
      TextEditingController();
  bool _saving = false;
  bool _loadingReasons = true;
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
  int _visibleStep = 1;
  List<Map<String, dynamic>> _reasonOptions = [];
  List<Map<String, dynamic>> _selectedReasons = [];
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  List<Map<String, dynamic>> _attachments = [];
=======
  int _editStep = 0;
>>>>>>> 9d9abd1e (fix: rework)
=======
>>>>>>> 190e34fd (fix: evaluasi rework)

  String get _draftType => 'rework';
=======
  List<Map<String, dynamic>> _reasonOptions = [];
  List<Map<String, dynamic>> _selectedReasons = [];
>>>>>>> 41ded02d (fix: rework)
=======
  int _editStep = 0;
>>>>>>> fcd6e08b (fix: rework)
=======
>>>>>>> 264bcd0f (fix: evaluasi rework)
=======
  List<Map<String, dynamic>> _attachments = [];
<<<<<<< HEAD
  bool _attachmentsDirty = false;
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
>>>>>>> 01aa2117 (fix: attachment evaluation)

  String get _draftType => 'rework';

  @override
  void initState() {
    super.initState();
=======

  String get _draftType => 'rework';
>>>>>>> 91183a33 (fix: rework)
    final reasons = widget.data['reasons'];
    if (reasons is List) {
      _selectedReasons = reasons
<<<<<<< HEAD
<<<<<<< HEAD
          .where((reason) => reason.toString().trim().isNotEmpty)
          .map(
            (reason) => <String, dynamic>{
              'id': reason.toString(),
              'value': reason.toString(),
              'label': reason.toString(),
            },
          )
<<<<<<< HEAD
          .toList();
    }
    _preventivePlanController.text = _textValue(widget.data['preventivePlan']);
    _attachments = _parseAttachments(widget.data['attachments']);
<<<<<<< HEAD
    _visibleStep = _stepFromValues();
    _preventivePlanController.addListener(_persistDraft);
    _loadDraft();
=======
=======
          .where((reason) => reason.toString().trim().isNotEmpty)
>>>>>>> e7b9ec75 (fix: UI evaluasi)
          .map((reason) => {
                'value': reason.toString(),
                'label': reason.toString(),
              })
          .toList();
    }
<<<<<<< HEAD
    _actionPlanController.text = widget.data['actionPlan']?.toString() ?? '';
    _preventivePlanController.text =
        widget.data['preventivePlan']?.toString() ?? '';
>>>>>>> 41ded02d (fix: rework)
=======
    _actionPlanController.text = _textValue(widget.data['actionPlan']);
=======
          .toList();
    }
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
    _preventivePlanController.text = _textValue(widget.data['preventivePlan']);
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
    _visibleStep = _stepFromValues();
    _preventivePlanController.addListener(_persistDraft);
    _loadDraft();
>>>>>>> e7b9ec75 (fix: UI evaluasi)
    _loadReasonOptions();
  }

  @override
  void dispose() {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    _preventivePlanController.removeListener(_persistDraft);
=======
=======
    _actionPlanController.removeListener(_persistDraft);
    _preventivePlanController.removeListener(_persistDraft);
>>>>>>> e7b9ec75 (fix: UI evaluasi)
    _actionPlanController.dispose();
>>>>>>> 41ded02d (fix: rework)
=======
    _preventivePlanController.removeListener(_persistDraft);
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
    _preventivePlanController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
    if (_textValue(_preventivePlanController.text).isNotEmpty) return 2;
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
    return 1;
  }

  Future<void> _loadDraft() async {
    final draft = await EvaluationDraft.load(_draftType, widget.data['id']);
    if (!mounted || draft == null) return;

    setState(() {
      final reasons = draft['reasons'];
      if (reasons is List) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
        _selectedReasons = List<Map<String, dynamic>>.from(
          reasons
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item)),
        );
<<<<<<< HEAD
=======
        _selectedReasons = reasons
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
      if (draft.containsKey('actionPlan')) {
        _actionPlanController.text = draft['actionPlan']?.toString() ?? '';
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
      }
      if (draft.containsKey('preventivePlan')) {
        _preventivePlanController.text =
            draft['preventivePlan']?.toString() ?? '';
      }
<<<<<<< HEAD
<<<<<<< HEAD
      if (draft.containsKey('attachments')) {
        final parsed = _parseAttachments(draft['attachments']);
        _attachments = parsed;
=======
      if (draft.containsKey('attachments')) {
        final parsed = _parseAttachments(draft['attachments']);
        _attachments = parsed;
<<<<<<< HEAD
        _attachmentsDirty = !_sameAttachments(
          parsed,
          _parseAttachments(widget.data['attachments']),
        );
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
>>>>>>> 01aa2117 (fix: attachment evaluation)
      }
      final savedStep = draft['visibleStep'];
      final parsedStep =
          savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1;
      _visibleStep = math.max(
        _stepFromValues(),
<<<<<<< HEAD
<<<<<<< HEAD
        parsedStep.clamp(1, 2),
=======
      final savedStep = draft['visibleStep'];
      final parsedStep =
          savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1;
      _visibleStep = math.max(
        _stepFromValues(),
<<<<<<< HEAD
        savedStep is int ? savedStep : int.tryParse('$savedStep') ?? 1,
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
        parsedStep >= 3 ? 2 : parsedStep.clamp(1, 2),
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
=======
        parsedStep.clamp(1, 3),
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
        parsedStep.clamp(1, 2),
>>>>>>> 01aa2117 (fix: attachment evaluation)
      );
    });
  }

  Future<void> _persistDraft() async {
    await EvaluationDraft.save(_draftType, widget.data['id'], {
      'reasons': _selectedReasons,
<<<<<<< HEAD
<<<<<<< HEAD
      'preventivePlan': _preventivePlanController.text,
      'visibleStep': _visibleStep,
      'attachments': _attachments,
<<<<<<< HEAD
=======
      'actionPlan': _actionPlanController.text,
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
      'preventivePlan': _preventivePlanController.text,
      'visibleStep': _visibleStep,
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
    });
    if (mounted) setState(() {});
  }

  void _goNext() {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    if (_visibleStep >= 2 || !_canGoNext) return;
=======
    if (_visibleStep >= 3 || !_canGoNext) return;
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
    if (_visibleStep >= 2 || !_canGoNext) return;
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
=======
    if (_visibleStep >= 3 || !_canGoNext) return;
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
    if (_visibleStep >= 2 || !_canGoNext) return;
>>>>>>> 01aa2117 (fix: attachment evaluation)
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
      final message = await _reportService.updateReworkDetail(
=======
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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
<<<<<<< HEAD
      await _reportService.updateReworkDetail(
>>>>>>> 41ded02d (fix: rework)
=======
      final message = await _reportService.updateReworkDetail(
>>>>>>> 01aa2117 (fix: attachment evaluation)
        id: widget.data['id'],
        reasons: _selectedReasons
            .map((reason) => reason['value'].toString())
            .toList(),
<<<<<<< HEAD
<<<<<<< HEAD
        actionPlan: '',
        preventivePlan: _preventivePlanController.text,
<<<<<<< HEAD
<<<<<<< HEAD
        attachments: _attachments,
      );
      await EvaluationDraft.clear(_draftType, widget.data['id']);

      if (!mounted) return;
      Navigator.pop(context, message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      await showAlertDialog(
        context: context,
        title: 'Gagal Menyimpan',
        message: _errorMessage(e),
=======
        actionPlan: _actionPlanController.text,
=======
        actionPlan: '',
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
        preventivePlan: _preventivePlanController.text,
=======
        attachments: _attachmentsDirty ? _attachments : null,
>>>>>>> 67a12e35 (feat: Lampiran untuk evaluasi)
=======
        attachments: _attachments,
>>>>>>> 01aa2117 (fix: attachment evaluation)
      );
      await EvaluationDraft.clear(_draftType, widget.data['id']);

      if (!mounted) return;
      Navigator.pop(context, message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
<<<<<<< HEAD
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan perubahan: $e')),
>>>>>>> 41ded02d (fix: rework)
=======
      await showAlertDialog(
        context: context,
        title: 'Gagal Menyimpan',
<<<<<<< HEAD
        message: e.toString(),
>>>>>>> 7f4b7b66 (fix: flow submit form evaluasi rework)
=======
        message: _errorMessage(e),
>>>>>>> b77e0195 (fix: bs, gsm, rework)
      );
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b77e0195 (fix: bs, gsm, rework)
  String _errorMessage(Object error) {
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

<<<<<<< HEAD
  bool get _canSave {
    return _selectedReasons.isNotEmpty &&
        _preventivePlanController.text.trim().length >= 8;
  }

  bool get _canGoNext {
    if (_visibleStep == 1) return _selectedReasons.isNotEmpty;
    return false;
  }

  String? _planLengthWarning() {
    if (_preventivePlanController.text.trim().length >= 8) return null;
    return 'Rencana Pencegahan minimal 8 karakter.';
  }

=======
>>>>>>> 41ded02d (fix: rework)
=======
=======
>>>>>>> b77e0195 (fix: bs, gsm, rework)
  bool get _canSave {
    return _selectedReasons.isNotEmpty &&
        _preventivePlanController.text.trim().isNotEmpty;
  }

<<<<<<< HEAD
>>>>>>> fcd6e08b (fix: rework)
=======
  bool get _canGoNext {
    if (_visibleStep == 1) return _selectedReasons.isNotEmpty;
    return false;
  }

<<<<<<< HEAD
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
  String? _planLengthWarning() {
    if (_preventivePlanController.text.trim().length >= 8) return null;
    return 'Rencana Pencegahan minimal 8 karakter.';
  }

>>>>>>> 0e409703 (fix: evaluasi)
  Future<void> _loadReasonOptions() async {
    try {
      final options = await _reportService.getReworkReasonOptions();
      final values = options.map((option) => option['value']).toSet();
      final selectedOnly = _selectedReasons
          .where((reason) => !values.contains(reason['value']))
          .toList();
      if (!mounted) return;
      setState(() {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
        _reasonOptions = List<Map<String, dynamic>>.from([
          ...options,
          ...selectedOnly,
        ]);
<<<<<<< HEAD
=======
        _reasonOptions = [...options, ...selectedOnly];
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
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
<<<<<<< HEAD
<<<<<<< HEAD
        .where(
          (option) => !selectedValues.contains(option['value'].toString()),
        )
        .toList();

    final selected = await _showReasonSelectionSheet(availableOptions);

    if (selected == null || !mounted) return;
    setState(() {
      final nextSelected = List<Map<String, dynamic>>.from(_selectedReasons);
<<<<<<< HEAD
      for (final value in selected) {
        final valueKey = value.toString();
        final option = _reasonOptions.cast<Map<String, dynamic>>().firstWhere(
              (item) => item['value'].toString() == valueKey,
              orElse: () => <String, dynamic>{
                'id': valueKey,
                'value': valueKey,
                'label': valueKey,
              },
            );
        if (!nextSelected.any(
          (item) => item['value'].toString() == option['value'].toString(),
        )) {
          nextSelected.add(Map<String, dynamic>.from(option));
        }
      }
      _selectedReasons = nextSelected;
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
        var selectedIds = <String>[];
        var searchQuery = '';

        return StatefulBuilder(
          builder: (context, setSheetState) {
            void applyFilter() {
              filteredItems = items
                  .where(
                    (item) => item['label']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery),
                  )
                  .toList();
            }

            Future<void> deleteOption(Map<String, dynamic> item) async {
              final optionId = item['id']?.toString().trim().isNotEmpty == true
                  ? item['id'].toString()
                  : item['value']?.toString();
              if (optionId == null || optionId.isEmpty) return;

              final confirmed = await showDialog<bool>(
                context: sheetContext,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Hapus Alasan'),
                  content: Text(
                    'Hapus alasan "${item['label']}" dari daftar?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;

              try {
                await _reportService.deleteReworkReasonOption(optionId);
                setSheetState(() {
                  items.removeWhere(
                    (option) =>
                        option['id'].toString() == optionId ||
                        option['value'].toString() == optionId ||
                        option['value'].toString() == item['value'].toString(),
                  );
                  selectedIds.remove(item['value'].toString());
                  applyFilter();
                });
                if (!mounted) return;
                setState(() {
                  final valueKey = item['value'].toString();
                  _reasonOptions.removeWhere(
                    (option) =>
                        option['id'].toString() == optionId ||
                        option['value'].toString() == optionId ||
                        option['value'].toString() == valueKey,
                  );
                  _selectedReasons.removeWhere(
                    (option) =>
                        option['id'].toString() == optionId ||
                        option['value'].toString() == optionId ||
                        option['value'].toString() == valueKey,
                  );
                });
                _persistDraft();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(_errorMessage(e))),
                );
              }
            }

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
                          setSheetState(() {
                            searchQuery = value.trim().toLowerCase();
                            applyFilter();
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
                                final valueKey = item['value'].toString();
                                return CheckboxListTile(
                                  value: selectedIds.contains(valueKey),
                                  title: Text(item['label'].toString()),
                                  activeColor: Colors.green,
                                  secondary: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => deleteOption(item),
                                  ),
                                  onChanged: (_) {
                                    setSheetState(() {
                                      if (selectedIds.contains(valueKey)) {
                                        selectedIds = List.from(selectedIds)
                                          ..remove(valueKey);
                                      } else {
                                        selectedIds = List.from(selectedIds)
                                          ..add(valueKey);
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

    final trimmed = label?.trim() ?? '';
    if (trimmed.isEmpty || !mounted) return;

    if (trimmed.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alasan minimal 8 karakter')),
      );
      return;
    }

    final normalized = trimmed.toLowerCase();
    Map<String, dynamic>? existingOption;
    for (final option in _reasonOptions) {
      if (option['label'].toString().trim().toLowerCase() == normalized ||
          option['value'].toString().trim().toLowerCase() == normalized) {
        existingOption = option;
        break;
      }
    }

    if (existingOption != null) {
      final existing = existingOption;
      setState(() {
        final nextSelected = List<Map<String, dynamic>>.from(_selectedReasons);
        if (!nextSelected.any(
          (item) => item['value'].toString() == existing['value'].toString(),
        )) {
          nextSelected.add(Map<String, dynamic>.from(existing));
          _selectedReasons = nextSelected;
        }
      });
      _persistDraft();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alasan sudah ada dan dipilih')),
      );
      return;
    }

    try {
      final option = await _reportService.createReworkReasonOption(trimmed);
      if (!mounted) return;
      setState(() {
        final mapped = Map<String, dynamic>.from(option);
        final nextOptions = List<Map<String, dynamic>>.from(_reasonOptions);
        final nextSelected = List<Map<String, dynamic>>.from(_selectedReasons);
        if (!nextOptions.any(
          (item) => item['value'].toString() == mapped['value'].toString(),
        )) {
          nextOptions.add(mapped);
        }
        if (!nextSelected.any(
          (item) => item['value'].toString() == mapped['value'].toString(),
        )) {
          nextSelected.add(Map<String, dynamic>.from(mapped));
        }
        _reasonOptions = nextOptions;
        _selectedReasons = nextSelected;
      });
      _persistDraft();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alasan berhasil ditambahkan')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(e))),
=======
        .where((option) => !selectedValues.contains(option['value']))
=======
        .where(
          (option) => !selectedValues.contains(option['value'].toString()),
        )
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
        .toList();

    final selected = await _showReasonSelectionSheet(availableOptions);

    if (selected == null || !mounted) return;
    setState(() {
      final nextSelected =
          List<Map<String, dynamic>>.from(_selectedReasons);
=======
>>>>>>> dd9415e7 (fix: alasan penyebab rework)
      for (final value in selected) {
        final valueKey = value.toString();
        final option = _reasonOptions.cast<Map<String, dynamic>>().firstWhere(
              (item) => item['value'].toString() == valueKey,
              orElse: () => <String, dynamic>{
                'id': valueKey,
                'value': valueKey,
                'label': valueKey,
              },
            );
        if (!nextSelected.any(
          (item) => item['value'].toString() == option['value'].toString(),
        )) {
          nextSelected.add(Map<String, dynamic>.from(option));
        }
      }
      _selectedReasons = nextSelected;
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
        var selectedIds = <String>[];
        var searchQuery = '';

        return StatefulBuilder(
          builder: (context, setSheetState) {
            void applyFilter() {
              filteredItems = items
                  .where(
                    (item) => item['label']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery),
                  )
                  .toList();
            }

            Future<void> deleteOption(Map<String, dynamic> item) async {
              final optionId = item['id']?.toString().trim().isNotEmpty == true
                  ? item['id'].toString()
                  : item['value']?.toString();
              if (optionId == null || optionId.isEmpty) return;

              final confirmed = await showDialog<bool>(
                context: sheetContext,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Hapus Alasan'),
                  content: Text(
                    'Hapus alasan "${item['label']}" dari daftar?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;

              try {
                await _reportService.deleteReworkReasonOption(optionId);
                setSheetState(() {
                  items.removeWhere(
                    (option) =>
                        option['id'].toString() == optionId ||
                        option['value'].toString() == optionId ||
                        option['value'].toString() == item['value'].toString(),
                  );
                  selectedIds.remove(item['value'].toString());
                  applyFilter();
                });
                if (!mounted) return;
                setState(() {
                  final valueKey = item['value'].toString();
                  _reasonOptions.removeWhere(
                    (option) =>
                        option['id'].toString() == optionId ||
                        option['value'].toString() == optionId ||
                        option['value'].toString() == valueKey,
                  );
                  _selectedReasons.removeWhere(
                    (option) =>
                        option['id'].toString() == optionId ||
                        option['value'].toString() == optionId ||
                        option['value'].toString() == valueKey,
                  );
                });
                _persistDraft();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(_errorMessage(e))),
                );
              }
            }

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
                          setSheetState(() {
                            searchQuery = value.trim().toLowerCase();
                            applyFilter();
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
                                final valueKey = item['value'].toString();
                                return CheckboxListTile(
                                  value: selectedIds.contains(valueKey),
                                  title: Text(item['label'].toString()),
                                  activeColor: Colors.green,
                                  secondary: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => deleteOption(item),
                                  ),
                                  onChanged: (_) {
                                    setSheetState(() {
                                      if (selectedIds.contains(valueKey)) {
                                        selectedIds = List.from(selectedIds)
                                          ..remove(valueKey);
                                      } else {
                                        selectedIds = List.from(selectedIds)
                                          ..add(valueKey);
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

    final trimmed = label?.trim() ?? '';
    if (trimmed.isEmpty || !mounted) return;

    if (trimmed.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alasan minimal 8 karakter')),
      );
      return;
    }

    final normalized = trimmed.toLowerCase();
    Map<String, dynamic>? existingOption;
    for (final option in _reasonOptions) {
      if (option['label'].toString().trim().toLowerCase() == normalized ||
          option['value'].toString().trim().toLowerCase() == normalized) {
        existingOption = option;
        break;
      }
    }

    if (existingOption != null) {
      final existing = existingOption;
      setState(() {
        final nextSelected = List<Map<String, dynamic>>.from(_selectedReasons);
        if (!nextSelected.any(
          (item) => item['value'].toString() == existing['value'].toString(),
        )) {
          nextSelected.add(Map<String, dynamic>.from(existing));
          _selectedReasons = nextSelected;
        }
      });
      _persistDraft();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alasan sudah ada dan dipilih')),
      );
      return;
    }

    try {
      final option = await _reportService.createReworkReasonOption(trimmed);
      if (!mounted) return;
      setState(() {
        final mapped = Map<String, dynamic>.from(option);
        final nextOptions = List<Map<String, dynamic>>.from(_reasonOptions);
        final nextSelected = List<Map<String, dynamic>>.from(_selectedReasons);
        if (!nextOptions.any(
          (item) => item['value'].toString() == mapped['value'].toString(),
        )) {
          nextOptions.add(mapped);
        }
        if (!nextSelected.any(
          (item) => item['value'].toString() == mapped['value'].toString(),
        )) {
          nextSelected.add(Map<String, dynamic>.from(mapped));
        }
        _reasonOptions = nextOptions;
        _selectedReasons = nextSelected;
      });
      _persistDraft();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alasan berhasil ditambahkan')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        SnackBar(content: Text('Gagal menambah alasan: $e')),
>>>>>>> 41ded02d (fix: rework)
=======
        SnackBar(content: Text(_errorMessage(e))),
>>>>>>> 4ec508fc (fix: remove rencana tindakan)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Evaluasi Rework',
        onReturn: () => Navigator.pop(context),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
        isLoading: _saving,
=======
>>>>>>> bf6ce5bc (fix: rework)
        actions: [
          IconButton(
            tooltip: 'Simpan',
            onPressed: _saving || !_canSave ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.check_outlined,
                    color: _canSave ? null : Colors.grey.shade400,
                  ),
          ),
        ],
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> fcd6e08b (fix: rework)
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: SingleChildScrollView(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Column(
            children: [
<<<<<<< HEAD
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildOverviewCard(),
=======
              _buildOverviewCard(),
              const SizedBox(height: 16),
              _buildCategoryCard(),
              const SizedBox(height: 16),
              _buildReasonForm(),
              const SizedBox(height: 16),
              _buildEditorForm(
                label: 'Rencana Tindakan',
                controller: _actionPlanController,
>>>>>>> 7c2cdb6 (fix:)
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
                    label: 'Rencana Pencegahan',
                    controller: _preventivePlanController,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildAttachmentCard(),
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
=======
>>>>>>> 264bcd0f (fix: evaluasi rework)
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildOverviewCard(),
              const SizedBox(height: 16),
              _buildCategoryCard(),
              const SizedBox(height: 16),
              _buildReasonForm(),
              const SizedBox(height: 16),
              _buildEditorForm(
<<<<<<< HEAD
                label: 'Action Plan',
=======
                label: 'Rencana Tindakan',
>>>>>>> 264bcd0f (fix: evaluasi rework)
                controller: _actionPlanController,
              ),
              const SizedBox(height: 16),
              _buildEditorForm(
<<<<<<< HEAD
                label: 'Preventif Plan',
                controller: _preventivePlanController,
              ),
>>>>>>> 41ded02d (fix: rework)
=======
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
                    label: 'Rencana Pencegahan',
                    controller: _preventivePlanController,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildAttachmentCard(),
                ),
              ],
              if (_visibleStep < 2) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: _buildNextButton(),
                ),
              ],
>>>>>>> e7b9ec75 (fix: UI evaluasi)
            ],
          ),
=======
          padding: EdgeInsets.all(16),
          child: _buildEditStep(),
>>>>>>> fcd6e08b (fix: rework)
        ),
      ),
<<<<<<< HEAD
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
=======
                label: 'Rencana Pencegahan',
                controller: _preventivePlanController,
              ),
            ],
          ),
>>>>>>> 264bcd0f (fix: evaluasi rework)
        ),
      ),
      bottomNavigationBar: _buildSaveBar(),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
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
    );
  }

>>>>>>> 41ded02d (fix: rework)
  Widget _buildReasonForm() {
=======
  Widget _buildEditStep() {
    switch (_editStep) {
      case 1:
        return _buildEditorForm(
          label: 'Rencana Tindakan',
          controller: _actionPlanController,
          footer: _buildStepButtons(
            nextLabel: 'Selanjutnya',
            nextEnabled: _actionPlanController.text.trim().isNotEmpty,
            onNext: () => setState(() => _editStep = 2),
          ),
        );
      case 2:
        return _buildEditorForm(
          label: 'Rencana Pencegahan',
          controller: _preventivePlanController,
          footer: _buildStepButtons(
            nextLabel: 'Simpan',
            nextEnabled:
                _preventivePlanController.text.trim().isNotEmpty && !_saving,
            onNext: _save,
          ),
        );
      default:
        return _buildReasonForm(
          footer: _buildReasonStepButton(),
        );
    }
  }

  Widget _buildReasonStepButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedReasons.isEmpty
            ? null
            : () => setState(() => _editStep = 1),
        style: _primaryActionButtonStyle,
        child: const Text('Selanjutnya'),
      ),
    );
  }

  Widget _buildStepButtons({
    required String nextLabel,
    required bool nextEnabled,
    required VoidCallback onNext,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _saving ? null : () => setState(() => _editStep--),
            style: _secondaryActionButtonStyle,
            child: const Text('Kembali'),
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
>>>>>>> 264bcd0f (fix: evaluasi rework)
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

<<<<<<< HEAD
  ButtonStyle get _secondaryActionButtonStyle => OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  Widget _buildReasonForm({Widget? footer}) {
>>>>>>> fcd6e08b (fix: rework)
=======
  Widget _buildReasonForm() {
>>>>>>> 264bcd0f (fix: evaluasi rework)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
            spacing: 8,
            runSpacing: 8,
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> 01aa2117 (fix: attachment evaluation)
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
<<<<<<< HEAD
<<<<<<< HEAD
                      _persistDraft();
=======
>>>>>>> 41ded02d (fix: rework)
=======
                      _persistDraft();
>>>>>>> e7b9ec75 (fix: UI evaluasi)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 264bcd0f (fix: evaluasi rework)
    return TemplateCard(
      title: label,
      icon: Icons.description_outlined,
      child: child,
<<<<<<< HEAD
=======
    return Container(
      width: double.infinity,
      decoration: CustomTheme().cardTheme(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
>>>>>>> 41ded02d (fix: rework)
=======
>>>>>>> 264bcd0f (fix: evaluasi rework)
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

  bool get _isCompleted {
    final status = widget.data['status']?.toString().toLowerCase();
    return status == 'selesai' || status == 'completed';
  }

  String _value(String key) => widget.data[key]?.toString() ?? '-';

  String get _detailReferenceNo {
    final dyeing = widget.data['dyeing'];
    final raw = widget.data['rework_reference'] ??
        (dyeing is Map ? dyeing['rework_reference'] : null);
    final reference = raw is Map ? raw : <String, dynamic>{};
    final value =
        reference['dyeing_no'] ?? reference['no'] ?? reference['reference_no'];
    return value?.toString().trim().isNotEmpty == true ? value.toString() : '-';
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
          label: 'Rework Dyeing',
          value: _value('dyeingProcessNo'),
          valueColor: const Color(0xFF234393),
        ),
        const SizedBox(height: 12),
        _buildDyeingReferenceItem(
          label: 'Referensi Dyeing',
          value: _detailReferenceNo,
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

  List<Map<String, dynamic>> _parseAttachments(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) => _attachmentSource(item) != null)
        .toList();
  }

  bool _isLocalAttachment(Map<String, dynamic> item) => item['isNew'] == true;

  String? _attachmentSource(Map<String, dynamic> item) {
    if (_isLocalAttachment(item)) {
      final path = item['path']?.toString().trim() ?? '';
      return path.isEmpty ? null : path;
    }

    for (final key in ['file_path', 'file_url', 'url', 'path']) {
      final value = item[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  String? _attachmentUrl(Map<String, dynamic> item) {
    final source = _attachmentSource(item);
    if (source == null || _isLocalAttachment(item)) return source;
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

  Widget _attachmentImage(
    Map<String, dynamic> item, {
    BoxFit fit = BoxFit.cover,
  }) {
    final source = _attachmentUrl(item);
    if (source == null) {
      return const Icon(Icons.broken_image_outlined, color: Colors.white70);
    }

    if (_isLocalAttachment(item)) {
      return Image.file(
        File(source),
        fit: fit,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image_outlined, color: Colors.white70),
      );
    }

    return Image.network(
      source,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image_outlined, color: Colors.white70),
    );
  }

  Future<File?> _compressImage(String path) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 70,
    );
    if (result != null) return File(result.path);
    return File(path);
  }

  Future<ImageSource?> _showImageSourceSheet({required String title}) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ImageSourceButton(
                        icon: Icons.photo_camera_outlined,
                        label: 'Ambil gambar',
                        onTap: () =>
                            Navigator.pop(sheetContext, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ImageSourceButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Dari galeri',
                        onTap: () =>
                            Navigator.pop(sheetContext, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _pickPhoto(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (image == null) return null;

    final fileExtension = image.path.split('.').last.toLowerCase();
    const allowed = {'jpg', 'jpeg', 'png', 'gif', 'webp'};
    if (!allowed.contains(fileExtension)) {
      throw Exception('Lampiran hanya boleh jpg, jpeg, png, gif, atau webp.');
    }

    final File file;
    if (fileExtension == 'gif' || fileExtension == 'webp') {
      file = File(image.path);
    } else {
      final compressed = await _compressImage(image.path);
      if (compressed == null) return null;
      file = compressed;
    }

    if (await file.length() > 10 * 1024 * 1024) {
      throw Exception('Ukuran foto maksimal 10MB.');
    }

    final name = file.path.split('/').last;
    return {
      'name': name,
      'path': file.path,
      'extension': name.split('.').last.toLowerCase(),
      'isNew': true,
    };
  }

  Future<void> _addAttachment() async {
    try {
      final source = await _showImageSourceSheet(title: 'Tambah Foto');
      if (source == null || !mounted) return;
      final photo = await _pickPhoto(source);
      if (photo == null || !mounted) return;
      setState(() {
        _attachments = [..._attachments, photo];
      });
      _persistDraft();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(e))),
      );
    }
  }

  Future<void> _replaceAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    try {
      final source = await _showImageSourceSheet(title: 'Ganti Foto');
      if (source == null || !mounted) return;
      final photo = await _pickPhoto(source);
      if (photo == null || !mounted) return;
      setState(() {
        final next = List<Map<String, dynamic>>.from(_attachments);
        next[index] = photo;
        _attachments = next;
      });
      _persistDraft();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(e))),
      );
    }
  }

  Future<void> _deleteAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Foto'),
        content: const Text('Hapus lampiran foto ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      final next = List<Map<String, dynamic>>.from(_attachments);
      next.removeAt(index);
      _attachments = next;
    });
    _persistDraft();
  }

  Future<void> _viewAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: _attachmentImage(
                        _attachments[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await _deleteAttachment(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Hapus'),
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
  }

  Future<void> _showAttachmentActions(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(sheetContext, 'view'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ColoredBox(
                        color: Colors.black,
                        child: _attachmentImage(
                          _attachments[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Hapus gambar',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(sheetContext, 'delete'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;
    if (action == 'view') await _viewAttachment(index);
    if (action == 'edit') await _replaceAttachment(index);
    if (action == 'delete') await _deleteAttachment(index);
  }

  Widget _buildAttachmentCard() {
    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.photo_library_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 8.0;
          final columns = constraints.maxWidth < 280 ? 2 : 3;
          final tileSize =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final itemCount = _attachments.length + 1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemBuilder: (context, index) {
              if (index == _attachments.length) {
                return _AddPhotoTile(
                  size: tileSize,
                  onTap: _addAttachment,
                );
              }

              return GestureDetector(
                onTap: () => _viewAttachment(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: Colors.grey.shade200,
                        child: _attachmentImage(_attachments[index]),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: GestureDetector(
                          onTap: () => _showAttachmentActions(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
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

class _ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F6FB),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 96,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF4561DB)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _AddPhotoTile({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade700),
              const SizedBox(height: 6),
              Text(
                'Tambah\nfoto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _submit() {
    final value = _controller.text.trim();
    if (value.length < 8) {
      setState(() => _errorMessage = 'Minimal 8 karakter');
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final canAdd = _controller.text.trim().length >= 8;

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
                  hintText: 'Masukkan alasan rework (min. 8 karakter)',
                  border: OutlineInputBorder(),
                ).copyWith(errorText: _errorMessage),
                onChanged: (_) {
                  setState(() {
                    if (_errorMessage != null) _errorMessage = null;
                  });
                },
                onSubmitted: (_) => _submit(),
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
                      onPressed: canAdd ? _submit : null,
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
<<<<<<< HEAD

  List<Map<String, dynamic>> _parseAttachments(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .where((item) => _attachmentSource(item) != null)
        .toList();
  }

  bool _isLocalAttachment(Map<String, dynamic> item) => item['isNew'] == true;

  String? _attachmentSource(Map<String, dynamic> item) {
    if (_isLocalAttachment(item)) {
      final path = item['path']?.toString().trim() ?? '';
      return path.isEmpty ? null : path;
    }

    for (final key in ['file_path', 'file_url', 'url', 'path']) {
      final value = item[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  String? _attachmentUrl(Map<String, dynamic> item) {
    final source = _attachmentSource(item);
    if (source == null || _isLocalAttachment(item)) return source;
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

  Widget _attachmentImage(
    Map<String, dynamic> item, {
    BoxFit fit = BoxFit.cover,
  }) {
    final source = _attachmentUrl(item);
    if (source == null) {
      return const Icon(Icons.broken_image_outlined, color: Colors.white70);
    }

    if (_isLocalAttachment(item)) {
      return Image.file(
        File(source),
        fit: fit,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image_outlined, color: Colors.white70),
      );
    }

    return Image.network(
      source,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image_outlined, color: Colors.white70),
    );
  }

  Future<File?> _compressImage(String path) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 70,
    );
    if (result != null) return File(result.path);
    return File(path);
  }

  Future<ImageSource?> _showImageSourceSheet({required String title}) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ImageSourceButton(
                        icon: Icons.photo_camera_outlined,
                        label: 'Ambil gambar',
                        onTap: () =>
                            Navigator.pop(sheetContext, ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ImageSourceButton(
                        icon: Icons.photo_library_outlined,
                        label: 'Dari galeri',
                        onTap: () =>
                            Navigator.pop(sheetContext, ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _pickPhoto(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (image == null) return null;

    final fileExtension = image.path.split('.').last.toLowerCase();
    const allowed = {'jpg', 'jpeg', 'png', 'gif', 'webp'};
    if (!allowed.contains(fileExtension)) {
      throw Exception('Lampiran hanya boleh jpg, jpeg, png, gif, atau webp.');
    }

    final File file;
    if (fileExtension == 'gif' || fileExtension == 'webp') {
      file = File(image.path);
    } else {
      final compressed = await _compressImage(image.path);
      if (compressed == null) return null;
      file = compressed;
    }

    if (await file.length() > 10 * 1024 * 1024) {
      throw Exception('Ukuran foto maksimal 10MB.');
    }

    final name = file.path.split('/').last;
    return {
      'name': name,
      'path': file.path,
      'extension': name.split('.').last.toLowerCase(),
      'isNew': true,
    };
  }

  Future<void> _addAttachment() async {
    try {
      final source = await _showImageSourceSheet(title: 'Tambah Foto');
      if (source == null || !mounted) return;
      final photo = await _pickPhoto(source);
      if (photo == null || !mounted) return;
      setState(() {
        _attachments = [..._attachments, photo];
      });
      _persistDraft();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(e))),
      );
    }
  }

  Future<void> _replaceAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    try {
      final source = await _showImageSourceSheet(title: 'Ganti Foto');
      if (source == null || !mounted) return;
      final photo = await _pickPhoto(source);
      if (photo == null || !mounted) return;
      setState(() {
        final next = List<Map<String, dynamic>>.from(_attachments);
        next[index] = photo;
        _attachments = next;
      });
      _persistDraft();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(e))),
      );
    }
  }

  Future<void> _deleteAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Foto'),
        content: const Text('Hapus lampiran foto ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      final next = List<Map<String, dynamic>>.from(_attachments);
      next.removeAt(index);
      _attachments = next;
    });
    _persistDraft();
  }

  Future<void> _viewAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Center(
                      child: _attachmentImage(
                        _attachments[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await _deleteAttachment(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Hapus'),
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
  }

  Future<void> _showAttachmentActions(int index) async {
    if (index < 0 || index >= _attachments.length) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(sheetContext, 'view'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ColoredBox(
                        color: Colors.black,
                        child: _attachmentImage(
                          _attachments[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Hapus gambar',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Navigator.pop(sheetContext, 'delete'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;
    if (action == 'view') await _viewAttachment(index);
    if (action == 'edit') await _replaceAttachment(index);
    if (action == 'delete') await _deleteAttachment(index);
  }

  Widget _buildAttachmentCard() {
    return TemplateCard(
      title: 'Lampiran',
      icon: Icons.photo_library_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 8.0;
          final columns = constraints.maxWidth < 280 ? 2 : 3;
          final tileSize =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final itemCount = _attachments.length + 1;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemBuilder: (context, index) {
              if (index == _attachments.length) {
                return _AddPhotoTile(
                  size: tileSize,
                  onTap: _addAttachment,
                );
              }

              return GestureDetector(
                onTap: () => _viewAttachment(index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: Colors.grey.shade200,
                        child: _attachmentImage(_attachments[index]),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: GestureDetector(
                          onTap: () => _showAttachmentActions(index),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
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

class _ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F6FB),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 96,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF4561DB)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _AddPhotoTile({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade700),
              const SizedBox(height: 6),
              Text(
                'Tambah\nfoto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _submit() {
    final value = _controller.text.trim();
    if (value.length < 8) {
      setState(() => _errorMessage = 'Minimal 8 karakter');
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final canAdd = _controller.text.trim().length >= 8;

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
                  hintText: 'Masukkan alasan rework (min. 8 karakter)',
                  border: OutlineInputBorder(),
                ).copyWith(errorText: _errorMessage),
                onChanged: (_) {
                  setState(() {
                    if (_errorMessage != null) _errorMessage = null;
                  });
                },
                onSubmitted: (_) => _submit(),
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
                      onPressed: canAdd ? _submit : null,
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
=======
>>>>>>> 41ded02d (fix: rework)
}
