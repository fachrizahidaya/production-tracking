// ignore_for_file: use_build_context_synchronously

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
import 'dart:convert';

>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
<<<<<<< HEAD
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
<<<<<<< HEAD
import 'package:textile_tracking/screens/dyeing-preparation/create/dyeing_preparation_form_section.dart';
=======
=======
=======
import 'dart:async';
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
import 'dart:convert';
import 'dart:io';

<<<<<<< HEAD
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
import 'package:flutter/foundation.dart';
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
=======
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
import 'package:textile_tracking/screens/dyeing-preparation/create/dyeing_preparation_form_section.dart';
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
import 'package:textile_tracking/screens/dyeing-preparation/create/dyeing_preparation_form_section.dart';
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
import 'package:textile_tracking/screens/dyeing-preparation/model/dyeing_preparation.dart';

class EditDyeingPreparationScreen extends StatefulWidget {
  final dynamic id;

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  const EditDyeingPreparationScreen({super.key, required this.id});
=======
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
  const EditDyeingPreparationScreen({
    super.key,
    required this.id,
  });
<<<<<<< HEAD
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
  const EditDyeingPreparationScreen({super.key, required this.id});
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)

  @override
  State<EditDyeingPreparationScreen> createState() =>
      _EditDyeingPreparationScreenState();
}

class _EditDyeingPreparationScreenState
    extends State<EditDyeingPreparationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);
  final TextEditingController _yarnQtyController = TextEditingController();
  final TextEditingController _warpingTypeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final String baseUrl = dotenv.env['API_URL'] ?? '';
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
  final String baseUrl = dotenv.env['API_URL'] ?? '';
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
  final String baseUrl = dotenv.env['API_URL'] ?? '';
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)

  bool _isLoading = true;
  bool _isFetchingMachine = false;
  String? _errorMessage;

  Map<String, dynamic> _data = {};
  final Map<String, dynamic> _form = {};
  List<dynamic> _machineOption = [];
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  final List<Map<String, dynamic>> _greigeForms = [];
  List<Map<String, dynamic>> existingItems = [];
  List<Map<String, dynamic>> itemOptions = [];
  Map<String, dynamic> woData = {};
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
  late List<Map<String, dynamic>> allAttachments;
  final ValueNotifier<bool> _attachmentLoading = ValueNotifier(false);

  void _syncAttachmentsToForm() {
<<<<<<< HEAD
<<<<<<< HEAD
    final attachments =
        allAttachments.where((e) => e['is_add_button'] != true).toList();

    _form['attachments'] = attachments;
    _form['attachment_ids'] = attachments
        .where((e) => e['isNew'] != true && e['id'] != null)
        .map((e) => e['id'])
        .toList();
  }
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
    final attachments = allAttachments
        .where(
          (e) => e['is_add_button'] != true,
        )
        .toList();
=======
    final attachments =
        allAttachments.where((e) => e['is_add_button'] != true).toList();
>>>>>>> ae89df7c (fix: persiapan dyeing)

    _form['attachments'] = attachments;
    _form['attachment_ids'] = attachments
        .where((e) => e['isNew'] != true && e['id'] != null)
        .map((e) => e['id'])
        .toList();
  }
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
    allAttachments = [
      {'is_add_button': true},
    ];

<<<<<<< HEAD
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
    _disposeGreigeForms();
    _isSubmitting.dispose();
    _attachmentLoading.dispose();
<<<<<<< HEAD
=======
    _isSubmitting.dispose();
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
    _isSubmitting.dispose();
>>>>>>> b70754b7 (feat: persiapan dyeing)
    _yarnQtyController.dispose();
    _warpingTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  String _baseCode(String? code) {
    if (code == null || code.isEmpty) return '';

    return code.split('-').first;
  }

  Map<String, dynamic> _spkItem(Map<String, dynamic> item) {
    return item["spk_item"] is Map
        ? Map<String, dynamic>.from(item["spk_item"])
        : <String, dynamic>{};
  }

  Map<String, dynamic> _spkProduct(Map<String, dynamic> item) {
    final spkItem = _spkItem(item);

    return spkItem["item"] is Map
        ? Map<String, dynamic>.from(spkItem["item"])
        : <String, dynamic>{};
  }

  dynamic _workOrderItemId(Map<String, dynamic> item) {
    return item["item_id"] ?? _spkProduct(item)["id"];
  }

  String _workOrderItemCode(Map<String, dynamic> item) {
    return item["item_code"]?.toString() ??
        _spkProduct(item)["code"]?.toString() ??
        '';
  }

  String _workOrderItemName(Map<String, dynamic> item) {
    return item["item_name"]?.toString() ??
        _spkProduct(item)["name"]?.toString() ??
        '';
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
      final baseCode = _baseCode(_workOrderItemCode(item));

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          headers: {'Authorization': 'Bearer $token'},
=======
          headers: {
            'Authorization': 'Bearer $token',
          },
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
          headers: {'Authorization': 'Bearer $token'},
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
          headers: {
            'Authorization': 'Bearer $token',
          },
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode != 200) {
          throw responseData['message'] ?? 'Gagal mengambil opsi greige item.';
        }

        optionCache[baseCode] = List<dynamic>.from(responseData['data'] ?? []);
      }

      final data = optionCache[baseCode] ?? [];

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      options.addAll(
        data.map<Map<String, dynamic>>((rawOption) {
          final option = Map<String, dynamic>.from(rawOption);

          return {
            "work_order_item_id": item["id"],
            "spk_item_id": item["spk_item_id"],
            "source_item_id": _workOrderItemId(item),
            "item_id": option["value"],
            "item_code": option["code"],
            "item_name": option["label"],
            "spk_no": null,
            "qty": item["qty"],
            "weight": item["weight"],
            "qty_tolerance": 0,
            "unit_id": item["unit_id"] ?? item["unit"]?["id"] ?? 1,
            "weight_unit_id":
                item["weight_unit_id"] ?? item["weight_unit"]?["id"] ?? 2,
          };
        }),
      );
=======
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
      options.addAll(data.map<Map<String, dynamic>>((rawOption) {
        final option = Map<String, dynamic>.from(rawOption);

        return {
          "work_order_item_id": item["id"],
          "spk_item_id": item["spk_item_id"],
          "source_item_id": _workOrderItemId(item),
          "item_id": option["value"],
          "item_code": option["code"],
          "item_name": option["label"],
          "spk_no": null,
          "qty": item["qty"],
          "weight": item["weight"],
          "qty_tolerance": 0,
          "unit_id": item["unit_id"] ?? item["unit"]?["id"] ?? 1,
          "weight_unit_id":
              item["weight_unit_id"] ?? item["weight_unit"]?["id"] ?? 2,
        };
      }));
<<<<<<< HEAD
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
      options.addAll(
        data.map<Map<String, dynamic>>((rawOption) {
          final option = Map<String, dynamic>.from(rawOption);

          return {
            "work_order_item_id": item["id"],
            "spk_item_id": item["spk_item_id"],
            "source_item_id": _workOrderItemId(item),
            "item_id": option["value"],
            "item_code": option["code"],
            "item_name": option["label"],
            "spk_no": null,
            "qty": item["qty"],
            "weight": item["weight"],
            "qty_tolerance": 0,
            "unit_id": item["unit_id"] ?? item["unit"]?["id"] ?? 1,
            "weight_unit_id":
                item["weight_unit_id"] ?? item["weight_unit"]?["id"] ?? 2,
          };
        }),
      );
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
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

    final greigeItemId = greige?["greige_item_id"] ?? _workOrderItemId(item);
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
      "item_code": option?["item_code"] ??
          greigeItem["code"] ??
          _workOrderItemCode(item),
      "item_name": option?["item_name"] ??
          greigeItem["name"] ??
          _workOrderItemName(item),
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
        return const <Map<String, dynamic>>[];
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          "source_qty": item["source_qty"] ?? item["qty"],
          "source_weight": item["source_weight"] ?? item["weight"],
=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
          "source_qty": item["source_qty"] ?? item["qty"],
          "source_weight": item["source_weight"] ?? item["weight"],
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
          "qty_tolerance": greige["qty_tolerance"] ?? 0,
          "unit_id": greige["unit_id"] ?? 1,
          "weight_unit_id": greige["weight_unit_id"] ?? 2,
        };
      });
    }).toList();
  }

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> ae89df7c (fix: persiapan dyeing)
      final service = Provider.of<DyeingPreparationService>(
        context,
        listen: false,
      );
<<<<<<< HEAD
      await service.fetchPreparationDetail(context, widget.id);
=======
      final service =
          Provider.of<DyeingPreparationService>(context, listen: false);
<<<<<<< HEAD
      await service.getDataView(context, widget.id);
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
=======
>>>>>>> ae89df7c (fix: persiapan dyeing)
      await service.fetchPreparationDetail(context, widget.id);
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
      final service =
          Provider.of<DyeingPreparationService>(context, listen: false);
      await service.getDataView(context, widget.id);
>>>>>>> b70754b7 (feat: persiapan dyeing)

      final response = service.dataView;
      final detail = response['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(response['data'])
          : Map<String, dynamic>.from(response);

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      woData = Map<String, dynamic>.from(detail["work_orders"] ?? {});
=======
      final machine = _mapValue(detail['machine']);
      final orderGreige = _mapValue(detail['order_greige']);
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      woData = Map<String, dynamic>.from(
        detail["work_orders"] ?? {},
      );
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
      woData = Map<String, dynamic>.from(detail["work_orders"] ?? {});
>>>>>>> ae89df7c (fix: persiapan dyeing)
=======
      final machine = _mapValue(detail['machine']);
      final orderGreige = _mapValue(detail['order_greige']);
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
      woData = Map<String, dynamic>.from(
        detail["work_orders"] ?? {},
      );
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)

      _form
        ..clear()
        ..addAll({
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          "wo_id": detail["wo_id"],
          "no_wo": woData["wo_no"] ?? detail["wo_no"] ?? "",
          "notes": detail["notes"] ?? "",
          "attachments": List<Map<String, dynamic>>.from(
            detail["attachments"] ?? [],
          ),
          "attachment_ids": List<Map<String, dynamic>>.from(
            detail["attachments"] ?? [],
          ).map((e) => e["id"]).where((id) => id != null).toList(),
<<<<<<< HEAD
        });

      allAttachments = [
        ...List<Map<String, dynamic>>.from(detail["attachments"] ?? []),
        {'is_add_button': true},
      ];
      _syncAttachmentsToForm();

      final workOrderItems = List<dynamic>.from(woData["items"] ?? []);
      final options = await _fetchGreigeItemOptions(workOrderItems);

      existingItems = _mapExistingItems(workOrderItems, options);
      itemOptions = options;

=======
          'machine_id': detail['machine_id']?.toString(),
          'yarn_qty': detail['yarn_qty']?.toString() ?? '',
          'order_greige_id': detail['order_greige_id']?.toString(),
          'no_greige_order': orderGreige['og_no']?.toString() ?? '',

          // tambahkan ini
          'warping_type': detail['warping_type']?.toString() ?? '',
          'notes': detail['notes']?.toString() ?? '',
=======
          "wo_id": detail["wo_id"],
          "no_wo": woData["wo_no"] ?? detail["wo_no"] ?? "",
          "notes": detail["notes"] ?? "",
<<<<<<< HEAD
          "items": List<Map<String, dynamic>>.from(
            detail["items"] ?? [],
          ),
>>>>>>> 0225cb3d (feat: edit persiapan dyeing)
        });

>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
        });

      allAttachments = [
        ...List<Map<String, dynamic>>.from(detail["attachments"] ?? []),
        {'is_add_button': true},
      ];
      _syncAttachmentsToForm();

      final workOrderItems = List<dynamic>.from(woData["items"] ?? []);
      final options = await _fetchGreigeItemOptions(workOrderItems);

      existingItems = _mapExistingItems(workOrderItems, options);
      itemOptions = options;

>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
          'machine_id': detail['machine_id']?.toString(),
          'yarn_qty': detail['yarn_qty']?.toString() ?? '',
          'order_greige_id': detail['order_greige_id']?.toString(),
          'no_greige_order': orderGreige['og_no']?.toString() ?? '',

          // tambahkan ini
          'warping_type': detail['warping_type']?.toString() ?? '',
          'notes': detail['notes']?.toString() ?? '',
=======
          "wo_id": detail["wo_id"],
          "no_wo": woData["wo_no"] ?? detail["wo_no"] ?? "",
          "notes": detail["notes"] ?? "",
<<<<<<< HEAD
          "items": List<Map<String, dynamic>>.from(
            detail["items"] ?? [],
          ),
>>>>>>> 0435f750 (feat: edit persiapan dyeing)
        });

>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
        });

      final workOrderItems = List<dynamic>.from(woData["items"] ?? []);
      final options = await _fetchGreigeItemOptions(workOrderItems);

      existingItems = _mapExistingItems(workOrderItems, options);
      itemOptions = options;

>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
      _yarnQtyController.text = detail['yarn_qty']?.toString() ?? '';
      _warpingTypeController.text = detail['warping_type']?.toString() ?? '';

      _notesController.text = detail['notes']?.toString() ?? '';

      setState(() {
        _data = detail;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleChangeInput(String key, dynamic value) {
    setState(() {
      _form[key] = value;
    });
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
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
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
<<<<<<< HEAD
=======
  Future<void> _pickAttachments() async {
=======
  Future<void> _pickAttachments(ImageSource source) async {
>>>>>>> 04066211 (fix: attachment pick dari galeri untuk warping - persiapan dyeing)
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
      );
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
>>>>>>> ae89df7c (fix: persiapan dyeing)

      if (image == null) return;

      final compressedFile = await compressImage(image.path);

      if (compressedFile == null) return;

      setState(() {
<<<<<<< HEAD
<<<<<<< HEAD
        allAttachments.removeWhere((e) => e['is_add_button'] == true);
=======
        allAttachments.removeWhere(
          (e) => e['is_add_button'] == true,
        );
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
        allAttachments.removeWhere((e) => e['is_add_button'] == true);
>>>>>>> ae89df7c (fix: persiapan dyeing)

        allAttachments.add({
          'name': compressedFile.path.split('/').last,
          'path': compressedFile.path,
          'extension': compressedFile.path.split('.').last,
          'isNew': true,
        });

<<<<<<< HEAD
<<<<<<< HEAD
        allAttachments.add({'is_add_button': true});
=======
        allAttachments.add({
          'is_add_button': true,
        });
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
        allAttachments.add({'is_add_button': true});
>>>>>>> ae89df7c (fix: persiapan dyeing)

        _syncAttachmentsToForm();
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
  void showImageDialog(BuildContext context, bool isNew, String filePath) {
=======
  void showImageDialog(
    BuildContext context,
    bool isNew,
    String filePath,
  ) {
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
  void showImageDialog(BuildContext context, bool isNew, String filePath) {
>>>>>>> ae89df7c (fix: persiapan dyeing)
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
                  ? Image.file(File(filePath), fit: BoxFit.contain)
                  : Image.network(filePath, fit: BoxFit.contain),
=======
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      filePath,
                      fit: BoxFit.contain,
                    ),
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
                  ? Image.file(File(filePath), fit: BoxFit.contain)
                  : Image.network(filePath, fit: BoxFit.contain),
>>>>>>> ae89df7c (fix: persiapan dyeing)
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
      isLoading: _attachmentLoading,
      title: 'Hapus Lampiran',
      message: 'Apakah Anda yakin ingin menghapus lampiran ini?',
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
<<<<<<< HEAD
<<<<<<< HEAD
        await Future.delayed(const Duration(milliseconds: 200));
=======
        await Future.delayed(
          const Duration(milliseconds: 200),
        );
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
        await Future.delayed(const Duration(milliseconds: 200));
>>>>>>> ae89df7c (fix: persiapan dyeing)

        if (!mounted) {
          completer.complete(false);
          return;
        }

        setState(() {
          allAttachments.remove(item);

          _syncAttachmentsToForm();
        });

        Navigator.pop(context);

        completer.complete(true);
      },
    );

    return completer.future;
  }

  bool get _isFormInvalid {
    return _form['wo_id'] == null || _form['wo_id'].toString().isEmpty;
=======
  bool get _isFormInvalid {
<<<<<<< HEAD
    return (_form['machine_id'] == null ||
            _form['machine_id'].toString().isEmpty) ||
        (_form['yarn_qty'] == null || _form['yarn_qty'].toString().isEmpty);
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
    return _form['wo_id'] == null || _form['wo_id'].toString().isEmpty;
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
  bool get _isFormInvalid {
<<<<<<< HEAD
    return (_form['machine_id'] == null ||
            _form['machine_id'].toString().isEmpty) ||
        (_form['yarn_qty'] == null || _form['yarn_qty'].toString().isEmpty);
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
    return _form['wo_id'] == null || _form['wo_id'].toString().isEmpty;
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  }

  Future<void> _handleSubmit() async {
    if (_isFormInvalid) return;

    final dyeingPreparation = DyeingPreparation(
      woId: int.tryParse(_form['wo_id']?.toString() ?? ''),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      items: _form['items'] ?? [],
      notes: _form['notes']?.toString(),
      attachments: _form['attachments'],
      attachmentIds: _form['attachment_ids'],
<<<<<<< HEAD
=======
      items: _form['items'] ?? [],
      notes: _form['notes']?.toString(),
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
    );

    try {
      final message = await Provider.of<DyeingPreparationService>(
        context,
        listen: false,
      ).updatePreparation(
        context,
        widget.id.toString(),
        dyeingPreparation,
        _isSubmitting,
      );
=======
=======
      items: _form['items'] ?? [],
      notes: _form['notes']?.toString(),
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
    );

    try {
=======
    );

    try {
>>>>>>> b70754b7 (feat: persiapan dyeing)
      final message = await Provider.of<DyeingPreparationService>(context,
              listen: false)
          .updateItem(
              context, widget.id.toString(), dyeingPreparation, _isSubmitting);
<<<<<<< HEAD
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
    );

    try {
      final message = await Provider.of<DyeingPreparationService>(
        context,
        listen: false,
      ).updatePreparation(
        context,
        widget.id.toString(),
        dyeingPreparation,
        _isSubmitting,
      );
>>>>>>> 5ac5af63 (fix: persiapan dyeing buat ddan edit)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)

      await showAlertDialog(
        context: context,
        title: 'Persiapan Dyeing Diubah',
        message: message,
      );

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      if (!mounted) return;

      // keluar dari Edit
      Navigator.pop(context, true);

      // keluar dari Detail
      Navigator.pop(context, true);
=======
      if (mounted) {
        Navigator.pop(context, true);
      }
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
      if (!mounted) return;

      // keluar dari Edit
      Navigator.pop(context, true);

      // keluar dari Detail
      Navigator.pop(context, true);
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
      if (mounted) {
        Navigator.pop(context, true);
      }
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
      if (!mounted) return;

// keluar dari Edit
      Navigator.pop(context, true);

// keluar dari Detail
      Navigator.pop(context, true);
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
    } catch (e) {
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
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return DyeingPreparationFormSection(
      id: widget.id,
      title: 'Edit Persiapan Dyeing',
      form: _form,
      formKey: _formKey,
      woData: woData,
      handleSubmit: _handleSubmit,
      isSubmitting: _isSubmitting,
      selectWorkOrder: () {},
      firstLoading: _isLoading,
      existingItems: existingItems,
      itemOptions: itemOptions,
      greigeInfoMessage: null,
      greigeReady: existingItems.isNotEmpty,
      handleChangeInput: _handleChangeInput,
      note: _notesController,
      isEdit: true,
      disableWorkOrder: true,
      attachments: allAttachments,
      onAddAttachment: _pickAttachments,
      onDeleteAttachment: _handleDeleteAttachment,
      onPreviewImage: (isNew, filePath) {
        showImageDialog(context, isNew, filePath);
=======
  Future<void> _handleCancel() async {
    showConfirmationDialog(
      context: context,
      isLoading: _isSubmitting,
      onConfirm: () async {
        Navigator.pop(context);
        Navigator.pop(context);
>>>>>>> b70754b7 (feat: persiapan dyeing)
      },
      title: 'Batal Edit Proses Persiapan Dyeing',
      message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
      buttonBackground: CustomTheme().buttonColor('danger'),
    );
  }

<<<<<<< HEAD
  void _disposeGreigeForms() {
    for (final item in _greigeForms) {
      (item['spk_no'] as TextEditingController?)?.dispose();
      (item['qty'] as TextEditingController?)?.dispose();
      (item['weight'] as TextEditingController?)?.dispose();
    }
    _greigeForms.clear();
=======
  Future<void> _handleCancel() async {
    showConfirmationDialog(
      context: context,
      isLoading: _isSubmitting,
      onConfirm: () async {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      title: 'Batal Edit Proses Persiapan Dyeing',
      message: 'Anda yakin ingin kembali? Semua perubahan tidak disimpan',
      buttonBackground: CustomTheme().buttonColor('danger'),
    );
  }

=======
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
  @override
  Widget build(BuildContext context) {
    return DyeingPreparationFormSection(
      id: widget.id,
      title: 'Edit Persiapan Dyeing',
      form: _form,
      formKey: _formKey,
      woData: woData,
      handleSubmit: _handleSubmit,
      isSubmitting: _isSubmitting,
      selectWorkOrder: () {},
      firstLoading: _isLoading,
      existingItems: existingItems,
      itemOptions: itemOptions,
      greigeInfoMessage: null,
      greigeReady: existingItems.isNotEmpty,
      handleChangeInput: _handleChangeInput,
      note: _notesController,
      isEdit: true,
      disableWorkOrder: true,
      attachments: allAttachments,
      onAddAttachment: _pickAttachments,
      onDeleteAttachment: _handleDeleteAttachment,
      onPreviewImage: (isNew, filePath) {
        showImageDialog(context, isNew, filePath);
      },
    );
  }

<<<<<<< HEAD
=======
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  @override
  Widget build(BuildContext context) {
    return DyeingPreparationFormSection(
      id: widget.id,
      title: 'Edit Persiapan Dyeing',
      form: _form,
      formKey: _formKey,
      woData: woData,
      handleSubmit: _handleSubmit,
      isSubmitting: _isSubmitting,
      selectWorkOrder: () {},
      firstLoading: _isLoading,
      existingItems: existingItems,
      itemOptions: itemOptions,
      greigeInfoMessage: null,
      handleChangeInput: _handleChangeInput,
      note: _notesController,
      isEdit: true,
      disableWorkOrder: true,
    );
  }

<<<<<<< HEAD
>>>>>>> b70754b7 (feat: persiapan dyeing)
  Widget _buildSummaryCard() {
    final orderGreige = _mapValue(_data['order_greige']);

    return TemplateCard(
      title: 'Informasi Persiapan Dyeing',
      icon: Icons.assignment_outlined,
      child: Column(
        children: [
          _InfoLine('No. Persiapan Dyeing', _display(_data['warping_no'])),
          // _InfoLine('Status', _display(_data['status'])),
          // _InfoLine('Greige Order', _display(orderGreige['og_no'])),
        ].separatedBy(Divider(height: 18, color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildGreigeCard() {
    return TemplateCard(
      title: 'Greige Order',
      icon: Icons.assessment_outlined,
      child: SelectForm(
        label: 'Greige Order',
        onTap: () {},
        selectedLabel: _form['no_greige_order']?.toString() ?? '',
        selectedValue: _form['order_greige_id']?.toString() ?? '',
        required: true,
        isDisabled: true,
      ),
    );
  }

  Widget _buildYarnCard() {
    return TemplateCard(
      title: 'Benang',
      icon: Icons.join_inner_outlined,
      child: TextForm(
        label: 'Jumlah Benang (KG)',
        controller: _yarnQtyController,
        req: false,
        isNumber: true,
        isSorting: true,
        handleChange: (value) => _handleChangeInput('yarn_qty', value),
      ),
    );
  }

  Widget _buildAdditionalCard() {
    return Column(
      children: [
        NoteEditor(
          controller: _notesController,
          form: _form,
          formKey: 'notes',
          label: 'Catatan',
          onChanged: (value) {
            _handleChangeInput('notes', value);
          },
        ),
      ],
    );
  }

  Widget _buildSubmitSection() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSubmitting,
      builder: (context, isSubmitting, _) {
        return Row(
          children: [
            Expanded(
              child: CancelButton(
                label: 'Batal',
                onPressed: () => Navigator.pop(context),
                customHeight: 50.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FormButton(
                label: 'Simpan',
                isLoading: isSubmitting,
                isDisabled: _isFormInvalid,
                customHeight: 50.0,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        );
      },
    );
<<<<<<< HEAD
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  void _disposeGreigeForms() {
    for (final item in _greigeForms) {
      (item['spk_no'] as TextEditingController?)?.dispose();
      (item['qty'] as TextEditingController?)?.dispose();
      (item['weight'] as TextEditingController?)?.dispose();
    }
    _greigeForms.clear();
<<<<<<< HEAD
>>>>>>> b35f25c0 (feat: edit persiapan dyeing)
=======
>>>>>>> b70754b7 (feat: persiapan dyeing)
=======
>>>>>>> 4369aaa7 (feat: edit persiapan dyeing)
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: CustomTheme().fontSize('md'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ),
      ],
    );
  }
}

Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

String _display(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';
  return value.toString();
}
