// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/form/text_form_grade.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/screens/update/process/sorting_grade_a_source.dart';
import 'package:textile_tracking/helpers/util/extract_semi_finished.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_item_semi_finished.dart';

class SortingSection extends StatefulWidget {
  final Map<String, dynamic> form;

  final List? itemGradeOption;
  final List? itemTypeOption;

  final processData;
  final finishedItemGrb;
  final finishedItem;
  final woData;
  final bool isInitializing;
  final onQtyWarning;

  const SortingSection(
      {super.key,
      required this.form,
      required this.itemGradeOption,
      required this.itemTypeOption,
      this.processData,
      this.finishedItemGrb,
      this.finishedItem,
      this.woData,
      this.isInitializing = false,
      this.onQtyWarning});

  @override
  State<SortingSection> createState() => _SortingSectionState();
}

class _SortingSectionState extends State<SortingSection> {
  num _gradeAInput(int itemIndex) {
    if (itemIndex < 0 || itemIndex >= _items.length) return 0;
    final grades = _items[itemIndex]['grades'] ?? [];
    num total = 0;
    for (final grade in grades) {
      if ((grade['code'] ?? '').toString().toUpperCase() == 'A') {
        total += num.tryParse(grade['qty'].toString()) ?? 0;
      }
    }
    return total;
  }

  num? _maxGradeASourceQty(int itemIndex) {
    if (itemIndex < 0 || itemIndex >= _items.length) return null;

    final woItems = widget.processData?['work_orders']?['items'];
    if (woItems is! List) return null;

    final item = _items[itemIndex];
    for (final raw in woItems) {
      if (raw is! Map) continue;
      if (raw['id']?.toString() != item['wo_item_id']?.toString()) continue;

      final totalWoQty = _parseQty(raw['qty']);
      if (totalWoQty <= 0) return null;

      return (totalWoQty - _gradeAInput(itemIndex)).clamp(0, totalWoQty);
    }

    return null;
  }

  dynamic get _currentWoId {
    final workOrder = widget.processData?['work_orders'];
    if (workOrder is Map && workOrder['id'] != null) return workOrder['id'];
    return widget.form['wo_id'] ?? widget.woData?['id'];
  }

  final Map<int, num> _absorbedQty = {};
  final Map<int, bool> _sourceQtyExceeded = {};
  final Map<String, TextEditingController> _gradeControllers = {};
  final Map<String, TextEditingController> _repairControllers = {};
  late List<Map<String, dynamic>> _items;
  List itemGradeOption = [];

  bool _isFetchingGrade = false;

  @override
  void initState() {
    super.initState();

    _items = [];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await _handleFetchItemGrade();

      await _initializeFormFromApi();
    });
  }

  TextEditingController _getGradeController(
    int itemIndex,
    int gradeIndex,
    dynamic value,
  ) {
    final key = '${itemIndex}_$gradeIndex';

    if (!_gradeControllers.containsKey(key)) {
      _gradeControllers[key] = TextEditingController(
        text: formatNumber(value).toString(),
      );
    }

    return _gradeControllers[key]!;
  }

  TextEditingController _getRepairController(
    int itemIndex,
    String key,
    dynamic value,
  ) {
    final mapKey = '${itemIndex}_$key';

    if (!_repairControllers.containsKey(mapKey)) {
      _repairControllers[mapKey] = TextEditingController(
        text: formatNumber(value).toString(),
      );
    }

    return _repairControllers[mapKey]!;
  }

  Future<void> _handleFetchItemGrade() async {
    setState(() {
      _isFetchingGrade = true;
    });

    final service = Provider.of<OptionItemGradeService>(
      context,
      listen: false,
    );

    try {
      await service.fetchOptions();

      final data = service.dataListOption;

      setState(() {
        itemGradeOption = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
    } finally {
      setState(() {
        _isFetchingGrade = false;
      });
    }
  }

  List<Map<String, dynamic>> mapSemiFinishedByBaseColor({
    required List<dynamic> baseCodes,
    required List<dynamic> colorCodes,
    List<dynamic> variantCodes = const [],
    required List<Map<String, dynamic>> options,
  }) {
    final List<Map<String, dynamic>> result = [];

    for (int i = 0; i < baseCodes.length; i++) {
      final baseCode = baseCodes[i].toString();

      final colorCode = i < colorCodes.length ? colorCodes[i].toString() : '';

      final variantCode =
          i < variantCodes.length ? variantCodes[i].toString() : '';

      Map<String, dynamic>? matched;

      for (final option in options) {
        final code = option['code']?.toString() ?? '';

        final parts = code.split('-');

        final optionBaseCode = parts.isNotEmpty ? parts.first : '';

        final optionColorCode = parts.isNotEmpty ? parts.last : '';

        final optionVariantCode = extractVariantCode(code);

        final sameVariant =
            variantCode.isEmpty || optionVariantCode == variantCode;

        if (optionBaseCode == baseCode &&
            optionColorCode == colorCode &&
            sameVariant) {
          matched = option;
          break;
        }
      }

      if (matched != null) {
        result.add(Map<String, dynamic>.from(matched));
      }
    }

    return result;
  }

  /*
|--------------------------------------------------------------------------
| INIT FROM API
|--------------------------------------------------------------------------
*/

  Future<void> _initializeFormFromApi() async {
    final currentItems = widget.form['items'];

    final hasValidItems = currentItems is List &&
        currentItems.isNotEmpty &&
        currentItems.any(
          (e) => e is Map && (e['grades'] != null || e['item_id'] != null),
        );

    if (hasValidItems) {
      _items = List<Map<String, dynamic>>.from(
        currentItems.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      /*
|--------------------------------------------------------------------------
| SYNC EXISTING DATA
|--------------------------------------------------------------------------
*/

      _syncFormItems();

      widget.form['grades'] =
          _items.expand((item) => item['grades'] ?? []).toList();

      if (mounted) {
        setState(() {});
      }

      _validateAllSortingQty();

      return;
    }

    final grades = widget.processData['grades'] ?? [];

    final woItems = widget.processData['work_orders']?['items'] ?? [];

    final Map<dynamic, Map<String, dynamic>> groupedItems = {};
    final Map<dynamic, String> spkNoMap = {
      for (final woItem in woItems)
        woItem['id']: woItem['spk_no']?.toString() ?? '-',
    };

    /*
|--------------------------------------------------------------------------
| EXISTING DATA
|--------------------------------------------------------------------------
*/

    for (final grade in grades) {
      final gradeItems = grade['items'] ?? [];

      final itemGrade = grade['item_grade'];

      for (final item in gradeItems) {
        final itemId = item['item_id'];
        final itemKey = '${item['wo_item_id']}_${item['item_id']}';

        if (!groupedItems.containsKey(itemKey)) {
          groupedItems[itemKey] = {
            'wo_item_id': item['wo_item_id'],
            'spk_no': spkNoMap[item['wo_item_id']],
            'item_id': item['item_id'],
            'finished_product': item['finished_product'],
            'semifinished_product': item['semifinished_product'],
            'grades': [],
            'defects': [],
          };
        }

        if ((itemGrade?['code'] ?? '').toString().toUpperCase() == 'A') {
          final transfersIn = item['transfers_in'];
          if (transfersIn is List) {
            groupedItems[itemKey]!['transfers_in'] = transfersIn
                .whereType<Map>()
                .map((transfer) => Map<String, dynamic>.from(transfer))
                .toList();
          }
          final transfersOut = item['transfers_out'];
          if (transfersOut is List) {
            groupedItems[itemKey]!['transfers_out'] = transfersOut
                .whereType<Map>()
                .map((transfer) => Map<String, dynamic>.from(transfer))
                .toList();
          }
        }

        groupedItems[itemKey]!['grades'].add({
          'item_grade_id': itemGrade['id'],
          'name': itemGrade['name'],
          'code': itemGrade['code'],
          'spk_no': spkNoMap[item['wo_item_id']],
          'qty': item['qty'] ?? 0,
          'source_qty': item['qty'] ?? 0,
          'available_qty': item['available_qty'],
          'notes': grade['notes'],
          'semifinished_product_id': item['semifinished_product_id'],
          'semifinished_product': item['semifinished_product'],
          'finished_product': item['finished_product'],
          'spraying': item['spraying'] ?? 0,
          'rework_long_hemming': item['rework_long_hemming'] ?? 0,
          'combing': item['combing'] ?? 0,
        });

        final defects = item['defects'] ?? [];

        for (final defect in defects) {
          groupedItems[itemKey]!['defects'].add({
            'defect_type_id': defect['type']['id'],
            'name': defect['type']['name'],
            'qty': defect['qty'] ?? 0,
          });
        }
      }
    }

    /*
|--------------------------------------------------------------------------
| FIRST CREATE
|--------------------------------------------------------------------------
*/

    if (groupedItems.isEmpty && woItems.isNotEmpty) {
      final semiFinishedService = Provider.of<OptionItemSemiFinishedService>(
        context,
        listen: false,
      );

      final params = extractSemiFinishedParams(
        woItems,
      );

      /// FETCH GRADE A
      await semiFinishedService.fetchOptions(
        isInitialLoad: true,
        process: 'packing',
        baseCodes: params['base_codes'] ?? [],
        colorCodes: params['color_codes'] ?? [],
        variantCodes: params['variant_codes'] ?? [],
      );

      final List<Map<String, dynamic>> semiFinishedItemsGradeA =
          List<Map<String, dynamic>>.from(
        semiFinishedService.dataListOption.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      final mappedGradeAItems = mapSemiFinishedByBaseColor(
        baseCodes: params['base_codes'] ?? [],
        colorCodes: params['color_codes'] ?? [],
        variantCodes: params['variant_codes'] ?? [],
        options: semiFinishedItemsGradeA,
      );

      /// FETCH GRADE B
      await semiFinishedService.fetchOptions(
        isInitialLoad: true,
        process: 'sorting',
        baseCodes: params['base_codes'] ?? [],
        colorCodes: ['GRB'],
        variantCodes: params['variant_codes'] ?? [],
      );

      final List<Map<String, dynamic>> semiFinishedItemsGradeB =
          List<Map<String, dynamic>>.from(
        semiFinishedService.dataListOption.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      final mappedGradeBItems = mapSemiFinishedByBaseColor(
        baseCodes: params['base_codes'] ?? [],
        colorCodes: List.generate(
          (params['base_codes'] ?? []).length,
          (_) => 'GRB',
        ),
        variantCodes: params['variant_codes'] ?? [],
        options: semiFinishedItemsGradeB,
      );

      final gradeAOption = itemGradeOption.firstWhere(
        (e) => (e['label'] ?? '').toString().toLowerCase() == 'grade a',
        orElse: () => {
          'value': 1,
          'label': 'Grade A',
        },
      );

      final gradeBOption = itemGradeOption.firstWhere(
        (e) => (e['label'] ?? '').toString().toLowerCase() == 'grade b',
        orElse: () => {
          'value': 2,
          'label': 'Grade B',
        },
      );

      final gradeBSOption = itemGradeOption.firstWhere(
        (e) {
          final label = (e['label'] ?? '').toString().toLowerCase();

          return label == 'grade bs' || label == 'bs';
        },
        orElse: () => {
          'value': 3,
          'label': 'Grade BS',
        },
      );

      for (int i = 0; i < woItems.length; i++) {
        final woItem = woItems[i];

        final itemCode = woItem['item_code']?.toString() ?? '';

        /// ambil base code sebelum "-"
        final baseCode = itemCode.split('-').first;

        Map<String, dynamic>? gradeAItem;
        Map<String, dynamic>? gradeBItem;

        if (i < mappedGradeAItems.length) {
          gradeAItem = mappedGradeAItems[i];
        }

        if (i < mappedGradeBItems.length) {
          gradeBItem = mappedGradeBItems[i];
        }

        final itemKey = woItem['greige_item_id'] ?? woItem['id'];

        groupedItems[itemKey] = {
          'wo_item_id': woItem['id'],
          'spk_no': woItem['spk_no'],
          'item_id': woItem['greige_item_id'],
          'finished_product': {
            'id': woItem['greige_item_id'],
            'code': woItem['item_code'],
            'name': woItem['item_name'],
          },
          'semifinished_product': {
            'id': woItem['greige_item_id'],
            'code': woItem['item_code'],
            'name': woItem['item_name'],
          },
          'grades': [
            /*
|--------------------------------------------------------------------------
| GRADE A
|--------------------------------------------------------------------------
*/
            {
              'item_grade_id': gradeAOption['value'],
              'name': 'Grade A',
              'code': 'A',
              'spk_no': woItem['spk_no'],
              'qty': 0,
              'notes': null,
              'semifinished_product_id': gradeAItem?['value'],
              'semifinished_product': gradeAItem != null
                  ? {
                      'id': gradeAItem['value'],
                      'code': gradeAItem['code'],
                      'name': gradeAItem['label'],
                    }
                  : null,
              'finished_product': {
                'id': woItem['greige_item_id'],
                'code': woItem['item_code'],
                'name': woItem['item_name'],
              },
              'spraying': 0,
              'rework_long_hemming': 0,
              'combing': 0,
            },

            /*
|--------------------------------------------------------------------------
| GRADE B
|--------------------------------------------------------------------------
*/
            {
              'item_grade_id': gradeBOption['value'],
              'name': 'Grade B',
              'code': 'B',
              'qty': 0,
              'notes': null,
              'semifinished_product_id': gradeBItem?['value'],
              'semifinished_product': gradeBItem != null
                  ? {
                      'id': gradeBItem['value'],
                      'code': gradeBItem['code'],
                      'name': gradeBItem['label'],
                    }
                  : null,
              'finished_product': {
                'id': woItem['greige_item_id'],
                'code': woItem['item_code'],
                'name': woItem['item_name'],
              },
              'spraying': 0,
              'rework_long_hemming': 0,
              'combing': 0,
            },

            /*
|--------------------------------------------------------------------------
| GRADE BS
|--------------------------------------------------------------------------
*/
            {
              'item_grade_id': gradeBSOption['value'],
              'name': 'BS',
              'code': 'BS',
              'qty': 0,
              'notes': null,
              'semifinished_product_id': null,
              'semifinished_product': null,
              'finished_product': {
                'id': woItem['greige_item_id'],
                'code': woItem['item_code'],
                'name': woItem['item_name'],
              },
              'spraying': 0,
              'rework_long_hemming': 0,
              'combing': 0,
            },
          ],
          'defects': [],
        };
      }
    }

    _items = groupedItems.values.toList();

    for (final item in _items) {
      final grades = List<Map<String, dynamic>>.from(
        item['grades'] ?? [],
      );

      bool hasA = grades.any(
        (g) => (g['code'] ?? '') == 'A',
      );

      bool hasB = grades.any(
        (g) => (g['code'] ?? '') == 'B',
      );

      bool hasBS = grades.any(
        (g) => (g['code'] ?? '') == 'BS',
      );

      if (!hasA) {
        grades.add({
          'item_grade_id': 1,
          'name': 'Grade A',
          'code': 'A',
          'qty': 0,
        });
      }

      if (!hasB) {
        grades.add({
          'item_grade_id': 2,
          'name': 'Grade B',
          'code': 'B',
          'qty': 0,
        });
      }

      if (!hasBS) {
        grades.add({
          'item_grade_id': 3,
          'name': 'BS',
          'code': 'BS',
          'qty': 0,
        });
      }

      grades.sort((a, b) {
        final order = {
          'A': 0,
          'B': 1,
          'BS': 2,
        };

        return (order[a['code']] ?? 99).compareTo(order[b['code']] ?? 99);
      });

      item['grades'] = grades;
    }

    _syncFormItems();

    widget.form['grades'] =
        _items.expand((item) => item['grades'] ?? []).toList();

    if (mounted) {
      setState(() {});
    }

    _validateAllSortingQty();
  }

  /*
|--------------------------------------------------------------------------
| HELPERS
|--------------------------------------------------------------------------
*/

  void _setAbsorbedRows(int itemIndex, List<Map<String, dynamic>> rows) {
    if (itemIndex < 0 || itemIndex >= _items.length) return;
    _items[itemIndex]['absorbed_work_orders'] = rows;
    _syncFormItems();
    if (mounted) setState(() {});
    _validateAllSortingQty();
  }

  void _syncFormItems() {
    widget.form['items'] = List<Map<String, dynamic>>.from(_items);

    widget.form['grades'] =
        _items.expand((item) => item['grades'] ?? []).toList();
    widget.form['grade_a_transfers'] = _buildGradeATransfers();
  }

  List<Map<String, dynamic>> _buildGradeATransfers() {
    final transfers = <Map<String, dynamic>>[];

    for (final item in _items) {
      final rows = item['absorbed_work_orders'];
      if (rows is! List) continue;

      for (final row in rows) {
        if (row is! Map) continue;
        final fromSortingId = row['sorting_id'] ?? row['from_sorting_id'];
        if (fromSortingId == null) continue;

        transfers.add({
          'from_sorting_id': _transferId(fromSortingId),
          'item_id': _transferId(row['item_id']),
          'qty': row['qty'] ?? 0,
        });
      }
    }

    return transfers;
  }

  dynamic _transferId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? value;
  }

  void _setSourceQtyExceeded(int itemIndex, bool exceeded) {
    _sourceQtyExceeded[itemIndex] = exceeded;
  }

  List<Map<String, dynamic>> _gradeATransfers(int itemIndex) {
    if (itemIndex < 0 || itemIndex >= _items.length) return [];
    final item = _items[itemIndex];
    if (item.containsKey('absorbed_work_orders')) {
      final saved = item['absorbed_work_orders'];
      if (saved is List) {
        return saved
            .whereType<Map>()
            .map((row) => Map<String, dynamic>.from(row))
            .toList();
      }
    }
    final transfers = item['transfers_in'];
    if (transfers is! List) return [];
    return transfers
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  dynamic _gradeAItemId(int itemIndex) {
    if (itemIndex < 0 || itemIndex >= _items.length) return null;
    final item = _items[itemIndex];
    final grades = item['grades'];
    if (grades is List) {
      for (final grade in grades) {
        if (grade is! Map) continue;
        if ((grade['code'] ?? '').toString().toUpperCase() != 'A') continue;
        return item['item_id'] ??
            grade['item_id'] ??
            grade['semifinished_product_id'];
      }
    }
    return item['item_id'];
  }

  double parseSafe(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }

  void _recalculateGradeBS(
    int itemIndex,
  ) {
    final item = _items[itemIndex];

    final defects = item['defects'] ?? [];

    int total = 0;

    for (final defect in defects) {
      total += (num.tryParse(
                defect['qty'].toString(),
              ) ??
              0)
          .toInt();
    }

    final grades = item['grades'] ?? [];

    final bsIndex = grades.indexWhere(
      (e) => (e['code'] ?? '').toString().toUpperCase() == 'BS',
    );

    if (bsIndex != -1) {
      grades[bsIndex]['qty'] = total;

      final controller = _getGradeController(
        itemIndex,
        bsIndex,
        total,
      );

      if (controller.text != total.toString()) {
        controller.text = total.toString();
      }
    }

    _syncFormItems();

    if (mounted) {
      setState(() {});
    }

    _validateAllSortingQty();
  }

  @override
  void didUpdateWidget(
    covariant SortingSection oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    final oldItems = oldWidget.processData['items'] ?? [];
    final newItems = widget.processData['items'] ?? [];

    final oldGrades = oldWidget.processData['grades'] ?? [];
    final newGrades = widget.processData['grades'] ?? [];

    final shouldInitialize = (oldItems.isEmpty && newItems.isNotEmpty) ||
        (oldGrades.isEmpty && newGrades.isNotEmpty);

    if (shouldInitialize) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        await _initializeFormFromApi();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _gradeControllers.values) {
      controller.dispose();
    }

    for (final controller in _repairControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return 0;
    }

    return double.tryParse(
          stringValue.replaceAll(',', '.'),
        ) ??
        0;
  }

  String? _validateSortingQty(int itemIndex) {
    if (itemIndex >= _items.length) {
      return null;
    }

    final item = _items[itemIndex];

    final woItems = widget.processData['work_orders']?['items'];

    if (woItems is! List || woItems.isEmpty) {
      return null;
    }

    final woItemId = item['wo_item_id'];

    Map<String, dynamic>? woItem;

    for (final raw in woItems) {
      if (raw is! Map) continue;

      if (raw['id'].toString() == woItemId?.toString()) {
        woItem = Map<String, dynamic>.from(raw);
        break;
      }
    }

    if (woItem == null) {
      return null;
    }

    final referenceQty = _parseQty(woItem['qty']);

    if (referenceQty <= 0) {
      return null;
    }

    final grades = item['grades'] ?? [];

    double gradeA = 0;
    double gradeB = 0;
    double gradeBS = 0;

    for (final grade in grades) {
      if (grade is! Map) continue;
      final code = (grade['code'] ?? '').toString().toUpperCase();
      final qty = _parseQty(grade['qty']);

      if (code == 'A') {
        gradeA += _summaryGradeA(item, grade, itemIndex);
      } else if (code == 'B') {
        gradeB += qty;
      } else if (code == 'BS') {
        gradeBS += qty;
      }
    }

    final repair = grades.isEmpty
        ? 0.0
        : _parseQty(grades[0]['spraying']) +
            _parseQty(grades[0]['rework_long_hemming']) +
            _parseQty(grades[0]['combing']);
    final totalSorting = gradeA + gradeB + gradeBS + repair;

    final lowerLimit = referenceQty * 0.90;
    final upperLimit = referenceQty * 1.10;

    if (totalSorting < lowerLimit || totalSorting > upperLimit) {
      final differencePercent =
          ((totalSorting - referenceQty) / referenceQty) * 100;

      return 'Total hasil sortir ${totalSorting < referenceQty ? 'kurang' : 'lebih'} '
          '${differencePercent.abs().toStringAsFixed(2)}% '
          '(Batas: ${formatNumber(lowerLimit)} – '
          '${formatNumber(upperLimit)})';
    }

    return null;
  }

  void _validateAllSortingQty() {
    String? warning;

    for (int i = 0; i < _items.length; i++) {
      final itemWarning = _validateSortingQty(i);

      if (itemWarning != null) {
        warning = itemWarning;
        break;
      }
    }

    final sourceExceeded = _sourceQtyExceeded.values.any((value) => value);

    widget.onQtyWarning?.call(
      warning != null || sourceExceeded,
    );
  }

  double _parseQty(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toDouble();
    }

    final valueString = value.toString().trim();

    if (valueString.isEmpty) {
      return 0;
    }

    return double.tryParse(
          valueString.replaceAll(',', ''),
        ) ??
        0;
  }

  /*
|--------------------------------------------------------------------------
| BUILD
|--------------------------------------------------------------------------
*/

  @override
  Widget build(BuildContext context) {
    final items = _items;

    if (items.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultTabController(
      length: items.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              final itemIndex = tabController.index;
              String? sortingWarning;
              for (int i = 0; i < items.length; i++) {
                sortingWarning = _validateSortingQty(i);
                if (sortingWarning != null) break;
              }
              return Column(
                children: [
                  if (sortingWarning != null) ...[
                    _buildQtyWarning(sortingWarning),
                    CustomTheme().vGap('xl'),
                  ],
                  _buildGlobalSummary(),
                  const SizedBox(height: 16),
                  KeyedSubtree(
                    key: const ValueKey('sorting-edit-body'),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: TabBar(
                              isScrollable: true,
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              indicatorColor: Colors.white,
                              indicator: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              tabAlignment: TabAlignment.start,
                              tabs: [
                                for (int i = 0; i < items.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: Tab(
                                      text: 'Item ${i + 1}',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        _buildItemCard(itemIndex),
                      ].separatedBy(CustomTheme().vGap('xl')),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /*
|--------------------------------------------------------------------------
| ITEM CARD
|--------------------------------------------------------------------------
*/

  Widget _buildItemCard(
    int itemIndex,
  ) {
    final item = _items[itemIndex];

    final grades = item['grades'] ?? [];
    final qtyWarning = _validateSortingQty(itemIndex);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.5,
          color: CustomTheme().colors('text-primary').withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (qtyWarning != null) ...[
            _buildQtyWarning(qtyWarning),
            const SizedBox(height: 16),
          ],
          KeyedSubtree(
            key: ValueKey('sorting-item-fields-$itemIndex'),
            child: Column(
              children: [
          /*
      |--------------------------------------------------------------------------
      | GRADES
      |--------------------------------------------------------------------------
      */

          TemplateCard(
            title: 'Grade',
            icon: Icons.grade_outlined,
            child: Column(
              children: [
                for (int i = 0; i < grades.length; i++)
                  _buildGradeCard(
                    itemIndex,
                    i,
                  ),
              ].separatedBy(
                SizedBox(height: 12),
              ),
            ),
          ),
          SortingGradeASourceSection(
            key: ValueKey('grade-a-source-$itemIndex'),
            initialTransfers: _gradeATransfers(itemIndex),
            itemId: _gradeAItemId(itemIndex),
            excludeWoId: _currentWoId,
            sortingId: widget.processData?['id'],
            gradeAInput: _gradeAInput(itemIndex),
            maxTakenQty: _maxGradeASourceQty(itemIndex),
            onTotalChanged: (total) {
              setState(() => _absorbedQty[itemIndex] = total);
            },
            onRowsChanged: (rows) => _setAbsorbedRows(itemIndex, rows),
            onExceededChanged: (exceeded) =>
                _setSourceQtyExceeded(itemIndex, exceeded),
          ),

          /*
      |--------------------------------------------------------------------------
      | PERBAIKAN
      |--------------------------------------------------------------------------
      */

          TemplateCard(
            title: 'Perbaikan',
            icon: Icons.build_outlined,
            child: Row(
              children: [
                _buildRepairInput(
                  itemIndex,
                  'spraying',
                  'Semprotan',
                ),
                _buildRepairInput(
                  itemIndex,
                  'rework_long_hemming',
                  'Permak Long Hemming',
                ),
                _buildRepairInput(
                  itemIndex,
                  'combing',
                  'Sisiran',
                ),
              ].separatedBy(
                SizedBox(width: 12),
              ),
            ),
          ),

          /*
      |--------------------------------------------------------------------------
      | DEFECTS
      |--------------------------------------------------------------------------
      */

          _buildDefectsCard(
            itemIndex,
          ),

          /*
      |--------------------------------------------------------------------------
      | SUMMARY
      |--------------------------------------------------------------------------
      */

          _buildSummary(
            itemIndex,
          ),
              ].separatedBy(
                const SizedBox(height: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
|--------------------------------------------------------------------------
| GRADE CARD
|--------------------------------------------------------------------------
*/

  Widget _buildGradeCard(
    int itemIndex,
    int gradeIndex,
  ) {
    final item = _items[itemIndex];

    final grade = _items[itemIndex]['grades'][gradeIndex];

    final isBS = (grade['code'] ?? '').toString().toUpperCase() == 'BS';

    final items = _items ?? [];

    String getSpkNo(Map<String, dynamic> item) {
      return item['spk_no']?.toString() ?? '-';
    }

    final transferOutNote = _transferOutNote(item, grade);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
        children: [
          /*
|--------------------------------------------------------------------------
| GRADE LABEL
|--------------------------------------------------------------------------
*/
          Expanded(
            flex: 1,
            child: Text(
              grade['code'] ?? '-',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /*
|--------------------------------------------------------------------------
| PRODUCT INFO
|--------------------------------------------------------------------------
*/
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (grade['code'] == 'A')
                  Text(
                    getSpkNo(item),
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isBS
                  ? [
                      Text(
                        'Perhitungan otomatis dari total Tipe BS',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]
                  : grade['code'] == 'B' &&
                          grade['semifinished_product']?['code'] == null
                      ? [
                          Text(
                            'Material code belum tersedia',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ]
                      : [
                          Text(
                            grade['semifinished_product']?['code'] ??
                                grade['finished_product']?['code'] ??
                                '-',
                          ),
                          Text(
                            grade['semifinished_product']?['name'] ??
                                grade['finished_product']?['name'] ??
                                '-',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
            ),
          ),

          /*
|--------------------------------------------------------------------------
| QTY
|--------------------------------------------------------------------------
*/
          Expanded(
            flex: 2,
            child: TextFormGrade(
              label: 'Qty',
              isDisabled: isBS,
              initialValue: '${grade['qty'] ?? 0}',
              controller: _getGradeController(
                itemIndex,
                gradeIndex,
                grade['qty'] ?? 0,
              ),
              onChanged: (value) {
                grade['qty'] = num.tryParse(
                      value.toString(),
                    ) ??
                    0;

                _syncFormItems();

                setState(() {});

                _validateAllSortingQty();
              },
            ),
          ),
        ],
          ),
          if (grade['code'] == 'A' && transferOutNote != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(flex: 4),
                Expanded(
                  flex: 2,
                  child: transferOutNote,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget? _transferOutNote(Map item, Map grade) {
    final out = _transferSummary(item['transfers_out'], 'to_wo_no');
    final incoming = _transferSummary(item['transfers_in'], 'from_wo_no');
    if (out == null && incoming == null) return null;

    const black = TextStyle(color: Colors.black);
    const blackBold = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
    const redBold = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w700,
    );
    final lines = <Widget>[];

    if (out != null) {
      lines.add(
        _qtyTakenLine(
          amount: '-${formatNumber(out.$1)}',
          amountStyle: redBold,
          conjunction: ' untuk ',
          woNos: out.$2,
          labelStyle: black,
        ),
      );
    }

    if (incoming != null) {
      lines.add(
        _qtyTakenLine(
          amount: '+${formatNumber(incoming.$1)}',
          amountStyle: blackBold,
          conjunction: ' dari ',
          woNos: incoming.$2,
          labelStyle: black,
        ),
      );
    }

    final total =
        parseSafe(grade['qty']) - (out?.$1 ?? 0) + (incoming?.$1 ?? 0);
    lines.add(
      Text(
        'Total: ${formatNumber(total)}',
        textAlign: TextAlign.right,
        style: blackBold,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: lines.separatedBy(const SizedBox(height: 4)).toList(),
    );
  }

  (double, String)? _transferSummary(dynamic rows, String woKey) {
    if (rows is! List) return null;
    final transfers = rows.whereType<Map>().toList();
    if (transfers.isEmpty) return null;

    var total = 0.0;
    final woNos = <String>[];
    for (final row in transfers) {
      total += parseSafe(row['qty']);
      final woNo = (row[woKey] ?? row['wo_no'])?.toString() ?? '';
      if (woNo.isNotEmpty) woNos.add(woNo);
    }

    return (total, woNos.join(', '));
  }

  Widget _qtyTakenLine({
    required String amount,
    required TextStyle amountStyle,
    required String conjunction,
    required String woNos,
    required TextStyle labelStyle,
  }) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
        children: [
          TextSpan(
            text: 'Qty diambil ',
            style: labelStyle,
          ),
          TextSpan(
            text: amount,
            style: amountStyle,
          ),
          if (woNos.isNotEmpty) ...[
            TextSpan(
              text: conjunction,
              style: labelStyle,
            ),
            TextSpan(
              text: woNos,
              style: labelStyle,
            ),
          ],
        ],
      ),
      textAlign: TextAlign.right,
    );
  }

  /*
|--------------------------------------------------------------------------
| REPAIR INPUT
|--------------------------------------------------------------------------
*/

  Widget _buildRepairInput(
    int itemIndex,
    String key,
    String label,
  ) {
    final grades = _items[itemIndex]['grades'];

    if (grades.isEmpty) {
      return SizedBox();
    }

    final grade = grades[0];

    return Expanded(
      child: TextForm(
        label: label,
        isNumber: true,
        controller: _getRepairController(
          itemIndex,
          key,
          grade[key] ?? 0,
        ),
        initialValue: '${grade[key] ?? 0}',
        handleChange: (value) {
          setState(() {
            for (final g in grades) {
              g[key] = num.tryParse(value.toString()) ?? 0;
            }
          });

          _syncFormItems();

          _validateAllSortingQty();
        },
      ),
    );
  }

  /*
|--------------------------------------------------------------------------
| DEFECTS
|--------------------------------------------------------------------------
*/

  Widget _buildDefectsCard(
    int itemIndex,
  ) {
    final item = _items[itemIndex];

    final defects = item['defects'] ?? [];

    return TemplateCard(
      title: 'Tipe BS',
      icon: Icons.warning_amber_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (defects.isNotEmpty)
            SizedBox(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: defects.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return _buildDefectItem(
                    itemIndex,
                    index,
                  );
                },
              ),
            ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showAddDefectDialog(
              itemIndex,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
              child: Center(
                child: Text(
                  '+ Tambah Tipe BS',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefectItem(
    int itemIndex,
    int defectIndex,
  ) {
    final defects = _items[itemIndex]['defects'] ?? [];

    if (defectIndex >= defects.length) {
      return const SizedBox();
    }

    final defect = defects[defectIndex];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8,
        ),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                defect['name'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                formatNumber(defect['qty']),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _showEditDefectDialog(
                  itemIndex,
                  defectIndex,
                ),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.form['items'][itemIndex]['defects']
                        .removeAt(defectIndex);

                    _recalculateGradeBS(
                      itemIndex,
                    );
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
|--------------------------------------------------------------------------
| ADD DEFECT
|--------------------------------------------------------------------------
*/

  void _showAddDefectDialog(
    int itemIndex,
  ) {
    final item = _items[itemIndex];

    item['defects'] ??= [];

    final List defects = item['defects'];

    final selectedIds =
        defects.map((e) => e['defect_type_id'].toString()).toList();

    showDialog(
      context: context,
      builder: (_) {
        final TextEditingController searchController = TextEditingController();

        List availableDefects = (widget.itemTypeOption ?? [])
            .where(
              (e) => !selectedIds.contains(
                e['id'].toString(),
              ),
            )
            .toList();

        List filteredDefects = List.from(availableDefects);

        return StatefulBuilder(
          builder: (context, setState) {
            void runSearch(String value) {
              setState(() {
                filteredDefects = availableDefects.where((e) {
                  final keyword = value.toLowerCase().trim();

                  return [
                    e['name'],
                    e['code'],
                  ].join(' ').toLowerCase().contains(keyword);
                }).toList();
              });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 500,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Pilih Tipe BS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /*
|--------------------------------------------------------------------------
| SEARCH
|--------------------------------------------------------------------------
*/
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Tipe BS',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    runSearch('');
                                  },
                                  icon: Icon(Icons.close),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: runSearch,
                      ),
                      const SizedBox(height: 16),
                      if (filteredDefects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 24,
                          ),
                          child: Text(
                            'Tipe BS tidak ditemukan',
                          ),
                        )
                      else
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredDefects.length,
                            itemBuilder: (context, index) {
                              final e = filteredDefects[index];

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  e['name'],
                                ),
                                onTap: () {
                                  setState(() {
                                    defects.add({
                                      'defect_type_id': e['id'],
                                      'name': e['name'],
                                      'qty': 0,
                                    });
                                  });

                                  Navigator.pop(context);

                                  _showEditDefectDialog(
                                    itemIndex,
                                    defects.length - 1,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /*
|--------------------------------------------------------------------------
| EDIT DEFECT
|--------------------------------------------------------------------------
*/

  void _showEditDefectDialog(
    int itemIndex,
    int defectIndex,
  ) {
    final defect = _items[itemIndex]['defects'][defectIndex];

    final controller = TextEditingController(
      text: '${defect['qty'] ?? 0}',
    );

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  defect['name'],
                ),
                SizedBox(height: 16),
                TextFormGrade(
                  label: 'Qty',
                  controller: controller,
                  initialValue: controller.text,
                  onChanged: (value) {},
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CancelButton(
                        label: 'Batal',
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: FormButton(
                        label: 'Simpan',
                        onPressed: () {
                          setState(() {
                            final cleanValue = controller.text
                                .replaceAll('.', '')
                                .replaceAll(',', '');

                            defect['qty'] = parseSafe(cleanValue).toInt();
                            _syncFormItems();

                            _recalculateGradeBS(
                              itemIndex,
                            );
                            _syncFormItems();
                          });

                          Navigator.pop(
                            context,
                          );
                        },
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

  /*
|--------------------------------------------------------------------------
| SUMMARY
|--------------------------------------------------------------------------
*/

  Widget _buildSummary(
    int itemIndex,
  ) {
    final item = _items[itemIndex];

    final grades = item['grades'] ?? [];

    double gradeA = 0;
    double gradeAAdditional = 0;
    double gradeATaken = 0;
    double gradeB = 0;
    double gradeBS = 0;

    for (final grade in grades) {
      final code = (grade['code'] ?? '').toString().toUpperCase();

      final qty = num.tryParse(grade['qty'].toString()) ?? 0;

      if (code == 'A') {
        gradeA += _summaryGradeA(item, grade, itemIndex);
        gradeAAdditional += _gradeAAdditional(item, grade, itemIndex);
        gradeATaken += _gradeATaken(item, grade);
      } else if (code == 'B') {
        gradeB += qty;
      } else if (code == 'BS') {
        gradeBS += qty;
      }
    }

    final totalRepair = (num.tryParse(
              grades[0]['spraying'].toString(),
            ) ??
            0) +
        (num.tryParse(
              grades[0]['rework_long_hemming'].toString(),
            ) ??
            0) +
        (num.tryParse(
              grades[0]['combing'].toString(),
            ) ??
            0);

    final totalSorting = gradeA + gradeB + gradeBS + totalRepair;

    return TemplateCard(
      title: 'Hasil Sortir',
      icon: Icons.summarize_outlined,
      child: Row(
        children: [
          _summaryBox(
            'Grade A',
            gradeA,
          ),
          _summaryBox(
            'Grade B',
            gradeB,
          ),
          _summaryBox(
            'Tipe BS',
            gradeBS,
          ),
          _summaryBox(
            'Perbaikan',
            totalRepair,
          ),
          _summaryBox(
            'Grade A Tambahan',
            gradeAAdditional,
            valuePrefix: '+',
          ),
          _summaryBox(
            'Grade A Diambil',
            gradeATaken,
            valuePrefix: '-',
            valueColor: Colors.red,
          ),
          _summaryBox(
            'Hasil Sortir',
            totalSorting,
          ),
        ].separatedBy(
          SizedBox(width: 12),
        ),
      ),
    );
  }

  double _summaryGradeA(Map item, Map grade, int itemIndex) {
    final input = parseSafe(grade['qty']);
    final absorbed = _absorbedQty[itemIndex] ?? 0;
    if (grade['available_qty'] == null) {
      return input + absorbed;
    }

    return parseSafe(grade['available_qty']) +
        input -
        parseSafe(grade['source_qty']) +
        absorbed -
        _savedTransferInQty(item);
  }

  double _savedTransferInQty(Map item) {
    final rows = item['transfers_in'];
    if (rows is! List) return 0;

    var total = 0.0;
    for (final row in rows) {
      if (row is Map) total += parseSafe(row['qty']);
    }
    return total;
  }

  double _gradeAAdditional(Map item, Map grade, int itemIndex) {
    if (_absorbedQty.containsKey(itemIndex)) {
      return (_absorbedQty[itemIndex] ?? 0).toDouble();
    }

    return parseSafe(grade['qty_in']);
  }

  double _gradeATaken(Map item, Map grade) {
    final rows = item['transfers_out'];
    if (rows is List) {
      var total = 0.0;
      for (final row in rows) {
        if (row is Map) total += parseSafe(row['qty']);
      }
      return total;
    }

    return parseSafe(grade['qty_out']);
  }

  Widget _summaryBox(
    String title,
    dynamic value,
    {
    String valuePrefix = '',
    Color? valueColor,
    }
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              '$valuePrefix${formatNumber(value)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalSummary() {
    final items = _items;

    double totalGradeA = 0;
    double totalGradeAAdditional = 0;
    double totalGradeATaken = 0;
    double totalGradeB = 0;
    double totalGradeBS = 0;

    double totalRepair = 0;

    for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
      final item = items[itemIndex];
      final grades = item['grades'] ?? [];

      for (final grade in grades) {
        final code = (grade['code'] ?? '').toString().toUpperCase();

        final qty = num.tryParse(grade['qty'].toString()) ?? 0;

        if (code == 'A') {
          totalGradeA += _summaryGradeA(item, grade, itemIndex);
          totalGradeAAdditional +=
              _gradeAAdditional(item, grade, itemIndex);
          totalGradeATaken += _gradeATaken(item, grade);
        } else if (code == 'B') {
          totalGradeB += qty;
        } else if (code == 'BS') {
          totalGradeBS += qty;
        }
      }

      if (grades.isNotEmpty) {
        totalRepair += (num.tryParse(
                  grades[0]['spraying'].toString(),
                ) ??
                0) +
            (num.tryParse(
                  grades[0]['rework_long_hemming'].toString(),
                ) ??
                0) +
            (num.tryParse(
                  grades[0]['combing'].toString(),
                ) ??
                0);
      }
    }

    final totalSorting = totalGradeA + totalGradeB + totalGradeBS + totalRepair;

    return TemplateCard(
      title: 'Total Hasil Sortir',
      icon: Icons.analytics_outlined,
      child: Row(
        children: [
          _summaryBox(
            'Grade A',
            totalGradeA,
          ),
          _summaryBox(
            'Grade B',
            totalGradeB,
          ),
          _summaryBox(
            'Tipe BS',
            totalGradeBS,
          ),
          _summaryBox(
            'Perbaikan',
            totalRepair,
          ),
          _summaryBox(
            'Grade A Tambahan',
            totalGradeAAdditional,
            valuePrefix: '+',
          ),
          _summaryBox(
            'Grade A Diambil',
            totalGradeATaken,
            valuePrefix: '-',
            valueColor: Colors.red,
          ),
          _summaryBox(
            'Hasil Sortir',
            totalSorting,
          ),
        ].separatedBy(
          SizedBox(width: 12),
        ),
      ),
    );
  }

  Widget _buildQtyWarning(String warning) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              warning,
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
