import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/form/text_form_grade.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/helpers/result/to_double.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SortingEditSection extends StatefulWidget {
  final Map form;
  final List grades;
  final List? itemGradeOption;

  final TextEditingController spraying;
  final TextEditingController reworkLongHemming;
  final TextEditingController combing;

  final Function(String, dynamic) onChange;

  final buildMultiTipeUpdate;
  final buildGradeCard;

  final Function() updateTotalSorting;
  final Function() calculateTotalVermak;
  final Function() calculateTotalQtySorting;

  final defectArray;
  final gradeArray;
  final defects;
  final itemTypeOption;
  final finishedItemGood;
  final finishedItemGrb;
  final handleUpdateGrade;
  final defectQty;
  final recalculateGradeBS;
  final data;
  final qty;

  const SortingEditSection(
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
      required this.updateTotalSorting,
      required this.calculateTotalVermak,
      required this.calculateTotalQtySorting,
      this.defectArray,
      this.defects,
      this.itemTypeOption,
      this.finishedItemGood,
      this.finishedItemGrb,
      this.handleUpdateGrade,
      this.defectQty,
      this.gradeArray,
      this.recalculateGradeBS,
      this.data,
      this.qty});

  @override
  State<SortingEditSection> createState() => _SortingEditSectionState();
}

class _SortingEditSectionState extends State<SortingEditSection> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  String getDefectLabel(int i) {
    return widget.itemTypeOption.firstWhere(
          (e) =>
              e['id'].toString() ==
              widget.defectArray[i]['defect_type_id'].toString(),
          orElse: () => {'name': ''},
        )['name'] ??
        '';
  }

  String getGradeLabel(int i) {
    return widget.itemGradeOption?.firstWhere(
          (e) =>
              e['id'].toString() ==
              widget.gradeArray[i]['item_grade_id'].toString(),
          orElse: () => {'name': ''},
        )['name'] ??
        '';
  }

  void _ensureController(int index) {
    while (widget.qty.length <= index) {
      widget.qty.add(TextEditingController(text: '0'));
    }
  }

  void _ensureDefectController(int index) {
    while (widget.defectQty.length <= index) {
      widget.defectQty.add(TextEditingController(text: '0'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ✅ PERBAIKAN
        TemplateCard(
          title: 'Perbaikan',
          icon: Icons.replay_outlined,
          child: Row(
            children: [
              _buildInput('spraying', 'Semprotan', widget.spraying),
              _buildInput('rework_long_hemming', 'Permak Long Hemming',
                  widget.reworkLongHemming),
              _buildInput('combing', 'Sisiran', widget.combing),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ),

        /// ✅ TIPE BS
        _buildMultiTipeUpdate(),

        /// ✅ GRADE
        TemplateCard(
          title: 'Grade Material',
          icon: Icons.grade_outlined,
          child: Column(
            children: [
              if ((widget.itemGradeOption ?? []).isNotEmpty &&
                  widget.grades.length >= widget.itemGradeOption!.length)
                for (int i = 0; i < widget.itemGradeOption!.length; i++)
                  _buildGradeCard(i),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        ),

        /// ✅ SUMMARY
        TemplateCard(
          title: 'Ringkasan Sortir',
          icon: Icons.summarize_outlined,
          child: widget.grades.length >= 3
              ? _buildSummary()
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Loading grades...'),
                ),
        ),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  Widget _buildInput(
      String key, String label, TextEditingController controller) {
    return Expanded(
      child: TextForm(
        label: label,
        isNumber: true,
        isSorting: true,
        controller: controller,
        initialValue: widget.form[key]?.toString() ?? '0',
        handleChange: (value) {
          final safe = value.trim().isEmpty ? '0' : value;

          widget.onChange(key, safe);
          setState(() {});
          widget.updateTotalSorting();
        },
      ),
    );
  }

  Widget _buildSummary() {
    return Row(
      children: [
        _box('Grade A', widget.grades[0]['qty']),
        _box('Grade B', widget.grades[1]['qty']),
        _box('Tipe BS', widget.grades[2]['qty']),
        _box('Perbaikan', widget.calculateTotalVermak()),
        _box('Total', widget.calculateTotalQtySorting()),
      ].separatedBy(const SizedBox(width: 8)),
    );
  }

  Widget _box(String title, dynamic value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text(
              formatNumber(value).toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  if (widget.defectArray.isNotEmpty)
                    ...widget.defectArray.asMap().entries.map((entry) {
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
                                              widget.defectArray.removeAt(i);
                                              if (i < widget.defectQty.length) {
                                                widget.defectQty[i].dispose();
                                                widget.defectQty.removeAt(i);
                                              }
                                              widget.form['defects'] =
                                                  widget.defectArray;
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

  /*
Select Tipe BS
*/
  void _showSelectDefectTypeDialog() {
    final selectedDefectsWithQty = widget.defectArray
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
              maxHeight: MediaQuery.of(context).size.height * 0.5),
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
                                  final exists = widget.defectArray.firstWhere(
                                    (d) =>
                                        d['defect_type_id'].toString() ==
                                        option['id'].toString(),
                                    orElse: () => <String, dynamic>{},
                                  );

                                  if (exists.isEmpty) {
                                    setState(() {
                                      widget.defectArray.add({
                                        'defect_type_id': option['id'],
                                        'qty': '0',
                                      });
                                      widget.defectQty.add(
                                        TextEditingController(text: '0'),
                                      );
                                      widget.form['defects'] =
                                          widget.defectArray;
                                    });
                                  }

                                  Navigator.pop(context);
                                  _showDefectQtyDialog(
                                      widget.defectArray.length - 1);
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

  /*
Input Qty Tipe BS
*/
  void _showDefectQtyDialog(int index) {
    final controller = TextEditingController(
      text: widget.defectArray[index]['qty']?.toString() ?? '0',
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
                              widget.defectArray[index]['qty']?.toString() ??
                                  '0',
                          controller: controller,
                          handleChange: (value) {
                            final safeValue =
                                (value.trim().isEmpty) ? '0' : value;

                            widget.defectArray[index]['qty'] =
                                toDouble(safeValue);
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

                              widget.defectArray[index]['qty'] = cleanValue;
                              widget.defectQty[index].text = cleanValue;

                              widget.form['defects'] = widget.defectArray;

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
    final items = widget.data?['work_orders']?['items'] ?? [];

    _ensureController(i);

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
          SizedBox(width: 12),

          // Produk Jadi Column
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

          // Qty Column
          Expanded(
            flex: 2,
            child: TextFormGrade(
              label: 'Qty (PCS)',
              controller: widget.qty[i],
              initialValue: widget.gradeArray[i]['qty']?.toString() ?? '0',
              isDisabled: i == 2,
              onChanged: (val) {
                setState(() {
                  widget.gradeArray[i]['qty'] = val;
                });

                widget.handleUpdateGrade(i, 'qty', val);
                widget.updateTotalSorting();
              },
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildFinishedItemCompact(List items, int i) {
    final gradeLabel = getGradeLabel(i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gradeLabel == 'A'
              ? widget.finishedItemGood[0]['code']
              : gradeLabel == 'B'
                  ? widget.finishedItemGrb[0]['code']
                  : '-',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          gradeLabel == 'A'
              ? widget.finishedItemGood[0]['label']
              : gradeLabel == 'B'
                  ? widget.finishedItemGrb[0]['label']
                  : '-',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
