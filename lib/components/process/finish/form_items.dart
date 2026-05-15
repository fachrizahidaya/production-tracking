// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/process/finish/process/form_helpers.dart';
import 'package:textile_tracking/components/process/finish/process/qty_weight.dart';
import 'package:textile_tracking/components/process/finish/process/sorting.dart';
import 'package:textile_tracking/components/process/finish/process/weight.dart';
import 'package:textile_tracking/helpers/util/attachment_picker.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/note_editor.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class FormItems extends StatefulWidget {
  final id;
  final form;
  final withItemGrade;
  final withQtyAndWeight;
  final forDyeing;
  final forPacking;
  final forSewing;
  final forHemming;
  final itemGradeOption;
  final handleSelectQtyUnit;
  final length;
  final width;
  final weight;
  final weightDozen;
  final gsm;
  final totalWeight;
  final note;
  final handleChangeInput;
  final handleSelectLengthUnit;
  final handleSelectWidthUnit;
  final handleSelectUnit;
  final qty;
  final qtyItem;
  final grades;
  final allAttachments;
  final handleSelectWo;
  final handleSelectFinishedMaterial;
  final handleUpdateGrade;
  final handlePickAttachments;
  final handleDeleteAttachment;
  final handleSelectQtyUnitItem;
  final handleSelectQtyUnitDyeing;
  final showImageDialog;
  final validateWeight;
  final validateQty;
  final weightWarning;
  final qtyWarning;
  final label;
  final data;
  final processData;
  final handleTotalItemQty;
  final handleRemainingQtyForGrade;
  final dyeingLotNo;
  final weightGood;
  final weightDefect;
  final woData;
  final reworkLongHemming;
  final combing;
  final spraying;
  final itemTypeOption;
  final defects;
  final defectQty;
  final handleSelectItemType;
  final handleUpdateDefect;
  final packingQty;
  final weightGradeA;
  final finishedItem;
  final dyeingQty;
  final finishedItemGood;
  final finishedItemGrb;

  const FormItems(
      {super.key,
      this.allAttachments,
      this.form,
      this.grades,
      this.handleChangeInput,
      this.handlePickAttachments,
      this.handleSelectLengthUnit,
      this.handleSelectQtyUnit,
      this.handleSelectQtyUnitItem,
      this.handleSelectUnit,
      this.handleSelectWidthUnit,
      this.handleSelectWo,
      this.handleUpdateGrade,
      this.id,
      this.itemGradeOption,
      this.length,
      this.note,
      this.qty,
      this.showImageDialog,
      this.weight,
      this.width,
      this.withItemGrade = false,
      this.withQtyAndWeight = false,
      this.handleDeleteAttachment,
      this.validateWeight,
      this.weightWarning,
      this.validateQty,
      this.qtyWarning,
      this.forDyeing = false,
      this.label,
      this.handleSelectQtyUnitDyeing,
      this.data,
      this.forPacking = false,
      this.gsm,
      this.totalWeight,
      this.weightDozen,
      this.handleRemainingQtyForGrade,
      this.handleTotalItemQty,
      this.processData,
      this.qtyItem,
      this.dyeingLotNo,
      this.forHemming,
      this.forSewing,
      this.handleSelectFinishedMaterial,
      this.weightDefect,
      this.weightGood,
      this.woData,
      this.reworkLongHemming,
      this.combing,
      this.spraying,
      this.itemTypeOption,
      this.defects,
      this.defectQty,
      this.handleSelectItemType,
      this.handleUpdateDefect,
      this.packingQty,
      this.weightGradeA,
      this.finishedItem,
      this.dyeingQty,
      this.finishedItemGood,
      this.finishedItemGrb});

  @override
  State<FormItems> createState() => _FormItemsState();
}

class _FormItemsState extends State<FormItems> with TickerProviderStateMixin {
  double beratLusin = 0;
  double gsm = 0;
  double beratGradeA = 0;
  double totalBerat = 0;
  late List<Map<String, dynamic>> _grades;
  TabController? _semiFinishedTabController;
  int _selectedSemiFinishedIndex = 0;

  @override
  void initState() {
    super.initState();

    _grades = (widget.processData['grades'] ?? [])
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
    _initGradeControllers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final good = parseSafe(widget.form['good_weight']);
      final defect = parseSafe(widget.form['bs_weight']);

      if (good > 0 || defect > 0) {
        calculateLongHemmingWeight();
      }

      _syncGradesWithOptions();

      // final semiFinishedProducts =
      //     widget.processData['semifinished_products'] ?? [];

      // if (semiFinishedProducts.isNotEmpty) {
      //   widget.handleChangeInput(
      //     'greige_item_id',
      //     semiFinishedProducts[0]['id'],
      //   );

      //   widget.handleChangeInput(
      //     'nama_greige_item',
      //     semiFinishedProducts[0]['name'],
      //   );

      //   widget.handleChangeInput(
      //     'sku_greige_item',
      //     semiFinishedProducts[0]['code'],
      //   );
      // }

      _initializeSemiFinishedTab();
    });

    final semiFinishedProducts =
        widget.processData['semifinished_products'] ?? [];

    if (semiFinishedProducts.length > 1) {
      _semiFinishedTabController = TabController(
        length: semiFinishedProducts.length,
        vsync: this,
      );

      _semiFinishedTabController!.addListener(() {
        if (!_semiFinishedTabController!.indexIsChanging) {
          final selectedIndex = _semiFinishedTabController!.index;

          final items = widget.processData['semifinished_products'];

          setState(() {
            _selectedSemiFinishedIndex = selectedIndex;

            widget.handleChangeInput(
              'greige_item_id',
              items[selectedIndex]['id'],
            );

            widget.handleChangeInput(
              'nama_greige_item',
              items[selectedIndex]['name'],
            );

            widget.handleChangeInput(
              'sku_greige_item',
              items[selectedIndex]['code'],
            );
          });
        }
      });
    }
  }

  void _syncGradesWithOptions() {
    final List<Map<String, dynamic>> updated = [];

    for (int i = 0; i < widget.itemGradeOption.length; i++) {
      final grade = widget.itemGradeOption[i];

      final existing = _grades.firstWhere(
        (g) => g['item_grade_id'].toString() == grade['value'].toString(),
        orElse: () => {},
      );

      dynamic greigeItemId;

      if (i == 0) {
        greigeItemId = widget.processData['greige_item'] != null
            ? widget.processData['greige_item']['id']
            : null;
      } else if (i == 1) {
        greigeItemId = widget.finishedItemGrb.isNotEmpty
            ? widget.finishedItemGrb[0]['value']
            : null;
      } else if (i == 2) {
        greigeItemId = null;
      } else {
        greigeItemId = existing['greige_item_id'];
      }

      updated.add({
        'item_grade_id': grade['value'],
        'unit_id': existing['unit_id'] ?? 1,
        'qty': existing['qty'] ?? '0',
        'notes': existing['notes'] ?? '',
        'greige_item_id': greigeItemId,
        'name': grade['label'] ?? ''
      });
    }

    setState(() {
      _grades = updated;
    });

    widget.handleChangeInput('grades', _grades);
  }

  void _initGradeControllers() {
    for (int i = 0; i < _grades.length; i++) {
      _ensureController(i);

      final qty = _grades[i]['qty']?.toString() ?? '0';

      widget.qtyItem[i].text = qty;
    }
  }

  String getGradeLabel(int i) {
    return widget.itemGradeOption.firstWhere(
          (e) =>
              e['value'].toString() ==
              widget.grades[i]['item_grade_id'].toString(),
          orElse: () => {'label': ''},
        )['label'] ??
        '';
  }

  String getDefectLabel(int i) {
    return widget.itemTypeOption.firstWhere(
          (e) =>
              e['id'].toString() ==
              widget.defects[i]['defect_type_id'].toString(),
          orElse: () => {'name': ''},
        )['name'] ??
        '';
  }

  double getGradePercentage(int index) {
    final grades = widget.form['grades'];

    if (grades == null || grades is! List || grades.isEmpty) {
      return 0;
    }

    if (index < 0 || index >= grades.length) {
      return 0;
    }

    final totalQty = widget.handleTotalItemQty();
    if (totalQty == 0) return 0;

    final gradeQty =
        double.tryParse(grades[index]?['qty']?.toString() ?? '0') ?? 0;

    return (gradeQty / totalQty) * 100;
  }

  void _ensureController(int index) {
    while (widget.qtyItem.length <= index) {
      widget.qtyItem.add(TextEditingController(text: '0'));
    }
  }

  double getMaxQtyFromGrades() {
    final grades =
        double.tryParse(widget.form['qty']?.toString() ?? '0') ?? 0.0;

    return grades;
  }

  double getMaxTotalQty() {
    final data = widget.woData['processes'][10]['data'][0];

    final gradesList = data['grades'] ?? [];

    int totalQty = 0;

    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    final spraying = int.tryParse(data['spraying']?.toString() ?? '0') ?? 0;

    final reworkLongHemming =
        int.tryParse(data['rework_long_hemming']?.toString() ?? '0') ?? 0;

    final combing = int.tryParse(data['combing']?.toString() ?? '0') ?? 0;

    totalQty += spraying + reworkLongHemming + combing;

    return totalQty.toDouble();
  }

  int customRound(double value) {
    final decimal = value - value.floor();

    if (decimal > 0.5) {
      return value.ceil();
    } else {
      return value.floor();
    }
  }

  void calculateGsm(double value) {
    final size = widget.woData['items'][0]['variants'][1]['value'];
    final panjang = int.tryParse(size.split('X')[0]) ?? 0;
    final lebar = int.tryParse(size.split('X')[1]) ?? 0;

    setState(() {
      beratLusin = value;
      final rawGsm = (beratLusin * 10000000) / (12 * panjang * lebar);

      final roundedGsm = customRound(rawGsm);

      if (panjang == 0 || lebar == 0) {
        gsm = 0;
      } else {
        gsm = roundedGsm.toDouble();
      }

      widget.gsm.text = roundedGsm.toString();

      widget.handleChangeInput('gsm', roundedGsm.toString());
    });
  }

  String formatId(num value) {
    final formatter = NumberFormat('#,##0.00', 'id_ID');
    return formatter.format(value);
  }

  double parseId(String value) {
    return double.tryParse(
          value.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
  }

  String toApi(num value) {
    return value.toString();
  }

  void calculateBeratA(double beratLusin) {
    final packing = double.tryParse(
          widget.packingQty.text.replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;

    if (packing <= 0 || beratLusin <= 0) {
      widget.weightGradeA.text = '0';
      return;
    }

    final result = (packing / 12) * beratLusin;

    widget.weightGradeA.text = result.toStringAsFixed(2);
  }

  void calculateTotalBerat(double value) {
    final maxQty = getMaxTotalQty();

    setState(() {
      beratLusin = value;

      totalBerat = maxQty == 0 ? 0 : (beratLusin / 12) * maxQty;

      widget.totalWeight.text = totalBerat.toStringAsFixed(2);

      widget.handleChangeInput(
        'total_weight',
        totalBerat.toStringAsFixed(2),
      );
    });
  }

  double parseSafe(dynamic val) {
    if (val == null) return 0;

    String str = val.toString().trim();

    if (str.isEmpty) return 0;

    // Jika ada koma, anggap format Indonesia (1.000,5)
    if (str.contains(',')) {
      str = str.replaceAll('.', '');
      str = str.replaceAll(',', '.');
    }

    return double.tryParse(str) ?? 0;
  }

  void calculateLongHemmingWeight() {
    final good = parseSafe(widget.form['good_weight']);
    final defect = parseSafe(widget.form['bs_weight']);

    final total = good + defect;

    setState(() {
      widget.handleChangeInput('weight', total.toStringAsFixed(2));
      widget.weight.value = TextEditingValue(
        text: total.toStringAsFixed(2),
        selection: TextSelection.collapsed(
          offset: total.toStringAsFixed(2).length,
        ),
      );
    });
  }

  void _recalculateGradeBS() {
    final totalBs = widget.defects.fold<int>(
      0,
      (int sum, defect) {
        final qty = int.tryParse(
                (defect['qty']?.toString() ?? '0').replaceAll(',', '')) ??
            0;
        return sum + qty;
      },
    );

    final grades = List<Map<String, dynamic>>.from(_grades);
    final index = grades.indexWhere((g) => g['name'].toString() == 'Grade BS');

    if (index != -1) {
      grades[index]['qty'] = totalBs;
      _grades = grades;
      widget.form['grades'] = _grades;

      if (index < widget.qtyItem.length) {
        widget.qtyItem[index].text = totalBs.toString();
      }
    }
  }

  void _initializeSemiFinishedTab() {
    final semiFinishedProducts =
        widget.processData['semifinished_products'] ?? [];

    // dispose controller lama
    _semiFinishedTabController?.dispose();
    _semiFinishedTabController = null;

    if (semiFinishedProducts.length > 1) {
      _semiFinishedTabController = TabController(
        length: semiFinishedProducts.length,
        vsync: this,
      );

      _semiFinishedTabController!.addListener(() {
        if (!_semiFinishedTabController!.indexIsChanging) {
          final selectedIndex = _semiFinishedTabController!.index;

          final items = widget.processData['semifinished_products'];

          setState(() {
            _selectedSemiFinishedIndex = selectedIndex;

            widget.handleChangeInput(
              'greige_item_id',
              items[selectedIndex]['id'],
            );

            widget.handleChangeInput(
              'nama_greige_item',
              items[selectedIndex]['name'],
            );

            widget.handleChangeInput(
              'sku_greige_item',
              items[selectedIndex]['code'],
            );
          });
        }
      });
    }

    if (semiFinishedProducts.isNotEmpty) {
      widget.handleChangeInput(
        'greige_item_id',
        semiFinishedProducts[0]['id'],
      );

      widget.handleChangeInput(
        'nama_greige_item',
        semiFinishedProducts[0]['name'],
      );

      widget.handleChangeInput(
        'sku_greige_item',
        semiFinishedProducts[0]['code'],
      );
    }
  }

  bool _isDataEmpty() {
    if ((widget.itemGradeOption ?? []).isEmpty) return true;
    if (_grades.isEmpty) return true;
    if (widget.processData?['grades'].isEmpty) return true;

    return false;
  }

  Map<String, dynamic>? get selectedSemiFinishedItem {
    final items = widget.processData['semifinished_products'];

    if (items == null || items.isEmpty) {
      return null;
    }

    return items[_selectedSemiFinishedIndex];
  }

  bool get isLoadingSemiFinished {
    final hasSelectedWO = widget.form['wo_id'] != null;

    final semiFinishedProducts =
        widget.processData['semifinished_products'] ?? [];

    return hasSelectedWO && semiFinishedProducts.isEmpty;
  }

  @override
  void didUpdateWidget(covariant FormItems oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldItems = oldWidget.processData['semifinished_products'];

    final newItems = widget.processData['semifinished_products'];

    if (oldItems != newItems) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeSemiFinishedTab();
      });
    }
  }

  @override
  void dispose() {
    _semiFinishedTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSorting = widget.label == 'Sorting';
    final hasSelectedWO = widget.form['wo_id'] != null;
    final semiFinishedProducts =
        widget.processData['semifinished_products'] ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.id == null)
              Expanded(
                child: TemplateCard(
                  title: 'Work Order',
                  icon: Icons.description_outlined,
                  child: SelectForm(
                    label: 'Work Order',
                    onTap: () => widget.handleSelectWo(),
                    selectedLabel: widget.form['no_wo'] ?? '',
                    selectedValue: widget.form['wo_id']?.toString() ?? '',
                    required: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Work Order wajib dipilih';
                      }
                      return null;
                    },
                  ),
                ),
              ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        // if (isSorting && hasSelectedWO && _isDataEmpty())
        //   FormHelpers.buildEmptyState(false)
        // else ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.id != null)
              Expanded(
                child: TemplateCard(
                    title: 'Work Order',
                    icon: Icons.description_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Work Order'),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.data != null
                                      ? '${widget.data['wo_no']}'
                                      : '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
              ),
            if (widget.data != null &&
                (widget.label != 'Long Hemming' &&
                    widget.label != 'Cross Cutting' &&
                    widget.label != 'Sewing' &&
                    widget.label != 'Sorting' &&
                    widget.label != 'Packing'))
              Expanded(
                child: TemplateCard(
                    title: 'Mesin',
                    icon: Icons.local_laundry_service_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mesin'),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.data != null
                                      ? '${widget.processData['machine']['code']} ${widget.processData['machine']['name']}'
                                      : '-',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )),
              ),
            if (widget.data != null && widget.forDyeing == true)
              Expanded(
                child: TemplateCard(
                  title: 'Lot Celup',
                  icon: Icons.invert_colors_on_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                TextForm(
                                  label: 'No. Lot Celup',
                                  controller: widget.dyeingLotNo,
                                  handleChange: (value) {
                                    widget.handleChangeInput(
                                        'lot_celup_no', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
              ),
            if (widget.data != null &&
                widget.label != 'Dyeing' &&
                widget.label != 'Long Hemming' &&
                widget.label != 'Cross Cutting' &&
                widget.label != 'Sewing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Packing')
              Expanded(
                child: WeightSection(
                  form: widget.form,
                  controller: widget.weight,
                  warning: widget.weightWarning,
                  onChange: (val) {
                    widget.handleChangeInput('weight', val);
                  },
                  onValidate: (val) {
                    widget.validateWeight(val);
                  },
                ),
              ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        if (widget.data != null &&
            (widget.label == 'Long Hemming' ||
                widget.label == 'Cross Cutting' ||
                widget.label == 'Sewing'))
          TemplateCard(
              title: 'Mesin',
              icon: Icons.local_laundry_service_outlined,
              child: FormHelpers.buildMachine(
                context: context,
                machines: widget.processData['machines'] ?? [],
              )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.data != null &&
                widget.withItemGrade == false &&
                widget.label != 'Packing' &&
                widget.label != 'Press' &&
                widget.label != 'Tumbler' &&
                widget.label != 'Stenter' &&
                widget.label != 'Long Slitting')
              QtyWeightSection(
                form: widget.form,
                label: widget.label,
                withItemGrade: widget.withItemGrade,
                withQtyAndWeight: widget.withQtyAndWeight,
                forDyeing: widget.forDyeing,
                qty: widget.qty,
                dyeingQty: widget.dyeingQty,
                weightGood: widget.weightGood,
                weightDefect: widget.weightDefect,
                qtyWarning: widget.qtyWarning,
                weightWarning: widget.weightWarning,
                onChange: widget.handleChangeInput,
                validateQty: widget.validateQty,
                validateWeight: widget.validateWeight,
                calculateLongHemmingWeight: calculateLongHemmingWeight,
              ),
            if (isLoadingSemiFinished)
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (semiFinishedProducts.length > 1)
              Expanded(
                child: TemplateCard(
                  title: 'Produk Setengah Jadi',
                  icon: Icons.inventory_2_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_semiFinishedTabController != null)
                        TabBar(
                          tabAlignment: TabAlignment.start,
                          controller: _semiFinishedTabController,
                          isScrollable: true,
                          labelColor: Colors.black,
                          tabs: List.generate(
                            semiFinishedProducts.length,
                            (index) {
                              return Tab(
                                text: semiFinishedProducts[index]['code']
                                        ?.toString()
                                        .split('-')
                                        .first ??
                                    'Item ${index + 1}',
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedSemiFinishedItem?['code'] ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedSemiFinishedItem?['name'] ?? '-',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // if (widget.data != null &&
            //     (widget.forDyeing == true ||
            //         widget.forSewing == true ||
            //         widget.forHemming == true ||
            //         widget.forPacking == true))
            //   Expanded(
            //     child: TemplateCard(
            //       title: 'Produk Setelah ${widget.label}',
            //       icon: Icons.inventory_2_outlined,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Row(
            //             children: [
            //               Expanded(
            //                   flex: 2,
            //                   child: SelectForm(
            //                     label: widget.label == 'Sorting' ||
            //                             widget.label == 'Packing'
            //                         ? 'Produk Jadi'
            //                         : 'Produk Setengah Jadi',
            //                     onTap: () =>
            //                         widget.handleSelectFinishedMaterial(),
            //                     selectedLabel:
            //                         widget.form['nama_greige_item'] ?? '',
            //                     selectedCode:
            //                         widget.form['sku_greige_item'] ?? '',
            //                     selectedValue:
            //                         widget.form['greige_item_id']?.toString() ??
            //                             '',
            //                     isWithCode: true,
            //                     required: true,
            //                     validator: (value) {
            //                       if (value == null || value.trim().isEmpty) {
            //                         return 'Produk wajib dipilih';
            //                       }
            //                       return null;
            //                     },
            //                   )),
            //             ].separatedBy(CustomTheme().hGap('xl')),
            //           ),
            //         ].separatedBy(CustomTheme().vGap('lg')),
            //       ),
            //     ),
            //   )
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.processData['rework'] == true)
              Expanded(
                child: TemplateCard(
                    title: 'Referensi Rework',
                    icon: Icons.replay_outlined,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_buildReworkReference()],
                        ),
                      ],
                    )),
              ),
          ].separatedBy(CustomTheme().hGap('xl')),
        ),
        if (widget.form?['wo_id'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.label == 'Sorting')
                SortingSection(
                  form: widget.form,
                  grades: _grades,
                  itemGradeOption: widget.itemGradeOption,
                  spraying: widget.spraying,
                  reworkLongHemming: widget.reworkLongHemming,
                  combing: widget.combing,
                  onChange: widget.handleChangeInput,
                  defectQty: widget.defectQty,
                  defects: widget.defects,
                  itemTypeOption: widget.itemTypeOption,
                  recalculateGradeBS: _recalculateGradeBS,
                  qtyItem: widget.qtyItem,
                  processData: widget.processData,
                  handleUpdateGrade: widget.handleUpdateGrade,
                  finishedItemGrb: widget.finishedItemGrb,
                  finishedItem: widget.finishedItem,
                  woData: widget.processData,
                ),
              if (widget.label == 'Packing')
                Column(
                  children: [
                    TemplateCard(
                      title: 'Rincian Hasil Sortir',
                      icon: Icons.sort_outlined,
                      child: _buildSortingQty(),
                    ),
                    TemplateCard(
                      title: 'Informasi Packing',
                      icon: Icons.layers_outlined,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextForm(
                                  label: 'Total Packing (PCS)',
                                  req: true,
                                  isNumber: true,
                                  // isSorting: true,
                                  initialValue:
                                      widget.processData['qty']?.toString() ??
                                          '0',
                                  controller: widget.packingQty,
                                  handleChange: (value) {
                                    final safeValue =
                                        (value.toString().trim().isEmpty)
                                            ? '0'
                                            : value.toString();

                                    widget.handleChangeInput('qty', safeValue);

                                    setState(() {
                                      final input = double.tryParse(
                                            widget.weightDozen.text
                                                .replaceAll('.', '')
                                                .replaceAll(',', '.'),
                                          ) ??
                                          0;
                                      if (input > 0) {
                                        calculateBeratA(input);
                                      }
                                    });
                                    // setState(() {
                                    //   widget.validateQty(safeValue);
                                    // });
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Total packing wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          if (widget.qtyWarning != null)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    widget.qtyWarning ?? '-',
                                                    style: TextStyle(
                                                      color: CustomTheme()
                                                          .colors('warning'),
                                                      fontSize: CustomTheme()
                                                          .fontSize('sm'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ].separatedBy(CustomTheme().hGap('xl')),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextForm(
                                label: 'Berat 1 Lusin (KG)',
                                req: true,
                                isNumber: true,
                                isSorting: true,
                                initialValue: widget.form['weight_per_dozen']
                                        ?.toString() ??
                                    '0',
                                controller: widget.weightDozen,
                                handleChange: (val) {
                                  final safeValue =
                                      (val.toString().trim().isEmpty)
                                          ? '0'
                                          : val.toString();

                                  widget.handleChangeInput(
                                      'weight_per_dozen', safeValue);

                                  setState(() {
                                    final input = double.tryParse(
                                          widget.weightDozen.text
                                              .replaceAll('.', '')
                                              .replaceAll(',', '.'),
                                        ) ??
                                        0;

                                    calculateGsm(input);
                                    calculateBeratA(input);
                                    calculateTotalBerat(input);
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Berat 1 lusin wajib diisi';
                                  }
                                }),
                          ),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ),
                    TemplateCard(
                      title: 'Gramasi & Total Berat',
                      icon: Icons.scale_outlined,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextForm(
                              label: 'Gramasi (GSM)',
                              isDisabled: true,
                              isNumber: true,
                              initialValue:
                                  widget.form['gsm']?.toString() ?? '',
                              controller: widget.gsm,
                              handleChange: (value) {
                                setState(() {
                                  widget.handleChangeInput('gsm', value);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: TextForm(
                              label: 'Berat Grade A (KG)',
                              req: false,
                              isDisabled: true,
                              isNumber: true,
                              initialValue:
                                  widget.form['weight_grade_a']?.toString() ??
                                      '',
                              controller: widget.weightGradeA,
                              handleChange: (value) {
                                setState(() {
                                  widget.handleChangeInput(
                                      'weight_grade_a', value);
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: TextForm(
                              label: 'Total Berat Keseluruhan (KG)',
                              isDisabled: true,
                              isNumber: true,
                              initialValue:
                                  widget.form['total_weight']?.toString() ?? '',
                              controller: widget.totalWeight,
                              handleChange: (value) {
                                setState(() {
                                  widget.handleChangeInput(
                                      'total_weight', value);
                                });
                              },
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                    ),
                  ],
                ),
              AttachmentPicker(
                attachments: widget.allAttachments,
                onAddAttachment: widget.handlePickAttachments,
                onDeleteAttachment: widget.handleDeleteAttachment,
                onPreviewImage: (isNew, filePath) {
                  widget.showImageDialog(context, isNew, filePath);
                },
              ),
              NoteEditor(
                controller: widget.note,
                formKey: 'notes',
                label: 'Catatan',
                form: widget.form,
                onChanged: (value) {
                  widget.handleChangeInput('notes', value);
                },
              )
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        // ],
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

/*
Rework
*/
  Widget _buildReworkReference() {
    final items = [
      {
        'label': 'No. Dyeing',
        'value': widget.processData['rework_reference']?['dyeing_no'] ?? '-',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Tanggal',
        'value': DateFormat("dd MMM yyyy").format(DateTime.parse(
            widget.data['rework_reference']?['start_time'] ??
                DateTime.now().toString())),
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Mesin',
        'value':
            '${widget.processData['rework_reference']?['machine']?['code'] ?? ''} '
                '${widget.processData['rework_reference']?['machine']?['name'] ?? '-'}',
        'icon': Icons.description_outlined,
      },
      {
        'label': 'Qty Hasil Dyeing',
        'value':
            '${formatNumber(widget.processData['rework_reference']?['work_orders']?['greige_qty'])} ${widget.processData['rework_reference']?['work_orders']?['greige_unit']?['code'] ?? ''}',
        'icon': Icons.description_outlined,
      },
    ];

    return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: items.map((item) {
          return Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item['value'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ].separatedBy(CustomTheme().vGap('md')),
                ),
              ],
            ),
          );
        }).toList());
  }

/*
Qty Sorting
*/
  Widget _buildSortingQty() {
    final gradesList = widget.processData['sorting']?['grades'] ?? [];

    double getTotalAdditionalProcess() {
      final data = widget.processData['sorting'];

      if (data == null) return 0;

      final rework = double.tryParse(
            data['rework_long_hemming']?.toString() ?? '0',
          ) ??
          0;

      final spraying = double.tryParse(
            data['spraying']?.toString() ?? '0',
          ) ??
          0;

      final combing = double.tryParse(
            data['combing']?.toString() ?? '0',
          ) ??
          0;

      return rework + spraying + combing;
    }

    final total = getTotalAdditionalProcess();

    // Calculate total quantity
    int totalQty = 0;
    for (var grade in gradesList) {
      final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
      totalQty += qty;
    }

    final grandTotal = totalQty + total;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Loop through grades
        ...gradesList.asMap().entries.map((entry) {
          final grade = entry.value;
          final gradeName = grade['item_grade']['code']?.toString() ?? '-';
          final gradeQty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
          final gradeUnit = grade['unit']?['code']?.toString() ?? '';

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8), // 👈 gap
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade $gradeName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(gradeQty.toString())} $gradeUnit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbaikan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                Text(
                  '${formatNumber(total.toString())} PCS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        // Total
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
                Text(
                  '${formatNumber(grandTotal.toStringAsFixed(0))} ${gradesList.isNotEmpty ? gradesList[0]['unit']['code']?.toString() ?? '' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
