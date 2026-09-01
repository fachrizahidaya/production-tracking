// ignore_for_file: use_build_context_synchronously

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
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/show_select_dialog.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_greige_order.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

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

  @override
  void initState() {
    super.initState();

    processId = widget.processId?.toString();
    woData = Map<String, dynamic>.from(widget.data ?? {});
    _noteController.text = widget.form?['notes']?.toString() ?? '';

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

  @override
  void dispose() {
    widget.form?.clear();

    _noteController.dispose();
    _yarnQtyController.dispose();
    for (final controller in _lengthControllers) {
      controller.dispose();
    }
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
                      text: 'Info Greige Order',
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
                                title: 'Greige Order',
                                icon: Icons.assignment_outlined,
                                child: SelectForm(
                                  label: 'Greige Order',
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
                  label: 'Jumlah Benang (KG)',
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
                      ? 'Jumlah Beam'
                      : 'Jumlah Section',
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
      child: Column(
        children: List.generate(
          _lengthControllers.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextForm(
              label: 'Jumlah Panjang ${index + 1} (M)',
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
      ),
    );
  }
}
