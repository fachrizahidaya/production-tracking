import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/form/text_form_grade.dart';
import 'package:textile_tracking/helpers/util/extract_semi_finished.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
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

  const SortingSection(
      {super.key,
      required this.form,
      required this.itemGradeOption,
      required this.itemTypeOption,
      this.processData,
      this.finishedItemGrb,
      this.finishedItem,
      this.woData,
      this.isInitializing = false});

  @override
  State<SortingSection> createState() => _SortingSectionState();
}

class _SortingSectionState extends State<SortingSection> {
  final Map<String, TextEditingController> _gradeControllers = {};
  final Map<String, TextEditingController> _repairControllers = {};
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeFormFromApi();
      }
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

      if (mounted) {
        setState(() {});
      }

      return;
    }

    final grades = widget.processData['grades'] ?? [];

    final woItems = widget.processData['work_orders']?['items'] ?? [];

    final Map<int, Map<String, dynamic>> groupedItems = {};

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

        if (!groupedItems.containsKey(itemId)) {
          groupedItems[itemId] = {
            'item_id': itemId,
            'finished_product': item['finished_product'],
            'semifinished_product': item['semifinished_product'],
            'grades': [],
            'defects': [],
          };
        }

        groupedItems[itemId]!['grades'].add({
          'item_grade_id': itemGrade['id'],
          'name': itemGrade['name'],
          'code': itemGrade['code'],
          'qty': item['qty'] ?? 0,
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
          groupedItems[itemId]!['defects'].add({
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

      await semiFinishedService.fetchOptions(
        isInitialLoad: true,
        process: 'sorting',
        baseCodes: params['base_codes'] ?? [],
        colorCodes: params['color_codes'] ?? [],
      );

      final semiFinishedItems = semiFinishedService.dataListOption;

      for (int i = 0; i < woItems.length; i++) {
        final woItem = woItems[i];

        final gradeBItem =
            i < semiFinishedItems.length ? semiFinishedItems[i] : null;

        groupedItems[woItem['greige_item_id']] = {
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
              'item_grade_id': 1,
              'name': 'Grade A',
              'code': 'A',
              'qty': 0,
              'notes': null,
              'semifinished_product_id': woItem['greige_item_id'],
              'semifinished_product': {
                'id': woItem['greige_item_id'],
                'code': woItem['item_code'],
                'name': woItem['item_name'],
              },
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
              'item_grade_id': 2,
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
              'item_grade_id': 3,
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
  }

  /*
|--------------------------------------------------------------------------
| HELPERS
|--------------------------------------------------------------------------
*/

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

  double parseInput(dynamic value) {
    if (value == null) return 0;

    String str = value.toString().trim();

    if (str.isEmpty) return 0;

    final ribuanRegex = RegExp(r'^\d{1,3}(\.\d{3})+$');

    if (ribuanRegex.hasMatch(str)) {
      str = str.replaceAll('.', '');
      return double.tryParse(str) ?? 0;
    }

    if (str.contains(',')) {
      str = str.replaceAll('.', '');
      str = str.replaceAll(',', '.');
    }

    return double.tryParse(str) ?? 0;
  }

  void _syncFormItems() {
    widget.form['items'] = List<Map<String, dynamic>>.from(_items);

    widget.form['grades'] =
        _items.expand((item) => item['grades'] ?? []).toList();
  }

  void _recalculateGradeBS(
    int itemIndex,
  ) {
    final item = _items[itemIndex];

    final defects = item['defects'] ?? [];

    double total = 0;

    for (final defect in defects) {
      total += num.tryParse(defect['qty'].toString()) ?? 0;
    }

    final grades = item['grades'] ?? [];

    final bsIndex = grades.indexWhere(
      (e) => (e['code'] ?? '').toString().toUpperCase() == 'BS',
    );

    if (bsIndex != -1) {
      grades[bsIndex]['qty'] = total;

      /// UPDATE CONTROLLER AGAR UI LANGSUNG BERUBAH
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
    setState(() {});
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
      child: Column(
        children: [
          /*
|--------------------------------------------------------------------------
| TAB HEADER
|--------------------------------------------------------------------------
*/
          _buildGlobalSummary(),
          SizedBox(height: 16),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              tabs: [
                for (final item in items)
                  Tab(
                    text: item['finished_product']?['code'] ?? '-',
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),

          /*
|--------------------------------------------------------------------------
| TAB BODY
|--------------------------------------------------------------------------
*/
          SizedBox(
            height: 1000,
            child: TabBarView(
              children: [
                for (int itemIndex = 0; itemIndex < items.length; itemIndex++)
                  _buildItemCard(
                    itemIndex,
                  ),
              ],
            ),
          ),
        ],
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

    return Column(
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
        SizedBox(height: 16),
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
    final grade = _items[itemIndex]['grades'][gradeIndex];

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              grade['code'] ?? '-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              grade['semifinished_product']?['code'] ?? '-',
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormGrade(
              label: 'Qty',
              isDisabled: grade['code'] == 'BS',
              initialValue: '${grade['qty'] ?? 0}',
              controller: _getGradeController(
                itemIndex,
                gradeIndex,
                grade['qty'] ?? 0,
              ),
              onChanged: (value) {
                grade['qty'] = num.tryParse(value.toString()) ?? 0;

                _syncFormItems();

                setState(() {});
              },
            ),
          ),
        ],
      ),
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
    final defect = widget.form['items'][itemIndex]['defects'][defectIndex];

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

                            defect['qty'] = num.tryParse(cleanValue) ?? 0;
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
    double gradeB = 0;
    double gradeBS = 0;

    for (final grade in grades) {
      final code = (grade['code'] ?? '').toString().toUpperCase();

      final qty = num.tryParse(grade['qty'].toString()) ?? 0;

      if (code == 'A') {
        gradeA += qty;
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
      title: 'Rincian Sortir',
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
            'Hasil Sortir',
            totalSorting,
          ),
        ].separatedBy(
          SizedBox(width: 12),
        ),
      ),
    );
  }

  Widget _summaryBox(
    String title,
    dynamic value,
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
            Text(title),
            SizedBox(height: 8),
            Text(
              formatNumber(value).toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
    double totalGradeB = 0;
    double totalGradeBS = 0;

    double totalRepair = 0;

    for (final item in items) {
      final grades = item['grades'] ?? [];

      for (final grade in grades) {
        final code = (grade['code'] ?? '').toString().toUpperCase();

        final qty = num.tryParse(grade['qty'].toString()) ?? 0;

        if (code == 'A') {
          totalGradeA += qty;
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
      title: 'Rincian Hasil Sortir',
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
            'Hasil Sortir',
            totalSorting,
          ),
        ].separatedBy(
          SizedBox(width: 12),
        ),
      ),
    );
  }
}
