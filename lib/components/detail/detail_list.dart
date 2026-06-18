// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unnecessary_to_list_in_spreads

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/detail/sorting_detail_grade.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/dyeing/%5Bdyeing_id%5D.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class DetailList extends StatefulWidget {
  final dynamic data;
  final no;
  final String? processType;
  final onRefresh;
  final existingAttachment;
  final existingGrades;
  final handleBuildAttachment;
  final withItemGrade;
  final withQtyAndWeight;
  final withMaklon;
  final label;
  final forDyeing;
  final maklon;
  final handleUpdate;
  final handleDelete;
  final idProcess;
  final processService;
  final forPacking;
  final fetchFinish;
  final handleChangeInput;
  final form;
  final handleSubmit;
  final itemGradeOption;
  final forSewing;
  final forHemming;

  const DetailList(
      {super.key,
      required this.data,
      this.processType,
      this.onRefresh,
      this.existingAttachment,
      this.existingGrades,
      this.handleBuildAttachment,
      this.no,
      this.forDyeing = false,
      this.label,
      this.withItemGrade = false,
      this.withQtyAndWeight = false,
      this.maklon,
      this.withMaklon,
      this.handleUpdate,
      this.handleDelete,
      this.idProcess,
      this.processService,
      this.forPacking,
      this.fetchFinish,
      this.handleChangeInput,
      this.form,
      this.handleSubmit,
      this.itemGradeOption,
      this.forHemming,
      this.forSewing});

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  String capitalizeWords(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final isLargeTablet = constraints.maxWidth > 900;

        return RefreshIndicator(
          onRefresh: () async => widget.onRefresh(),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildWorkOrderInfo(isTablet),

                // Main Content
                if (isTablet)
                  _buildTabletLayout(isLargeTablet)
                else
                  _buildMobileLayout(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(bool isTablet) {
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.no ?? '-',
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: CustomTheme().fontWeight('bold'),
                              color: Colors.grey[800],
                            ),
                          ),
                          if (widget.data['rework'] == true)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomBadge(
                                  withStatus: true,
                                  status: 'Rework',
                                  title: 'Rework',
                                  rework: true,
                                ),
                                CustomBadge(
                                  status: 'Menunggu Diproses',
                                  title: widget.data['rework_reference'] != null
                                      ? widget.data['rework_reference']
                                          ['dyeing_no']
                                      : '-',
                                  rework: true,
                                )
                              ].separatedBy(CustomTheme().hGap('md')),
                            ),
                          if (widget.data['rework_dyeing'] == true &&
                              (widget.label == 'Press' ||
                                  widget.label == 'Tumbler'))
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomBadge(
                                  withStatus: true,
                                  status: 'Rework',
                                  title: 'Rework',
                                  rework: true,
                                ),
                              ].separatedBy(CustomTheme().hGap('md')),
                            ),
                        ].separatedBy(CustomTheme().hGap('xl')),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.data['created_at'] != null
                                ? 'Dibuat pada ${DateFormat("dd MMM yyyy, HH.mm").format(DateTime.parse(widget.data['created_at']).toLocal())}'
                                : '-',
                            style: TextStyle(
                              fontSize: CustomTheme().fontSize('lg'),
                              color: Colors.grey[600],
                              fontWeight: CustomTheme().fontWeight('semibold'),
                            ),
                          ),
                        ].separatedBy(CustomTheme().hGap('sm')),
                      ),
                    ].separatedBy(CustomTheme().vGap('sm')),
                  ),
                ),
                _buildStatusBadge(isTablet),
              ],
            ),
            if (widget.label != 'Long Hemming' &&
                widget.label != 'Cross Cutting' &&
                widget.label != 'Sewing' &&
                widget.label != 'Sorting' &&
                widget.label != 'Embroidery' &&
                widget.label != 'Printing' &&
                widget.label != 'Packing')
              _buildQuickInfoRow(isTablet),
          ].separatedBy(CustomTheme().vGap('xl')),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isTablet) {
    return CustomBadge(
      title: widget.data['status']?.toString() ?? '-',
      withStatus: true,
      status: widget.data['status']?.toString() ?? '-',
    );
  }

  Widget _buildQuickInfoRow(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          if (widget.data['maklon'] == true)
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.business_outlined,
                label: 'Maklon',
                value: widget.data['maklon_name'] ?? '-',
                isTablet: isTablet,
              ),
            ),
          if (widget.data['machine_id'] != null ||
              widget.data['machine']?['name'] != null)
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.local_laundry_service_outlined,
                label: 'Mesin',
                value:
                    '${widget.data['machine']?['code']} - ${widget.data['machine']?['name']}',
                isTablet: isTablet,
              ),
            ),
          if (widget.data['machine_id'] != null) _buildVerticalDivider(false),
          if (widget.data['machine_id'] != null)
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.location_on_outlined,
                label: 'Lokasi',
                value: widget.data['machine']?['location'] ?? '-',
                isTablet: isTablet,
              ),
            ),
          if (widget.forDyeing == true && widget.data['status'] == 'Selesai')
            _buildVerticalDivider(false),
          if (widget.forDyeing == true && widget.data['status'] == 'Selesai')
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.scale_outlined,
                label: 'Qty Hasil ${widget.label}',
                value: widget.data['qty'] != null
                    ? '${formatNumber(widget.data['qty'])} ${widget.data['unit']['code']}'
                    : '0 ${widget.data['unit'] != null ? widget.data['unit']['code'] : ''}',
                isTablet: isTablet,
              ),
            ),
          if (widget.forDyeing == false &&
              widget.data['status'] == 'Selesai' &&
              !([
                'Long Hemming',
                'Cross Cutting',
                'Sewing',
                'Embroidery',
                'Printing'
              ].contains(widget.label)))
            _buildVerticalDivider(false),
          if (widget.forDyeing == false &&
              widget.label != 'Long Hemming' &&
              widget.label != 'Cross Cutting' &&
              widget.label != 'Sewing' &&
              widget.label != 'Embroidery' &&
              widget.label != 'Printing' &&
              widget.data['status'] == 'Selesai')
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.scale_outlined,
                label: 'Berat',
                value: widget.data['weight'] != null
                    ? '${formatNumber(widget.data['weight'])} ${widget.data['weight_unit']['code']}'
                    : '0 ${widget.data['weight_unit'] != null ? widget.data['weight_unit']['code'] : ''}',
                isTablet: isTablet,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: isTablet ? 20 : 18,
          color: CustomTheme().colors('primary'),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('sm'),
            color: Colors.grey[800],
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: isTablet ? 13 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800]),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildVerticalDivider(isWo) {
    return Container(
      width: 1,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: isWo == true
          ? Colors.white.withOpacity(0.2)
          : Colors.grey.withOpacity(0.2),
    );
  }

/*
Work Order
*/
  Widget _buildWorkOrderInfo(bool isTablet) {
    return Padding(
      padding: CustomTheme().padding('content'),
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomTheme().buttonColor('primary'),
              CustomTheme().buttonColor('primary').withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: CustomTheme().buttonColor('primary').withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. WO',
                        style: TextStyle(
                          fontSize: CustomTheme().fontSize('lg'),
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[300],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkOrderDetail(
                                id: widget.data['work_orders']?['id']
                                        .toString() ??
                                    '-',
                              ),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.data['work_orders']?['wo_no'] ?? '-',
                              style: TextStyle(
                                fontSize: isTablet ? 22 : 18,
                                fontWeight: CustomTheme().fontWeight('bold'),
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24,
                              color: Colors.white,
                            )
                          ].separatedBy(CustomTheme().hGap('md')),
                        ),
                      ),
                    ].separatedBy(CustomTheme().vGap('sm')),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.scale_outlined,
                          size: isTablet ? 20 : 18,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Qty Greige',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('sm'),
                            color: Colors.grey[300],
                            fontWeight: CustomTheme().fontWeight('semibold'),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.data['work_orders']?['greige_qty'] != null
                              ? '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']?['code'] ?? ''}'
                              : '-',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('base'),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildVerticalDivider(true),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: isTablet ? 20 : 18,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tanggal WO',
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('sm'),
                            color: Colors.grey[300],
                            fontWeight: CustomTheme().fontWeight('semibold'),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat("dd MMM yyyy").format(DateTime.parse(
                              widget.data['work_orders']['wo_date'])),
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('base'),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ].separatedBy(CustomTheme().vGap('lg')),
        ),
      ),
    );
  }

  /*
Informasi Proses
*/
  Widget _buildProcessInfo(bool isTablet) {
    final items = [
      if (widget.forDyeing == true && widget.data['status'] == 'Selesai')
        {
          'label': 'Qty Hasil ${widget.label}',
          'value': widget.data['qty'] != null
              ? '${formatNumber(widget.data['qty'])} ${widget.data['unit']['code']}'
              : '0 ${widget.data['unit'] != null ? widget.data['unit']['code'] : ''}',
          'icon': Icons.layers_outlined,
        },
      if (widget.label == 'Cross Cutting' || widget.label == 'Sewing')
        {
          'label': 'Qty Material',
          'value': widget.data['item_qty'] != null
              ? '${formatNumber(widget.data['item_qty'])} ${widget.data['item_unit']['code']}'
              : '0 ${widget.data['item_unit'] != null ? widget.data['item_unit']['code'] : ''}',
          'icon': Icons.layers_outlined,
        },
      if (widget.forDyeing == true && widget.data['status'] == 'Selesai')
        {
          'label': 'No. Lot Celup',
          'value': widget.data['lot_celup_no'] != null
              ? '${widget.data['lot_celup_no']}'
              : '-',
          'icon': Icons.invert_colors_on_outlined,
        },
      if (widget.withQtyAndWeight == true && widget.data['status'] == 'Selesai')
        {
          'label': 'Qty Hasil ${widget.label}',
          'value': widget.data['item_qty'] != null
              ? '${formatNumber(widget.data['item_qty'])} ${widget.data['item_unit']['code']}'
              : '0 ${widget.data['item_unit'] != null ? widget.data['item_unit']['code'] : ''}',
          'icon': Icons.layers_outlined,
        },
      if (widget.label == 'Long Hemming')
        {
          'label': 'Berat Bagus',
          'value': widget.data['good_weight'] != null
              ? '${formatNumber(widget.data['good_weight'])} ${widget.data['good_weight_unit']['code']}'
              : '0 ${widget.data['good_weight_unit'] != null ? widget.data['good_weight_unit']['code'] : ''}',
          'icon': Icons.scale_outlined,
        },
      if (widget.label == 'Long Hemming')
        {
          'label': 'Berat BS',
          'value': widget.data['bs_weight'] != null
              ? '${formatNumber(widget.data['bs_weight'])} ${widget.data['bs_weight_unit']['code']}'
              : '0 ${widget.data['bs_weight_unit'] != null ? widget.data['bs_weight_unit']['code'] : ''}',
          'icon': Icons.scale_outlined,
        },
      if (widget.data['status'] == 'Selesai' &&
          (widget.forDyeing == false &&
              widget.label != 'Long Hemming' &&
              widget.label != 'Cross Cutting' &&
              widget.label != 'Sewing'))
        {
          'label': 'Berat',
          'value': widget.data['weight'] != null
              ? '${formatNumber(widget.data['weight'])} ${widget.data['weight_unit']['code']}'
              : '0 ${widget.data['weight_unit'] != null ? widget.data['weight_unit']['code'] : ''}',
          'icon': Icons.scale_outlined,
        },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /*
Grades
*/

  /*
Ringkasan Sorting
*/
  Widget _buildTotalSorting(bool isTablet) {
    /// 📊 Calculate Total Perbaikan Long Hemming (spraying + combing + rework)
    int totalVermak = 0;
    totalVermak += int.tryParse(widget.label == 'Packing'
            ? widget.data['sorting']['rework_long_hemming']?.toString() ?? '0'
            : widget.data['rework_long_hemming']?.toString() ?? '0') ??
        0;
    totalVermak += int.tryParse(widget.label == 'Packing'
            ? widget.data['sorting']['combing']?.toString() ?? '0'
            : widget.data['combing']?.toString() ?? '0') ??
        0;
    totalVermak += int.tryParse(widget.label == 'Packing'
            ? widget.data['sorting']['spraying']?.toString() ?? '0'
            : widget.data['spraying']?.toString() ?? '0') ??
        0;

    /// 📊 Calculate Total Qty Sorting (sum of all grades + vermak)
    int totalRepair = 0;

    int totalGradeA = 0;
    int totalGradeB = 0;
    int totalGradeBS = 0;

    final grades = widget.data['grades'] ?? [];

    for (final grade in grades) {
      final String code =
          (grade['item_grade']?['code'] ?? '').toString().toUpperCase();

      final List items = grade['items'] ?? [];

      for (final item in items) {
        final int qty = parseSafe(
          item['qty'],
        ).toInt();

        if (code == 'A') {
          totalGradeA += qty;
        } else if (code == 'B') {
          totalGradeB += qty;
        } else if (code == 'BS') {
          final List defects = item['defects'] ?? [];

          final int totalDefects = defects.fold<int>(
            0,
            (int sum, defect) {
              final int defectQty = parseSafe(
                defect['qty'],
              ).toInt();

              return sum + defectQty;
            },
          );

          totalGradeBS += totalDefects;
        }

        final int spraying = parseSafe(
          item['spraying'],
        ).toInt();

        final int rework = parseSafe(
          item['rework_long_hemming'],
        ).toInt();

        final int combing = parseSafe(
          item['combing'],
        ).toInt();

        totalRepair += spraying + rework + combing;
      }
    }

    final totalSorting = totalGradeA + totalGradeB + totalGradeBS + totalRepair;

    return Row(
      children: [
        _buildSummaryItem(
          'Grade A',
          totalGradeA,
        ),
        _buildSummaryItem(
          'Grade B',
          totalGradeB,
        ),
        _buildSummaryItem(
          'Tipe BS',
          totalGradeBS,
        ),
        _buildSummaryItem(
          'Perbaikan',
          totalRepair,
        ),
        _buildSummaryItem(
          'Hasil Sortir',
          totalSorting,
        ),
      ].separatedBy(
        SizedBox(width: 12),
      ),
    );
  }

  Widget _buildSummaryItem(
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
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
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

/*
Info Material
*/
  Widget _buildMaterialInfo(bool isTablet) {
    final bool isDyeing = widget.label == 'Dyeing';

    if (isDyeing) {
      final semiFinishedProducts = List<Map<String, dynamic>>.from(
        widget.data['semifinished_products'] ?? [],
      );

      if (semiFinishedProducts.isEmpty) {
        return NoData();
      }

      final items = semiFinishedProducts.map((item) {
        return {
          'label': 'Produk Setengah Jadi',
          'value': item['code'] ?? '-',
          'another_value': item['name'] ?? '-',
          'spk_no': item['spk_no'] ?? '-',
          'icon': Icons.inventory_2_outlined,
          'is_product': true,
        };
      }).toList();

      return _buildMultiInfoGrid(items, isTablet);
    }

    final items = List<Map<String, dynamic>>.from(
      widget.data['items'] ?? [],
    );

    if (items.isEmpty) {
      return NoData();
    }

    final woItems = List<Map<String, dynamic>>.from(
      widget.data['work_orders']?['items'] ?? [],
    );

    final mappedItems = items.map((item) {
      final semiFinished = item['semifinished_product'];
      final finished = item['finished_product'];

      final bool isPacking = widget.label == 'Packing';

      final product = isPacking ? finished : semiFinished;

      String spkNo = '-';

      final woItemId = item['wo_item_id'];

      final matchedWo = woItems.cast<Map<String, dynamic>>().firstWhere(
            (e) => e['id'] == woItemId,
            orElse: () => <String, dynamic>{},
          );

      spkNo = matchedWo['spk_no']?.toString() ?? '-';

      return {
        'label': isPacking ? 'Produk Jadi' : 'Produk Setengah Jadi',
        'value': product?['code'] ?? '-',
        'another_value': product?['name'] ?? '-',
        'spk_no': spkNo,
        'icon': Icons.inventory_2_outlined,
        'is_product': true,
      };
    }).toList();

    return _buildMultiInfoGrid(mappedItems, isTablet);
  }

/*
Rework
*/
  Widget _buildReworkInfo(bool isTablet) {
    final items = [
      {
        'label': 'Referensi Dyeing',
        'value': widget.data['rework_reference'] != null
            ? widget.data['rework_reference']['dyeing_no']
            : '-',
        'icon': Icons.paste_outlined,
        'navigate': () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DyeingDetail(
                  id: widget.data['rework_reference_id'].toString(),
                  no: widget.data['rework_reference']['dyeing_no'].toString(),
                  canDelete: false,
                  canUpdate: false,
                ),
              ));
        },
        'right-icon': Icons.chevron_right_outlined,
      },
      {
        'label': 'Qty Referensi',
        'value': widget.data['rework_reference']['qty'] != null
            ? '${formatNumber(widget.data['rework_reference']['qty'])} ${widget.data['rework_reference']['unit']['code']}'
            : '0 ${widget.data['unit'] != null ? widget.data['rework_reference']['unit']['code'] : ''}',
        'icon': Icons.layers_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /*
Multi Mesin
*/
  Widget _buildMachine(bool isTablet) {
    final machines = widget.data['machines'] as List? ?? [];

    if (machines.isEmpty) return NoData();

    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 16,
      runSpacing: 16,
      children: machines.map((machine) {
        return Container(
            width: machines.length > 1
                ? (MediaQuery.of(context).size.width - 80) / 2
                : double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (machine['machine'] != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${machine['machine']['code']} - ${machine['machine']['name']}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Lokasi: ${machine['location']}',
                          ),
                        ],
                      ),
                      CustomBadge(
                        title: machine['status'],
                        rework: true,
                        status: machine['status'] == 'Selesai'
                            ? 'Selesai'
                            : 'Diproses',
                        withStatus: true,
                      )
                    ],
                  ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mulai: ${machine['start_time'] != null ? DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(machine['start_time']).toLocal()) : '-'}',
                    ),
                    Text(
                      'Selesai: ${machine['end_time'] != null ? DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(machine['end_time']).toLocal()) : '-'}',
                    ),
                  ],
                ),
              ],
            ));
      }).toList(),
    );
  }

/*
Perbaikan >> Sorting
*/

/*
Tipe BS
*/

/*
Berat >> Packing
*/

  /*
Timeline
*/
  Widget _buildTimelineInfo(bool isTablet) {
    return Column(
      children: [
        _buildTimelineItem(
          icon: Icons.access_time_outlined,
          iconColor: Colors.blue,
          title: 'Mulai Proses',
          time: widget.data['start_time'],
          user: widget.data['start_by']?['name'],
          isFirst: true,
          isLast: widget.data['end_time'] == null,
        ),
        if (widget.data['end_time'] != null)
          _buildTimelineItem(
            icon: Icons.task_alt_outlined,
            iconColor: Colors.green,
            title: 'Selesai Proses',
            time: widget.data['end_time'],
            user: widget.data['end_by']?['name'],
            isFirst: false,
            isLast: true,
          ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    dynamic time,
    String? user,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey[300],
                    ),
                  ),
              ],
            ),
          ),
          // Timeline Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      Text(
                        time != null
                            ? DateFormat("dd MMM yyyy, HH:mm")
                                .format(DateTime.parse(time))
                            : '-',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('md')),
                  ),
                  if (user != null && user.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        Text(
                          user,
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('sm'),
                            color: Colors.grey[600],
                          ),
                        ),
                      ].separatedBy(CustomTheme().hGap('md')),
                    ),
                  ],
                ].separatedBy(CustomTheme().vGap('md')),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

/*
Lampiran
*/
  Widget _buildAttachment(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: widget.existingAttachment.isEmpty
              ? NoData()
              : Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: widget.handleBuildAttachment(context),
                ),
        ),
      ],
    );
  }

/*
Material WO
*/
  Widget _buildMaterial(bool isTablet) {
    final items = (widget.data['work_orders']['items'] ?? [])
        .cast<Map<String, dynamic>>();

    if (items.isEmpty) {
      return Center(child: Text('No Data'));
    }

    return Column(
      children: List.generate(items.length, (index) {
        return Column(
          children: [
            ListItem(
              item: items[index],
              withSpk: true,
            ),
            if (index != items.length - 1) SizedBox(height: 12),
          ].separatedBy(CustomTheme().vGap('xl')),
        );
      }),
    );
  }

  /*
Catatan
*/
  Widget _buildNote(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: widget.data['notes'] != null
              ? Text(
                  htmlToPlainText(widget.data['notes']),
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                  ),
                )
              : NoData(),
        ),
      ],
    );
  }

/*
Catatan WO
*/
  Widget _buildNoteWo(bool isTablet) {
    return widget.data['work_orders']['notes'] != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  htmlToPlainText(widget.data['work_orders']['notes']),
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                  ),
                ),
              ),
            ],
          )
        : NoData();
  }

  Widget _buildItemResultPerProduct(bool isTablet) {
    final items = List<Map<String, dynamic>>.from(
      widget.data['items'] ?? [],
    );

    if (items.isEmpty) {
      return NoData();
    }

    final bool isLongHemming = widget.label == 'Long Hemming';

    final bool isQtyProcess =
        widget.label == 'Cross Cutting' || widget.label == 'Sewing';

    final bool isPacking = widget.label == 'Packing';

    String getSpkNo(Map<String, dynamic> item) {
      final woItemId = item['wo_item_id'];

      try {
        final matched = widget.data['work_orders']?['items'].firstWhere(
          (e) => e['id'] == woItemId,
        );

        return matched['spk_no']?.toString() ?? '-';
      } catch (_) {
        return '-';
      }
    }

    Widget buildItem(dynamic item) {
      final semiFinished = item['semifinished_product'];

      final finished = item['finished_product'];

      final goodWeight = double.tryParse(
            item['good_weight']?.toString() ?? '0',
          ) ??
          0;

      final bsWeight = double.tryParse(
            item['bs_weight']?.toString() ?? '0',
          ) ??
          0;

      final qty = double.tryParse(
            item['qty']?.toString() ?? '0',
          ) ??
          0;

      final weight = double.tryParse(
            item['weight_grade_a']?.toString() ?? '0',
          ) ??
          0;

      final totalWeight = double.tryParse(
            item['total_weight']?.toString() ?? '0',
          ) ??
          0;

      final weightPerDozen = double.tryParse(
            item['weight_per_dozen']?.toString() ?? '0',
          ) ??
          0;

      final gsm = double.tryParse(
            item['gsm']?.toString() ?? '0',
          ) ??
          0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Semi Finished
          if (semiFinished != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label != 'Packing')
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.shade100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Produk Setengah Jadi',
                            style: TextStyle(
                              fontWeight: CustomTheme().fontWeight(
                                'semibold',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            semiFinished['code'] ?? '-',
                          ),
                          Text(
                            semiFinished['name'] ?? '-',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                /// Finished Product
                if (finished != null)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.shade100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Produk Jadi',
                            style: TextStyle(
                              fontWeight: CustomTheme().fontWeight(
                                'semibold',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            finished['code'] ?? '-',
                          ),
                          Text(
                            finished['name'] ?? '-',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.shade100,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No. SPK',
                          style: TextStyle(
                            fontWeight: CustomTheme().fontWeight(
                              'semibold',
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getSpkNo(item) ?? '-',
                        ),
                      ],
                    ),
                  ),
                ),

                /// CROSS CUTTING / SEWING
                if (isQtyProcess)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Qty Hasil',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${formatNumber(qty)} PCS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: CustomTheme().fontWeight('bold'),
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),

          /// LONG HEMMING
          if (isLongHemming)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Berat Bagus',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${formatNumber(goodWeight)} KG',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: CustomTheme().fontWeight('bold'),
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Berat BS',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${formatNumber(bsWeight)} KG',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: CustomTheme().fontWeight('bold'),
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          /// PACKING
          if (isPacking)
            Column(
              children: [
                Row(
                  children: [
                    if (isPacking)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(
                            12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hasil Packing',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${formatNumber(qty)} PCS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: CustomTheme().fontWeight('bold'),
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (isPacking)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(
                            12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gramasi',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${formatNumber(gsm)} GSM',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: CustomTheme().fontWeight('bold'),
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(
                          12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Berat per Lusin',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${formatNumber(weightPerDozen)} KG',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: CustomTheme().fontWeight('bold'),
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(
                          12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Berat Grade A',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${formatNumber(weight)} KG',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: CustomTheme().fontWeight('bold'),
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Berat',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${formatNumber(totalWeight)} KG',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: CustomTheme().fontWeight('bold'),
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ].separatedBy(CustomTheme().hGap('xl')),
                ),
              ].separatedBy(
                CustomTheme().vGap('xl'),
              ),
            ),
        ].separatedBy(
          CustomTheme().vGap('xl'),
        ),
      );
    }

    /// SINGLE ITEM
    if (items.length == 1) {
      return buildItem(items.first);
    }

    /// MULTIPLE ITEMS
    return DefaultTabController(
      length: items.length,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
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
                tabs: items.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Tab(
                        text: 'Item ${index + 1}',
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          SizedBox(
            height: isPacking
                ? 250
                : widget.label == 'Long Hemming'
                    ? 250
                    : 150,
            child: TabBarView(
              children: items.map((item) {
                return buildItem(item);
              }).toList(),
            ),
          ),
        ].separatedBy(
          CustomTheme().vGap('lg'),
        ),
      ),
    );
  }

  /// Layout untuk Tablet
  Widget _buildTabletLayout(bool isLargeTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(true),
        if (widget.label == 'Long Hemming' ||
            widget.label == 'Cross Cutting' ||
            widget.label == 'Sewing')
          _buildInfoCard(
            title: 'Informasi Mesin',
            icon: Icons.local_laundry_service_outlined,
            child: _buildMachine(true),
          ),
        if (widget.forDyeing == false &&
            widget.withItemGrade == false &&
            widget.label != 'Dyeing' &&
            widget.label != 'Press' &&
            widget.label != 'Tumbler' &&
            widget.label != 'Stenter' &&
            widget.label != 'Long Slitting' &&
            widget.label != 'Long Hemming' &&
            widget.label != 'Cross Cutting' &&
            widget.label != 'Sewing' &&
            widget.label != 'Embroidery' &&
            widget.label != 'Printing')
          _buildInfoCard(
            title: 'Informasi Proses',
            icon: Icons.settings_outlined,
            child: _buildProcessInfo(true),
          ),
        if (widget.data['rework'] == true)
          _buildInfoCard(
            title: 'Informasi Rework',
            icon: Icons.replay_outlined,
            child: _buildReworkInfo(true),
          ),
        if (widget.label == 'Packing')
          _buildInfoCard(
            title: 'Informasi Packing',
            icon: Icons.inventory_2_outlined,
            child: _buildPackingSummaryInfo(),
          ),
        if (widget.label == 'Sorting')
          Padding(
            padding: CustomTheme().padding('card'),
            child: SortingDetailGradeList(sortingData: widget.data),
          ),
        if (widget.label == 'Sorting')
          _buildInfoCard(
            title: 'Total Sortir',
            icon: Icons.attachment_outlined,
            child: _buildTotalSorting(true),
          ),
        if ((widget.label == 'Dyeing'))
          _buildInfoCard(
            title: 'Produk Setengah Jadi',
            icon: Icons.inventory_2_outlined,
            child: _buildMaterialInfo(true),
          ),
        if (widget.label == 'Long Hemming' ||
            widget.label == 'Cross Cutting' ||
            widget.label == 'Sewing' ||
            widget.label == 'Packing')
          _buildInfoCard(
            title: 'Detail Per Material',
            icon: Icons.scale_outlined,
            child: _buildItemResultPerProduct(true),
          ),
        _buildInfoCard(
          title: 'Material WO',
          icon: Icons.inventory_2_outlined,
          child: _buildMaterial(true),
        ),
        _buildInfoCard(
          title: 'Catatan ${widget.label}',
          icon: Icons.note_outlined,
          child: _buildNote(true),
        ),
        _buildInfoCard(
          title: 'Lampiran',
          icon: Icons.attachment_outlined,
          child: _buildAttachment(true),
        ),
        _buildInfoCard(
          title: 'Catatan Work Order',
          icon: Icons.note_outlined,
          child: _buildNoteWo(true),
        ),
        _buildInfoCard(
          title: 'Timeline Proses',
          icon: Icons.timeline_outlined,
          child: _buildTimelineInfo(true),
        ),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  /// Layout untuk Mobile
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(false),
        if (widget.label == 'Long Hemming' ||
            widget.label == 'Cross Cutting' ||
            widget.label == 'Sewing')
          _buildInfoCard(
            title: 'Informasi Mesin',
            icon: Icons.local_laundry_service_outlined,
            child: _buildMachine(false),
          ),
        if (widget.forDyeing == false &&
            widget.withItemGrade == false &&
            widget.label != 'Dyeing' &&
            widget.label != 'Press' &&
            widget.label != 'Tumbler' &&
            widget.label != 'Stenter' &&
            widget.label != 'Long Slitting' &&
            widget.label != 'Long Hemming' &&
            widget.label != 'Cross Cutting' &&
            widget.label != 'Sewing' &&
            widget.label != 'Embroidery' &&
            widget.label != 'Printing')
          _buildInfoCard(
            title: 'Informasi Proses',
            icon: Icons.settings_outlined,
            child: _buildProcessInfo(false),
          ),
        if (widget.data['rework'] == true)
          _buildInfoCard(
            title: 'Informasi Rework',
            icon: Icons.replay_outlined,
            child: _buildReworkInfo(false),
          ),
        if (widget.label == 'Packing')
          _buildInfoCard(
            title: 'Informasi Packing',
            icon: Icons.inventory_2_outlined,
            child: _buildPackingSummaryInfo(),
          ),
        if (widget.label == 'Sorting')
          Padding(
            padding: CustomTheme().padding('card'),
            child: SortingDetailGradeList(sortingData: widget.data),
          ),
        if (widget.label == 'Sorting')
          _buildInfoCard(
            title: 'Total Sortir',
            icon: Icons.attachment_outlined,
            child: _buildTotalSorting(false),
          ),
        if ((widget.label == 'Dyeing'))
          _buildInfoCard(
            title: 'Produk Setengah Jadi',
            icon: Icons.inventory_2_outlined,
            child: _buildMaterialInfo(false),
          ),
        if (widget.label == 'Long Hemming' ||
            widget.label == 'Cross Cutting' ||
            widget.label == 'Sewing' ||
            widget.label == 'Packing')
          _buildInfoCard(
            title: 'Detail Per Material',
            icon: Icons.scale_outlined,
            child: _buildItemResultPerProduct(false),
          ),
        _buildInfoCard(
          title: 'Material WO',
          icon: Icons.inventory_2_outlined,
          child: _buildMaterial(false),
        ),
        _buildInfoCard(
          title: 'Catatan ${widget.label}',
          icon: Icons.note_outlined,
          child: _buildNote(false),
        ),
        _buildInfoCard(
          title: 'Lampiran',
          icon: Icons.attachment_outlined,
          child: _buildAttachment(false),
        ),
        _buildInfoCard(
          title: 'Catatan Work Order',
          icon: Icons.note_outlined,
          child: _buildNoteWo(false),
        ),
        _buildInfoCard(
          title: 'Timeline Proses',
          icon: Icons.timeline_outlined,
          child: _buildTimelineInfo(false),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: TemplateCard(
        title: title,
        icon: icon,
        child: child,
      ),
    );
  }

  /// Info Grid Builder
  Widget _buildInfoGrid(List<Map<String, dynamic>> items, bool isTablet) {
    final int totalRework = (widget.data['rework_long_hemming'] ?? 0) +
        (widget.data['combing'] ?? 0) +
        (widget.data['spraying'] ?? 0);

    if (isTablet) {
      return Column(
        children: [
          items.length > 3
              ? Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: items.map((item) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 90) / 3,
                      child: _buildInfoItem(
                          label: item['label'],
                          value: item['value'],
                          icon: item['icon'],
                          id: item['id'].toString(),
                          isTablet: isTablet,
                          navigateTo: item['navigate'],
                          rightIcon: item['right-icon']),
                    );
                  }).toList(),
                )
              : Row(
                  spacing: 16,
                  children: items.map((item) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 100) / 4,
                      child: _buildInfoItem(
                          label: item['label'],
                          value: item['value'],
                          icon: item['icon'],
                          id: item['id'].toString(),
                          isTablet: isTablet,
                          navigateTo: item['navigate'],
                          rightIcon: item['right-icon']),
                    );
                  }).toList()),
          SizedBox(height: 8),
          if (widget.label == 'Sorting' &&
              items[0]['label'] == 'Semprotan' &&
              totalRework > 0)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total Perbaikan: ${formatNumber(totalRework)} PCS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            )
        ],
      );
    }

    return Column(
      children: items
          .map((item) => _buildInfoItem(
              label: item['label'],
              value: item['value'],
              id: item['id'].toString(),
              icon: item['icon'],
              isTablet: isTablet,
              navigateTo: item['navigate'],
              rightIcon: item['right-icon']))
          .toList(),
    );
  }

  /// Info Grid Builder
  Widget _buildMultiInfoGrid(List<Map<String, dynamic>> items, bool isTablet) {
    if (isTablet) {
      return items.length > 2
          ? Wrap(
              spacing: 16,
              runSpacing: 16,
              children: items.map((item) {
                return SizedBox(
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    child: _buildMultiInfoItem(
                      label: item['label'],
                      value: item['value'],
                      anotherValue: item['another_value'],
                      spkNo: item['spk_no'],
                      icon: item['icon'],
                      id: item['id'].toString(),
                      isTablet: isTablet,
                      navigateTo: item['navigate'],
                      rightIcon: item['right-icon'],
                      isProduct: item['is_product'] ?? false,
                      isGrade: item['is_grade'] ?? false,
                      nameValue: item['name_value'],
                    ));
              }).toList(),
            )
          : Row(
              spacing: 16,
              children: items.map((item) {
                return SizedBox(
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    child: _buildMultiInfoItem(
                      label: item['label'],
                      value: item['value'],
                      anotherValue: item['another_value'],
                      spkNo: item['spk_no'],
                      icon: item['icon'],
                      id: item['id'].toString(),
                      isTablet: isTablet,
                      navigateTo: item['navigate'],
                      rightIcon: item['right-icon'],
                      isProduct: item['is_product'] ?? false,
                      isGrade: item['is_grade'] ?? false,
                      nameValue: item['name_value'],
                    ));
              }).toList());
    }

    return Column(
      children: items
          .map((item) => _buildInfoItem(
              label: item['label'],
              value: item['value'],
              id: item['id'].toString(),
              icon: item['icon'],
              isTablet: isTablet,
              navigateTo: item['navigate'],
              rightIcon: item['right-icon']))
          .toList(),
    );
  }

  /// Single Info Item
  Widget _buildInfoItem(
      {required String label,
      required String value,
      required String id,
      required IconData icon,
      required bool isTablet,
      navigateTo,
      rightIcon,
      qty,
      withQty = false}) {
    return GestureDetector(
      onTap: navigateTo,
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (label == 'No. Work Order' &&
                          widget.data['work_orders']['urgent'] == true)
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 14,
                        ),
                      if (withQty == true)
                        Text(
                          '(${qty != null ? formatNumber(qty) : '0'})',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ].separatedBy(CustomTheme().hGap('sm')),
                  ),
                ].separatedBy(CustomTheme().vGap('sm')),
              ),
            ),
            if (navigateTo != null)
              Icon(
                rightIcon,
                size: isTablet ? 18 : 16,
              ),
          ].separatedBy(CustomTheme().hGap('md')),
        ),
      ),
    );
  }

  /// Multi Info Item
  Widget _buildMultiInfoItem({
    required String label,
    required String value,
    required String anotherValue,
    required String id,
    required IconData icon,
    required bool isTablet,
    navigateTo,
    rightIcon,
    isProduct,
    isGrade,
    nameValue,
    String? spkNo,
  }) {
    return GestureDetector(
      onTap: navigateTo,
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 12 : 11,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.label != 'Sorting')
                          Text(
                            anotherValue,
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 13,
                              color: isProduct
                                  ? Colors.grey[600]
                                  : Colors.grey[800],
                              fontWeight: CustomTheme().fontWeight('semibold'),
                            ),
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                      ],
                    ),
                    if ((spkNo ?? '').isNotEmpty)
                      CustomBadge(
                        status: 'Rework',
                        title: spkNo.toString(),
                        rework: true,
                      ),
                  ],
                ),
              ],
            ),
            if (label == 'Grade A' || label == 'Grade B')
              Text(
                'Produk Jadi',
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (label == 'Grade A' || label == 'Grade B')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anotherValue,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 13,
                      color: isProduct ? Colors.grey[600] : Colors.grey[800],
                      fontWeight: CustomTheme().fontWeight('semibold'),
                    ),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    nameValue,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 13,
                      color: isProduct ? Colors.grey[600] : Colors.grey[600],
                      fontWeight: CustomTheme().fontWeight('semibold'),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
          ].separatedBy(CustomTheme().vGap('sm')),
        ),
      ),
    );
  }

  Widget _buildPackingSummaryInfo() {
    final items = widget.data['items'] ?? [];

    double totalPacking = 0;
    double totalWeight = 0;

    for (final item in items) {
      totalPacking += parseSafe(item['qty']);

      totalWeight += parseSafe(item['total_weight']);
    }

    return Row(
      children: [
        Expanded(
          child: _buildPackingInfoCard(
            title: 'Total Packing',
            value: formatNumber(totalPacking),
            subtitle: 'PCS',
            icon: Icons.inventory_2_outlined,
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: _buildPackingInfoCard(
            title: 'Total Berat',
            value: formatNumber(totalWeight),
            subtitle: 'KG',
            icon: Icons.scale_outlined,
            color: Colors.green,
          ),
        ),
      ].separatedBy(
        CustomTheme().hGap('xl'),
      ),
    );
  }

  Widget _buildPackingInfoCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: CustomTheme().fontWeight(
                          'bold',
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 3,
                      ),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
