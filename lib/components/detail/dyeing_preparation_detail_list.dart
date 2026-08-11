// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/action_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class DyeingPreparationDetailList extends StatelessWidget {
  final Map<String, dynamic> data;
  final Future<void> Function() onRefresh;
  final bool canDelete;
  final bool canUpdate;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final processName;
  final processNoKey;

  const DyeingPreparationDetailList(
      {super.key,
      required this.data,
      required this.onRefresh,
      required this.canDelete,
      required this.canUpdate,
      required this.onDelete,
      required this.onEdit,
      this.processName,
      this.processNoKey});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final isLargeTablet = constraints.maxWidth > 900;

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildTopBar(context, isTablet),
                _buildOrderGreigeInfo(context, isTablet),
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

  Widget _buildTopBar(BuildContext context, bool isTablet) {
    final canShowDelete = canDelete && data['can_delete'] != false;

    final status = data['status']?.toString().toLowerCase() ?? '';
    final canShowEdit =
        canUpdate && (status == 'diproses' || status.contains('diproses'));

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.chevron_left_outlined,
            ),
          ),
          Expanded(
            child: Text(
              'Detail Proses $processName',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('xl'),
              ),
            ),
          ),
          if (canShowEdit) ...[
            ActionTextButton(
              label: 'Edit',
              onPressed: onEdit,
            ),
          ],
          if (canShowDelete)
            ActionTextButton(
              label: 'Hapus',
              textColor: Colors.red,
              borderColor: Colors.red,
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }

  Widget _buildOrderGreigeInfo(BuildContext context, bool isTablet) {
    final orderGreige = _mapValue(data['work_orders']);

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
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
              onTap: () => _openGreigeOrderDetail(context, orderGreige),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _display(orderGreige['wo_no'] ?? '-'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: Colors.white,
                  ),
                ].separatedBy(CustomTheme().hGap('md')),
              ),
            ),
            Container(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Expanded(
                  //   child: _buildOrderInfoItem(
                  //     icon: Icons.scale_outlined,
                  //     label: 'Jumlah Order',
                  //     value: _withUnit(orderGreige['order_qty'], 'KG'),
                  //     isTablet: isTablet,
                  //   ),
                  // ),
                  // _buildVerticalDivider(true),
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal WO',
                      value: _formatDate(orderGreige['wo_date']),
                      isTablet: isTablet,
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

  Widget _buildOrderInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Icon(icon, size: isTablet ? 20 : 18, color: Colors.white),
        Text(
          label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('sm'),
            color: Colors.grey[300],
            fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('base'),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: Column(
        children: [
          _buildHeaderSection(false),
          _buildSectionCard(
            title: 'Timeline Proses',
            icon: Icons.timeline_outlined,
            child: _buildTimelineInfo(false),
          ),
          _buildSectionCard(
            title: 'Kebutuhan Benang',
            icon: Icons.layers_outlined,
            child: _buildYarnItems(false),
          ),
          _buildSectionCard(
            title: 'Kebutuhan Loom Beam',
            icon: Icons.inventory_2_outlined,
            child: _buildLoomBeams(false),
          ),
          _buildSectionCard(
            title: 'Catatan Order Greige',
            icon: Icons.note_alt_outlined,
            child: _buildNote(_mapValue(data['order_greige'])['notes']),
          ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  Widget _buildTabletLayout(bool isLargeTablet) {
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: Column(
        children: [
          _buildHeaderSection(true),
          Column(
            children: [
              // _buildSectionCard(
              //   title: 'Informasi Proses',
              //   icon: Icons.info_outline,
              //   child: _buildProcessInfo(true),
              // ),
              _buildSectionCard(
                title: 'Item Work Order',
                icon: Icons.inventory_2_outlined,
                child: _buildWorkOrderItems(true),
              ),
              _buildSectionCard(
                title: 'Timeline Proses',
                icon: Icons.timeline_outlined,
                child: _buildTimelineInfo(true),
              ),
              _buildSectionCard(
                title: 'Catatan $processName',
                icon: Icons.note_outlined,
                child: _buildNote(data['notes']),
              ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
          // Column(
          //   children: [
          // _buildSectionCard(
          //   title: 'Kebutuhan Benang',
          //   icon: Icons.layers_outlined,
          //   child: _buildYarnItems(true),
          // ),
          // _buildSectionCard(
          //   title: 'Kebutuhan Loom Beam',
          //   icon: Icons.inventory_2_outlined,
          //   child: _buildLoomBeams(true),
          // ),
          // _buildSectionCard(
          //   title: 'Catatan Order Greige',
          //   icon: Icons.note_alt_outlined,
          //   child: _buildNote(_mapValue(data['work_orders'])['notes']),
          // ),
          //   ].separatedBy(CustomTheme().vGap('xl')),
          // ),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildHeaderSection(bool isTablet) {
    return Container(
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
                    Text(
                      _display(data[processNoKey]),
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      data['created_at'] != null
                          ? 'Dibuat pada ${_formatDateTime(data['created_at'])}'
                          : '-',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        color: Colors.grey[600],
                        fontWeight: CustomTheme().fontWeight('semibold'),
                      ),
                    ),
                  ].separatedBy(CustomTheme().vGap('sm')),
                ),
              ),
              CustomBadge(
                title: _display(data['status']),
                withStatus: true,
                status: _display(data['status']),
              ),
            ],
          ),
          // _buildQuickInfoRow(isTablet),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return TemplateCard(
      icon: icon,
      title: title,
      child: Column(
        children: [
          child,
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  Widget _buildTimelineInfo(bool isTablet) {
    return Column(
      children: [
        _buildTimelineItem(
          icon: Icons.access_time_outlined,
          iconColor: Colors.blue,
          title: 'Proses Dibuat',
          time: data['created_at'],
          user: _mapValue(data['start_by'])['name'],
          isLast: data['end_time'] == null,
        ),
        // if (data['end_time'] != null)
        //   _buildTimelineItem(
        //     icon: Icons.task_alt_outlined,
        //     iconColor: Colors.green,
        //     title: 'Selesai Proses',
        //     time: data['end_time'],
        //     user: _mapValue(data['end_by'])['name'],
        //     isLast: true,
        //   ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    dynamic time,
    dynamic user,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor, width: 2),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey[300],
                    ),
                  ),
              ],
            ),
          ),
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
                      Icon(Icons.access_time,
                          size: 14, color: Colors.grey[500]),
                      Text(
                        _formatDateTime(time),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('md')),
                  ),
                  if (user != null && user.toString().isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 14, color: Colors.grey[500]),
                        Text(
                          user.toString(),
                          style: TextStyle(
                            fontSize: CustomTheme().fontSize('sm'),
                            color: Colors.grey[600],
                          ),
                        ),
                      ].separatedBy(CustomTheme().hGap('md')),
                    ),
                ].separatedBy(CustomTheme().vGap('md')),
              ),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('xl')),
      ),
    );
  }

  Widget _buildYarnItems(bool isTablet) {
    final yarnItems = _listValue(_mapValue(data['order_greige'])['yarn_items']);

    if (yarnItems.isEmpty) {
      return NoData();
    }

    return Column(
      children: yarnItems
          .map((item) {
            return _buildDataBox(
              children: [
                _buildInfoLine('Kode Warna', _display(item['color_code'])),
                _buildInfoLine(
                    'Jumlah Benang', _withUnit(item['yarn_qty'], 'PCS')),
                if (item['ne'] != null)
                  _buildInfoLine('Ne', _display(item['ne'])),
                if (item['lot'] != null)
                  _buildInfoLine('Lot', _display(item['lot'])),
              ],
            );
          })
          .toList()
          .separatedBy(CustomTheme().vGap('md')),
    );
  }

  Widget _buildLoomBeams(bool isTablet) {
    final loomBeams = _listValue(_mapValue(data['order_greige'])['loom_beams']);

    if (loomBeams.isEmpty) {
      return NoData();
    }

    return Column(
      children: loomBeams
          .map((item) {
            return _buildDataBox(
              children: [
                _buildInfoLine('Benang', _withUnit(item['yarn_qty'], 'PCS')),
                _buildInfoLine(
                    'Lebar Beam', _withUnit(item['beam_width'], 'M')),
                _buildInfoLine('Beam A/B', _display(item['beam_ab'])),
                _buildInfoLine('Panjang', _withUnit(item['length'], 'M')),
                _buildInfoLine('No. MC', _display(item['machine_no'])),
                _buildInfoLine('Berat', _withUnit(item['weight'], 'KG')),
                _buildInfoLine('Majun', _withUnit(item['majun'], 'KG')),
                _buildInfoLine('Gempor', _withUnit(item['gempor'], 'CNS')),
              ],
            );
          })
          .toList()
          .separatedBy(CustomTheme().vGap('md')),
    );
  }

  Widget _buildDataBox({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: children
            .separatedBy(Divider(height: 16, color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _buildInfoLine(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('sm'),
              color: Colors.grey[600],
              fontWeight: CustomTheme().fontWeight('semibold'),
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('sm'),
              color: Colors.grey[800],
              fontWeight: CustomTheme().fontWeight('bold'),
            ),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('md')),
    );
  }

  Widget _buildNote(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return NoData();
    }

    return Text(
      htmlToPlainText(value.toString()),
      style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
    );
  }

  Widget _buildWorkOrderItems(bool isTablet) {
    final workOrderItems = _listValue(
      _mapValue(data['work_orders'])['items'],
    );

    if (workOrderItems.isEmpty) {
      return NoData();
    }

    return Column(
      children: workOrderItems
          .map((workOrderItem) {
            final greigeItems = _listValue(workOrderItem['greige_items']);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (workOrderItems.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Work Order Item #${workOrderItem["id"]}',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ...greigeItems.map((item) {
                  final product = _mapValue(item['greige_item']);

                  return _buildDataBox(
                    children: [
                      _buildInfoLine(
                        'Kode Barang',
                        _display(product['code']),
                      ),
                      _buildInfoLine(
                        'Nama Barang',
                        _display(product['name']),
                      ),
                      _buildInfoLine(
                        'Qty',
                        _withUnit(item['qty'], 'PCS'),
                      ),
                      _buildInfoLine(
                        'Berat',
                        _withUnit(item['weight'], 'KG'),
                      ),
                      if (item['greige_item_op_no'] != null)
                        _buildInfoLine(
                          'No. OP',
                          _display(item['greige_item_op_no']),
                        ),
                    ],
                  );
                }),
              ].separatedBy(CustomTheme().vGap('md')),
            );
          })
          .toList()
          .separatedBy(
            CustomTheme().vGap('xl'),
          ),
    );
  }

  void _openGreigeOrderDetail(
    BuildContext context,
    Map<String, dynamic> orderGreige,
  ) {
    final id = orderGreige['id'] ?? data['order_greige_id'];

    if (id == null || id.toString().isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkOrderDetail(
          id: data['work_orders']?['id'].toString() ?? '-',
        ),
      ),
    );
  }
}

Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _listValue(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  return <Map<String, dynamic>>[];
}

String _display(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';
  return value.toString();
}

String _withUnit(dynamic value, String unit) {
  if (value == null || value.toString().isEmpty) return '-';
  final formatted = formatNumber(value);
  if (unit.isEmpty) return formatted;
  return '$formatted $unit';
}

String _formatDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  try {
    return DateFormat('dd MMM yyyy')
        .format(DateTime.parse(value.toString()).toLocal());
  } catch (_) {
    return value.toString();
  }
}

String _formatDateTime(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  try {
    return DateFormat('dd MMM yyyy, HH.mm')
        .format(DateTime.parse(value.toString()).toLocal());
  } catch (_) {
    return value.toString();
  }
}
