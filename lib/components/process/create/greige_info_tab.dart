import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class GreigeInfoTab extends StatelessWidget {
  final data;

  const GreigeInfoTab({
    super.key,
    required this.data,
  });

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

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SingleChildScrollView(
        padding: CustomTheme().padding('content'),
        child: TemplateCard(
          title: 'Greige Order',
          icon: Icons.assignment_outlined,
          child: NoData(),
        ),
      );
    }

    final yarnItems = List<Map<String, dynamic>>.from(
      data['yarn_items'] ?? [],
    );
    final loomBeams = List<Map<String, dynamic>>.from(
      data['loom_beams'] ?? [],
    );

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummary(context),
          _buildYarnSection(yarnItems),
          _buildLoomBeamSection(loomBeams),
          _buildNotesSection(),
        ].separatedBy(CustomTheme().vGap('2xl')),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth > 720
            ? (constraints.maxWidth - 32) / 3
            : constraints.maxWidth;

        return Wrap(
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
        );
      },
    );
  }

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
            ),
          ),
        ],
      ),
    );
  }

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
    );
  }

  Widget _buildNotesSection() {
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
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return TemplateCard(
      title: title,
      icon: icon,
      child: child,
    );
  }

  Widget _buildBorderBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(
    String label,
    dynamic value, {
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: CustomTheme().fontWeight('semibold'),
              fontSize: CustomTheme().fontSize('md'),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value?.toString() ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: CustomTheme().fontWeight('bold'),
                    fontSize: CustomTheme().fontSize('md'),
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing,
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: CustomTheme().fontSize('xs'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
    );
  }
}
