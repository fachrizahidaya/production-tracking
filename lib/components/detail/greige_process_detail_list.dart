// ignore_for_file: deprecated_member_use

<<<<<<< HEAD
<<<<<<< HEAD
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/button/action_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/pdf/pdf_viewer_screen.dart';
import 'package:textile_tracking/screens/greige-order/%5Bgreige_order_id%5D.dart';
import 'package:url_launcher/url_launcher.dart';
=======
=======
import 'dart:io';

>>>>>>> deb4d660 (fix: detail warping - shearing)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/components/master/button/action_button.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/result/show_image_dialog.dart';
import 'package:textile_tracking/helpers/util/format_bytes.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/pdf/pdf_viewer_screen.dart';
import 'package:textile_tracking/screens/greige-order/%5Bgreige_order_id%5D.dart';
<<<<<<< HEAD
>>>>>>> 230afad3 (feat: greige order detail)
=======
import 'package:url_launcher/url_launcher.dart';
>>>>>>> deb4d660 (fix: detail warping - shearing)

class GreigeProcessDetailList extends StatelessWidget {
  final Map<String, dynamic> data;
  final String processName;
  final String processNoKey;
  final Future<void> Function() onRefresh;
  final bool canDelete;
<<<<<<< HEAD
<<<<<<< HEAD
  final bool canUpdate;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool withMultiMachine;
  final bool withBrokenYarns;
  final bool withAttachments;

  const GreigeProcessDetailList(
      {super.key,
      required this.data,
      required this.processName,
      required this.processNoKey,
      required this.onRefresh,
      required this.canDelete,
      required this.onDelete,
      required this.onEdit,
      required this.canUpdate,
      this.withMultiMachine = false,
      this.withBrokenYarns = false,
      this.withAttachments = false});
<<<<<<< HEAD
=======
=======
  final bool canUpdate;
>>>>>>> 5afc921a (fix: detail proses)
  final VoidCallback onDelete;
  final VoidCallback onEdit;

<<<<<<< HEAD
  const GreigeProcessDetailList({
    super.key,
    required this.data,
    required this.processName,
    required this.processNoKey,
    required this.onRefresh,
    required this.canDelete,
    required this.onDelete,
  });
>>>>>>> 230afad3 (feat: greige order detail)
=======
  const GreigeProcessDetailList(
      {super.key,
      required this.data,
      required this.processName,
      required this.processNoKey,
      required this.onRefresh,
      required this.canDelete,
      required this.onDelete,
      required this.onEdit,
      required this.canUpdate});
>>>>>>> 5afc921a (fix: detail proses)
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)

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
                // _buildTopBar(context, isTablet),
                _buildOrderGreigeInfo(context, isTablet),
                if (isTablet)
                  _buildTabletLayout(context, isLargeTablet)
<<<<<<< HEAD
                else
                  _buildMobileLayout(context),
=======
                _buildTopBar(context, isTablet),
=======
                // _buildTopBar(context, isTablet),
>>>>>>> f7a54b43 (fix: detail list)
                _buildOrderGreigeInfo(context, isTablet),
                if (isTablet)
                  _buildTabletLayout(isLargeTablet)
                else
                  _buildMobileLayout(),
>>>>>>> 230afad3 (feat: greige order detail)
=======
                else
                  _buildMobileLayout(context),
>>>>>>> deb4d660 (fix: detail warping - shearing)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, bool isTablet) {
    final canShowDelete = canDelete && data['can_delete'] != false;

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5afc921a (fix: detail proses)
    final status = data['status']?.toString().toLowerCase() ?? '';
    final canShowEdit =
        canUpdate && (status == 'diproses' || status.contains('diproses'));

<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> 5afc921a (fix: detail proses)
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: () => Navigator.pop(context),
<<<<<<< HEAD
<<<<<<< HEAD
            icon: const Icon(
              Icons.chevron_left_outlined,
            ),
=======
            icon: const Icon(Icons.chevron_left_outlined, size: 28),
            color: Colors.grey.shade700,
>>>>>>> 230afad3 (feat: greige order detail)
=======
            icon: const Icon(
              Icons.chevron_left_outlined,
            ),
>>>>>>> 5afc921a (fix: detail proses)
          ),
          Expanded(
            child: Text(
              'Detail Proses $processName',
              style: TextStyle(
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
                fontSize: isTablet ? 22 : 18,
                color: Colors.grey.shade900,
=======
                fontSize: CustomTheme().fontSize('xl'),
>>>>>>> 5afc921a (fix: detail proses)
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
<<<<<<< HEAD
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomTheme().buttonColor('danger'),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Hapus $processName'),
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> 5afc921a (fix: detail proses)
            ),
        ],
      ),
    );
  }

  Widget _buildOrderGreigeInfo(BuildContext context, bool isTablet) {
    final orderGreige = _mapValue(data['order_greige']);

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
              'No. OG',
=======
              'No. Order Greige',
>>>>>>> 230afad3 (feat: greige order detail)
=======
              'No. OG',
>>>>>>> 5afc921a (fix: detail proses)
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
                      _display(orderGreige['og_no'] ?? orderGreige['pp_no']),
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

<<<<<<< HEAD
<<<<<<< HEAD
  Widget _buildMobileLayout(BuildContext context) {
=======
  Widget _buildMobileLayout() {
>>>>>>> 230afad3 (feat: greige order detail)
=======
  Widget _buildMobileLayout(BuildContext context) {
>>>>>>> deb4d660 (fix: detail warping - shearing)
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: Column(
        children: [
          _buildHeaderSection(false),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
          if (withMultiMachine)
            _buildSectionCard(
              title: 'Informasi Mesin',
              icon: Icons.local_laundry_service_outlined,
              child: _buildMachine(context, false),
            ),
<<<<<<< HEAD
          _buildSectionCard(
            title: 'Informasi Proses',
            icon: Icons.info_outline,
            child: _buildProcessInfo(),
=======
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
          _buildSectionCard(
            title: 'Informasi Proses',
            icon: Icons.info_outline,
            child: _buildProcessInfo(false),
>>>>>>> 230afad3 (feat: greige order detail)
          ),
          _buildSectionCard(
            title: 'Timeline Proses',
            icon: Icons.timeline_outlined,
            child: _buildTimelineInfo(false),
          ),
          _buildSectionCard(
            title: 'Hasil $processName',
            icon: Icons.account_tree_outlined,
<<<<<<< HEAD
            child: _buildResultInfo(),
          ),
          if (withBrokenYarns)
            _buildSectionCard(
              title: 'Benang Putus',
              icon: Icons.content_cut_outlined,
              child: _buildBrokenYarns(),
            ),
          if (withAttachments)
            _buildSectionCard(
              title: 'Lampiran',
              icon: Icons.attachment_outlined,
              child: _buildAttachmentList(context),
            ),
          _buildPasangSection(false),
=======
            child: _buildResultInfo(false),
          ),
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 230afad3 (feat: greige order detail)
=======
=======
          if (withBrokenYarns)
            _buildSectionCard(
              title: 'Catatan Benang Putus',
              icon: Icons.content_cut_outlined,
              child: _buildBrokenYarns(false),
            ),
          if (withAttachments)
            _buildSectionCard(
              title: 'Lampiran',
              icon: Icons.attachment_outlined,
              child: _buildAttachmentList(context),
            ),
>>>>>>> deb4d660 (fix: detail warping - shearing)
          _buildPasangSection(false),
>>>>>>> 663098db (fix: detail warping)
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
            title: 'Catatan $processName',
            icon: Icons.note_outlined,
            child: _buildNote(data['notes']),
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
  Widget _buildTabletLayout(BuildContext context, bool isLargeTablet) {
=======
  Widget _buildTabletLayout(bool isLargeTablet) {
>>>>>>> 230afad3 (feat: greige order detail)
=======
  Widget _buildTabletLayout(BuildContext context, bool isLargeTablet) {
>>>>>>> deb4d660 (fix: detail warping - shearing)
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: Column(
        children: [
          _buildHeaderSection(true),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
          if (withMultiMachine)
            _buildSectionCard(
              title: 'Informasi Mesin',
              icon: Icons.local_laundry_service_outlined,
              child: _buildMachine(context, true),
            ),
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
          Column(
            children: [
              // _buildSectionCard(
              //   title: 'Informasi Proses',
              //   icon: Icons.info_outline,
<<<<<<< HEAD
              //   child: _buildProcessInfo(),
=======
              //   child: _buildProcessInfo(true),
>>>>>>> 230afad3 (feat: greige order detail)
              // ),
              _buildSectionCard(
                title: 'Hasil $processName',
                icon: Icons.account_tree_outlined,
<<<<<<< HEAD
                child: _buildResultInfo(),
              ),
              if (withBrokenYarns)
                _buildSectionCard(
                  title: 'Benang Putus',
                  icon: Icons.content_cut_outlined,
                  child: _buildBrokenYarns(),
                ),
              if (withAttachments)
                _buildSectionCard(
                  title: 'Lampiran',
                  icon: Icons.attachment_outlined,
                  child: _buildAttachmentList(context),
                ),
              _buildPasangSection(true),
=======
                child: _buildResultInfo(true),
              ),
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> 230afad3 (feat: greige order detail)
=======
=======
              if (withBrokenYarns)
                _buildSectionCard(
                  title: 'Catatan Benang Putus',
                  icon: Icons.content_cut_outlined,
                  child: _buildBrokenYarns(true),
                ),
              if (withAttachments)
                _buildSectionCard(
                  title: 'Lampiran',
                  icon: Icons.attachment_outlined,
                  child: _buildAttachmentList(context),
                ),
>>>>>>> deb4d660 (fix: detail warping - shearing)
              _buildPasangSection(true),
>>>>>>> 663098db (fix: detail warping)
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 5afc921a (fix: detail proses)
          Column(
            children: [
              _buildSectionCard(
                title: 'Kebutuhan Benang',
                icon: Icons.layers_outlined,
                child: _buildYarnItems(true),
              ),
              _buildSectionCard(
                title: 'Kebutuhan Loom Beam',
                icon: Icons.inventory_2_outlined,
                child: _buildLoomBeams(true),
              ),
              _buildSectionCard(
                title: 'Catatan Order Greige',
                icon: Icons.note_alt_outlined,
                child: _buildNote(_mapValue(data['order_greige'])['notes']),
              ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
<<<<<<< HEAD
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
          //   child:
          //       _buildNote(_mapValue(data['order_greige'])['notes']),
          // ),
          // ].separatedBy(CustomTheme().vGap('xl')),
          // ),
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> 5afc921a (fix: detail proses)
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
<<<<<<< HEAD
<<<<<<< HEAD
          if (!withMultiMachine) _buildQuickInfoRow(isTablet),
=======
          _buildQuickInfoRow(isTablet),
>>>>>>> 230afad3 (feat: greige order detail)
=======
          if (!withMultiMachine) _buildQuickInfoRow(isTablet),
>>>>>>> deb4d660 (fix: detail warping - shearing)
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

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
<<<<<<< HEAD
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
  Widget _buildMachine(BuildContext context, bool isTablet) {
    final machines = data['machines'] as List? ?? [];

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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('Lokasi: ${machine['location']}'),
                      ],
                    ),
                    CustomBadge(
                      title: machine['status'],
                      rework: true,
                      status: machine['status'] == 'Selesai'
                          ? 'Selesai'
                          : 'Diproses',
                      withStatus: true,
                    ),
                  ],
                ),
              const Divider(),
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
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttachmentList(BuildContext context) {
    final attachments = _listValue(data['attachments']);
    if (attachments.isEmpty) return NoData();

    final baseUrl = dotenv.env['IMAGE_URL'] ?? '';

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: attachments.map((item) {
        final isNew = item.containsKey('path');
        final filePath = (isNew ? item['path'] : item['file_path'])?.toString();
        final fileName = isNew
            ? item['name']?.toString() ?? ''
            : item['file_name']?.toString() ?? filePath?.split('/').last ?? '';
        final extension = fileName.split('.').last.toLowerCase();
        final isPdf = extension == 'pdf';
        final isImage =
            ['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(extension);
        final remotePath = filePath == null ||
                filePath.startsWith('http://') ||
                filePath.startsWith('https://')
            ? filePath
            : '$baseUrl$filePath';

        var fileSizeText = 'Unknown size';
        if (isNew && filePath != null) {
          final file = File(filePath);
          if (file.existsSync()) {
            fileSizeText = formatBytes(file.lengthSync());
          }
        } else {
          final fileSize = int.tryParse(item['file_size']?.toString() ?? '');
          if (fileSize != null) {
            fileSizeText = formatBytes(fileSize);
          }
        }

        Widget preview;
        if (isImage && isNew && filePath != null) {
          preview = Image.file(File(filePath), fit: BoxFit.cover);
        } else if (isImage && remotePath != null) {
          preview = Image.network(
            remotePath,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) =>
                const Icon(Icons.broken_image, size: 40),
          );
        } else {
          preview = Icon(
            Icons.description_outlined,
            size: 40,
            color: Colors.grey.shade700,
          );
        }

        return GestureDetector(
          onTap: filePath == null
              ? null
              : () async {
                  if (isImage) {
                    showImageDialog(
                      context: context,
                      isNew: isNew,
                      filePath: isNew ? filePath : remotePath!,
                    );
                    return;
                  }

                  if (isPdf) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(
                          url: remotePath!,
                          fileName: fileName,
                        ),
                      ),
                    );
                    return;
                  }

                  await launchUrl(
                    Uri.parse(remotePath!),
                    mode: LaunchMode.externalApplication,
                  );
                },
          child: Container(
            width: 320,
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade100,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: preview,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fileSizeText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
<<<<<<< HEAD
<<<<<<< HEAD
    return TemplateCard(
      icon: icon,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
=======
    return Container(
      width: double.infinity,
      padding: CustomTheme().padding('card'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
=======
    return TemplateCard(
      icon: icon,
      title: title,
>>>>>>> 5afc921a (fix: detail proses)
      child: Column(
        children: [
<<<<<<< HEAD
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CustomTheme().colors('primary').withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: CustomTheme().colors('primary'),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ].separatedBy(CustomTheme().hGap('md')),
          ),
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> 5afc921a (fix: detail proses)
          child,
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildProcessInfo() {
=======
  Widget _buildProcessInfo(bool isTablet) {
>>>>>>> 230afad3 (feat: greige order detail)
    final items = [
      {
        'label': 'No. Proses',
        'value': _display(data[processNoKey]),
        'icon': Icons.confirmation_number_outlined
      },
      {
        'label': 'Status',
        'value': _display(data['status']),
        'icon': Icons.verified_outlined
      },
      {
        'label': 'Mulai',
        'value': _formatDateTime(data['start_time']),
        'icon': Icons.play_circle_outline
      },
      {
        'label': 'Selesai',
        'value': _formatDateTime(data['end_time']),
        'icon': Icons.task_alt_outlined
      },
    ];

<<<<<<< HEAD
    return _buildInfoGrid(items);
  }

  Widget _buildResultInfo() {
=======
    return _buildInfoGrid(items, isTablet);
  }

  Widget _buildResultInfo(bool isTablet) {
>>>>>>> 230afad3 (feat: greige order detail)
    final rows = _resultRows();

    if (rows.isEmpty) {
      return NoData();
    }

<<<<<<< HEAD
    return _buildInfoGrid(rows);
  }

  Widget _buildBrokenYarns() {
    final brokenYarns = _listValue(data['broken_yarns'])
      ..sort(
        (a, b) => (a['sort_order'] as num? ?? 0)
            .compareTo(b['sort_order'] as num? ?? 0),
      );

    if (brokenYarns.isEmpty) {
      return NoData();
    }

    final rows = brokenYarns
        .map(
          (item) => <String, dynamic>{
            'label': _display(item['label']),
            'value': formatNumber(item['qty']),
          },
        )
        .toList();

    return _buildWrapInfoGrid(rows);
  }

  Widget _buildWrapInfoGrid(List<Map<String, dynamic>> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;

        return Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: items.map((item) {
            return Container(
              width: itemWidth,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
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
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildInfoGrid(
    List<Map<String, dynamic>> items, {
    bool showIcon = true,
  }) {
=======
    return _buildInfoGrid(rows, isTablet);
  }

<<<<<<< HEAD
  Widget _buildInfoGrid(List<Map<String, dynamic>> items, bool isTablet) {
>>>>>>> 230afad3 (feat: greige order detail)
=======
  Widget _buildBrokenYarns(bool isTablet) {
    final brokenYarns = _listValue(data['broken_yarns'])
      ..sort(
        (a, b) => (a['sort_order'] as num? ?? 0)
            .compareTo(b['sort_order'] as num? ?? 0),
      );

    if (brokenYarns.isEmpty) {
      return NoData();
    }

    final rows = brokenYarns
        .map(
          (item) => <String, dynamic>{
            'label': _display(item['label']),
            'value': formatNumber(item['qty']),
          },
        )
        .toList();

    return _buildInfoGrid(rows, isTablet, showIcon: false);
  }

  Widget _buildInfoGrid(
    List<Map<String, dynamic>> items,
    bool isTablet, {
    bool showIcon = true,
  }) {
>>>>>>> deb4d660 (fix: detail warping - shearing)
    if (items.isEmpty) {
      return NoData();
    }

<<<<<<< HEAD
    final children = items
        .map((item) {
          final infoColumn = Column(
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
          );

          final card = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                if (showIcon)
                  Icon(
                    item['icon'] as IconData,
                    size: 20,
                    color: CustomTheme().colors('primary'),
                  ),
                Expanded(child: infoColumn),
              ].separatedBy(CustomTheme().hGap('md')),
            ),
          );

          return Expanded(child: card);
        })
        .toList()
        .separatedBy(const SizedBox(width: 16));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
=======
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
              if (showIcon)
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
>>>>>>> 230afad3 (feat: greige order detail)
    );
  }

  Widget _buildTimelineInfo(bool isTablet) {
    return Column(
      children: [
        _buildTimelineItem(
          icon: Icons.access_time_outlined,
          iconColor: Colors.blue,
          title: 'Mulai Proses',
          time: data['start_time'],
          user: _mapValue(data['start_by'])['name'],
          isLast: data['end_time'] == null,
        ),
        if (data['end_time'] != null)
          _buildTimelineItem(
            icon: Icons.task_alt_outlined,
            iconColor: Colors.green,
            title: 'Selesai Proses',
            time: data['end_time'],
            user: _mapValue(data['end_by'])['name'],
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
<<<<<<< HEAD
    final orderGreige = _mapValue(data['order_greige']);
    final design = _mapValue(orderGreige['design']);
    final yarnItems = _listValue(orderGreige['yarn_items']);
=======
    final yarnItems = _listValue(_mapValue(data['order_greige'])['yarn_items']);
>>>>>>> 230afad3 (feat: greige order detail)

    if (yarnItems.isEmpty) {
      return NoData();
    }

<<<<<<< HEAD
    final warpingTypeLabel = _formatWarpingType(
      design['warping_type'] ?? orderGreige['warping_type'],
    );

=======
>>>>>>> 230afad3 (feat: greige order detail)
    return Column(
      children: yarnItems
          .map((item) {
            return _buildDataBox(
              children: [
                _buildInfoLine('Kode Warna', _display(item['color_code'])),
                _buildInfoLine(
<<<<<<< HEAD
                    'Jml. Bng', _withUnit(item['yarn_qty'], 'Helai')),
                if (item['ne'] != null)
                  _buildInfoLine(
                    'Ne',
                    _display(item['ne']),
                    trailing: warpingTypeLabel.isEmpty
                        ? null
                        : _buildWarpingTypeBadge(warpingTypeLabel),
                  ),
                _buildInfoLine(
                  'Lot Benang',
                  _formatYarnLot(design['yarn_lot']),
                ),
=======
                    'Jumlah Benang', _withUnit(item['yarn_qty'], 'PCS')),
                if (item['ne'] != null)
                  _buildInfoLine('Ne', _display(item['ne'])),
                if (item['lot'] != null)
                  _buildInfoLine('Lot', _display(item['lot'])),
>>>>>>> 230afad3 (feat: greige order detail)
              ],
            );
          })
          .toList()
          .separatedBy(CustomTheme().vGap('md')),
    );
  }

  Widget _buildLoomBeams(bool isTablet) {
<<<<<<< HEAD
    final orderGreige = _mapValue(data['order_greige']);
    final design = _mapValue(orderGreige['design']);
    final loomBeams = _listValue(orderGreige['loom_beams']);
=======
    final loomBeams = _listValue(_mapValue(data['order_greige'])['loom_beams']);
>>>>>>> 230afad3 (feat: greige order detail)

    if (loomBeams.isEmpty) {
      return NoData();
    }

    return Column(
      children: loomBeams
          .map((item) {
            return _buildDataBox(
              children: [
<<<<<<< HEAD
                _buildInfoLine('Benang', _withUnit(item['yarn_qty'], 'Helai')),
                _buildInfoLine('Panjang', _withUnit(item['length'], 'M')),
                _buildInfoLine(
                    'Lebar Beam', _withUnit(design['beam_width'], 'M')),
                _buildInfoLine('No. MC', _display(design['machine_no'])),
                _buildInfoLine('Beam A/B', _display(design['beam_ab'])),
                // _buildInfoLine('Berat', _withUnit(item['weight'], 'KG')),
                // _buildInfoLine('Majun', _withUnit(item['majun'], 'KG')),
                // _buildInfoLine('Gempor', _withUnit(item['gempor'], 'CNS')),
=======
                _buildInfoLine('Benang', _withUnit(item['yarn_qty'], 'PCS')),
                _buildInfoLine(
                    'Lebar Beam', _withUnit(item['beam_width'], 'M')),
                _buildInfoLine('Beam A/B', _display(item['beam_ab'])),
                _buildInfoLine('Panjang', _withUnit(item['length'], 'M')),
                _buildInfoLine('No. MC', _display(item['machine_no'])),
                _buildInfoLine('Berat', _withUnit(item['weight'], 'KG')),
                _buildInfoLine('Majun', _withUnit(item['majun'], 'KG')),
                _buildInfoLine('Gempor', _withUnit(item['gempor'], 'CNS')),
>>>>>>> 230afad3 (feat: greige order detail)
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

<<<<<<< HEAD
  Widget _buildInfoLine(String label, String value, {Widget? trailing}) {
    final valueChildren = <Widget>[
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
    ];

    if (trailing != null) {
      valueChildren.add(const SizedBox(width: 8));
      valueChildren.add(trailing);
    }

=======
  Widget _buildInfoLine(String label, String value) {
>>>>>>> 230afad3 (feat: greige order detail)
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
<<<<<<< HEAD
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: valueChildren,
=======
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
>>>>>>> 230afad3 (feat: greige order detail)
          ),
        ),
      ].separatedBy(CustomTheme().hGap('md')),
    );
  }

<<<<<<< HEAD
  String _formatYarnLot(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '-';
    return formatNumber(value);
  }

  String _formatWarpingType(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return '';

    final text = value.toString().toLowerCase();
    if (text.contains('double')) return 'Double';
    if (text.contains('single')) return 'Single';

    return value
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Widget _buildWarpingTypeBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: CustomTheme().buttonColor('primary'),
          fontSize: CustomTheme().fontSize('xs'),
          fontWeight: CustomTheme().fontWeight('bold'),
        ),
      ),
    );
  }

=======
>>>>>>> 230afad3 (feat: greige order detail)
  Widget _buildNote(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return NoData();
    }

    return Text(
      htmlToPlainText(value.toString()),
      style: TextStyle(fontSize: CustomTheme().fontSize('lg')),
    );
  }

  Widget _buildVerticalDivider(bool isOrder) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isOrder
          ? Colors.white.withOpacity(0.2)
          : Colors.grey.withOpacity(0.2),
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
        builder: (context) => GreigeOrderDetail(id: id.toString()),
      ),
    );
  }

  List<Map<String, dynamic>> _resultRows() {
    if (processName == 'Warping') {
      return [
        {
          'label': 'Jenis Warping',
<<<<<<< HEAD
<<<<<<< HEAD
          'value': _formatType(data['order_greige']['warping_type']),
          'icon': Icons.category_outlined
        },
        {
          'label': 'Jumlah Panjang',
          'value': _withUnit(data['length'], ''),
=======
          'value': _formatType(data['warping_type']),
          'icon': Icons.category_outlined
        },
        {
          'label': 'Qty Benang',
          'value': _withUnit(data['yarn_qty'], 'KG'),
          'icon': Icons.layers_outlined
        },
        {
          'label': 'Panjang',
          'value': _withUnit(data['length'], 'M'),
>>>>>>> 230afad3 (feat: greige order detail)
=======
          'value': _formatType(data['order_greige']['warping_type']),
          'icon': Icons.category_outlined
        },
        {
          'label': 'Jumlah Panjang',
          'value': _withUnit(data['length'], ''),
>>>>>>> deb4d660 (fix: detail warping - shearing)
          'icon': Icons.straighten_outlined
        },
        {
          'label': 'Jumlah Section',
          'value': _withUnit(data['section'], ''),
          'icon': Icons.view_column_outlined
        },
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
        {
          'label': 'Jumlah Berat',
          'value': _withUnit(data['weight'], 'KG'),
          'icon': Icons.layers_outlined
        },
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> deb4d660 (fix: detail warping - shearing)
      ];
    }

    if (processName == 'Sizing') {
      return [
        {
          'label': 'Panjang Gulungan',
          'value': _withUnit(data['roll_length'], 'M'),
          'icon': Icons.straighten_outlined
        },
      ];
    }

    if (processName == 'Weaving') {
      return [
        {
          'label': 'Qty',
          'value': _withUnit(data['qty'], 'PCS'),
          'icon': Icons.layers_outlined
        },
        {
          'label': 'Berat',
          'value': _withUnit(data['weight'], 'KG'),
          'icon': Icons.scale_outlined
        },
        {
          'label': 'Waste',
          'value': _withUnit(data['waste'], 'KG'),
          'icon': Icons.delete_sweep_outlined
        },
      ];
    }

    return [
      {
        'label': 'Qty',
        'value': _withUnit(data['qty'], 'PCS'),
        'icon': Icons.layers_outlined
      },
      {
        'label': 'Berat',
        'value': _withUnit(data['weight'], 'KG'),
        'icon': Icons.scale_outlined
      },
    ];
  }
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 663098db (fix: detail warping)

  Widget _buildPasangSection(bool isTablet) {
    final pasangs = _listValue(data['pasangs']);

    if (pasangs.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSectionCard(
      title: 'Panjang Pasang',
      icon: Icons.straighten_outlined,
      child: _buildPasangList(pasangs, isTablet),
    );
  }

  Widget _buildPasangList(
    List<Map<String, dynamic>> pasangs,
    bool isTablet,
  ) {
    return Column(
      children: pasangs.asMap().entries.map((entry) {
        final index = entry.key;
        final pasang = entry.value;

        final pasangNo = pasang['pasang_no'] ?? index + 1;
        final length = pasang['length'];

        return Container(
          margin: EdgeInsets.only(
            bottom: index == pasangs.length - 1 ? 0 : 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Center(
                  child: Text(
                    '$pasangNo',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pasang $pasangNo',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                _withUnit(length, 'M'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
=======
>>>>>>> 663098db (fix: detail warping)
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

String _formatType(dynamic value) {
  if (value == null || value.toString().isEmpty) return '-';

  return value
      .toString()
      .split('_')
      .map((word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
