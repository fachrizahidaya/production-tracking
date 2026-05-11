import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/work-order/tab/attachment_tab.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SpkInfoTab extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isLoading;

  const SpkInfoTab({
    super.key,
    required this.data,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data.isEmpty) {
      return NoData();
    }

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SpkHeader(data: data, isTablet: isTablet),
              _SpkMaterialCard(data: data),
              AttachmentTab(existingAttachment: data['attachments'] ?? []),
            ].separatedBy(CustomTheme().vGap('2xl')),
          );
        },
      ),
    );
  }
}

class _SpkHeader extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isTablet;

  const _SpkHeader({
    required this.data,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
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
            color: CustomTheme().buttonColor('primary').withValues(alpha: 0.3),
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
                child: Text(
                  data['spk_no']?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize(isTablet ? '2xl' : 'xl'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              CustomBadge(
                title: data['status']?.toString() ?? '-',
                withStatus: true,
                status: data['status']?.toString() ?? '-',
              ),
            ].separatedBy(CustomTheme().hGap('xl')),
          ),
          _buildQuickInfo(),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildQuickInfo() {
    final items = [
      _QuickInfoData(
        icon: Icons.calendar_month_outlined,
        label: 'Tanggal SPK',
        value: _formatDate(data['spk_date']),
      ),
      _QuickInfoData(
        icon: Icons.business_outlined,
        label: 'Pelanggan',
        value: data['customer']?['name']?.toString() ?? '-',
      ),
      _QuickInfoData(
        icon: Icons.person_outlined,
        label: 'Dibuat Oleh',
        value: data['user']?['name']?.toString() ?? '-',
      ),
    ];

    return Container(
      padding: CustomTheme().padding(isTablet ? 'content' : 'card'),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: isTablet
          ? Row(children: _buildInfoRow(items))
          : Column(
              children: items
                  .map((item) => _QuickInfoItem(item: item, isTablet: false))
                  .toList()
                  .separatedBy(CustomTheme().vGap('lg')),
            ),
    );
  }

  List<Widget> _buildInfoRow(List<_QuickInfoData> items) {
    final widgets = <Widget>[];

    for (var i = 0; i < items.length; i++) {
      widgets.add(
        Expanded(
          child: _QuickInfoItem(item: items[i], isTablet: true),
        ),
      );

      if (i != items.length - 1) {
        widgets.add(_buildVerticalDivider());
      }
    }

    return widgets;
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return '-';

    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(value.toString()));
    } catch (_) {
      return value.toString();
    }
  }
}

class _QuickInfoData {
  final IconData icon;
  final String label;
  final String value;

  const _QuickInfoData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _QuickInfoItem extends StatelessWidget {
  final _QuickInfoData item;
  final bool isTablet;

  const _QuickInfoItem({
    required this.item,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          item.icon,
          size: CustomTheme().iconSize(isTablet ? 'xl' : 'lg'),
          color: Colors.white,
        ),
        Text(
          item.label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            color: Colors.white.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          item.value,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }
}

class _SpkMaterialCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _SpkMaterialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final items = (data['items'] ?? []) as List<dynamic>;
    final totalQty = items.fold<num>(
      0,
      (sum, item) => sum + ((item['qty'] ?? 0) as num),
    );
    final firstItem =
        items.isNotEmpty ? items.first as Map<String, dynamic> : null;
    final firstUnit = firstItem?['unit'] as Map<String, dynamic>?;
    final unit = firstUnit?['code'] ?? '';

    return TemplateCard(
      title: 'Material',
      icon: Icons.inventory_2_outlined,
      child: items.isEmpty
          ? NoData()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(items.length, (index) {
                    return _SpkMaterialItem(
                      item: items[index] as Map<String, dynamic>,
                    );
                  }).separatedBy(CustomTheme().vGap('xl')),
                ),
              ].separatedBy(CustomTheme().vGap('xl')),
            ),
    );
  }
}

class _SpkMaterialItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const _SpkMaterialItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Container(
          padding: CustomTheme().padding('card'),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: isTablet ? _buildTablet() : _buildMobile(),
        );
      },
    );
  }

  Widget _buildTablet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildItemInfo(),
        ),
        Expanded(
          child: _buildQtyInfo(),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemInfo(),
        _buildQtyInfo(),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  Widget _buildItemInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['item_code']?.toString() ?? '-',
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.grey[800],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          item['item_name']?.toString() ?? '-',
          style: TextStyle(
            fontSize: CustomTheme().fontSize('lg'),
            fontWeight: CustomTheme().fontWeight('semibold'),
            color: Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        _buildVariants(),
      ].separatedBy(CustomTheme().vGap('md')),
    );
  }

  Widget _buildVariants() {
    final variants = (item['variants'] ?? []) as List<dynamic>;

    if (variants.isEmpty) {
      return SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: variants.map((variant) {
        return _buildChip(
          '${variant['type'] ?? '-'}',
          '${variant['value'] ?? '-'}',
        );
      }).toList(),
    );
  }

  Widget _buildChip(String title, String value) {
    return Container(
      padding: CustomTheme().padding('badge-rework'),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        '$title: $value',
        style: TextStyle(
          fontSize: CustomTheme().fontSize('sm'),
          color: Colors.grey[700],
          fontWeight: CustomTheme().fontWeight('semibold'),
        ),
      ),
    );
  }

  Widget _buildQtyInfo() {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 16,
      runSpacing: 12,
      children: [
        _buildQtyColumn(
          'Qty',
          item['qty'],
          item['unit']?['code']?.toString() ?? '',
        ),
        _buildQtyColumn(
          'Diproses',
          item['process_qty'],
          item['unit']?['code']?.toString() ?? '',
        ),
        _buildStatus(),
      ],
    );
  }

  Widget _buildQtyColumn(String label, dynamic value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatNumber(value ?? 0),
              style: TextStyle(
                fontSize: CustomTheme().fontSize('xl'),
                fontWeight: CustomTheme().fontWeight('bold'),
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: CustomTheme().fontSize('lg'),
                color: Colors.grey[600],
              ),
            ),
          ].separatedBy(CustomTheme().hGap('sm')),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        Text(
          item['status']?.toString() ?? '-',
          style: TextStyle(
            fontWeight: CustomTheme().fontWeight('bold'),
          ),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }
}
