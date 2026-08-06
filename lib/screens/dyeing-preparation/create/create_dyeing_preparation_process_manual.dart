// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextEditingController _noteController = TextEditingController();

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  List<dynamic> workOrderOption = [];
  Map<String, dynamic> woData = {};
  List<Map<String, dynamic>> existingItems = [];
  List<Map<String, dynamic>> greigeItemOptions = [];
  String? greigeInfoMessage;

  int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);

    return null;
  }

  String _baseCode(String? code) {
    if (code == null || code.isEmpty) return '';

    return code.split('-').first;
  }

  Future<List<Map<String, dynamic>>> _fetchGreigeItemOptions(
    List<dynamic> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final options = <Map<String, dynamic>>[];
    final optionCache = <String, List<dynamic>>{};

    for (final rawItem in items) {
      final item = Map<String, dynamic>.from(rawItem);
      final baseCode = _baseCode(item['item_code']?.toString());

      if (baseCode.isEmpty) {
        continue;
      }

      if (!optionCache.containsKey(baseCode)) {
        final uri = Uri.parse('$baseUrl/item/option').replace(
          queryParameters: {
            'type': 'greige_item',
            'base_code': baseCode,
            'process': 'work_order',
          },
        );

        final response = await http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode != 200) {
          throw responseData['message'] ?? 'Gagal mengambil opsi greige item.';
        }

        optionCache[baseCode] = List<dynamic>.from(responseData['data'] ?? []);
      }

      final data = optionCache[baseCode] ?? [];

      options.addAll(data.map<Map<String, dynamic>>((rawOption) {
        final option = Map<String, dynamic>.from(rawOption);

        return {
          "work_order_item_id": item["id"],
          "spk_item_id": item["spk_item_id"],
          "source_item_id": item["item_id"],
          "item_id": option["value"],
          "item_code": option["code"],
          "item_name": option["label"],
          "spk_no": null,
          "qty": item["qty"],
          "weight": item["weight"],
          "qty_tolerance": 0,
          "unit_id": item["unit"]?["id"] ?? 1,
          "weight_unit_id": item["weight_unit"]?["id"] ?? 2,
        };
      }));
    }

    return options;
  }

  Map<String, dynamic> _resolveGreigeItem(
    Map<String, dynamic> item,
    List<Map<String, dynamic>> options,
    Map<String, dynamic>? greige,
  ) {
    final greigeItem = greige?["greige_item"] is Map
        ? Map<String, dynamic>.from(greige?["greige_item"])
        : <String, dynamic>{};

    final greigeItemId = greige?["greige_item_id"] ?? item["item_id"];
    final matchedOption = options.cast<Map<String, dynamic>?>().firstWhere(
          (option) =>
              option?["work_order_item_id"] == item["id"] &&
              option?["item_id"]?.toString() == greigeItemId?.toString(),
          orElse: () => null,
        );

    final fallbackOption = options.cast<Map<String, dynamic>?>().firstWhere(
          (option) => option?["work_order_item_id"] == item["id"],
          orElse: () => null,
        );

    final option = matchedOption ?? fallbackOption;

    return {
      "item_id": option?["item_id"] ?? greigeItemId,
      "item_code":
          option?["item_code"] ?? greigeItem["code"] ?? item["item_code"],
      "item_name":
          option?["item_name"] ?? greigeItem["name"] ?? item["item_name"],
    };
  }

  List<Map<String, dynamic>> _mapExistingItems(
    List<dynamic> items,
    List<Map<String, dynamic>> options,
  ) {
    return items.expand<Map<String, dynamic>>((e) {
      final item = Map<String, dynamic>.from(e);
      final greigeItems = List<dynamic>.from(item["greige_items"] ?? []);

      if (greigeItems.isEmpty) {
        final greigeItem = _resolveGreigeItem(item, options, null);

        return [
          {
            "id": null,
            "work_order_item_id": item["id"],
            "item_id": greigeItem["item_id"],
            "spk_item_id": item["spk_item_id"],
            "item_code": greigeItem["item_code"],
            "item_name": greigeItem["item_name"],
            "spk_no": null,
            "qty": item["qty"],
            "weight": item["weight"],
            "qty_tolerance": 0,
            "unit_id": item["unit"]?["id"] ?? 1,
            "weight_unit_id": item["weight_unit"]?["id"] ?? 2,
          }
        ];
      }

      return greigeItems.map<Map<String, dynamic>>((rawGreige) {
        final greige = Map<String, dynamic>.from(rawGreige);
        final greigeItem = _resolveGreigeItem(item, options, greige);

        return {
          "id": greige["id"],
          "work_order_item_id": item["id"],
          "item_id": greigeItem["item_id"],
          "spk_item_id": item["spk_item_id"],
          "item_code": greigeItem["item_code"],
          "item_name": greigeItem["item_name"],
          "spk_no": greige["greige_item_op_no"],
          "qty": greige["qty"] ?? item["qty"],
          "weight": greige["weight"] ?? item["weight"],
          "qty_tolerance": greige["qty_tolerance"] ?? 0,
          "unit_id": greige["unit_id"] ?? 1,
          "weight_unit_id": greige["weight_unit_id"] ?? 2,
        };
      });
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.data != null && widget.data!.isNotEmpty) {
      woData = widget.data!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkOrder();
      _hydrateInitialData();
    });
  }

  Future<void> _hydrateInitialData() async {
    if (widget.data == null || widget.data!.isEmpty) return;

    setState(() {
      _firstLoading = true;
    });

    try {
      final items = List<dynamic>.from(widget.data!['items'] ?? []);
      final options = await _fetchGreigeItemOptions(items);

      setState(() {
        greigeItemOptions = options;
        existingItems = _mapExistingItems(items, options);
      });
    } catch (e) {
      setState(() {
        existingItems = _mapExistingItems(
          List<dynamic>.from(widget.data!['items'] ?? []),
          const [],
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
    }
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

      final List<Map<String, dynamic>> availableItems = [];

      for (final rawItem in items) {
        final item = Map<String, dynamic>.from(rawItem);

        final spkItemId = _toInt(item['spk_item_id']);

        if (spkItemId == null) {
          continue;
        }

        final stock = await _spkService.checkStock(
          spkItemId: spkItemId,
        );

        final stockData = Map<String, dynamic>.from(
          stock['data'] ?? stock,
        );

        final bool available = stockData['available'] == true;

        final bool greigeAvailable = item['greige_available'] == true;

        if (available && greigeAvailable) {
          availableItems.add(item);
        }
      }

      final options = await _fetchGreigeItemOptions(availableItems);

      setState(() {
        woData = data;

        if (availableItems.isEmpty) {
          existingItems = [];
          greigeItemOptions = [];
          greigeInfoMessage = 'Masih diproses atau greige tidak tersedia.';
        } else {
          greigeItemOptions = options;
          existingItems = _mapExistingItems(availableItems, options);
          greigeInfoMessage = null;
        }
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
                greigeItemOptions = [];
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

  void _handleChangeInput(String key, dynamic value) {
    setState(() {
      widget.form?[key] = value;
    });
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
      itemOptions: greigeItemOptions.isEmpty ? null : greigeItemOptions,
      greigeInfoMessage: greigeInfoMessage,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
      isEdit: false,
      disableWorkOrder: false,
    );
  }
}
