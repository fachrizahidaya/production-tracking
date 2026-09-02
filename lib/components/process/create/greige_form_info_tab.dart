import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/create/greige_create_section.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeFormInfoTab extends StatefulWidget {
  final id;
  final data;
  final processData;
  final label;
  final form;
  final formKey;
  final handleSelectMachine;
  final handleSelectGreigeOrder;
  final isLoading;
  final maklonName;
  final isMaklon;
  final withMaklonOrMachine;
  final withOnlyMaklon;
  final withNoMaklonOrMachine;
  final handleChangeInput;
  final note;
  final yarnQty;
  final beamQty;
  final section;

  const GreigeFormInfoTab(
      {super.key,
      this.data,
      this.processData,
      this.form,
      this.label,
      this.formKey,
      this.handleSelectMachine,
      this.handleSelectGreigeOrder,
      this.id,
      this.isLoading,
      this.isMaklon,
      this.maklonName,
      this.withMaklonOrMachine,
      this.withNoMaklonOrMachine,
      this.withOnlyMaklon,
      this.handleChangeInput,
      this.note,
      this.yarnQty,
      this.beamQty,
      this.section});

  @override
  State<GreigeFormInfoTab> createState() => _GreigeFormInfoTabState();
}

class _GreigeFormInfoTabState extends State<GreigeFormInfoTab> {
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

  String _orderQtyUnit(Map<String, dynamic> data) {
    final spkItem = _mapValue(_mapValue(data['work_order_item'])['spk_item']);
    final weightUnit = _mapValue(spkItem['weight_unit']);
    return _display(weightUnit['code'], fallback: 'KG');
  }

  String _pasangText(Map<String, dynamic> data) {
    final pasangQty = data['pasang_qty'];
    final sectionQty = data['section_qty'];
    final beamQty = data['beam_qty'];

    if (pasangQty != null && sectionQty != null) {
      return '${formatNumber(pasangQty)} x Pasang = ${formatNumber(sectionQty)} Section';
    }

    if (pasangQty != null && beamQty != null) {
      return '${formatNumber(pasangQty)} x Pasang = ${formatNumber(beamQty)} Beam';
    }

    if (pasangQty != null) {
      return '${formatNumber(pasangQty)} Pasang';
    }

    if (sectionQty != null) {
      return '${formatNumber(sectionQty)} Section';
    }

    if (beamQty != null) {
      return '${formatNumber(beamQty)} Beam';
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: CustomTheme().padding('content'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreigeCreateSection(
                formKey: widget.formKey,
                form: widget.form,
                maklonName: widget.maklonName,
                isMaklon: widget.isMaklon,
                selectGreigeOrder: widget.handleSelectGreigeOrder,
                selectMachine: widget.handleSelectMachine,
                id: widget.id,
                withMaklonOrMachine: widget.withMaklonOrMachine,
                withOnlyMaklon: widget.withOnlyMaklon,
                withNoMaklonOrMachine: widget.withNoMaklonOrMachine,
                label: widget.label,
                data: widget.processData,
                handleChangeInput: widget.handleChangeInput,
                note: widget.note,
                yarnQty: widget.yarnQty,
                beamQty: widget.beamQty,
                section: widget.section,
              ),
              _buildGreigeOrderSummary(),
            ].separatedBy(CustomTheme().vGap('2xl')),
          ),
        );
      },
    );
  }

  Widget _buildGreigeOrderSummary() {
    final data = _mapValue(widget.data);

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final yarnItems = _listValue(data['yarn_items']);
    final loomBeams = _listValue(data['loom_beams']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, data),
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
          child: _buildNotesSection(data),
        ),
      ].separatedBy(CustomTheme().vGap('2xl')),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> data) {
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
                  _buildStatusBadge(isTablet),
                ].separatedBy(CustomTheme().hGap('xl')),
              ),
              _buildQuickInfoRow(data, isTablet),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        );
      },
    );
  }

  Widget _buildQuickInfoRow(Map<String, dynamic> data, bool isTablet) {
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
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.scale_outlined,
              label: 'Jumlah Order',
              value: _withUnit(data['order_qty'], _orderQtyUnit(data)),
              isTablet: isTablet,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.view_week_outlined,
              label: 'Warping Type',
              value: _formatType(data['warping_type']),
              isTablet: isTablet,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.view_agenda_outlined,
              label: 'Pasang',
              value: _pasangText(data),
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

  Widget _buildYarnTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return NoData();
    }

    return _buildDataTable(
      columns: const [
        DataColumn(
          label: Text('Kode Warna'),
        ),
        DataColumn(
          label: Text('Jumlah Benang'),
        ),
        DataColumn(
          label: Text('NE'),
        ),
        DataColumn(
          label: Text('Lot'),
        ),
      ],
      rows: items
          .map(
            (item) => DataRow(
              cells: [
                DataCell(
                  Text(
                    _display(item['color_code']),
                  ),
                ),
                DataCell(
                  _richUnit(
                    item['yarn_qty'],
                    'PCS',
                  ),
                ),
                DataCell(
                  Text(
                    _display(item['ne']),
                  ),
                ),
                DataCell(
                  Text(
                    _display(item['lot']),
                  ),
                ),
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

  Widget _buildNotesSection(Map<String, dynamic> data) {
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

  Widget _buildStatusBadge(bool isTablet) {
    return CustomBadge(
      title: widget.data['status']?.toString() ?? '-',
      withStatus: true,
      status: widget.data['status']?.toString() ?? '-',
    );
  }
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
