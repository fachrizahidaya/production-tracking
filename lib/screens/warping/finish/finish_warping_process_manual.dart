// ignore_for_file: use_build_context_synchronously

<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:async';
import 'dart:io';

=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
import 'dart:async';
import 'dart:io';

>>>>>>> 64274789 (fix: selesai warping-shearing)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/greige_info_tab.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
=======
=======
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
>>>>>>> 64274789 (fix: selesai warping-shearing)
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/screens/update/process/machine.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';
<<<<<<< HEAD
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
>>>>>>> 64274789 (fix: selesai warping-shearing)

class FinishWarpingProcessManual extends StatefulWidget {
  final dynamic id;
  final dynamic processId;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final Future<void> Function(String id)? handleSubmit;
  final void Function(String fieldName, dynamic value)? handleChangeInput;

  const FinishWarpingProcessManual({
    super.key,
    this.id,
    this.processId,
    this.data,
    this.form,
    this.handleSubmit,
    this.handleChangeInput,
  });

  @override
  State<FinishWarpingProcessManual> createState() =>
      _FinishWarpingProcessManualState();
}

class _FinishWarpingProcessManualState
    extends State<FinishWarpingProcessManual> {
  final OptionGreigeOrderService _greigeOrderService =
      OptionGreigeOrderService();
  final WarpingService _warpingService = WarpingService();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final TextEditingController _noteController = TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  List<Map<String, dynamic>> _brokenYarnTypes = [];
  List<TextEditingController> _brokenYarnQtyControllers = [];
  final List<_CustomBrokenYarnEntry> _customBrokenYarns = [];
=======
  final TextEditingController _yarnQtyController = TextEditingController();
  List<TextEditingController> _lengthControllers = [];
  final TextEditingController _sectionController = TextEditingController();
<<<<<<< HEAD
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
  final TextEditingController _beamQtyController = TextEditingController();
>>>>>>> e02e3ffb (fix: finish warping)
=======
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  List<Map<String, dynamic>> _brokenYarnTypes = [];
  List<TextEditingController> _brokenYarnQtyControllers = [];
  final List<_CustomBrokenYarnEntry> _customBrokenYarns = [];
>>>>>>> 3562ec45 (fix: selesai warping - shearing)

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  List<dynamic> workOrderOption = [];
  Map<String, dynamic> woData = {};
  Map<String, dynamic> processData = {};
  String? processId;

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64274789 (fix: selesai warping-shearing)
  late List<Map<String, dynamic>> allAttachments;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

<<<<<<< HEAD
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
>>>>>>> 64274789 (fix: selesai warping-shearing)
  @override
  void initState() {
    super.initState();

    processId = widget.processId?.toString();
    woData = Map<String, dynamic>.from(widget.data ?? {});
    _noteController.text = widget.form?['notes']?.toString() ?? '';

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 64274789 (fix: selesai warping-shearing)
    final existing = List<Map<String, dynamic>>.from(
      widget.form?['attachments'] ?? [],
    );

    allAttachments = [
      ...existing,
      {'is_add_button': true},
    ];

<<<<<<< HEAD
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
>>>>>>> 64274789 (fix: selesai warping-shearing)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postInit();
    });
  }

  Future<void> _postInit() async {
    await _fetchWorkOrder();
<<<<<<< HEAD
<<<<<<< HEAD
    await _fetchBrokenYarnTypes();
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
    await _fetchBrokenYarnTypes();
>>>>>>> 3562ec45 (fix: selesai warping - shearing)

    if (widget.processId != null) {
      await _getProcessView(widget.processId);
    }
  }

  Future<void> _fetchWorkOrder() async {
    setState(() => _isFetchingWorkOrder = true);

    try {
      final service =
          Provider.of<OptionGreigeOrderService>(context, listen: false);
      await service.fetchWarpingFinishOptions();

      setState(() {
        workOrderOption = service.dataListOption;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      setState(() => _isFetchingWorkOrder = false);
    }
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
  Future<void> _fetchBrokenYarnTypes() async {
    try {
      final types = await _warpingService.fetchBrokenYarnTypes(context);
      types.sort(
        (a, b) => (a['sort_order'] as num? ?? 0)
            .compareTo(b['sort_order'] as num? ?? 0),
      );

      if (!mounted) return;

      for (final controller in _brokenYarnQtyControllers) {
        controller.dispose();
      }

      setState(() {
        _brokenYarnTypes = types;
        _brokenYarnQtyControllers = List.generate(
          types.length,
          (_) => TextEditingController(),
        );
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

<<<<<<< HEAD
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
  void _handleChangeInput(String field, dynamic value) {
    setState(() {
      widget.form?[field] = value;
    });
    widget.handleChangeInput?.call(field, value);
  }

<<<<<<< HEAD
<<<<<<< HEAD
  num? _parseBrokenYarnQty(String value) {
    final parsed = num.tryParse(
      value.trim().replaceAll('.', '').replaceAll(',', '.'),
    );
    return parsed != null && parsed > 0 ? parsed : null;
  }

  num get _totalBrokenYarnQty {
    num total = 0;

    for (final controller in _brokenYarnQtyControllers) {
      total += _parseBrokenYarnQty(controller.text) ?? 0;
    }

    for (final entry in _customBrokenYarns) {
      total += _parseBrokenYarnQty(entry.qtyController.text) ?? 0;
    }

    return total;
  }

=======
  num? _parseBrokenYarnQty(String value) {
    final parsed = num.tryParse(
      value.trim().replaceAll('.', '').replaceAll(',', '.'),
    );
    return parsed != null && parsed > 0 ? parsed : null;
  }

<<<<<<< HEAD
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
=======
  num get _totalBrokenYarnQty {
    num total = 0;

    for (final controller in _brokenYarnQtyControllers) {
      total += _parseBrokenYarnQty(controller.text) ?? 0;
    }

    for (final entry in _customBrokenYarns) {
      total += _parseBrokenYarnQty(entry.qtyController.text) ?? 0;
    }

    return total;
  }

>>>>>>> ffa19d72 (fix: akumulasi jumlah benang di warping)
  void _syncBrokenYarns() {
    final brokenYarns = <Map<String, dynamic>>[];

    for (int i = 0; i < _brokenYarnTypes.length; i++) {
      final qty = _parseBrokenYarnQty(_brokenYarnQtyControllers[i].text);

      if (qty != null) {
        brokenYarns.add({
          'break_type': _brokenYarnTypes[i]['break_type'],
          'qty': qty,
        });
      }
    }

    for (final entry in _customBrokenYarns) {
      final label = entry.labelController.text.trim();
      final qty = _parseBrokenYarnQty(entry.qtyController.text);

      if (label.isNotEmpty && qty != null) {
        brokenYarns.add({
          'break_type': null,
          'label': label,
          'qty': qty,
        });
      }
    }

    widget.form?['broken_yarns'] = brokenYarns;
    widget.handleChangeInput?.call('broken_yarns', brokenYarns);
  }

  void _applyExistingBrokenYarns(dynamic value) {
    final existing = List<Map<String, dynamic>>.from(value ?? []);

    for (int i = 0; i < _brokenYarnTypes.length; i++) {
      final breakType = _brokenYarnTypes[i]['break_type']?.toString();
      final match = existing.where(
        (item) => item['break_type']?.toString() == breakType,
      );

      _brokenYarnQtyControllers[i].text =
          match.isEmpty ? '' : match.first['qty']?.toString() ?? '';
    }

    for (final entry in _customBrokenYarns) {
      entry.dispose();
    }
    _customBrokenYarns.clear();

    for (final item in existing.where((item) => item['break_type'] == null)) {
      _customBrokenYarns.add(
        _CustomBrokenYarnEntry(
          label: item['label']?.toString() ?? '',
          qty: item['qty']?.toString() ?? '',
        ),
      );
    }

    _syncBrokenYarns();
  }

  void _addCustomBrokenYarn() {
    setState(() {
      _customBrokenYarns.add(_CustomBrokenYarnEntry());
    });
  }

  void _removeCustomBrokenYarn(int index) {
    setState(() {
      _customBrokenYarns.removeAt(index).dispose();
      _syncBrokenYarns();
    });
  }

<<<<<<< HEAD
  Future<void> _getWorkOrderView(dynamic id) async {
    await _greigeOrderService.getDataView(id);

    final data = _greigeOrderService.dataView;

    setState(() {
      woData = data;
      final warpingType = _readWarpingType(data);
      if (warpingType != null) {
        widget.form?['warping_type'] = warpingType;
      }
=======
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
  Future<void> _getWorkOrderView(dynamic id) async {
    await _greigeOrderService.getDataView(id);

    final data = _greigeOrderService.dataView;

    setState(() {
<<<<<<< HEAD
      woData = _greigeOrderService.dataView;
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
      woData = data;
<<<<<<< HEAD

      // dispose controller lama
      for (final c in _lengthControllers) {
        c.dispose();
      }

      _lengthControllers = List.generate(
        pasangQty,
        (_) => TextEditingController(),
      );

      widget.form?['lengths'] = List.generate(pasangQty, (_) => '');
>>>>>>> e02e3ffb (fix: finish warping)
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
    });
  }

  Future<void> _getProcessView(dynamic id) async {
    setState(() => _firstLoading = true);

    try {
      await _warpingService.getDataView(context, id);

<<<<<<< HEAD
<<<<<<< HEAD
      final data = _warpingService.dataView['data'];
      final attachments = List<Map<String, dynamic>>.from(
        data['attachments'] ?? [],
      );

      setState(() {
        processData = data;

        widget.form?['process_id'] = data['id']?.toString();
        widget.form?['machines'] = List<Map<String, dynamic>>.from(
          data['machines'] ?? [],
        );
        widget.form?['machine_id'] = data['machine']?['id'];
        widget.form?['warping_type'] = _readWarpingType(data) ??
            _readWarpingType(data['order_greige']) ??
            _readWarpingType(woData) ??
            _readWarpingType(widget.form?['warping_type']);
        widget.form?['yarn_qty'] = data['yarn_qty'];
        widget.form?['beam_qty'] = data['beam_qty'];
        widget.form?['section'] = data['section'];
        widget.form?['order_greige_id'] = data['order_greige_id'];
        widget.form?['no_og'] =
            data['order_greige']?['og_no'] ?? widget.form?['no_og'];
        widget.form?['notes'] = data['notes']?.toString() ?? '';
        widget.form?['attachments'] = attachments;
        widget.form?['length'] = data['length'];
        widget.form?['weight'] = data['weight'];

        allAttachments = [
          ...attachments,
          {'is_add_button': true},
        ];

        _lengthController.text = data['length']?.toString() ?? '';

        _weightController.text = data['weight']?.toString() ?? '';

        _sectionController.text = data['section']?.toString() ?? '';

        _noteController.text = data['notes']?.toString() ?? '';
        _applyExistingBrokenYarns(data['broken_yarns']);
=======
      setState(() {
        processData = _warpingService.dataView['data'];
        widget.form?['process_id'] = processData['id']?.toString();
        widget.form?['machine_id'] = processData['machine']['id'];
        widget.form?['warping_type'] = processData['warping_type'];
        widget.form?['yarn_qty'] = processData['yarn_qty'];
        widget.form?['length'] = processData['length'];
        widget.form?['section'] = processData['section'];
        widget.form?['order_greige_id'] = processData['order_greige_id'];
        widget.form?['no_og'] =
            processData['order_greige']?['og_no'] ?? widget.form?['no_og'];
        widget.form?['notes'] = processData['notes']?.toString() ?? '';

        _yarnQtyController.text = processData['yarn_qty']?.toString() ?? '';
        _lengthController.text = processData['length']?.toString() ?? '';
        _sectionController.text = processData['section']?.toString() ?? '';
        _noteController.text = processData['notes']?.toString() ??
            widget.form?['notes']?.toString() ??
            '';
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
      final data = _warpingService.dataView['data'];
      final attachments = List<Map<String, dynamic>>.from(
        data['attachments'] ?? [],
      );

      setState(() {
        processData = data;

        widget.form?['process_id'] = data['id']?.toString();
        widget.form?['machines'] = List<Map<String, dynamic>>.from(
          data['machines'] ?? [],
        );
        widget.form?['machine_id'] = data['machine']?['id'];
        widget.form?['warping_type'] = data['warping_type'];
        widget.form?['yarn_qty'] = data['yarn_qty'];
        widget.form?['beam_qty'] = data['beam_qty'];
        widget.form?['section'] = data['section'];
        widget.form?['order_greige_id'] = data['order_greige_id'];
        widget.form?['no_og'] =
            data['order_greige']?['og_no'] ?? widget.form?['no_og'];
        widget.form?['notes'] = data['notes']?.toString() ?? '';
        widget.form?['attachments'] = attachments;
        widget.form?['length'] = data['length'];
        widget.form?['weight'] = data['weight'];

        allAttachments = [
          ...attachments,
          {'is_add_button': true},
        ];

        _lengthController.text = data['length']?.toString() ?? '';

        _weightController.text = data['weight']?.toString() ?? '';

        _sectionController.text = data['section']?.toString() ?? '';

        _noteController.text = data['notes']?.toString() ?? '';
<<<<<<< HEAD

        // dispose controller lama
        for (final c in _lengthControllers) {
          c.dispose();
        }

        // buat controller baru
        _lengthControllers = List.generate(
          lengths.length,
          (index) => TextEditingController(
            text: lengths[index].toString(),
          ),
        );
>>>>>>> e02e3ffb (fix: finish warping)
=======
        _applyExistingBrokenYarns(data['broken_yarns']);
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
      });
    } finally {
      setState(() => _firstLoading = false);
    }
  }

<<<<<<< HEAD
  dynamic _readWarpingType(dynamic source, [int depth = 0]) {
    if (source == null) return null;

    if (source is! Map) {
      final text = source.toString().trim();
      return text.isEmpty ? null : source;
    }

    final direct = source['warping_type'];
    if (direct != null &&
        direct is! Map &&
        direct.toString().trim().isNotEmpty) {
      return direct;
    }

    if (depth >= 3) return null;

    for (final value in source.values) {
      if (value is Map) {
        final found = _readWarpingType(value, depth + 1);
        if (found != null) return found;
      }
    }

    return null;
  }

  String _formatWarpingType(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

    return value
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

=======
>>>>>>> 5d1f483f (fix: warping, sizing)
  void _selectWorkOrder() {
    showSelectDialog(
      context: context,
      title: 'Work Order',
      isFetching: _isFetchingWorkOrder,
      option: workOrderOption,
<<<<<<< HEAD
      badgeKey: 'warping_type',
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
      selected: widget.form?['wo_id']?.toString() ?? '',
      handleChangeValue: (selected) async {
        final woId = selected['value']?.toString();
        final selectedProcessId = selected['warping_id']?.toString();

        setState(() {
          widget.form?['order_greige_id'] = woId;
          widget.form?['no_og'] = selected['label']?.toString() ?? '';
<<<<<<< HEAD
          widget.form?['warping_type'] = _readWarpingType(selected);
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
          widget.form?['process_id'] = selectedProcessId;
          processId = selectedProcessId;
          processData = {};
        });

        if (woId != null && woId.isNotEmpty) {
          await _getWorkOrderView(woId);
        }

        if (selectedProcessId != null && selectedProcessId.isNotEmpty) {
          await _getProcessView(selectedProcessId);
        }
      },
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final id = processId ?? widget.form?['process_id']?.toString();

    if (id == null || id.isEmpty) return;

    Widget buildBoldMessage(String woNo) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: CustomTheme().fontSize('xl'),
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'Anda yakin ingin menyelesaikan Warping '),
            TextSpan(
              text: woNo,
              style: TextStyle(
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            const TextSpan(text: '? Pastikan semua data sudah benar!'),
          ],
        ),
      );
    }

    showConfirmationDialog(
      context: context,
      isLoading: _isSubmitting,
      onConfirm: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        _isSubmitting.value = true;
        try {
          await widget.handleSubmit?.call(id);
        } finally {
          _isSubmitting.value = false;
        }
      },
      title: 'Selesai Warping',
      buttonBackground: CustomTheme().buttonColor('primary'),
      child: buildBoldMessage(widget.form?['no_og']?.toString() ?? '-'),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
  dynamic _getMachineStatus(dynamic machineId) {
    final machines = List<Map<String, dynamic>>.from(
      processData['machines'] ?? [],
    );

    for (final item in machines) {
      if (item['machine']?['id']?.toString() == machineId.toString()) {
        return item['status'];
      }
    }

    return null;
  }

  bool _isAllMachineDone() {
    final machines = processData['machines'] as List? ?? [];

    return machines.isNotEmpty &&
        machines.every((machine) => machine?['status'] == 'Selesai');
  }

<<<<<<< HEAD
=======
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
  Future<File?> compressImage(String path) async {
    if (kIsWeb) {
      return File(path);
    }

    final dir = await getTemporaryDirectory();

    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 70,
    );

    return result != null ? File(result.path) : null;
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Future<void> _pickAttachments(ImageSource source) async {
=======
  Future<void> _pickAttachments() async {
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
  Future<void> _pickAttachments(ImageSource source) async {
>>>>>>> 04066211 (fix: attachment pick dari galeri untuk warping - persiapan dyeing)
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
<<<<<<< HEAD
<<<<<<< HEAD
        source: source,
=======
        source: ImageSource.camera,
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
        source: source,
>>>>>>> 04066211 (fix: attachment pick dari galeri untuk warping - persiapan dyeing)
      );

      if (image == null) return;

      final compressedFile = await compressImage(image.path);

      if (compressedFile == null) return;

      setState(() {
        // Hapus tombol tambah sementara
        allAttachments.removeWhere(
          (e) => e['is_add_button'] == true,
        );

        final newFile = {
          'name': compressedFile.path.split('/').last,
          'path': compressedFile.path,
          'extension': compressedFile.path.split('.').last,
          'isNew': true,
        };

        allAttachments.add(newFile);

        // Tambahkan kembali tombol tambah
        allAttachments.add({
          'is_add_button': true,
        });

        widget.form?['attachments'] =
            allAttachments.where((e) => e['is_add_button'] != true).toList();
      });
    } catch (e) {
      if (!mounted) return;

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  void showImageDialog(
    BuildContext context,
    bool isNew,
    String filePath,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: CustomTheme().padding('content'),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: CustomTheme().padding('process-content'),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: isNew
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _handleDeleteAttachment(Map item) async {
    if (!context.mounted) return false;

    final completer = Completer<bool?>();

    showConfirmationDialog(
      context: context,
      isLoading: _isLoading,
      title: 'Hapus Lampiran',
      message: 'Apakah Anda yakin ingin menghapus lampiran ini?',
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        await Future.delayed(
          const Duration(milliseconds: 200),
        );

        if (!mounted) {
          completer.complete(false);
          return;
        }

        setState(() {
          allAttachments.remove(item);

          widget.form?['attachments'] =
              allAttachments.where((e) => e['is_add_button'] != true).toList();
        });

        Navigator.pop(context);

        completer.complete(true);
      },
    );

    return completer.future;
  }

<<<<<<< HEAD
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
>>>>>>> 64274789 (fix: selesai warping-shearing)
  @override
  void dispose() {
    widget.form?.clear();

    _noteController.dispose();
<<<<<<< HEAD
<<<<<<< HEAD
    _lengthController.dispose();
    for (final controller in _brokenYarnQtyControllers) {
      controller.dispose();
    }
    for (final entry in _customBrokenYarns) {
      entry.dispose();
    }
    _weightController.dispose();
=======
    _yarnQtyController.dispose();
<<<<<<< HEAD
    _lengthController.dispose();
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
    for (final controller in _lengthControllers) {
      controller.dispose();
    }
<<<<<<< HEAD
>>>>>>> e02e3ffb (fix: finish warping)
=======
    _beamQtyController.dispose();
>>>>>>> 64274789 (fix: selesai warping-shearing)
=======
    _lengthController.dispose();
    for (final controller in _brokenYarnQtyControllers) {
      controller.dispose();
    }
    for (final entry in _customBrokenYarns) {
      entry.dispose();
    }
    _weightController.dispose();
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
    final isDisabled = widget.form?['order_greige_id'] == null
        // ||
        // !_isAllMachineDone()
        // ||
        // widget.form?['machine_id'] == null ||
        // widget.form?['warping_type'] == null ||
        // widget.form?['yarn_qty'] == null
<<<<<<< HEAD
        // ||
        // widget.form?['length'] == null
        // ||
        // widget.form?['section'] == null
        //  ||
        // widget.form?['beam_qty'] == null
        ;
=======
    final isDisabled = widget.form?['order_greige_id'] == null ||
<<<<<<< HEAD
        widget.form?['machine_id'] == null ||
        widget.form?['warping_type'] == null ||
        widget.form?['yarn_qty'] == null ||
        widget.form?['length'] == null ||
        widget.form?['section'] == null;
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
            widget.form?['machine_id'] == null ||
            widget.form?['warping_type'] == null ||
            widget.form?['yarn_qty'] == null
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
        // ||
        // widget.form?['length'] == null
        // ||
        // widget.form?['section'] == null
        //  ||
        // widget.form?['beam_qty'] == null
        ;
>>>>>>> e02e3ffb (fix: finish warping)

    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFf9fafc),
          appBar: CustomAppBar(
            title: 'Selesai Warping',
            onReturn: () => Navigator.pop(context),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(tabs: [
                    Tab(
                      text: 'Form',
                    ),
                    Tab(
<<<<<<< HEAD
<<<<<<< HEAD
                      text: 'Info Order Greige',
=======
                      text: 'Info Greige Order',
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
                      text: 'Info Order Greige',
>>>>>>> 64274789 (fix: selesai warping-shearing)
                    ),
                  ]),
                ),
                Expanded(
                    child: TabBarView(children: [
                  _firstLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: CustomTheme().padding('content'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TemplateCard(
<<<<<<< HEAD
<<<<<<< HEAD
                                title: 'Order Greige',
                                icon: Icons.assignment_outlined,
                                child: SelectForm(
                                  label: 'Order Greige',
=======
                                title: 'Greige Order',
                                icon: Icons.assignment_outlined,
                                child: SelectForm(
                                  label: 'Greige Order',
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
                                title: 'Order Greige',
                                icon: Icons.assignment_outlined,
                                child: SelectForm(
                                  label: 'Order Greige',
>>>>>>> 64274789 (fix: selesai warping-shearing)
                                  onTap: _selectWorkOrder,
                                  selectedLabel: widget.form?['no_og'] ?? '',
                                  selectedValue: widget.form?['order_greige_id']
                                          ?.toString() ??
                                      '',
<<<<<<< HEAD
                                  badge: _formatWarpingType(
                                    _readWarpingType(widget.form?['warping_type']) ??
                                        _readWarpingType(woData) ??
                                        _readWarpingType(processData),
                                  ),
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
                                  required: true,
                                ),
                              ),
                              if (widget.form?['order_greige_id'] != null) ...[
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
                                TemplateCard(
                                  title: 'Mesin',
                                  icon: Icons.local_laundry_service_outlined,
                                  child: MachineEditSection(
                                    data: processData,
                                    form: widget.form,
                                    getMachineStatus: _getMachineStatus,
                                    newMachines: <Map<String, dynamic>>[],
                                    withAddMachine: false,
<<<<<<< HEAD
                                    columns: 2,
                                    compactDisplay: true,
                                    wrapCrossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    onMachineChanged: () => setState(() {}),
                                  ),
                                ),
                                _buildBrokenYarnSection(),
                                _buildBeamWeightSection(),
<<<<<<< HEAD
=======
                                    onMachineChanged: () => setState(() {}),
                                  ),
                                ),
                                _buildBrokenYarnSection(),
<<<<<<< HEAD
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
=======
                                _buildBeamWeightSection(),
>>>>>>> ffa19d72 (fix: akumulasi jumlah benang di warping)
                                AttachmentPicker(
                                  attachments: allAttachments,
                                  onAddAttachment: _pickAttachments,
                                  onDeleteAttachment: _handleDeleteAttachment,
                                  onPreviewImage: (isNew, filePath) {
                                    showImageDialog(
                                      context,
                                      isNew,
                                      filePath,
                                    );
                                  },
                                ),
=======
                                _buildBeamWeightSection(),
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
                                _buildPanjangSection(),
<<<<<<< HEAD
>>>>>>> e02e3ffb (fix: finish warping)
=======
                                AttachmentPicker(
                                  attachments: allAttachments,
                                  onAddAttachment: _pickAttachments,
                                  onDeleteAttachment: _handleDeleteAttachment,
                                  onPreviewImage: (isNew, filePath) {
                                    showImageDialog(
                                      context,
                                      isNew,
                                      filePath,
                                    );
                                  },
                                ),
>>>>>>> 64274789 (fix: selesai warping-shearing)
                                NoteEditor(
                                  controller: _noteController,
                                  formKey: 'notes',
                                  label: 'Catatan',
                                  form: widget.form,
                                  onChanged: (value) {
                                    _handleChangeInput('notes', value);
                                  },
                                ),
                              ],
                            ].separatedBy(CustomTheme().vGap('2xl')),
                          ),
                        ),
                  GreigeInfoTab(data: woData)
                ])),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: CancelButton(
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      customHeight: 56.0,
                      fontSize: CustomTheme().fontSize('xl'),
                    ),
                  ),
                  Expanded(
                    child: FormButton(
                      label: 'Selesai',
                      isDisabled: isDisabled,
                      onPressed: () => _handleSubmit(context),
                      customHeight: 56.0,
                      fontSize: CustomTheme().fontSize('xl'),
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('xl')),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBeamWeightSection() {
    return TemplateCard(
      title: 'Benang',
      icon: Icons.rule,
<<<<<<< HEAD
<<<<<<< HEAD
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextForm(
<<<<<<< HEAD
<<<<<<< HEAD
                  label: 'Jumlah Panjang (M)',
                  controller: _lengthController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('length', value);
                  },
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Jumlah Berat (KG)',
                  controller: _weightController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('weight', value);
                  },
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Jumlah Section',
                  controller: _sectionController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('section', value);
                  },
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ],
      ),
    );
  }

  Widget _buildBrokenYarnSection() {
    return TemplateCard(
      title: 'Jenis Benang Putus',
      icon: Icons.content_cut_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 24.0;
          final columns = constraints.maxWidth >= 900
              ? 3
              : constraints.maxWidth >= 600
                  ? 2
                  : 1;
          final itemWidth =
              (constraints.maxWidth - (spacing * (columns - 1))) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Jumlah Benang Putus: ${formatNumber(_totalBrokenYarnQty)}',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
              ),
<<<<<<< HEAD
              Wrap(
                spacing: spacing,
                runSpacing: 16,
                children: List.generate(
                  _brokenYarnTypes.length,
                  (index) => SizedBox(
                    width: itemWidth,
                    child: TextForm(
                      label:
                          _brokenYarnTypes[index]['label']?.toString() ?? '-',
                      controller: _brokenYarnQtyControllers[index],
                      req: false,
                      isNumber: true,
                      isSorting: true,
                      handleChange: (_) {
                        _syncBrokenYarns();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              ..._customBrokenYarns.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextForm(
                        label: 'Jenis Lainnya',
                        controller: item.labelController,
                        req: false,
                        handleChange: (_) {
                          _syncBrokenYarns();
                        },
                      ),
                    ),
                    Expanded(
                      child: TextForm(
                        label: 'Qty',
                        controller: item.qtyController,
                        req: false,
                        isNumber: true,
                        isSorting: true,
                        handleChange: (_) {
                          _syncBrokenYarns();
                          setState(() {});
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus jenis',
                      onPressed: () => _removeCustomBrokenYarn(index),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ].separatedBy(CustomTheme().hGap('lg')),
                );
              }),
              TextButton.icon(
                onPressed: _addCustomBrokenYarn,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Jenis'),
              ),
            ].separatedBy(CustomTheme().vGap('lg')),
          );
        },
=======
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
=======
      child: Column(
>>>>>>> e02e3ffb (fix: finish warping)
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextForm(
                  label: 'Jumlah Benang (KG)',
=======
                  label: 'Qty Benang (KG)',
>>>>>>> 64274789 (fix: selesai warping-shearing)
                  controller: _yarnQtyController,
=======
                  label: 'Jumlah Panjang (M)',
                  controller: _lengthController,
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('length', value);
                  },
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Jumlah Berat (KG)',
                  controller: _weightController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('weight', value);
                  },
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Jumlah Section',
                  controller: _sectionController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('section', value);
                  },
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ],
      ),
    );
  }

  Widget _buildBrokenYarnSection() {
    return TemplateCard(
      title: 'Jenis Benang Putus',
      icon: Icons.content_cut_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 24.0;
          final columns = constraints.maxWidth >= 900
              ? 3
              : constraints.maxWidth >= 600
                  ? 2
                  : 1;
          final itemWidth =
              (constraints.maxWidth - (spacing * (columns - 1))) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
=======
>>>>>>> ffa19d72 (fix: akumulasi jumlah benang di warping)
              Wrap(
                spacing: spacing,
                runSpacing: 16,
                children: List.generate(
                  _brokenYarnTypes.length,
                  (index) => SizedBox(
                    width: itemWidth,
                    child: TextForm(
                      label:
                          _brokenYarnTypes[index]['label']?.toString() ?? '-',
                      controller: _brokenYarnQtyControllers[index],
                      req: false,
                      isNumber: true,
                      isSorting: true,
                      handleChange: (_) {
                        _syncBrokenYarns();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
<<<<<<< HEAD
            ),
<<<<<<< HEAD
          ),
<<<<<<< HEAD
          Expanded(
            child: TextForm(
              label: 'Jumlah Panjang (M)',
              controller: _lengthController,
              req: false,
              isNumber: true,
              isSorting: true,
              handleChange: (value) {
                _handleChangeInput('length', value);
              },
            ),
          ),
          Expanded(
            child: TextForm(
              label: 'Jumlah Section (PCS)',
              controller: _sectionController,
              req: false,
              isNumber: true,
              isSorting: true,
              handleChange: (value) {
                _handleChangeInput('section', value);
              },
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xl')),
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
        ),
>>>>>>> e02e3ffb (fix: finish warping)
=======
=======
              ..._customBrokenYarns.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextForm(
                        label: 'Jenis Lainnya',
                        controller: item.labelController,
                        req: false,
                        handleChange: (_) {
                          _syncBrokenYarns();
                        },
                      ),
                    ),
                    Expanded(
                      child: TextForm(
                        label: 'Qty',
                        controller: item.qtyController,
                        req: false,
                        isNumber: true,
                        isSorting: true,
                        handleChange: (_) {
                          _syncBrokenYarns();
                          setState(() {});
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus jenis',
                      onPressed: () => _removeCustomBrokenYarn(index),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ].separatedBy(CustomTheme().hGap('lg')),
                );
              }),
              TextButton.icon(
                onPressed: _addCustomBrokenYarn,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Jenis'),
              ),
            ].separatedBy(CustomTheme().vGap('lg')),
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
          );
        },
>>>>>>> 64274789 (fix: selesai warping-shearing)
      ),
    );
  }
}
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)

class _CustomBrokenYarnEntry {
  final TextEditingController labelController;
  final TextEditingController qtyController;

  _CustomBrokenYarnEntry({
    String label = '',
    String qty = '',
  })  : labelController = TextEditingController(text: label),
        qtyController = TextEditingController(text: qty);

  void dispose() {
    labelController.dispose();
    qtyController.dispose();
  }
}
<<<<<<< HEAD
=======
>>>>>>> 5d1f483f (fix: warping, sizing)
=======
>>>>>>> 3562ec45 (fix: selesai warping - shearing)
