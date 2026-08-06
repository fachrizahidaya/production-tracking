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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';
=======
import 'package:textile_tracking/screens/greige-order/%5Bgreige_order_id%5D.dart';
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
import 'package:textile_tracking/screens/greige-order/%5Bgreige_order_id%5D.dart';
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';
>>>>>>> fa574d36 (fix: detail persiapan dyeing)

class DyeingPreparationDetailList extends StatelessWidget {
  final Map<String, dynamic> data;
  final Future<void> Function() onRefresh;
  final bool canDelete;
  final bool canUpdate;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  final processName;
  final processNoKey;
  final List<Widget> Function(BuildContext)? handleBuildAttachment;
=======
  final processName;
  final processNoKey;
>>>>>>> fa574d36 (fix: detail persiapan dyeing)

  const DyeingPreparationDetailList(
      {super.key,
      required this.data,
      required this.onRefresh,
      required this.canDelete,
      required this.canUpdate,
      required this.onDelete,
      required this.onEdit,
      this.processName,
<<<<<<< HEAD
      this.processNoKey,
      this.handleBuildAttachment});
=======

=======

>>>>>>> 96e137ef (feat: persiapan dyeing detail)
  const DyeingPreparationDetailList({
    super.key,
    required this.data,
    required this.onRefresh,
    required this.canDelete,
    required this.canUpdate,
    required this.onDelete,
    required this.onEdit,
  });
<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
  final processName;
  final processNoKey;
  final List<Widget> Function(BuildContext)? handleBuildAttachment;

  const DyeingPreparationDetailList(
      {super.key,
      required this.data,
      required this.onRefresh,
      required this.canDelete,
      required this.canUpdate,
      required this.onDelete,
      required this.onEdit,
      this.processName,
<<<<<<< HEAD
      this.processNoKey});
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
      this.processNoKey,
      this.handleBuildAttachment});
>>>>>>> 52b21ae2 (fix: rumus persiapan dyeing untuk qty dan berat)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
      this.processNoKey});
>>>>>>> fa574d36 (fix: detail persiapan dyeing)

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                // _buildTopBar(context, isTablet),
                _buildOrderGreigeInfo(context, isTablet),
                if (isTablet)
                  _buildTabletLayout(context, isLargeTablet)
<<<<<<< HEAD
=======
                _buildTopBar(context, isTablet),
=======
                // _buildTopBar(context, isTablet),
>>>>>>> 27570e76 (fix: detail persiapan dyeing)
                _buildOrderGreigeInfo(context, isTablet),
                if (isTablet)
                  _buildTabletLayout(isLargeTablet)
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> 52b21ae2 (fix: rumus persiapan dyeing untuk qty dan berat)
=======
                _buildTopBar(context, isTablet),
                _buildOrderGreigeInfo(context, isTablet),
                if (isTablet)
                  _buildTabletLayout(isLargeTablet)
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
          Expanded(
            child: Text(
              'Detail Proses $processName',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('xl'),
              ),
            ),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    final orderGreige = _mapValue(data['work_orders']);
=======
    final orderGreige = _mapValue(data['order_greige']);
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
    final orderGreige = _mapValue(data['work_orders']);
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
    final orderGreige = _mapValue(data['order_greige']);
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
    final orderGreige = _mapValue(data['work_orders']);
>>>>>>> fa574d36 (fix: detail persiapan dyeing)

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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
              'No. WO',
=======
              'No. OG',
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
              'No. WO',
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
              'No. OG',
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
              'No. WO',
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                      _display(orderGreige['wo_no'] ?? '-'),
=======
                      _display(orderGreige['og_no'] ?? orderGreige['pp_no']),
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
                      _display(orderGreige['wo_no'] ?? '-'),
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
                      _display(orderGreige['og_no'] ?? orderGreige['pp_no']),
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
                      _display(orderGreige['wo_no'] ?? '-'),
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
                  // Expanded(
                  //   child: _buildOrderInfoItem(
                  //     icon: Icons.scale_outlined,
                  //     label: 'Jumlah Order',
                  //     value: _withUnit(orderGreige['order_qty'], 'KG'),
                  //     isTablet: isTablet,
                  //   ),
                  // ),
                  // _buildVerticalDivider(true),
<<<<<<< HEAD
<<<<<<< HEAD
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal WO',
                      value: _formatDate(orderGreige['wo_date']),
=======
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.scale_outlined,
                      label: 'Jumlah Order',
                      value: _withUnit(orderGreige['order_qty'], 'KG'),
                      isTablet: isTablet,
                    ),
                  ),
                  _buildVerticalDivider(true),
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal OG',
                      value: _formatDate(orderGreige['og_date']),
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal WO',
                      value: _formatDate(orderGreige['wo_date']),
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.scale_outlined,
                      label: 'Jumlah Order',
                      value: _withUnit(orderGreige['order_qty'], 'KG'),
                      isTablet: isTablet,
                    ),
                  ),
                  _buildVerticalDivider(true),
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal OG',
                      value: _formatDate(orderGreige['og_date']),
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
                  Expanded(
                    child: _buildOrderInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal WO',
                      value: _formatDate(orderGreige['wo_date']),
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildTabletLayout(BuildContext context, bool isLargeTablet) {
=======
  Widget _buildTabletLayout(bool isLargeTablet) {
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
  Widget _buildTabletLayout(BuildContext context, bool isLargeTablet) {
>>>>>>> 52b21ae2 (fix: rumus persiapan dyeing untuk qty dan berat)
=======
  Widget _buildTabletLayout(bool isLargeTablet) {
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
              _buildSectionCard(
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
                title: 'Item Work Order',
                icon: Icons.inventory_2_outlined,
                child: _buildWorkOrderItems(true),
              ),
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
              _buildSectionCard(
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
              _buildSectionCard(
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
                title: 'Timeline Proses',
                icon: Icons.timeline_outlined,
                child: _buildTimelineInfo(true),
              ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 52b21ae2 (fix: rumus persiapan dyeing untuk qty dan berat)
              if ((data['attachments'] as List? ?? []).isNotEmpty)
                _buildSectionCard(
                  title: 'Lampiran',
                  icon: Icons.attachment_outlined,
                  child: Column(
                    children: handleBuildAttachment?.call(context) ?? [],
                  ),
                ),
=======
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
          Column(
            children: [
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
              _buildSectionCard(
                title: 'Catatan $processName',
                icon: Icons.note_outlined,
                child: _buildNote(data['notes']),
              ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
=======
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
          Column(
            children: [
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
              _buildSectionCard(
                title: 'Catatan $processName',
                icon: Icons.note_outlined,
                child: _buildNote(data['notes']),
              ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
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
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
                      _display(data[processNoKey]),
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          // _buildQuickInfoRow(isTablet),
=======
          _buildQuickInfoRow(isTablet),
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
          // _buildQuickInfoRow(isTablet),
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
          _buildQuickInfoRow(isTablet),
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
          // _buildQuickInfoRow(isTablet),
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
  Widget _buildQuickInfoRow(bool isTablet) {
    final machine = _mapValue(data['machine']);

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.local_laundry_service_outlined,
              label: 'Mesin',
              value:
                  '${_display(machine['code'])} - ${_display(machine['name'])}',
              isTablet: isTablet,
            ),
          ),
          _buildVerticalDivider(false),
          Expanded(
            child: _buildQuickInfoItem(
              icon: Icons.location_on_outlined,
              label: 'Lokasi',
              value: _display(machine['location']),
              isTablet: isTablet,
            ),
          ),
          // if (_mainResultValue() != '-') _buildVerticalDivider(false),
          // if (_mainResultValue() != '-')
          //   Expanded(
          //     child: _buildQuickInfoItem(
          //       icon: Icons.scale_outlined,
          //       label: 'Hasil',
          //       value: _mainResultValue(),
          //       isTablet: isTablet,
          //     ),
          //   ),
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
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
  Widget _buildResultInfo(bool isTablet) {
    return Text('tes');
  }

  Widget _buildInfoGrid(List<Map<String, dynamic>> items, bool isTablet) {
    if (items.isEmpty) {
      return NoData();
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items.map((item) {
        final width = isTablet ? 220.0 : double.infinity;

        return Container(
          width: width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                size: 20,
                color: CustomTheme().colors('primary'),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['label'].toString(),
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('sm'),
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      item['value'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('base'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.grey[800],
                      ),
                    ),
                  ].separatedBy(CustomTheme().vGap('xs')),
                ),
              ),
            ].separatedBy(CustomTheme().hGap('md')),
          ),
        );
      }).toList(),
    );
  }

<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
  Widget _buildTimelineInfo(bool isTablet) {
    return Column(
      children: [
        _buildTimelineItem(
          icon: Icons.access_time_outlined,
          iconColor: Colors.blue,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
          title: 'Mulai Proses',
          time: data['start_time'],
          user: _mapValue(data['start_by'])['name'],
          isLast: data['end_time'] == null,
        ),
=======
          title: 'Mulai Proses',
          time: data['start_time'],
          user: _mapValue(data['start_by'])['name'],
          isLast: data['end_time'] == null,
        ),
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
        if (data['end_time'] != null)
          _buildTimelineItem(
            icon: Icons.task_alt_outlined,
            iconColor: Colors.green,
            title: 'Selesai Proses',
            time: data['end_time'],
            user: _mapValue(data['end_by'])['name'],
            isLast: true,
          ),
<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
          title: 'Proses Dibuat',
          time: data['created_at'],
          user: _mapValue(data['start_by'])['name'],
          isLast: data['end_time'] == null,
        ),
=======
          title: 'Proses Dibuat',
          time: data['created_at'],
          user: _mapValue(data['start_by'])['name'],
          isLast: data['end_time'] == null,
        ),
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
        // if (data['end_time'] != null)
        //   _buildTimelineItem(
        //     icon: Icons.task_alt_outlined,
        //     iconColor: Colors.green,
        //     title: 'Selesai Proses',
        //     time: data['end_time'],
        //     user: _mapValue(data['end_by'])['name'],
        //     isLast: true,
        //   ),
<<<<<<< HEAD
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
  Widget _buildVerticalDivider(bool isOrder) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isOrder
          ? Colors.white.withOpacity(0.2)
          : Colors.grey.withOpacity(0.2),
<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        builder: (context) => WorkOrderDetail(
          id: data['work_orders']?['id'].toString() ?? '-',
        ),
=======
        builder: (context) => GreigeOrderDetail(id: id.toString()),
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
        builder: (context) => WorkOrderDetail(
          id: data['work_orders']?['id'].toString() ?? '-',
        ),
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
        builder: (context) => GreigeOrderDetail(id: id.toString()),
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
        builder: (context) => WorkOrderDetail(
          id: data['work_orders']?['id'].toString() ?? '-',
        ),
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)

String _formatType(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  return value
      .toString()
      .split('_')
      .map((word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
<<<<<<< HEAD
>>>>>>> 252dc540 (feat: persiapan dyeing detail)
=======
>>>>>>> bdffbd30 (fix: detail persiapan dyeing)
=======
>>>>>>> 96e137ef (feat: persiapan dyeing detail)
=======
>>>>>>> fa574d36 (fix: detail persiapan dyeing)
