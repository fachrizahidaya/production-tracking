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
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

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

    setState(() {
      woData = _greigeOrderService.dataView;
    });
  }

  Future<void> _getProcessView(dynamic id) async {
    setState(() => _firstLoading = true);

    try {
      await _warpingService.getDataView(context, id);

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
    _lengthController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.form?['order_greige_id'] == null ||
        widget.form?['machine_id'] == null ||
        widget.form?['warping_type'] == null ||
        widget.form?['yarn_qty'] == null ||
        widget.form?['length'] == null ||
        widget.form?['section'] == null;

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
      child: Row(
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
      ),
    );
  }
}
