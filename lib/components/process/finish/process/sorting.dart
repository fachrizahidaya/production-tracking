import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/to_double.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SortingSection extends StatefulWidget {
  final Map<String, dynamic> form;

  final List<dynamic> grades;
  final List<dynamic>? itemGradeOption;

  final TextEditingController spraying;
  final TextEditingController reworkLongHemming;
  final TextEditingController combing;

  final Function(String key, String value) onChange;

  final buildMultiTipeUpdate;
  final buildGradeCard;

  final defectQty;
  final defects;
  final itemTypeOption;
  final recalculateGradeBS;
  final qtyItem;
  final processData;
  final handleUpdateGrade;
  final finishedItemGrb;
  final finishedItem;
  final woData;

  const SortingSection(
      {super.key,
      required this.form,
      required this.grades,
      required this.itemGradeOption,
      required this.spraying,
      required this.reworkLongHemming,
      required this.combing,
      required this.onChange,
      this.buildMultiTipeUpdate,
      this.buildGradeCard,
      this.defectQty,
      this.defects,
      this.itemTypeOption,
      this.recalculateGradeBS,
      this.qtyItem,
      this.processData,
      this.handleUpdateGrade,
      this.finishedItemGrb,
      this.finishedItem,
      this.woData});

  @override
  State<SortingSection> createState() => _SortingSectionState();
}

class _SortingSectionState extends State<SortingSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  int _parse(dynamic value) {
    if (value == null) return 0;

    final clean = value.toString().replaceAll('.', '').replaceAll(',', '');

    return int.tryParse(clean) ?? 0;
  }

  int _calculateTotalVermak() {
    final spraying = _parse(widget.spraying.text);
    final hemming = _parse(widget.reworkLongHemming.text);
    final combing = _parse(widget.combing.text);

    return spraying + hemming + combing;
  }

  int _calculateTotalQtySorting() {
    int total = 0;

    for (var g in widget.grades) {
      total += _parse(g['qty']);
    }

    return total + _calculateTotalVermak();
  }

  void _handleChange(String key, String value) {
    final safeValue = value.trim().isEmpty ? '0' : value;

    widget.onChange(key, safeValue);
    setState(() {});
  }

  void _ensureDefectController(int index) {
    while (widget.defectQty.length <= index) {
      widget.defectQty.add(TextEditingController(text: '0'));
    }
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

  String getGradeLabel(int i) {
    return widget.itemGradeOption?.firstWhere(
          (e) =>
              e['value'].toString() ==
              widget.grades[i]['item_grade_id'].toString(),
          orElse: () => {'label': ''},
        )['label'] ??
        '';
  }

  void _ensureController(int index) {
    while (widget.qtyItem.length <= index) {
      widget.qtyItem.add(TextEditingController(text: '0'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// =========================
        /// PERBAIKAN
        /// =========================
        TemplateCard(
          title: 'Perbaikan',
          icon: Icons.replay_outlined,
          child: Row(
            children: [
              Expanded(
                child: TextForm(
                  label: 'Semprotan',
                  isNumber: true,
                  controller: widget.spraying,
                  handleChange: (v) => _handleChange('spraying', v),
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Permak Long Hemming',
                  isNumber: true,
                  controller: widget.reworkLongHemming,
                  handleChange: (v) => _handleChange('rework_long_hemming', v),
                ),
              ),
              Expanded(
                child: TextForm(
                  label: 'Sisiran',
                  isNumber: true,
                  controller: widget.combing,
                  handleChange: (v) => _handleChange('combing', v),
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ),

        /// =========================
        /// MULTI TIPE
        /// =========================
        _buildMultiTipeUpdate(),

        /// =========================
        /// GRADE MATERIAL
        /// =========================

        TemplateCard(
          title: 'Grade Material',
          icon: Icons.grade_outlined,
          child: Column(
            children: List.generate(
              widget.itemGradeOption!.length,
              (i) => _buildGradeCard(i),
            ).separatedBy(CustomTheme().vGap('2xl')),
          ),
        ),

        /// =========================
        /// RINGKASAN
        /// =========================
        TemplateCard(
          title: 'Ringkasan Sortir',
          icon: Icons.summarize_outlined,
          child: widget.grades.length >= 3
              ? Row(
                  children: [
                    _summaryBox('Grade A', widget.grades[0]['qty']),
                    _summaryBox('Grade B', widget.grades[1]['qty']),
                    _summaryBox('Tipe BS', widget.grades[2]['qty']),
                    _summaryBox('Perbaikan', _calculateTotalVermak()),
                    _summaryBox('Total', _calculateTotalQtySorting()),
                  ].separatedBy(SizedBox(width: 8)),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Loading grades...'),
                ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _summaryBox(String title, dynamic value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text(
              formatNumber(_parse(value)).toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiTipeUpdate() {
    return TemplateCard(
      title: 'Tipe BS (BS-an)',
      icon: Icons.stop_circle_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LIST TIPE BS (HORIZONTAL)
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 32) / 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  /// ✅ DISPLAY SELECTED DEFECTS
                  if (widget.defects.isNotEmpty)
                    ...widget.defects.asMap().entries.map((entry) {
                      int i = entry.key;
                      var defect = entry.value;

                      _ensureDefectController(i);

                      int parseQty(dynamic value) {
                        if (value == null) return 0;
                        final clean = value
                            .toString()
                            .replaceAll('.', '')
                            .replaceAll(',', '');
                        return int.tryParse(clean) ?? 0;
                      }

                      final defectQty = parseQty(defect['qty']);

                      return SizedBox(
                        width: itemWidth,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (getDefectLabel(i)),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomBadge(
                                    title:
                                        'Qty: ${formatNumber(defectQty).toString()} PCS',
                                    status: 'Selesai',
                                    rework: true,
                                  ),
                                ].separatedBy(CustomTheme().vGap('lg')),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: GestureDetector(
                                      onTap: () => _showDefectQtyDialog(i),
                                      child: Icon(Icons.edit,
                                          color: Colors.blue, size: 32),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showConfirmationDialog(
                                          context: context,
                                          title: 'Hapus Tipe BS',
                                          message:
                                              'Apakah Anda yakin ingin menghapus ${getDefectLabel(i)}?',
                                          isLoading: _isLoading,
                                          buttonBackground: CustomTheme()
                                              .buttonColor('danger'),
                                          onConfirm: () async {
                                            setState(() {
                                              widget.defects.removeAt(i);
                                              if (i < widget.defectQty.length) {
                                                widget.defectQty[i].dispose();
                                                widget.defectQty.removeAt(i);
                                              }
                                              widget.form['defects'] =
                                                  widget.defects;
                                              widget.recalculateGradeBS();
                                            });
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      child: Icon(Icons.close,
                                          color: Colors.red, size: 32),
                                    ),
                                  ),
                                ].separatedBy(CustomTheme().hGap('lg')),
                              )
                            ].separatedBy(CustomTheme().vGap('lg')),
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          ),

          /// ✅ ADD BUTTON (also inline)
          GestureDetector(
            onTap: () => _showSelectDefectTypeDialog(),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('+ Tambah Tipe BS'),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  void _showSelectDefectTypeDialog() {
    final selectedDefectsWithQty = widget.defects
        .where((d) {
          final qty = d['qty'];
          final parsedQty = double.tryParse(qty.toString()) ?? 0;
          return parsedQty > 0;
        })
        .map((d) => d['defect_type_id'].toString())
        .toList();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  'Pilih Tipe BS',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('xl'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    height: 1,
                  ),
                ),
              ),
              Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var option in widget.itemTypeOption ?? [])
                            if (!selectedDefectsWithQty
                                .contains(option['id'].toString()))
                              ListTile(
                                title: Text(option['name'] ?? ''),
                                onTap: () {
                                  final exists = widget.defects.firstWhere(
                                    (d) =>
                                        d['defect_type_id'].toString() ==
                                        option['id'].toString(),
                                    orElse: () => <String, dynamic>{},
                                  );

                                  if (exists.isEmpty) {
                                    setState(() {
                                      widget.defects.add({
                                        'defect_type_id': option['id'],
                                        'qty': '0',
                                      });
                                      widget.defectQty.add(
                                        TextEditingController(text: '0'),
                                      );
                                      widget.form['defects'] = widget.defects;
                                    });
                                  }

                                  Navigator.pop(context);
                                  _showDefectQtyDialog(
                                      widget.defects.length - 1);
                                },
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDefectQtyDialog(int index) {
    final controller = TextEditingController(
      text: widget.defects[index]['qty']?.toString() ?? '0',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.4,
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Text(
                          '${getDefectLabel(index)} - Input Qty',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('xl'),
                            fontWeight: CustomTheme().fontWeight('bold'),
                            height: 1,
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: TextForm(
                          label: 'Qty',
                          req: true,
                          isNumber: true,
                          initialValue:
                              widget.defects[index]['qty']?.toString() ?? '0',
                          controller: controller,
                          handleChange: (value) {
                            final safeValue =
                                (value.trim().isEmpty) ? '0' : value;

                            widget.defects[index]['qty'] = toDouble(safeValue);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: CancelButton(
                          label: 'Batal',
                          onPressed: () => Navigator.pop(context),
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: FormButton(
                          label: 'Simpan',
                          onPressed: () {
                            setState(() {
                              final cleanValue = controller.text
                                  .replaceAll('.', '')
                                  .replaceAll(',', '');

                              widget.defects[index]['qty'] = cleanValue;
                              widget.defectQty[index].text = cleanValue;

                              widget.form['defects'] = widget.defects;

                              widget.recalculateGradeBS();
                            });
                            Navigator.pop(context);
                          },
                          fontSize: CustomTheme().fontSize('xl'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeCard(int i) {
    final gradeLabel = getGradeLabel(i);
    final items = widget.processData?['grades'] ?? [];

    _ensureController(i);

    final isGradeBS = gradeLabel == 'Grade BS';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grade Column
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  gradeLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
              ],
            ),
          ),

          // Produk Jadi hanya tampil selain Grade BS
          // if (!isGradeBS) ...[
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk Jadi',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: CustomTheme().fontWeight('semibold'),
                  ),
                ),
                SizedBox(height: 4),
                _buildFinishedItemCompact(items, i),
              ],
            ),
          ),
          // ],

          SizedBox(width: 12),

          // Qty Column
          Expanded(
            flex: 2,
            child: TextForm(
              label: 'Qty (PCS)',
              req: false,
              isDisabled: i == 2 ? true : false,
              isGrade: true,
              isNumber: true,
              isSorting: true,
              initialValue: widget.grades[i]['qty']?.toString() ?? '0',
              controller: widget.qtyItem[i],
              handleChange: (val) {
                String clean = (val).replaceAll('.', '').replaceAll(',', '');

                if (clean.isEmpty) clean = '0';

                setState(() {
                  widget.grades[i]['qty'] = clean;
                });

                widget.handleUpdateGrade(i, 'qty', clean);
              },
            ),
          ),

          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildFinishedItemCompact(List items, int i) {
    final item = (items.length > i) ? items[i] : null;
    final gradeLabel = getGradeLabel(i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item != null && item['greige_item'] != null
              ? item['greige_item']['code'].toString()
              : gradeLabel == 'Grade BS'
                  ? '-'
                  : gradeLabel == 'Grade B'
                      ? widget.finishedItemGrb[0]['code']
                      : widget.woData['greige_item'] != null
                          ? widget.woData['greige_item']['code']
                          : '-',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          item != null && item['greige_item'] != null
              ? item['greige_item']['name'].toString()
              : gradeLabel == 'Grade BS'
                  ? '-'
                  : gradeLabel == 'Grade B'
                      ? widget.finishedItemGrb[0]['label']
                      : widget.woData['greige_item'] != null
                          ? widget.woData['greige_item']['name']
                          : '-',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
