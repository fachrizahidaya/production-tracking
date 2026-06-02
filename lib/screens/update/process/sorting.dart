import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/form/text_form_grade.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/extract_semi_finished.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_item_semi_finished.dart';

class SortingEditSection extends StatefulWidget {
  final Map form;
  final Map data;

  final List? itemGradeOption;
  final List? itemTypeOption;

  final Function() updateTotalSorting;

  const SortingEditSection({
    super.key,
    required this.form,
    required this.data,
    required this.itemGradeOption,
    required this.itemTypeOption,
    required this.updateTotalSorting,
  });

  @override
  State<SortingEditSection> createState() => _SortingEditSectionState();
}

class _SortingEditSectionState extends State<SortingEditSection> {
  final Map<String, TextEditingController> _gradeControllers = {};
  final Map<String, TextEditingController> _repairControllers = {};
  List itemGradeOption = [];

  bool _isFetchingGrade = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
        text: value.toString(),
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
        text: value.toString(),
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

    return _repairControllers[mapKey]!;
  }

  /*
|--------------------------------------------------------------------------
| INIT FROM API
|--------------------------------------------------------------------------
*/

  Future<void> _initializeFormFromApi() async {
    final grades = widget.data['grades'] ?? [];
    final woItems = widget.data['work_orders']?['items'] ?? [];

    final Map<dynamic, Map<String, dynamic>> groupedItems = {};

    /*
|--------------------------------------------------------------------------
| EXISTING DATA
|--------------------------------------------------------------------------
*/

    for (final grade in grades) {
      final gradeItems = grade['items'] ?? [];

      final itemGrade = grade['item_grade'];

      for (final item in gradeItems) {
        final itemId = item['item_id'] ??
            item['finished_product']?['id'] ??
            DateTime.now().millisecondsSinceEpoch;

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
| FIRST CREATE / EMPTY DATA
|--------------------------------------------------------------------------
*/

    if (groupedItems.isEmpty) {
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
      );

      final List<Map<String, dynamic>> semiFinishedItemsGradeA =
          List<Map<String, dynamic>>.from(
        semiFinishedService.dataListOption.map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );

      /// FETCH GRADE B
      await semiFinishedService.fetchOptions(
        isInitialLoad: true,
        process: 'sorting',
        baseCodes: params['base_codes'] ?? [],
        colorCodes: ['GRB'],
      );

      final List<Map<String, dynamic>> semiFinishedItemsGradeB =
          List<Map<String, dynamic>>.from(
        semiFinishedService.dataListOption.map(
          (e) => Map<String, dynamic>.from(e),
        ),
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
        /// contoh:
        /// HGN187C0-55NN-LYO -> HGN187C0
        final baseCode = itemCode.split('-').first;
        Map<String, dynamic>? gradeAItem;
        Map<String, dynamic>? gradeBItem;

        try {
          gradeAItem = semiFinishedItemsGradeA.firstWhere(
            (e) {
              final optionCode = e['code']?.toString() ?? '';
              final optionBaseCode = optionCode.split('-').first;

              return optionBaseCode == baseCode;
            },
          );
          gradeBItem = semiFinishedItemsGradeB.firstWhere(
            (e) {
              final optionCode = e['code']?.toString() ?? '';
              final optionBaseCode = optionCode.split('-').first;

              return optionBaseCode == baseCode;
            },
          );
        } catch (_) {
          gradeAItem = null;
          gradeBItem = null;
        }
        final itemKey = woItem['greige_item_id'] ?? woItem['id'];

        groupedItems[itemKey] = {
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
            /*
|--------------------------------------------------------------------------
| GRADE A
|--------------------------------------------------------------------------
*/
            {
              'item_grade_id': gradeAOption['value'],
              'name': 'Grade A',
              'code': 'A',
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

    widget.form['items'] = groupedItems.values.toList();

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

  void _recalculateGradeBS(
    int itemIndex,
  ) {
    final item = widget.form['items'][itemIndex];

    final defects = item['defects'] ?? [];

    int total = 0;

    for (final defect in defects) {
      total += parseSafe(
        defect['qty'],
      ).toInt();
    }

    final grades = item['grades'] ?? [];

    final bsIndex = grades.indexWhere(
      (e) => (e['code'] ?? '').toString().toUpperCase() == 'BS',
    );

    if (bsIndex != -1) {
      grades[bsIndex]['qty'] = total;

      /// UPDATE CONTROLLER AGAR UI LANGSUNG BERUBAH
      _getGradeController(
        itemIndex,
        bsIndex,
        total,
      ).text = total.toString();
    }

    setState(() {});

    widget.updateTotalSorting();
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
    final items = widget.form['items'] ?? [];

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
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: TabBar(
                isScrollable: false,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(6),
                ),
                tabs: [
                  for (final item in items)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Tab(
                        text: item['finished_product']?['code'] ?? '-',
                      ),
                    ),
                ],
              ),
            ),
          ),

          /*
|--------------------------------------------------------------------------
| TAB BODY
|--------------------------------------------------------------------------
*/
          SizedBox(
            height: 1100,
            child: TabBarView(
              children: [
                for (int itemIndex = 0; itemIndex < items.length; itemIndex++)
                  _buildItemCard(
                    itemIndex,
                  ),
              ],
            ),
          ),
          _buildGlobalSummary(),
        ].separatedBy(CustomTheme().vGap('xl')),
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
    final item = widget.form['items'][itemIndex];

    final grades = item['grades'] ?? [];

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
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
    final grade = widget.form['items'][itemIndex]['grades'][gradeIndex];

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: grade['code'] == 'BS'
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
          Expanded(
            flex: 2,
            child: TextFormGrade(
              label: 'Qty',
              isDisabled: grade['code'] == 'BS',
              initialValue: '${grade['qty'] ?? 0}',
              onChanged: (value) {
                final parsed = parseSafe(value);

                grade['qty'] = parsed;

                _getGradeController(
                  itemIndex,
                  gradeIndex,
                  parsed,
                ).text = value;

                setState(() {});

                widget.updateTotalSorting();
              },
              controller: _getGradeController(
                itemIndex,
                gradeIndex,
                grade['qty'] ?? 0,
              ),
            ),
          )
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
    final grades = widget.form['items'][itemIndex]['grades'];

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
          final parsed = parseSafe(value);

          setState(() {
            for (final g in grades) {
              g[key] = parsed;
            }
          });

          _getRepairController(
            itemIndex,
            key,
            parsed,
          ).text = value;

          widget.updateTotalSorting();
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
    final item = widget.form['items'][itemIndex];

    final defects = item['defects'] ?? [];

    return TemplateCard(
      title: 'Tipe BS',
      icon: Icons.warning_amber_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (defects.isNotEmpty)
            SizedBox(
              height: 77,
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
    final item = widget.form['items'][itemIndex];

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
          builder: (context, setModalState) {
            void runSearch(String value) {
              setModalState(() {
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
    final defect = widget.form['items'][itemIndex]['defects'][defectIndex];

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
                TextForm(
                  label: 'Qty',
                  isNumber: true,
                  controller: controller,
                  initialValue: controller.text,
                  handleChange: (value) {},
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
                            defect['qty'] = parseSafe(
                              controller.text,
                            );

                            _recalculateGradeBS(
                              itemIndex,
                            );
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
    final item = widget.form['items'][itemIndex];

    final grades = item['grades'] ?? [];

    double gradeA = 0;
    double gradeB = 0;
    double gradeBS = 0;

    for (final grade in grades) {
      final code = (grade['code'] ?? '').toString().toUpperCase();

      final qty = parseSafe(
        grade['qty'],
      );

      if (code == 'A') {
        gradeA += qty;
      } else if (code == 'B') {
        gradeB += qty;
      } else if (code == 'BS') {
        gradeBS += qty;
      }
    }

    final totalRepair = parseSafe(
          grades[0]['spraying'],
        ) +
        parseSafe(
          grades[0]['rework_long_hemming'],
        ) +
        parseSafe(
          grades[0]['combing'],
        );

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
    final items = widget.form['items'] ?? [];

    double totalGradeA = 0;
    double totalGradeB = 0;
    double totalGradeBS = 0;

    double totalRepair = 0;

    for (final item in items) {
      final grades = item['grades'] ?? [];

      for (final grade in grades) {
        final code = (grade['code'] ?? '').toString().toUpperCase();

        final qty = parseSafe(
          grade['qty'],
        );

        if (code == 'A') {
          totalGradeA += qty;
        } else if (code == 'B') {
          totalGradeB += qty;
        } else if (code == 'BS') {
          totalGradeBS += qty;
        }
      }

      if (grades.isNotEmpty) {
        totalRepair += parseSafe(
              grades[0]['spraying'],
            ) +
            parseSafe(
              grades[0]['rework_long_hemming'],
            ) +
            parseSafe(
              grades[0]['combing'],
            );
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
