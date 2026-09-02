// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

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
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

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
  final TextEditingController _yarnQtyController = TextEditingController();
  List<TextEditingController> _lengthControllers = [];
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _beamQtyController = TextEditingController();

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  List<dynamic> workOrderOption = [];
  Map<String, dynamic> woData = {};
  Map<String, dynamic> processData = {};
  String? processId;

  late List<Map<String, dynamic>> allAttachments;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    processId = widget.processId?.toString();
    woData = Map<String, dynamic>.from(widget.data ?? {});
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    final existing = List<Map<String, dynamic>>.from(
      widget.form?['attachments'] ?? [],
    );

    allAttachments = [
      ...existing,
      {'is_add_button': true},
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postInit();
    });
  }

  Future<void> _postInit() async {
    await _fetchWorkOrder();

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

  void _handleChangeInput(String field, dynamic value) {
    setState(() {
      widget.form?[field] = value;
    });
    widget.handleChangeInput?.call(field, value);
  }

  Future<void> _getWorkOrderView(dynamic id) async {
    await _greigeOrderService.getDataView(id);

    final data = _greigeOrderService.dataView;

    final int pasangQty =
        int.tryParse((data['pasang_qty'] ?? 1).toString()) ?? 1;

    setState(() {
      woData = data;

      // dispose controller lama
      for (final c in _lengthControllers) {
        c.dispose();
      }

      _lengthControllers = List.generate(
        pasangQty,
        (_) => TextEditingController(),
      );

      widget.form?['lengths'] = List.generate(pasangQty, (_) => '');
    });
  }

  Future<void> _getProcessView(dynamic id) async {
    setState(() => _firstLoading = true);

    try {
      await _warpingService.getDataView(context, id);

      final data = _warpingService.dataView['data'];
      final attachments = List<Map<String, dynamic>>.from(
        data['attachments'] ?? [],
      );

      // ambil jumlah form dari WO
      final int pasangQty =
          int.tryParse((woData['pasang_qty'] ?? 1).toString()) ?? 1;

      // length dari process
      final dynamic rawLength = data['length'];

      List<dynamic> lengths = [];

      if (rawLength is List) {
        lengths = rawLength;
      } else if (rawLength != null) {
        lengths = [rawLength];
      }

      // kalau belum ada length, tetap buat controller sebanyak pasang_qty
      if (lengths.isEmpty) {
        lengths = List.generate(pasangQty, (_) => '');
      }

      setState(() {
        processData = data;

        widget.form?['process_id'] = data['id']?.toString();
        widget.form?['machine_id'] = data['machine']['id'];
        widget.form?['warping_type'] = data['warping_type'];
        widget.form?['yarn_qty'] = data['yarn_qty'];
        widget.form?['beam_qty'] = data['beam_qty'];
        widget.form?['section'] = data['section'];
        widget.form?['order_greige_id'] = data['order_greige_id'];
        widget.form?['no_og'] =
            data['order_greige']?['og_no'] ?? widget.form?['no_og'];
        widget.form?['notes'] = data['notes']?.toString() ?? '';
        widget.form?['attachments'] = attachments;

        allAttachments = [
          ...attachments,
          {'is_add_button': true},
        ];

        // simpan list length ke form
        widget.form?['lengths'] =
            List.generate(lengths.length, (i) => lengths[i]);

        _yarnQtyController.text = data['yarn_qty']?.toString() ?? '';

        _beamQtyController.text = data['beam_qty']?.toString() ?? '';

        _sectionController.text = data['section']?.toString() ?? '';

        _noteController.text = data['notes']?.toString() ?? '';

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
      });
    } finally {
      setState(() => _firstLoading = false);
    }
  }

  void _selectWorkOrder() {
    showSelectDialog(
      context: context,
      title: 'Work Order',
      isFetching: _isFetchingWorkOrder,
      option: workOrderOption,
      selected: widget.form?['wo_id']?.toString() ?? '',
      handleChangeValue: (selected) async {
        final woId = selected['value']?.toString();
        final selectedProcessId = selected['warping_id']?.toString();

        setState(() {
          widget.form?['order_greige_id'] = woId;
          widget.form?['no_og'] = selected['label']?.toString() ?? '';
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

  Future<void> _pickAttachments() async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
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

  @override
  void dispose() {
    widget.form?.clear();

    _noteController.dispose();
    _yarnQtyController.dispose();
    for (final controller in _lengthControllers) {
      controller.dispose();
    }
    _beamQtyController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.form?['order_greige_id'] == null ||
            widget.form?['machine_id'] == null ||
            widget.form?['warping_type'] == null ||
            widget.form?['yarn_qty'] == null
        // ||
        // widget.form?['length'] == null
        // ||
        // widget.form?['section'] == null
        //  ||
        // widget.form?['beam_qty'] == null
        ;

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
                      text: 'Info Order Greige',
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
                                title: 'Order Greige',
                                icon: Icons.assignment_outlined,
                                child: SelectForm(
                                  label: 'Order Greige',
                                  onTap: _selectWorkOrder,
                                  selectedLabel: widget.form?['no_og'] ?? '',
                                  selectedValue: widget.form?['order_greige_id']
                                          ?.toString() ??
                                      '',
                                  required: true,
                                ),
                              ),
                              if (widget.form?['order_greige_id'] != null) ...[
                                _buildBeamWeightSection(),
                                _buildPanjangSection(),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextForm(
                  label: 'Qty Benang (KG)',
                  controller: _yarnQtyController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput('yarn_qty', value);
                  },
                ),
              ),
              Expanded(
                child: TextForm(
                  label: widget.form?['warping_type'] == 'single_warping'
                      ? 'Berapa Beam'
                      : 'Berapa Section',
                  controller: widget.form?['warping_type'] == 'single_warping'
                      ? _beamQtyController
                      : _sectionController,
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    _handleChangeInput(
                        widget.form?['warping_type'] == 'single_warping'
                            ? 'beam_qty'
                            : 'section',
                        value);
                  },
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ],
      ),
    );
  }

  Widget _buildPanjangSection() {
    return TemplateCard(
      title: 'Panjang',
      icon: Icons.rule,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 24.0;

          // 3 item dalam satu baris
          final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

          return Wrap(
            spacing: spacing,
            runSpacing: 16,
            children: List.generate(
              _lengthControllers.length,
              (index) => SizedBox(
                width: itemWidth,
                child: TextForm(
                  label: 'Panjang Pasang ${index + 1} (M)',
                  controller: _lengthControllers[index],
                  req: false,
                  isNumber: true,
                  isSorting: true,
                  handleChange: (value) {
                    widget.form?['lengths'][index] = value;
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
