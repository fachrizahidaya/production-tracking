import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/components/master/card/custom_badge.dart';
=======
>>>>>>> 1e3750ac (fix: create process)
=======
import 'package:textile_tracking/components/master/card/custom_badge.dart';
>>>>>>> c940e94a (fix:)
import 'package:textile_tracking/components/master/container/template.dart';
=======
>>>>>>> 6aaef7aa (fix: create warping)
=======
import 'package:textile_tracking/components/master/container/template.dart';
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeInfoTab extends StatelessWidget {
<<<<<<< HEAD
<<<<<<< HEAD
  final Map<String, dynamic> data;
  final bool isLoading;
<<<<<<< HEAD
=======
  final data;
>>>>>>> 1e3750ac (fix: create process)
=======
  final Map<String, dynamic> data;
>>>>>>> 6aaef7aa (fix: create warping)
=======
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)

  const GreigeInfoTab({
    super.key,
    required this.data,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
    this.isLoading = false,
  });

  Map<String, dynamic> _mapValue(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  List<Map<String, dynamic>> _listValue(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  }

  String _display(dynamic value, {String fallback = '-'}) {
    if (value == null) return fallback;
    final text = value.toString();
    if (text.trim().isEmpty) return fallback;
    return text;
  }

<<<<<<< HEAD
=======
  });

>>>>>>> 1e3750ac (fix: create process)
=======
>>>>>>> 6aaef7aa (fix: create warping)
  String _formatDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return '-';

    try {
      final date = DateTime.parse(value.toString()).toLocal();
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return value.toString();
    }
  }

  String _formatType(dynamic value) {
    if (value == null || value.toString().isEmpty) return '-';

    return value
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _withUnit(dynamic value, String unit) {
    if (value == null || value.toString().isEmpty) return '-';
    return '${formatNumber(value)} $unit';
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c940e94a (fix:)
  String _formatYarnLot(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '-';
    return formatNumber(value);
  }

<<<<<<< HEAD
=======
>>>>>>> 6aaef7aa (fix: create warping)
=======
>>>>>>> c940e94a (fix:)
  String _productCode() {
    final spkItem = _mapValue(_mapValue(data['work_order_item'])['spk_item']);
    final item = _mapValue(spkItem['item']);
    return _display(
      data['article'] ?? item['code'],
    );
  }

  String _productName() {
    final spkItem = _mapValue(_mapValue(data['work_order_item'])['spk_item']);
    final item = _mapValue(spkItem['item']);
    return _display(item['name'], fallback: '');
  }

  String _orderQtyUnit() {
    final spkItem = _mapValue(_mapValue(data['work_order_item'])['spk_item']);
    final weightUnit = _mapValue(spkItem['weight_unit']);
    return _display(weightUnit['code'], fallback: 'KG');
  }

  String _pasangText() {
<<<<<<< HEAD
<<<<<<< HEAD
    final design = _mapValue(data['design']);
    final pasangQty = design['pasang_qty'] ?? data['pasang_qty'];
    final sectionQty = design['section_qty'] ?? data['section_qty'];

    if (pasangQty == null || sectionQty == null) return '-';

    return '${formatNumber(pasangQty)} x pasang = ${formatNumber(sectionQty)} section';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data.isEmpty) {
      return NoData();
    }

    final yarnItems = _listValue(data['yarn_items']);
    final loomBeams = _listValue(data['loom_beams']);
=======
=======
    final pasangQty = data['pasang_qty'];
    final sectionQty = data['section_qty'];
    final beamQty = data['beam_qty'];
=======
    final design = _mapValue(data['design']);
    final pasangQty = design['pasang_qty'] ?? data['pasang_qty'];
    final sectionQty = design['section_qty'] ?? data['section_qty'];
>>>>>>> c940e94a (fix:)

    if (pasangQty == null || sectionQty == null) return '-';

    return '${formatNumber(pasangQty)} x pasang = ${formatNumber(sectionQty)} section';
  }

>>>>>>> 6aaef7aa (fix: create warping)
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

<<<<<<< HEAD
<<<<<<< HEAD
    final yarnItems = List<Map<String, dynamic>>.from(
      data['yarn_items'] ?? [],
    );
    final loomBeams = List<Map<String, dynamic>>.from(
      data['loom_beams'] ?? [],
    );
>>>>>>> 1e3750ac (fix: create process)

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          _buildHeader(context),
          // TemplateCard(
          //   title: 'Referensi Work Order',
          //   icon: Icons.assignment_outlined,
          //   child: _buildWorkOrderBox(),
          // ),
          TemplateCard(
            title: 'Detail Order Greige',
            icon: Icons.info_outline,
            child: _buildDetailGrid(),
          ),
          TemplateCard(
            title: 'Kebutuhan Benang',
            icon: Icons.layers_outlined,
            child: _buildYarnTable(yarnItems),
          ),
          TemplateCard(
            title: 'Kebutuhan Loom Beam',
            icon: Icons.inventory_2_outlined,
            child: _buildLoomBeamTable(loomBeams),
          ),
          TemplateCard(
            title: 'Catatan',
            icon: Icons.sticky_note_2_outlined,
            child: _buildNotesSection(),
          ),
=======
          _buildSummary(context),
          _buildYarnSection(yarnItems),
          _buildLoomBeamSection(loomBeams),
          _buildNotesSection(),
>>>>>>> 1e3750ac (fix: create process)
        ].separatedBy(CustomTheme().vGap('2xl')),
=======
=======
    if (data.isEmpty) {
      return NoData();
    }

>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
    final yarnItems = _listValue(data['yarn_items']);
    final loomBeams = _listValue(data['loom_beams']);

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
<<<<<<< HEAD
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildWorkOrderBox(),
            _buildDetailGrid(),
            _buildTableSection(
              icon: Icons.layers_outlined,
              title: 'Kebutuhan Benang',
              child: _buildYarnTable(yarnItems),
            ),
            _buildTableSection(
              icon: Icons.inventory_2_outlined,
              title: 'Kebutuhan Loom Beam',
              child: _buildLoomBeamTable(loomBeams),
            ),
            _buildNotesSection(),
          ].separatedBy(CustomTheme().vGap('2xl')),
        ),
>>>>>>> 6aaef7aa (fix: create warping)
=======
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          // TemplateCard(
          //   title: 'Referensi Work Order',
          //   icon: Icons.assignment_outlined,
          //   child: _buildWorkOrderBox(),
          // ),
          TemplateCard(
            title: 'Detail Order Greige',
            icon: Icons.info_outline,
            child: _buildDetailGrid(),
          ),
          TemplateCard(
            title: 'Kebutuhan Benang',
            icon: Icons.layers_outlined,
            child: _buildYarnTable(yarnItems),
          ),
          TemplateCard(
            title: 'Kebutuhan Loom Beam',
            icon: Icons.inventory_2_outlined,
            child: _buildLoomBeamTable(loomBeams),
          ),
          TemplateCard(
            title: 'Catatan',
            icon: Icons.sticky_note_2_outlined,
            child: _buildNotesSection(),
          ),
        ].separatedBy(CustomTheme().vGap('2xl')),
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Container(
          padding: CustomTheme().padding('card'),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CustomTheme().buttonColor('primary'),
                CustomTheme().buttonColor('primary').withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                    CustomTheme().buttonColor('primary').withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
                    child: Text(
                      _display(data['og_no'] ?? data['pp_no']),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            CustomTheme().fontSize(isTablet ? '2xl' : 'xl'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                      ),
                    ),
                  ),
<<<<<<< HEAD
<<<<<<< HEAD
                  _buildStatusBadge(),
=======
                  _StatusPill(status: _display(data['status'])),
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
=======
                  _buildStatusBadge(),
>>>>>>> c940e94a (fix:)
                ].separatedBy(CustomTheme().hGap('xl')),
              ),
              _buildQuickInfoRow(isTablet),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
<<<<<<< HEAD
=======
  Widget _buildSummary(BuildContext context) {
=======
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            _display(data['og_no'] ?? data['pp_no']),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w800,
=======
        );
      },
    );
  }

  Widget _buildQuickInfoRow(bool isTablet) {
    final user = _mapValue(data['user']);

    return Container(
      padding: CustomTheme().padding(isTablet ? 'content' : 'card'),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.calendar_month_outlined,
              label: 'Tanggal OG',
              value: _formatDate(data['og_date'] ?? data['pp_date']),
              isTablet: isTablet,
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
            ),
          ),
          // _buildVerticalDivider(),
          // Expanded(
          //   child: _buildQuickInfoItem(
          //     icon: Icons.scale_outlined,
          //     label: 'Jumlah Order',
          //     value: _withUnit(data['order_qty'], _orderQtyUnit()),
          //     isTablet: isTablet,
          //   ),
          // ),
          // _buildVerticalDivider(),
          // Expanded(
          //   child: _buildQuickInfoItem(
          //     icon: Icons.view_week_outlined,
          //     label: 'Warping Type',
          //     value: _formatType(data['warping_type']),
          //     isTablet: isTablet,
          //   ),
          // ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.person_outlined,
              label: 'Dibuat Oleh',
              value: _display(user['name']),
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
          size: CustomTheme().iconSize(isTablet ? 'xl' : 'lg'),
          color: Colors.white,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            color: Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildResponsiveInfoRow(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 720;

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.separatedBy(CustomTheme().vGap('lg')),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map((child) => Expanded(child: child))
              .toList()
              .separatedBy(CustomTheme().hGap('2xl')),
        );
      },
    );
  }

  Widget _buildWorkOrderBox() {
    final workOrder = _mapValue(data['work_order']);
    final productName = _productName();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResponsiveInfoRow([
          _buildBlockInfo(
            'Referensi Work Order / Lot',
            _display(workOrder['wo_no'] ?? data['wo_no']),
            isLink: true,
          ),
          _buildBlockInfo(
            'Kekurangan Greige',
            _withUnit(
              data['greige_shortage_weight'] ?? data['weight'],
              _orderQtyUnit(),
            ),
          ),
        ]),
        _buildProductInfo(_productCode(), productName),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  Widget _buildProductInfo(String code, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produk Jadi',
          style: _labelStyle(),
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CustomTheme().buttonColor('primary').withValues(
                      alpha: 0.1,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: CustomTheme().buttonColor('primary'),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _valueStyle(fontSize: 'md'),
                  ),
                  if (name.isNotEmpty)
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: CustomTheme().fontSize('md'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                ],
              ),
            ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildDetailGrid() {
    final user = _mapValue(data['user']);
    final design = _mapValue(data['design']);
    final items = [
      // _DetailItem('Tanggal', _formatDate(data['og_date'] ?? data['pp_date'])),
      _DetailItem('No. SO', _display(data['so_no'])),
      _DetailItem('No. OB', _display(data['ob_no'])),
      _DetailItem('No. OP', _display(data['op_no'])),
      _DetailItem('Nama Design', _display(data['design_name'])),
      _DetailItem('Desain Warna', _display(data['design_color'])),
      _DetailItem('Article', _productCode()),
      _DetailItem(
        'Tipe Warping',
        _formatType(design['warping_type'] ?? data['warping_type']),
      ),
      _DetailItem('Pasang', _pasangText()),
      _DetailItem('Qty Order', _withUnit(data['order_qty'], 'PCS')),
      _DetailItem('Berat Order', _withUnit(data['weight'], _orderQtyUnit())),
      // _DetailItem('Dibuat oleh', _display(user['name'])),
    ];

>>>>>>> 6aaef7aa (fix: create warping)
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 720
                ? 2
                : 1;
        final spacing = 24.0;
        final width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
<<<<<<< HEAD
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildSummaryCard(
              width: itemWidth,
              label: 'NO. OG',
              value: data['og_no'] ?? data['pp_no'] ?? '-',
              isPrimary: true,
            ),
            _buildSummaryCard(
              width: itemWidth,
              label: 'TANGGAL OG',
              value: _formatDate(data['og_date']),
            ),
            _buildSummaryCard(
              width: itemWidth,
              label: 'JUMLAH ORDER',
              value: _withUnit(data['order_qty'], 'KG'),
            ),
          ],
>>>>>>> 1e3750ac (fix: create process)
=======
          spacing: spacing,
          runSpacing: 22,
          children: items
              .map((item) => SizedBox(
                    width: width,
                    child: _buildDetailItem(item),
                  ))
              .toList(),
>>>>>>> 6aaef7aa (fix: create warping)
        );
      },
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildQuickInfoRow(bool isTablet) {
    final user = _mapValue(data['user']);

    return Container(
      padding: CustomTheme().padding(isTablet ? 'content' : 'card'),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.calendar_month_outlined,
              label: 'Tanggal OG',
              value: _formatDate(data['og_date'] ?? data['pp_date']),
              isTablet: isTablet,
            ),
          ),
          // _buildVerticalDivider(),
          // Expanded(
          //   child: _buildQuickInfoItem(
          //     icon: Icons.scale_outlined,
          //     label: 'Jumlah Order',
          //     value: _withUnit(data['order_qty'], _orderQtyUnit()),
          //     isTablet: isTablet,
          //   ),
          // ),
          // _buildVerticalDivider(),
          // Expanded(
          //   child: _buildQuickInfoItem(
          //     icon: Icons.view_week_outlined,
          //     label: 'Warping Type',
          //     value: _formatType(data['warping_type']),
          //     isTablet: isTablet,
          //   ),
          // ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.person_outlined,
              label: 'Dibuat Oleh',
              value: _display(user['name']),
              isTablet: isTablet,
=======
  Widget _buildSummaryCard({
    required double width,
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: CustomTheme().fontWeight('bold'),
              fontSize: CustomTheme().fontSize('sm'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isPrimary
                  ? CustomTheme().buttonColor('primary')
                  : Colors.grey.shade800,
              fontWeight: CustomTheme().fontWeight('bold'),
              fontSize: CustomTheme().fontSize('xl'),
>>>>>>> 1e3750ac (fix: create process)
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
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
          size: CustomTheme().iconSize(isTablet ? 'xl' : 'lg'),
          color: Colors.white,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            color: Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildResponsiveInfoRow(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 720;

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.separatedBy(CustomTheme().vGap('lg')),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map((child) => Expanded(child: child))
              .toList()
              .separatedBy(CustomTheme().hGap('2xl')),
        );
      },
    );
  }

  Widget _buildWorkOrderBox() {
    final workOrder = _mapValue(data['work_order']);
    final productName = _productName();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResponsiveInfoRow([
          _buildBlockInfo(
            'Referensi Work Order / Lot',
            _display(workOrder['wo_no'] ?? data['wo_no']),
            isLink: true,
          ),
          _buildBlockInfo(
            'Kekurangan Greige',
            _withUnit(
              data['greige_shortage_weight'] ?? data['weight'],
              _orderQtyUnit(),
            ),
          ),
        ]),
        _buildProductInfo(_productCode(), productName),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  Widget _buildProductInfo(String code, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produk Jadi',
          style: _labelStyle(),
        ),
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CustomTheme().buttonColor('primary').withValues(
                      alpha: 0.1,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: CustomTheme().buttonColor('primary'),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _valueStyle(fontSize: 'md'),
                  ),
                  if (name.isNotEmpty)
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: CustomTheme().fontSize('md'),
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                ],
              ),
            ),
          ].separatedBy(CustomTheme().hGap('lg')),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildDetailGrid() {
    final user = _mapValue(data['user']);
    final design = _mapValue(data['design']);
    final items = [
      // _DetailItem('Tanggal', _formatDate(data['og_date'] ?? data['pp_date'])),
      _DetailItem('No. SO', _display(data['so_no'])),
      _DetailItem('No. OB', _display(data['ob_no'])),
      _DetailItem('No. OP', _display(data['op_no'])),
      _DetailItem('Nama Design', _display(data['design_name'])),
      _DetailItem('Desain Warna', _display(data['design_color'])),
      _DetailItem('Article', _productCode()),
      _DetailItem(
        'Tipe Warping',
        _formatType(design['warping_type'] ?? data['warping_type']),
      ),
      _DetailItem('Pasang', _pasangText()),
      _DetailItem('Qty Order', _withUnit(data['order_qty'], 'PCS')),
      _DetailItem('Berat Order', _withUnit(data['weight'], _orderQtyUnit())),
      // _DetailItem('Dibuat oleh', _display(user['name'])),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 720
                ? 2
                : 1;
        final spacing = 24.0;
        final width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 22,
          children: items
              .map((item) => SizedBox(
                    width: width,
                    child: _buildDetailItem(item),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildDetailItem(_DetailItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.label, style: _labelStyle()),
        Text(
          item.value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _valueStyle(fontSize: 'md'),
        ),
<<<<<<< HEAD
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildBlockInfo(
    String label,
    String value, {
    bool isLink = false,
  }) {
=======
  Widget _buildDetailItem(_DetailItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.label, style: _labelStyle()),
        item.chip
            ? Align(
                alignment: Alignment.centerLeft,
                child: _buildChip(item.value),
              )
            : Text(
                item.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _valueStyle(fontSize: 'md'),
              ),
=======
>>>>>>> c940e94a (fix:)
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildBlockInfo(
    String label,
    String value, {
    bool isLink = false,
  }) {
>>>>>>> 6aaef7aa (fix: create warping)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _valueStyle(
            fontSize: 'md',
            color: isLink
                ? CustomTheme().buttonColor('primary')
                : Colors.grey.shade800,
<<<<<<< HEAD
          ),
        ),
      ].separatedBy(CustomTheme().vGap('xs')),
    );
  }

  Widget _buildYarnTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return NoData();

    final design = _mapValue(data['design']);

<<<<<<< HEAD
    return _buildDataTable(
      columns: const [
        DataColumn(label: Text('KODE WARNA')),
        DataColumn(label: Text('JML. BNG')),
        DataColumn(label: Text('NE')),
        DataColumn(label: Text('LOT BENANG')),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                // Dari yarn_items
                DataCell(
                  Text(_display(item['color_code'])),
                ),

                // Dari yarn_items
                DataCell(
                  _richUnit(item['yarn_qty'], 'Helai'),
                ),

                // Dari yarn_items
                DataCell(
                  Text(_display(item['ne'])),
                ),

                // Dari design
                DataCell(
                  Text(_formatYarnLot(design['yarn_lot'])),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildLoomBeamTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return NoData();

    final design = _mapValue(data['design']);

    return _buildDataTable(
      columns: const [
        DataColumn(label: Text('BENANG')),
        DataColumn(label: Text('PANJANG')),
        DataColumn(label: Text('LEBAR BEAM')),
        DataColumn(label: Text('NO. MC')),
        DataColumn(label: Text('BEAM A/B')),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                // Dari loom_beams
                DataCell(
                  _richUnit(item['yarn_qty'], 'Helai'),
                ),

                // Dari loom_beams
                DataCell(
                  _richUnit(item['length'], 'M'),
                ),

                // Dari design
                DataCell(
                  _richUnit(design['beam_width'], 'M'),
                ),

                // Dari design
                DataCell(
                  Text(_display(design['machine_no'])),
                ),

                // Dari design
                DataCell(
                  Text(_display(design['beam_ab'])),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(Colors.grey.shade50),
              headingTextStyle: TextStyle(
                color: Colors.grey.shade700,
                fontSize: CustomTheme().fontSize('sm'),
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
              dataTextStyle: TextStyle(
                color: Colors.grey.shade900,
                fontSize: CustomTheme().fontSize('md'),
              ),
              columnSpacing: 48,
              horizontalMargin: 18,
              dividerThickness: 0.8,
              columns: columns,
              rows: rows,
            ),
          ),
        );
      },
=======
  Widget _buildYarnSection(List<Map<String, dynamic>> items) {
    return _buildSection(
      icon: Icons.layers_outlined,
      title: 'Kebutuhan Benang',
      child: items.isEmpty
          ? NoData()
          : Column(
              children: items
                  .map((item) => _buildYarnItem(item))
                  .toList()
                  .separatedBy(CustomTheme().vGap('lg')),
            ),
    );
  }

  Widget _buildYarnItem(Map<String, dynamic> item) {
    return _buildBorderBox(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  'Kode Warna',
                  item['color_code'] ?? '-',
                ),
              ),
              Expanded(
                child: _buildInfoRow(
                  'Jml. Bng',
                  _withUnit(item['yarn_qty'], 'PCS'),
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  'Ne',
                  item['ne'] ?? '-',
                  trailing: _buildChip(_formatType(data['warping_type'])),
                ),
              ),
              Expanded(
                child: _buildInfoRow(
                  'Lot',
                  item['lot'] ?? '-',
                ),
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
        ],
      ),
    );
  }

  Widget _buildLoomBeamSection(List<Map<String, dynamic>> items) {
    return _buildSection(
      icon: Icons.inventory_2_outlined,
      title: 'Kebutuhan Loom Beam',
      child: items.isEmpty
          ? NoData()
          : Column(
              children: items
                  .map((item) => _buildLoomBeamItem(item))
                  .toList()
                  .separatedBy(CustomTheme().vGap('lg')),
            ),
    );
  }

  Widget _buildLoomBeamItem(Map<String, dynamic> item) {
    return _buildBorderBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 640;

          final left = Column(
            children: [
              _buildInfoRow('Benang', _withUnit(item['yarn_qty'], 'PCS')),
              const Divider(height: 20),
              _buildInfoRow('Lebar Beam', _withUnit(item['beam_width'], 'M')),
              const Divider(height: 20),
              _buildInfoRow('Beam A/B', item['beam_ab'] ?? '-'),
              const Divider(height: 20),
              _buildInfoRow('Beam', _withUnit(item['beam'], 'KG')),
              const Divider(height: 20),
              _buildInfoRow('Gempor', _withUnit(item['gempor'], 'CNS')),
            ],
          );

          final right = Column(
            children: [
              _buildInfoRow('Panjang', _withUnit(item['length'], 'M')),
              const Divider(height: 20),
              _buildInfoRow('No. MC', item['machine_no'] ?? '-'),
              const Divider(height: 20),
              _buildInfoRow('Berat', _withUnit(item['weight'], 'KG')),
              const Divider(height: 20),
              _buildInfoRow('Majun', _withUnit(item['majun'], 'KG')),
            ],
          );

          if (!isWide) {
            return Column(
              children: [
                left,
                const Divider(height: 24),
                right,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              Container(
                width: 1,
                height: 204,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.grey.shade200,
              ),
              Expanded(child: right),
            ],
          );
        },
      ),
>>>>>>> 1e3750ac (fix: create process)
    );
  }

  Widget _buildNotesSection() {
<<<<<<< HEAD
    final notes = _display(data['notes'], fallback: 'Tidak ada catatan');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        border: Border(
          left: BorderSide(
            color: Colors.blueGrey.shade300,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        notes,
        style: TextStyle(
          fontSize: CustomTheme().fontSize('md'),
          color: notes == 'Tidak ada catatan'
              ? Colors.grey.shade500
              : Colors.grey.shade800,
          fontStyle: notes == 'Tidak ada catatan' ? FontStyle.italic : null,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _richUnit(dynamic value, String unit) {
    if (value == null || value.toString().isEmpty) {
      return const Text('-');
    }

    return RichText(
      text: TextSpan(
        text: formatNumber(value),
        style: TextStyle(
          color: Colors.grey.shade900,
          fontSize: CustomTheme().fontSize('md'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
        children: [
          TextSpan(
            text: ' $unit',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: CustomTheme().fontSize('xs'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ],
=======
    return TemplateCard(
      title: 'Catatan Order Greige',
      icon: Icons.assignment_outlined,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          border: Border(
            left: BorderSide(
              color: CustomTheme().buttonColor('primary'),
              width: 4,
            ),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          data['notes']?.toString().isNotEmpty == true
              ? data['notes'].toString()
              : '-',
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
>>>>>>> 1e3750ac (fix: create process)
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildStatusBadge() {
    return CustomBadge(
      title: data['status']?.toString() ?? '-',
      withStatus: true,
      status: data['status']?.toString() ?? '-',
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      color: Colors.grey.shade600,
      fontWeight: CustomTheme().fontWeight('semibold'),
      fontSize: CustomTheme().fontSize('sm'),
    );
  }

  TextStyle _valueStyle({
    String fontSize = 'md',
    Color? color,
  }) {
    return TextStyle(
      color: color ?? Colors.grey.shade800,
      fontWeight: CustomTheme().fontWeight('bold'),
      fontSize: CustomTheme().fontSize(fontSize),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;

  const _DetailItem(
    this.label,
    this.value,
  );
}
=======
  Widget _buildSection({
=======
          ),
        ),
      ].separatedBy(CustomTheme().vGap('xs')),
    );
  }

<<<<<<< HEAD
  Widget _buildTableSection({
>>>>>>> 6aaef7aa (fix: create warping)
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade900),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: CustomTheme().fontSize('lg'),
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
          ].separatedBy(CustomTheme().hGap('sm')),
        ),
        child,
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

=======
>>>>>>> 9170cdf8 (fix: rumus otomatis berat greige persiapan dyeing)
  Widget _buildYarnTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return NoData();

=======
>>>>>>> e29028fd (fix: kebutuhan loom beam di greige order detail)
    return _buildDataTable(
      columns: const [
        DataColumn(label: Text('KODE WARNA')),
        DataColumn(label: Text('JML. BNG')),
        DataColumn(label: Text('NE')),
        DataColumn(label: Text('LOT BENANG')),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                // Dari yarn_items
                DataCell(
                  Text(_display(item['color_code'])),
                ),

                // Dari yarn_items
                DataCell(
                  _richUnit(item['yarn_qty'], 'Helai'),
                ),

                // Dari yarn_items
                DataCell(
                  Text(_display(item['ne'])),
                ),

                // Dari design
                DataCell(
                  Text(_formatYarnLot(design['yarn_lot'])),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildLoomBeamTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return NoData();

    final design = _mapValue(data['design']);

    return _buildDataTable(
      columns: const [
        DataColumn(label: Text('BENANG')),
        DataColumn(label: Text('PANJANG')),
        DataColumn(label: Text('LEBAR BEAM')),
        DataColumn(label: Text('NO. MC')),
        DataColumn(label: Text('BEAM A/B')),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                // Dari loom_beams
                DataCell(
                  _richUnit(item['yarn_qty'], 'Helai'),
                ),

                // Dari loom_beams
                DataCell(
                  _richUnit(item['length'], 'M'),
                ),

                // Dari design
                DataCell(
                  _richUnit(design['beam_width'], 'M'),
                ),

                // Dari design
                DataCell(
                  Text(_display(design['machine_no'])),
                ),

                // Dari design
                DataCell(
                  Text(_display(design['beam_ab'])),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(Colors.grey.shade50),
              headingTextStyle: TextStyle(
                color: Colors.grey.shade700,
                fontSize: CustomTheme().fontSize('sm'),
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
              dataTextStyle: TextStyle(
                color: Colors.grey.shade900,
                fontSize: CustomTheme().fontSize('md'),
              ),
              columnSpacing: 48,
              horizontalMargin: 18,
              dividerThickness: 0.8,
              columns: columns,
              rows: rows,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesSection() {
    final notes = _display(data['notes'], fallback: 'Tidak ada catatan');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        border: Border(
          left: BorderSide(
            color: Colors.blueGrey.shade300,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        notes,
        style: TextStyle(
          fontSize: CustomTheme().fontSize('md'),
          color: notes == 'Tidak ada catatan'
              ? Colors.grey.shade500
              : Colors.grey.shade800,
          fontStyle: notes == 'Tidak ada catatan' ? FontStyle.italic : null,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _richUnit(dynamic value, String unit) {
    if (value == null || value.toString().isEmpty) {
      return const Text('-');
    }

    return RichText(
      text: TextSpan(
        text: formatNumber(value),
        style: TextStyle(
          color: Colors.grey.shade900,
          fontSize: CustomTheme().fontSize('md'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
        children: [
          TextSpan(
            text: ' $unit',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: CustomTheme().fontSize('xs'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return CustomBadge(
      title: data['status']?.toString() ?? '-',
      withStatus: true,
      status: data['status']?.toString() ?? '-',
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      color: Colors.grey.shade600,
      fontWeight: CustomTheme().fontWeight('semibold'),
      fontSize: CustomTheme().fontSize('sm'),
    );
  }

  TextStyle _valueStyle({
    String fontSize = 'md',
    Color? color,
  }) {
    return TextStyle(
      color: color ?? Colors.grey.shade800,
      fontWeight: CustomTheme().fontWeight('bold'),
      fontSize: CustomTheme().fontSize(fontSize),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;

  const _DetailItem(
    this.label,
    this.value,
  );
}
>>>>>>> 1e3750ac (fix: create process)
