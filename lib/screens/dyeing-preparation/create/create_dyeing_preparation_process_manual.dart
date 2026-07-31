// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/screens/dyeing-preparation/create/dyeing_preparation_form_section.dart';

class CreateDyeingPreparationProcessManual extends StatefulWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final Future<void> Function()? handleSubmit;

  const CreateDyeingPreparationProcessManual({
    super.key,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
  });

  @override
  State<CreateDyeingPreparationProcessManual> createState() =>
      _CreateDyeingPreparationProcessManualState();
}

class _CreateDyeingPreparationProcessManualState
    extends State<CreateDyeingPreparationProcessManual> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WorkOrderService _workOrderService = WorkOrderService();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  List<dynamic> workOrderOption = [];
  Map<String, dynamic> woData = {};

  @override
  void initState() {
    super.initState();

    if (widget.data != null && widget.data!.isNotEmpty) {
      woData = widget.data!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkOrder();
    });
  }

  Future<void> _fetchWorkOrder() async {
    setState(() {
      _isFetchingWorkOrder = true;
    });

    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    try {
      await service.fetchDyeingPreparationOptions();

      setState(() {
        workOrderOption = service.dataListOption;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    } finally {
      setState(() {
        _isFetchingWorkOrder = false;
      });
    }
  }

  Future<void> _getDataView(dynamic id) async {
    setState(() {
      _firstLoading = true;
    });

    try {
      await _workOrderService.getDataView(id);

      setState(() {
        woData = _workOrderService.dataView;
      });
    } finally {
      setState(() {
        _firstLoading = false;
      });
    }
  }

  void _selectWorkOrder() {
    if (_isFetchingWorkOrder) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SelectDialog(
          label: 'Work Order',
          options: workOrderOption,
          selected: widget.form?['wo_id']?.toString() ?? '',
          handleChangeValue: (selected) async {
            final woId = selected['value']?.toString();

            setState(() {
              widget.form?['wo_id'] = woId;
              widget.form?['no_wo'] = selected['label']?.toString();
            });

            if (woId != null && woId.isNotEmpty) {
              await _getDataView(woId);
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    widget.form?.clear();
    _isSubmitting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DyeingPreparationFormSection(
      id: widget.id,
      title: 'Buat Persiapan Dyeing',
      form: widget.form,
      formKey: _formKey,
      woData: widget.data != null && widget.data!.isNotEmpty
          ? widget.data!
          : woData,
      handleSubmit: widget.handleSubmit ?? () async {},
      isSubmitting: _isSubmitting,
      selectWorkOrder: _selectWorkOrder,
      firstLoading: _firstLoading,
    );
  }
}
