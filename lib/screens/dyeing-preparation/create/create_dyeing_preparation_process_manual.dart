// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/models/master/spk.dart';
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
  final SpkService _spkService = SpkService();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  List<dynamic> workOrderOption = [];
  Map<String, dynamic> woData = {};
  List<Map<String, dynamic>> existingItems = [];

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);

    return null;
  }

  List<Map<String, dynamic>> _mapExistingItems(List<dynamic> items) {
    return items.where((e) => e != null).map<Map<String, dynamic>>((e) {
      final item = Map<String, dynamic>.from(e);

      return {
        "item_id": item["item_id"],
        "spk_item_id": item["spk_item_id"],
        "item_code": item["item_code"] ?? "",
        "item_name": item["item_name"] ?? "",
        "spk_no": item["spk_no"] ?? "",
        "qty": item["qty"] ?? 0,
        "weight": item["weight"] ?? 0,
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.data != null && widget.data!.isNotEmpty) {
      woData = widget.data!;
      existingItems = _mapExistingItems(
        List<dynamic>.from(widget.data!['items'] ?? []),
      );
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

      final data = _workOrderService.dataView;

      final List<dynamic> items = List<dynamic>.from(data['items'] ?? []);

      if (items.isEmpty) {
        throw 'Item tidak ditemukan.';
      }

      if (items.isEmpty) {
        throw Exception('Work Order tidak memiliki item');
      }

      final firstItem = Map<String, dynamic>.from(items.first);

      final spkItemId = _toInt(firstItem['spk_item_id']);

      if (spkItemId == null) {
        throw 'Item Work Order tidak memiliki SPK item yang valid.';
      }

      final stock = await _spkService.checkStock(spkItemId: spkItemId);

      final stockData = Map<String, dynamic>.from(
        stock['data'] ?? stock,
      );

      if (stockData['available'] != true) {
        throw stockData['message']?.toString() ?? 'Stok greige tidak tersedia.';
      }

      final spkItemResponse = await _spkService.getSpkItem(spkItemId);
      final spkItem = Map<String, dynamic>.from(
        spkItemResponse['data'] ?? spkItemResponse,
      );

      if (spkItem['pipeline'] != null) {
        throw 'Greige sedang berada pada proses lain.';
      }

      setState(() {
        woData = data;

        existingItems = _mapExistingItems(items);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
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
            if (selected == null) {
              setState(() {
                widget.form?['wo_id'] = null;
                widget.form?['no_wo'] = '';
                woData = {};
                existingItems = [];
              });
              return;
            }

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
      existingItems: existingItems,
    );
  }
}
