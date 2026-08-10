import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeInfoTab extends StatelessWidget {
  final Map<String, dynamic> data;

  const GreigeInfoTab({
    super.key,
    required this.data,
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
    final pasangQty = data['pasang_qty'];
    final sectionQty = data['section_qty'];
    final beamQty = data['beam_qty'];

    if (pasangQty != null && sectionQty != null) {
      return '${formatNumber(pasangQty)} x Pasang = ${formatNumber(sectionQty)} Section';
    }

    if (pasangQty != null && beamQty != null) {
      return '${formatNumber(pasangQty)} x Pasang = ${formatNumber(beamQty)} Beam';
    }

    if (pasangQty != null) return '${formatNumber(pasangQty)} Pasang';
    if (sectionQty != null) return '${formatNumber(sectionQty)} Section';
    if (beamQty != null) return '${formatNumber(beamQty)} Beam';
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SingleChildScrollView(
        padding: CustomTheme().padding('content'),
        child: NoData(),
      );
    }

    final yarnItems = _listValue(data['yarn_items']);
    final loomBeams = _listValue(data['loom_beams']);

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
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
      ),
    );
  }

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
            ),
          ),
        ),
        _StatusPill(status: _display(data['status'])),
      ].separatedBy(CustomTheme().hGap('lg')),
    );
  }

  Widget _buildWorkOrderBox() {
    final workOrder = _mapValue(data['work_order']);
    final productName = _productName();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFDFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 720;
              final children = [
                _buildBlockInfo(
                  'Referensi Work Order / Lot',
                  _display(workOrder['wo_no'] ?? data['wo_no']),
                  isLink: true,
                ),
                _buildBlockInfo(
                  'Kekurangan Greige',
                  _withUnit(data['greige_shortage_weight'] ?? data['weight'],
                      _orderQtyUnit()),
                ),
              ];

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
          ),
          _buildProductInfo(_productCode(), productName),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
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
    final items = [
      _DetailItem('Tanggal', _formatDate(data['og_date'] ?? data['pp_date'])),
      _DetailItem('No. SO', _display(data['so_no'])),
      _DetailItem('No. OB', _display(data['ob_no'])),
      _DetailItem('No. OP', _display(data['op_no'])),
      _DetailItem('Nama Design', _display(data['design_name'])),
      _DetailItem('Desain Warna', _display(data['design_color'])),
      _DetailItem('Article', _productCode()),
      _DetailItem(
          'Jumlah Order', _withUnit(data['order_qty'], _orderQtyUnit())),
      _DetailItem('Warping Type', _formatType(data['warping_type']),
          chip: true),
      _DetailItem('Dibuat oleh', _display(user['name'])),
      _DetailItem('Pasang', _pasangText()),
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
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildBlockInfo(
    String label,
    String value, {
    bool isLink = false,
  }) {
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
          ),
        ),
      ].separatedBy(CustomTheme().vGap('xs')),
    );
  }

  Widget _buildTableSection({
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

  Widget _buildYarnTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return NoData();

    return _buildDataTable(
      columns: const [
        DataColumn(label: Text('KODE WARNA')),
        DataColumn(label: Text('JML. BNG')),
        DataColumn(label: Text('NE')),
        DataColumn(label: Text('LOT')),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                DataCell(Text(_display(item['color_code']))),
                DataCell(_richUnit(item['yarn_qty'], 'PCS')),
                DataCell(Text(_display(item['ne']))),
                DataCell(Text(_display(item['lot']))),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildLoomBeamTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return NoData();

    return _buildDataTable(
      columns: const [
        DataColumn(label: Text('BENANG')),
        DataColumn(label: Text('PANJANG')),
        DataColumn(label: Text('LEBAR BEAM')),
        DataColumn(label: Text('NO. MC')),
        DataColumn(label: Text('BEAM A/B')),
        DataColumn(label: Text('ATRIBUT TAMBAHAN')),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                DataCell(_richUnit(item['yarn_qty'], 'PCS')),
                DataCell(_richUnit(item['length'], 'M')),
                DataCell(_richUnit(item['beam_width'], 'M')),
                DataCell(Text(_display(item['machine_no']))),
                DataCell(Text(_display(item['beam_ab']))),
                DataCell(Text(_display(item['extra_attributes']))),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assignment_outlined,
                size: 20, color: Colors.grey.shade900),
            Text(
              'Catatan',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: CustomTheme().fontSize('lg'),
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
          ].separatedBy(CustomTheme().hGap('sm')),
        ),
        Container(
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
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
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

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: CustomTheme().buttonColor('primary'),
          fontSize: CustomTheme().fontSize('xs'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
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
  final bool chip;

  const _DetailItem(
    this.label,
    this.value, {
    this.chip = false,
  });
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade800),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: CustomTheme().fontSize('sm'),
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xs')),
      ),
    );
  }
}
