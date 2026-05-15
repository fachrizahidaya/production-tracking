// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, unnecessary_to_list_in_spreads

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
            if (widget.label != 'Sorting' && widget.label != 'Packing')
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
          if (widget.forDyeing == true && widget.data['status'] == 'Selesai')
            _buildVerticalDivider(false),
          if (widget.forDyeing == true && widget.data['status'] == 'Selesai')
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.invert_colors_on_outlined,
                label: 'No. Lot Celup',
                value: widget.data['lot_celup_no'] != null
                    ? '${widget.data['lot_celup_no']}'
                    : '-',
                isTablet: isTablet,
              ),
            ),
          if (widget.forDyeing == false &&
              widget.data['status'] == 'Selesai' &&
              !(['Long Hemming', 'Cross Cutting', 'Sewing']
                  .contains(widget.label)))
            _buildVerticalDivider(false),
          if (widget.forDyeing == false &&
              widget.label != 'Long Hemming' &&
              widget.label != 'Cross Cutting' &&
              widget.label != 'Sewing' &&
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
          if (widget.label == 'Long Hemming')
            Expanded(
                child: _buildQuickInfoItem(
                    icon: Icons.thumb_up_outlined,
                    label: 'Berat Bagus',
                    value: widget.data['good_weight'] != null
                        ? '${formatNumber(widget.data['good_weight'])} ${widget.data['good_weight_unit']['code']}'
                        : '0 ${widget.data['good_weight_unit'] != null ? widget.data['good_weight_unit']['code'] : ''}',
                    isTablet: isTablet)),
          if (widget.label == 'Long Hemming') _buildVerticalDivider(false),
          if (widget.label == 'Long Hemming')
            Expanded(
                child: _buildQuickInfoItem(
                    icon: Icons.thumb_down_outlined,
                    label: 'Berat BS',
                    value: widget.data['bs_weight'] != null
                        ? '${formatNumber(widget.data['bs_weight'])} ${widget.data['bs_weight_unit']['code']}'
                        : '0 ${widget.data['bs_weight_unit'] != null ? widget.data['bs_weight_unit']['code'] : ''}',
                    isTablet: isTablet)),
          if (widget.label == 'Cross Cutting' || widget.label == 'Sewing')
            Expanded(
                child: _buildQuickInfoItem(
                    icon: Icons.numbers_outlined,
                    label: 'Qty Material',
                    value: widget.data['item_qty'] != null
                        ? '${formatNumber(widget.data['item_qty'])} ${widget.data['item_unit']['code']}'
                        : '0 ${widget.data['item_unit'] != null ? widget.data['item_unit']['code'] : ''}',
                    isTablet: isTablet)),
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
  Widget _buildGradeInfo(bool isTablet) {
    final items = widget.data['work_orders']?['items'] ?? [];
    final codeGradeA = widget.data['grades'][0]['greige_item']['code'];
    final nameGradeA = widget.data['grades'][0]['greige_item']['name'];
    final codeGradeB = widget.data['grades'][1]['greige_item']['code'];
    final nameGradeB = widget.data['grades'][1]['greige_item']['name'];

    final gradeItems = [
      for (int i = 0; i < widget.existingGrades.length; i++)
        {
          'label': 'Grade ${widget.existingGrades[i]['item_grade']['code']}',
          'value': widget.existingGrades[i]['qty'] != null
              ? '${formatNumber(widget.existingGrades[i]['qty'])} ${widget.existingGrades[i]['unit']['code']}'
              : '-',
          'another_value': widget.label == 'Sorting' &&
                  widget.existingGrades[i]['item_grade']['code'] == 'A'
              ? codeGradeA
              : widget.label == 'Sorting' &&
                      widget.existingGrades[i]['item_grade']['code'] == 'B'
                  ? codeGradeB
                  : i < items.length
                      ? '${items[i]['item_code'] ?? '-'}'
                      : '',
          'name_value': widget.label == 'Sorting' &&
                  widget.existingGrades[i]['item_grade']['code'] == 'A'
              ? nameGradeA
              : widget.label == 'Sorting' &&
                      widget.existingGrades[i]['item_grade']['code'] == 'B'
                  ? nameGradeB
                  : i < items.length
                      ? '${items[i]['item_name'] ?? '-'}'
                      : '',
          'icon': Icons.grade_outlined,
          'isGrade': true,
        },
    ];

    return _buildMultiInfoGrid(gradeItems, isTablet);
  }

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
    int totalGrades = 0;
    int gradeAQty = 0;
    int gradeBQty = 0;
    int gradeBSQty = 0;

    if (widget.existingGrades != null && widget.existingGrades.isNotEmpty) {
      for (var grade in widget.existingGrades) {
        final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
        totalGrades += qty;

        final gradeName =
            grade['item_grade']['code']?.toString().toLowerCase() ?? '';
        if (gradeName.contains('a')) {
          gradeAQty = qty;
        } else if (gradeName.contains('b') && !gradeName.contains('bs')) {
          gradeBQty = qty;
        } else if (gradeName.contains('bs')) {
          gradeBSQty = qty;
        }
      }
    }

    if (widget.data['sorting'] != null && widget.data['sorting'].isNotEmpty) {
      for (var grade in widget.data['sorting']['grades']) {
        final qty = int.tryParse(grade['qty']?.toString() ?? '0') ?? 0;
        totalGrades += qty;

        final gradeName =
            grade['item_grade']['code']?.toString().toLowerCase() ?? '';
        if (gradeName.contains('a')) {
          gradeAQty = qty;
        } else if (gradeName.contains('b') && !gradeName.contains('bs')) {
          gradeBQty = qty;
        } else if (gradeName.contains('bs')) {
          gradeBSQty = qty;
        }
      }
    }

    int totalQtySorting = totalGrades + totalVermak;

    return Row(
      children: [
        // Grade A
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade A',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatNumber(gradeAQty),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      'PCS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[600]),
                    ),
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        // Grade B
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade B',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatNumber(gradeBQty),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      'PCS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[600]),
                    ),
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        // Grade BS
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe BS (BS-an)',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatNumber(gradeBSQty),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      'PCS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[600]),
                    ),
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        // Perbaikan
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perbaikan',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatNumber(totalVermak),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      'PCS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[600]),
                    ),
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        // Hasil Sortir
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil Sortir',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formatNumber(totalQtySorting),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'PCS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: CustomTheme().fontWeight('semibold'),
                          color: Colors.grey[600]),
                    ),
                  ].separatedBy(
                    CustomTheme().hGap('md'),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

/*
Info Material
*/
  Widget _buildMaterialInfo(bool isTablet) {
    final items = [
      {
        'label':
            widget.label == 'Packing' ? 'Produk Jadi' : 'Produk Setengah Jadi',
        'value':
            '${widget.data['greige_item']['code'] ?? (widget.label == 'Sorting' ? widget.data['grades'][1]['greige_item']['code'] : '-')}',
        'another_value':
            '${widget.data['greige_item']['name'] ?? (widget.label == 'Sorting' ? widget.data['grades'][1]['greige_item']['name'] : '-')}',
        'icon': Icons.inventory_2_outlined,
        'is_product': true,
      },
    ];

    return _buildMultiInfoGrid(items, isTablet);
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
  Widget _buildReworkLongHemming(bool isTablet) {
    final items = [
      {
        'label': 'Semprotan',
        'value':
            '${widget.data['spraying'] != null ? formatNumber(widget.data['spraying']) : '0'} ${'PCS'}',
        'icon': Icons.numbers_outlined,
      },
      {
        'label': 'Permak Long Hemming',
        'value':
            '${widget.data['rework_long_hemming'] != null ? formatNumber(widget.data['rework_long_hemming']) : '0'} ${'PCS'}',
        'icon': Icons.twelve_mp_outlined,
      },
      {
        'label': 'Sisiran',
        'value':
            '${widget.data['combing'] != null ? formatNumber(widget.data['combing']) : '0'} ${'PCS'}',
        'icon': Icons.numbers_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

/*
Tipe BS
*/
  Widget _buildTypeBs(bool isTablet) {
    final itemTypes =
        List<Map<String, dynamic>>.from(widget.data['defects'] ?? []);
    if (itemTypes.isEmpty) return NoData();

    final total = itemTypes.fold<int>(
      0,
      (int sum, Map<String, dynamic> item) {
        final qty = int.tryParse(item['qty']?.toString() ?? '0') ?? 0;
        return sum + qty;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 24) / 4;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: itemTypes.map<Widget>((itemType) {
                return SizedBox(
                  width: itemWidth,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (itemType['type']?['name'] ?? '-'),
                          style: TextStyle(
                              fontWeight: CustomTheme().fontWeight('semibold')),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            CustomBadge(
                              title:
                                  'Qty: ${formatNumber(itemType['qty'])} PCS',
                              rework: true,
                              status: 'Selesai',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total BS: ${formatNumber(total)} PCS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

/*
Berat >> Packing
*/
  Widget _buildWeightInfo(bool isTablet) {
    final items = [
      {
        'label': 'Total Packing',
        'value':
            '${widget.data['qty'] != null ? formatNumber(widget.data['qty']) : '0'} ${'PCS'}',
        'icon': Icons.numbers_outlined,
      },
      {
        'label': 'Berat 1 Lusin',
        'value':
            '${widget.data['weight_per_dozen'] != null ? formatNumber(widget.data['weight_per_dozen']) : '0'} ${'KG'}',
        'icon': Icons.twelve_mp_outlined,
      },
      {
        'label': 'Gramasi',
        'value':
            '${widget.data['gsm'] != null ? formatNumber(widget.data['gsm']) : '0'} ${'GSM'}',
        'icon': Icons.numbers_outlined,
      },
      {
        'label': 'Berat Grade A',
        'value':
            '${widget.data['weight_grade_a'] != null ? formatNumber(widget.data['weight_grade_a']) : '0'} ${'KG'}',
        'icon': Icons.numbers_outlined,
      },
      {
        'label': 'Total Berat',
        'value':
            '${widget.data['total_weight'] != null ? formatNumber(widget.data['total_weight']) : '0'} ${'KG'}',
        'icon': Icons.numbers_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

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
    final int totalQty = items.fold<int>(
      0,
      (sum, item) => sum + (item['qty'] ?? 0) as int,
    );
    final totalBerat = widget.data['work_orders']['greige_qty'] ?? 0;
    final spkNo = widget.data?['work_orders']['items']?[0]?['spk_no'] ?? '-';

    if (items.isEmpty) {
      return Center(child: Text('No Data'));
    }

    return Column(
      children: List.generate(items.length, (index) {
        return Column(
          children: [
            _buildProdukJadiHeader(spkNo, totalBerat, totalQty),
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

  Widget _buildProdukJadiHeader(String spkNo, totalBerat, totalQty) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRODUK JADI',
            style: TextStyle(fontWeight: CustomTheme().fontWeight('semibold')),
          ),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['work_orders']['items'][0]['item_code'] ??
                          '-',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      widget.data['work_orders']['items'][0]['item_name'] ??
                          '-',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Qty',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(totalQty)} ${widget.data['work_orders']['items'][0]['unit']['code'] ?? ''}',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berat',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                    Text(
                      '${formatNumber(totalBerat)} ${widget.data['work_orders']['greige_unit']['code'] ?? ''}',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ].separatedBy(SizedBox(width: 16)),
          ),
        ].separatedBy(CustomTheme().vGap('md')),
      ),
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
            widget.label != 'Sewing')
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
        if (widget.label == 'Sorting')
          _buildInfoCard(
            title: 'Informasi Perbaikan',
            icon: Icons.grade_outlined,
            child: _buildReworkLongHemming(true),
          ),
        if (widget.label == 'Sorting')
          _buildInfoCard(
            title: 'Informasi Tipe BS',
            icon: Icons.attachment_outlined,
            child: _buildTypeBs(true),
          ),
        if (widget.withItemGrade == true && widget.existingGrades.isNotEmpty)
          _buildInfoCard(
            title: 'Informasi Grade',
            icon: Icons.grade_outlined,
            child: _buildGradeInfo(true),
          ),
        if (widget.label != 'Sorting' && widget.data['greige_item'] != null)
          _buildInfoCard(
            title: widget.label == 'Packing'
                ? 'Produk Jadi'
                : 'Produk Setengah Jadi',
            icon: Icons.inventory_2_outlined,
            child: _buildMaterialInfo(true),
          ),
        if (widget.label == 'Sorting' || widget.label == 'Packing')
          _buildInfoCard(
            title: 'Ringkasan Sortir',
            icon: Icons.attachment_outlined,
            child: _buildTotalSorting(true),
          ),
        if (widget.label == 'Packing')
          _buildInfoCard(
            title: 'Informasi Packing',
            icon: Icons.scale_outlined,
            child: _buildWeightInfo(true),
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
            widget.label != 'Sewing')
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
        if (widget.label == 'Sorting')
          _buildInfoCard(
            title: 'Informasi Perbaikan',
            icon: Icons.grade_outlined,
            child: _buildReworkLongHemming(false),
          ),
        if (widget.label == 'Sorting')
          _buildInfoCard(
            title: 'Informasi Tipe BS',
            icon: Icons.attachment_outlined,
            child: _buildTypeBs(false),
          ),
        if (widget.withItemGrade == true && widget.existingGrades.isNotEmpty)
          _buildInfoCard(
            title: 'Informasi Grade',
            icon: Icons.grade_outlined,
            child: _buildGradeInfo(false),
          ),
        if (widget.label != 'Sorting' && widget.data['greige_item'] != null)
          _buildInfoCard(
            title: widget.label == 'Packing'
                ? 'Produk Jadi'
                : 'Produk Setengah Jadi',
            icon: Icons.inventory_2_outlined,
            child: _buildMaterialInfo(false),
          ),
        if (widget.label == 'Sorting' || widget.label == 'Packing')
          _buildInfoCard(
            title: 'Ringkasan Sortir',
            icon: Icons.attachment_outlined,
            child: _buildTotalSorting(false),
          ),
        if (widget.label == 'Packing')
          _buildInfoCard(
            title: 'Informasi Packing',
            icon: Icons.scale_outlined,
            child: _buildWeightInfo(false),
          ),
        _buildInfoCard(
          title: 'Timeline Proses',
          icon: Icons.timeline_outlined,
          child: _buildTimelineInfo(false),
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
                      icon: item['icon'],
                      id: item['id'].toString(),
                      isTablet: isTablet,
                      navigateTo: item['navigate'],
                      rightIcon: item['right-icon'],
                      isProduct: item['is_product'] ?? false,
                      isGrade: item['is_grade'] ?? false,
                      nameValue: item['name_value']),
                );
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
                      icon: item['icon'],
                      id: item['id'].toString(),
                      isTablet: isTablet,
                      navigateTo: item['navigate'],
                      rightIcon: item['right-icon'],
                      isProduct: item['is_product'] ?? false,
                      isGrade: item['is_grade'] ?? false,
                      nameValue: item['name_value']),
                );
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
  Widget _buildMultiInfoItem(
      {required String label,
      required String value,
      required String anotherValue,
      required String id,
      required IconData icon,
      required bool isTablet,
      navigateTo,
      rightIcon,
      isProduct,
      isGrade,
      nameValue}) {
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                fontWeight:
                                    CustomTheme().fontWeight('semibold'),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ].separatedBy(CustomTheme().hGap('sm')),
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
                            color:
                                isProduct ? Colors.grey[600] : Colors.grey[800],
                            fontWeight: CustomTheme().fontWeight('semibold'),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          nameValue,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            color:
                                isProduct ? Colors.grey[600] : Colors.grey[600],
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
          ].separatedBy(CustomTheme().hGap('md')),
        ),
      ),
    );
  }
}
