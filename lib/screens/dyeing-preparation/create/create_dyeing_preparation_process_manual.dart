// ignore_for_file: use_build_context_synchronously

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:convert';
import 'dart:async';
import 'dart:io';

=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
import 'dart:convert';
import 'dart:async';
import 'dart:io';

>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/screens/dyeing-preparation/create/dyeing_preparation_form_section.dart';
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
<<<<<<< HEAD
=======
=======
import 'dart:convert';
import 'dart:async';
import 'dart:io';

>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/components/master/dialog/select_dialog.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/models/master/spk.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';
import 'package:textile_tracking/screens/dyeing-preparation/create/dyeing_preparation_form_section.dart';
<<<<<<< HEAD
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final TextEditingController _noteController = TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  late List<Map<String, dynamic>> allAttachments;
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
  final String baseUrl = dotenv.env['API_URL'] ?? '';
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
  late List<Map<String, dynamic>> allAttachments;
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
  final String baseUrl = dotenv.env['API_URL'] ?? '';
>>>>>>> 514dc398 (feat: persiapan dyeing)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
=======
  late List<Map<String, dynamic>> allAttachments;
>>>>>>> e467a136 (fix: attachment for dyeing preparation)

  bool _firstLoading = false;
  bool _isFetchingWorkOrder = false;
  List<dynamic> workOrderOption = [];
  Map<String, dynamic> woData = {};
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  List<Map<String, dynamic>> existingItems = [];
  List<Map<String, dynamic>> greigeItemOptions = [];
  String? greigeInfoMessage;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  String _baseCode(String? code) {
    if (code == null || code.isEmpty) return '';

    return code.split('-').first;
  }

  bool _isGreigeReady(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    return false;
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
          headers: {'Authorization': 'Bearer $token'},
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode != 200) {
          throw responseData['message'] ?? 'Gagal mengambil opsi greige item.';
        }

        optionCache[baseCode] = List<dynamic>.from(responseData['data'] ?? []);
      }

      final data = optionCache[baseCode] ?? [];

      options.addAll(
        data.map<Map<String, dynamic>>((rawOption) {
          final option = Map<String, dynamic>.from(rawOption);

          return {
            "work_order_item_id": item["id"],
            "spk_item_id": item["spk_item_id"],
            "source_item_id": item["item_id"],
            "source_item_code": item["item_code"],
            "source_item_name": item["item_name"],
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
        }),
      );
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
            "source_item_code": item["item_code"],
            "source_item_name": item["item_name"],
            "item_code": greigeItem["item_code"],
            "item_name": greigeItem["item_name"],
            "spk_no": null,

            "qty": item["qty"],
            "weight": item["weight"],

            // Sumber rumus dari Work Order
            "source_qty": item["qty"],
            "source_weight": item["weight"],

            "qty_tolerance": 0,
            "unit_id": item["unit"]?["id"] ?? 1,
            "weight_unit_id": item["weight_unit"]?["id"] ?? 2,
          },
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
          "source_item_code": item["item_code"],
          "source_item_name": item["item_name"],
          "item_code": greigeItem["item_code"],
          "item_name": greigeItem["item_name"],
          "spk_no": greige["greige_item_op_no"],

          // Nilai Qty Greige yang sedang digunakan
          "qty": greige["qty"] ?? item["qty"],

          // Berat Greige yang tersimpan
          "weight": greige["weight"] ?? item["weight"],

          // ==============================
          // SUMBER RUMUS DARI WORK ORDER
          // ==============================
          "source_qty": item["qty"],
          "source_weight": item["weight"],

          "qty_tolerance": greige["qty_tolerance"] ?? 0,
          "unit_id": greige["unit_id"] ?? 1,
          "weight_unit_id": greige["weight_unit_id"] ?? 2,
        };
      }).toList();
    }).toList();
  }
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
  List<Map<String, dynamic>> existingItems = [];
  List<Map<String, dynamic>> greigeItemOptions = [];
  String? greigeInfoMessage;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  String _baseCode(String? code) {
    if (code == null || code.isEmpty) return '';

    return code.split('-').first;
  }

  bool _isGreigeReady(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    return false;
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
          headers: {'Authorization': 'Bearer $token'},
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode != 200) {
          throw responseData['message'] ?? 'Gagal mengambil opsi greige item.';
        }

        optionCache[baseCode] = List<dynamic>.from(responseData['data'] ?? []);
      }

      final data = optionCache[baseCode] ?? [];

      options.addAll(
        data.map<Map<String, dynamic>>((rawOption) {
          final option = Map<String, dynamic>.from(rawOption);

          return {
            "work_order_item_id": item["id"],
            "spk_item_id": item["spk_item_id"],
            "source_item_id": item["item_id"],
            "source_item_code": item["item_code"],
            "source_item_name": item["item_name"],
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
        }),
      );
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
            "source_item_code": item["item_code"],
            "source_item_name": item["item_name"],
            "item_code": greigeItem["item_code"],
            "item_name": greigeItem["item_name"],
            "spk_no": null,

            "qty": item["qty"],
            "weight": item["weight"],

            // Sumber rumus dari Work Order
            "source_qty": item["qty"],
            "source_weight": item["weight"],

            "qty_tolerance": 0,
            "unit_id": item["unit"]?["id"] ?? 1,
            "weight_unit_id": item["weight_unit"]?["id"] ?? 2,
          },
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
          "source_item_code": item["item_code"],
          "source_item_name": item["item_name"],
          "item_code": greigeItem["item_code"],
          "item_name": greigeItem["item_name"],
          "spk_no": greige["greige_item_op_no"],

          // Nilai Qty Greige yang sedang digunakan
          "qty": greige["qty"] ?? item["qty"],

          // Berat Greige yang tersimpan
          "weight": greige["weight"] ?? item["weight"],

          // ==============================
          // SUMBER RUMUS DARI WORK ORDER
          // ==============================
          "source_qty": item["qty"],
          "source_weight": item["weight"],

          "qty_tolerance": greige["qty_tolerance"] ?? 0,
          "unit_id": greige["unit_id"] ?? 1,
          "weight_unit_id": greige["weight_unit_id"] ?? 2,
        };
      }).toList();
    }).toList();
  }
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
  List<Map<String, dynamic>> existingItems = [];
  List<Map<String, dynamic>> greigeItemOptions = [];
  String? greigeInfoMessage;
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  String _baseCode(String? code) {
    if (code == null || code.isEmpty) return '';

    return code.split('-').first;
  }

  bool _isGreigeReady(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    return false;
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
          "source_item_code": item["item_code"],
          "source_item_name": item["item_name"],
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
            "source_item_code": item["item_code"],
            "source_item_name": item["item_name"],
            "item_code": greigeItem["item_code"],
            "item_name": greigeItem["item_name"],
            "spk_no": null,

            "qty": item["qty"],
            "weight": item["weight"],

            // Sumber rumus dari Work Order
            "source_qty": item["qty"],
            "source_weight": item["weight"],

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
          "source_item_code": item["item_code"],
          "source_item_name": item["item_name"],
          "item_code": greigeItem["item_code"],
          "item_name": greigeItem["item_name"],
          "spk_no": greige["greige_item_op_no"],

          // Nilai Qty Greige yang sedang digunakan
          "qty": greige["qty"] ?? item["qty"],

          // Berat Greige yang tersimpan
          "weight": greige["weight"] ?? item["weight"],

          // ==============================
          // SUMBER RUMUS DARI WORK ORDER
          // ==============================
          "source_qty": item["qty"],
          "source_weight": item["weight"],

          "qty_tolerance": greige["qty_tolerance"] ?? 0,
          "unit_id": greige["unit_id"] ?? 1,
          "weight_unit_id": greige["weight_unit_id"] ?? 2,
        };
      }).toList();
    }).toList();
  }
>>>>>>> 514dc398 (feat: persiapan dyeing)

  @override
  void initState() {
    super.initState();

    if (widget.data != null && widget.data!.isNotEmpty) {
      woData = widget.data!;
    }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
    _noteController.text = widget.form?['notes']?.toString() ?? '';

    final existing = List<Map<String, dynamic>>.from(
      widget.form?['attachments'] ?? [],
    );

    allAttachments = [
      ...existing,
      {'is_add_button': true},
    ];

<<<<<<< HEAD
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkOrder();
      _hydrateInitialData();
    });
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Future<void> _hydrateInitialData() async {
    if (widget.data == null || widget.data!.isEmpty) return;

    setState(() {
      _firstLoading = true;
    });

    try {
      final data = widget.data!['id'] != null
          ? await _workOrderService.getFormInfo(widget.data!['id'])
          : widget.data!;
      final items = List<dynamic>.from(data['items'] ?? [])
          .map((rawItem) => Map<String, dynamic>.from(rawItem))
          .where((item) => _isGreigeReady(item['greige_ready']))
          .toList();
<<<<<<< HEAD
      final options = await _fetchGreigeItemOptions(items);

      setState(() {
        woData = data;
        greigeItemOptions = options;
        existingItems = _mapExistingItems(items, options);
        greigeInfoMessage = items.isEmpty
            ? 'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.'
            : null;
      });
    } catch (e) {
      setState(() {
        existingItems = [];
        greigeItemOptions = [];
        greigeInfoMessage =
            'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
    }
  }

=======
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkOrder();
      _hydrateInitialData();
    });
  }

<<<<<<< HEAD
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  Future<void> _hydrateInitialData() async {
    if (widget.data == null || widget.data!.isEmpty) return;

    setState(() {
      _firstLoading = true;
    });

    try {
<<<<<<< HEAD
      final items = List<dynamic>.from(widget.data!['items'] ?? []);
<<<<<<< HEAD
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
      final options = await _fetchGreigeItemOptions(items);

      setState(() {
        woData = data;
        greigeItemOptions = options;
        existingItems = _mapExistingItems(items, options);
        greigeInfoMessage = items.isEmpty
            ? 'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.'
            : null;
      });
    } catch (e) {
      setState(() {
        existingItems = [];
        greigeItemOptions = [];
        greigeInfoMessage =
            'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.';
=======
=======
      final data = widget.data!['id'] != null
          ? await _workOrderService.getFormInfo(widget.data!['id'])
          : widget.data!;
      final items = List<dynamic>.from(data['items'] ?? [])
          .map((rawItem) => Map<String, dynamic>.from(rawItem))
          .where((item) => _isGreigeReady(item['greige_ready']))
          .toList();
>>>>>>> 72a8ec95 (fix: persiapan dyeing buat ddan edit)
      final options = await _fetchGreigeItemOptions(items);

      setState(() {
        woData = data;
        greigeItemOptions = options;
        existingItems = _mapExistingItems(items, options);
        greigeInfoMessage = items.isEmpty
            ? 'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.'
            : null;
      });
    } catch (e) {
      setState(() {
<<<<<<< HEAD
        existingItems = _mapExistingItems(
          List<dynamic>.from(widget.data!['items'] ?? []),
          const [],
        );
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
=======
        existingItems = [];
        greigeItemOptions = [];
<<<<<<< HEAD
        greigeInfoMessage = 'Greige belum tersedia untuk item Work Order ini.';
>>>>>>> 72a8ec95 (fix: persiapan dyeing buat ddan edit)
=======
        greigeInfoMessage =
            'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.';
>>>>>>> 95e1119c (fix: button untuk persiapan dyeing)
      });
    } finally {
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
    }
  }

<<<<<<< HEAD
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
=======
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
>>>>>>> b70754b7 (feat: persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      final data = await _workOrderService.getFormInfo(id);

      final List<dynamic> items = List<dynamic>.from(data['items'] ?? []);

      if (items.isEmpty) {
        throw 'Item tidak ditemukan.';
      }

      final availableItems = items
          .map((rawItem) => Map<String, dynamic>.from(rawItem))
          .where((item) => _isGreigeReady(item['greige_ready']))
          .toList();

      final options = await _fetchGreigeItemOptions(availableItems);

      setState(() {
        woData = data;

        if (availableItems.isEmpty) {
          existingItems = [];
          greigeItemOptions = [];
          greigeInfoMessage =
              'Order Greige ${woData['items'][0]['order_greige']['og_no']} sudah selesai. Stok SAP belum ter-update WO bisa lanjut ke Persiapan Dyeing setelah stok greige mencukupi.';
<<<<<<< HEAD
<<<<<<< HEAD
        } else {
          greigeItemOptions = options;
          existingItems = _mapExistingItems(availableItems, options);
          greigeInfoMessage = null;
        }
=======
      await _workOrderService.getDataView(id);

      final data = _workOrderService.dataView;
=======
      final data = await _workOrderService.getFormInfo(id);
>>>>>>> 72a8ec95 (fix: persiapan dyeing buat ddan edit)

      final List<dynamic> items = List<dynamic>.from(data['items'] ?? []);

      if (items.isEmpty) {
        throw 'Item tidak ditemukan.';
      }

      final availableItems = items
          .map((rawItem) => Map<String, dynamic>.from(rawItem))
          .where((item) => _isGreigeReady(item['greige_ready']))
          .toList();

      final options = await _fetchGreigeItemOptions(availableItems);

      setState(() {
<<<<<<< HEAD
        woData = _workOrderService.dataView;
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
        woData = data;

<<<<<<< HEAD
        existingItems = _mapExistingItems(items);
>>>>>>> 514dc398 (feat: persiapan dyeing)
=======
        if (availableItems.isEmpty) {
          existingItems = [];
          greigeItemOptions = [];
          greigeInfoMessage =
              'Greige belum tersedia untuk item Work Order ini.';
=======
>>>>>>> 95e1119c (fix: button untuk persiapan dyeing)
        } else {
          greigeItemOptions = options;
          existingItems = _mapExistingItems(availableItems, options);
          greigeInfoMessage = null;
        }
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 514dc398 (feat: persiapan dyeing)
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
<<<<<<< HEAD
=======
      await _workOrderService.getDataView(id);

      final data = _workOrderService.dataView;
=======
      final data = await _workOrderService.getFormInfo(id);
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)

      final List<dynamic> items = List<dynamic>.from(data['items'] ?? []);

      if (items.isEmpty) {
        throw 'Item tidak ditemukan.';
      }

      final availableItems = items
          .map((rawItem) => Map<String, dynamic>.from(rawItem))
          .where((item) => _isGreigeReady(item['greige_ready']))
          .toList();

      final options = await _fetchGreigeItemOptions(availableItems);

      setState(() {
        woData = data;

        if (availableItems.isEmpty) {
          existingItems = [];
          greigeItemOptions = [];
          greigeInfoMessage =
              'Greige belum tersedia untuk item Work Order ini.';
=======
>>>>>>> 6578af90 (fix: button untuk persiapan dyeing)
        } else {
          greigeItemOptions = options;
          existingItems = _mapExistingItems(availableItems, options);
          greigeInfoMessage = null;
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
<<<<<<< HEAD
      setState(() {
        _firstLoading = false;
      });
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      if (mounted) {
        setState(() {
          _firstLoading = false;
        });
      }
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
      setState(() {
        _firstLoading = false;
      });
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> 514dc398 (feat: persiapan dyeing)
    }
  }

  void _selectWorkOrder() {
    if (_isFetchingWorkOrder) {
      showDialog(
        context: context,
        barrierDismissible: false,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        builder: (context) => const Center(child: CircularProgressIndicator()),
=======
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
        builder: (context) => const Center(child: CircularProgressIndicator()),
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
>>>>>>> b70754b7 (feat: persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
>>>>>>> 514dc398 (feat: persiapan dyeing)
            if (selected == null) {
              setState(() {
                widget.form?['wo_id'] = null;
                widget.form?['no_wo'] = '';
                woData = {};
                existingItems = [];
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                greigeItemOptions = [];
=======
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
                greigeItemOptions = [];
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> 514dc398 (feat: persiapan dyeing)
=======
                greigeItemOptions = [];
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
              });
              return;
            }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> 514dc398 (feat: persiapan dyeing)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
  void _handleChangeInput(String key, dynamic value) {
    setState(() {
      widget.form?[key] = value;
    });
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
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
<<<<<<< HEAD
  Future<void> _pickAttachments(ImageSource source) async {
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: source);
<<<<<<< HEAD
=======
  Future<void> _pickAttachments() async {
=======
  Future<void> _pickAttachments(ImageSource source) async {
>>>>>>> 04066211 (fix: attachment pick dari galeri untuk warping - persiapan dyeing)
=======
  Future<void> _pickAttachments() async {
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
    try {
      final picker = ImagePicker();

      final XFile? image = await picker.pickImage(
<<<<<<< HEAD
        source: source,
      );
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
        source: ImageSource.camera,
      );
>>>>>>> e467a136 (fix: attachment for dyeing preparation)

      if (image == null) return;

      final compressedFile = await compressImage(image.path);

      if (compressedFile == null) return;

      setState(() {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        allAttachments.removeWhere((e) => e['is_add_button'] == true);
=======
        allAttachments.removeWhere(
          (e) => e['is_add_button'] == true,
        );
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
        allAttachments.removeWhere((e) => e['is_add_button'] == true);
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
        allAttachments.removeWhere(
          (e) => e['is_add_button'] == true,
        );
>>>>>>> e467a136 (fix: attachment for dyeing preparation)

        final newFile = {
          'name': compressedFile.path.split('/').last,
          'path': compressedFile.path,
          'extension': compressedFile.path.split('.').last,
          'isNew': true,
        };

        allAttachments.add(newFile);

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        allAttachments.add({'is_add_button': true});

        widget.form?['attachments'] =
            allAttachments.where((e) => e['is_add_button'] != true).toList();
=======
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
        allAttachments.add({
          'is_add_button': true,
        });

        widget.form?['attachments'] = allAttachments
            .where(
              (e) => e['is_add_button'] != true,
            )
            .toList();
<<<<<<< HEAD
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
        allAttachments.add({'is_add_button': true});

        widget.form?['attachments'] =
            allAttachments.where((e) => e['is_add_button'] != true).toList();
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  void showImageDialog(BuildContext context, bool isNew, String filePath) {
=======
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
  void showImageDialog(
    BuildContext context,
    bool isNew,
    String filePath,
  ) {
<<<<<<< HEAD
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
  void showImageDialog(BuildContext context, bool isNew, String filePath) {
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  ? Image.file(File(filePath), fit: BoxFit.contain)
                  : Image.network(filePath, fit: BoxFit.contain),
=======
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                    ),
<<<<<<< HEAD
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
                  ? Image.file(File(filePath), fit: BoxFit.contain)
                  : Image.network(filePath, fit: BoxFit.contain),
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        await Future.delayed(const Duration(milliseconds: 200));
=======
        await Future.delayed(
          const Duration(milliseconds: 200),
        );
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
        await Future.delayed(const Duration(milliseconds: 200));
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
        await Future.delayed(
          const Duration(milliseconds: 200),
        );
>>>>>>> e467a136 (fix: attachment for dyeing preparation)

        if (!mounted) {
          completer.complete(false);
          return;
        }

        setState(() {
          allAttachments.remove(item);

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          widget.form?['attachments'] =
              allAttachments.where((e) => e['is_add_button'] != true).toList();
=======
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
          widget.form?['attachments'] = allAttachments
              .where(
                (e) => e['is_add_button'] != true,
              )
              .toList();
<<<<<<< HEAD
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
          widget.form?['attachments'] =
              allAttachments.where((e) => e['is_add_button'] != true).toList();
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
        });

        Navigator.pop(context);

        completer.complete(true);
      },
    );

    return completer.future;
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
=======
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
  @override
  void dispose() {
    widget.form?.clear();
    _isSubmitting.dispose();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    _noteController.dispose();
    _isLoading.dispose();
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
    _noteController.dispose();
    _isLoading.dispose();
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
    _noteController.dispose();
    _isLoading.dispose();
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          ? (woData.isNotEmpty ? woData : widget.data!)
=======
          ? widget.data!
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
          ? (woData.isNotEmpty ? woData : widget.data!)
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
          ? widget.data!
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
          ? (woData.isNotEmpty ? woData : widget.data!)
>>>>>>> 72a8ec95 (fix: persiapan dyeing buat ddan edit)
          : woData,
      handleSubmit: widget.handleSubmit ?? () async {},
      isSubmitting: _isSubmitting,
      selectWorkOrder: _selectWorkOrder,
      firstLoading: _firstLoading,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      existingItems: existingItems,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      itemOptions: greigeItemOptions.isEmpty ? null : greigeItemOptions,
      greigeInfoMessage: greigeInfoMessage,
      greigeReady: existingItems.isNotEmpty,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
      isEdit: false,
      disableWorkOrder: false,
      attachments: allAttachments,
      onAddAttachment: _pickAttachments,
      onDeleteAttachment: _handleDeleteAttachment,
      onPreviewImage: (isNew, filePath) {
        showImageDialog(context, isNew, filePath);
<<<<<<< HEAD
      },
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      existingItems: existingItems,
>>>>>>> 4281d8b4 (feat: persiapan dyeing)
=======
      greigeInfoMessage: greigeInfoMessage,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
      itemOptions: greigeItemOptions.isEmpty ? null : greigeItemOptions,
      greigeInfoMessage: greigeInfoMessage,
      greigeReady: existingItems.isNotEmpty,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
      isEdit: false,
      disableWorkOrder: false,
<<<<<<< HEAD
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
      attachments: allAttachments,
      onAddAttachment: _pickAttachments,
      onDeleteAttachment: _handleDeleteAttachment,
      onPreviewImage: (isNew, filePath) {
        showImageDialog(
          context,
          isNew,
          filePath,
        );
=======
>>>>>>> ae89df7c (fix: persiapan dyeing)
      },
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
      existingItems: existingItems,
>>>>>>> 514dc398 (feat: persiapan dyeing)
=======
      greigeInfoMessage: greigeInfoMessage,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
=======
      itemOptions: greigeItemOptions.isEmpty ? null : greigeItemOptions,
      greigeInfoMessage: greigeInfoMessage,
      greigeReady: existingItems.isNotEmpty,
      handleChangeInput: _handleChangeInput,
      note: _noteController,
      isEdit: false,
      disableWorkOrder: false,
<<<<<<< HEAD
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
=======
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
>>>>>>> e467a136 (fix: attachment for dyeing preparation)
    );
  }
}
