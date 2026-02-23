// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

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
import 'package:textile_tracking/screens/finish/%5Bfinish_process_id%5D.dart';
import 'package:textile_tracking/screens/finish/index.dart';
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
      this.itemGradeOption});

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(isTablet),

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

  Widget _buildActionButtons(bool isTablet) {
    return Padding(
      padding: CustomTheme().padding('card-detail'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.data['can_update'] == true)
            ElevatedButton.icon(
              onPressed: () {
                final String woId = widget.data['wo_id'].toString();
                final String processId = widget.data['id'].toString();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FinishProcess(
                      title: "Selesai ${widget.label}",
                      manualWoId: woId,
                      manualProcessId: processId,
                      formPageBuilder: (context, id, processId, data, form,
                          handleSubmit, handleChangeInput) {
                        return FinishProcessManual(
                          id: woId,
                          processId: processId,
                          idProcess: widget.idProcess,
                          data: widget.data,
                          form: form,
                          handleSubmit: widget.handleSubmit,
                          handleChangeInput: widget.handleChangeInput,
                          title: 'Selesai ${widget.label}',
                          label: widget.label,
                          fetchWorkOrder: widget.fetchFinish,
                          getWorkOrderOptions: (service) =>
                              service.dataListOption,
                          processService: widget.processService,
                          forDyeing: widget.forDyeing,
                          withItemGrade: widget.withItemGrade,
                          withQtyAndWeight: widget.withQtyAndWeight,
                          forPacking: widget.forPacking,
                          fetchItemGrade: (service) => service.fetchOptions(),
                          getItemGradeOptions: (service) =>
                              service.dataListOption,
                          itemGradeOption: widget.data['grades'] ?? [],
                        );
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.task_alt_outlined, color: Colors.white),
              label: Text('Selesai ${widget.label}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
        ].separatedBy(CustomTheme().hGap('md')),
      ),
    );
  }

  Widget _buildHeaderSection(bool isTablet) {
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
            boxShadow: [
              BoxShadow(
                color: CustomTheme().buttonColor('primary').withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ]),
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
                              color: Colors.white,
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
                                ? 'Dibuat pada ${DateFormat("dd MMM yyyy, HH.mm").format(DateTime.parse(widget.data['created_at']))}'
                                : '-',
                            style: TextStyle(
                              fontSize: CustomTheme().fontSize('lg'),
                              color: Colors.white.withOpacity(0.8),
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
            // Quick Info Row
            if (widget.data['machine_id'] != null ||
                widget.data['maklon_name'] != null)
              _buildQuickInfoRow(isTablet),
          ].separatedBy(CustomTheme().vGap('xl')),
        ),
      ),
    );
  }

  /// Status Badge
  Widget _buildStatusBadge(bool isTablet) {
    return CustomBadge(
      title: widget.data['status']?.toString() ?? '-',
      withStatus: true,
      status: widget.data['status']?.toString() ?? '-',
    );
  }

  /// Quick Info Row di Header
  Widget _buildQuickInfoRow(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
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
                value: widget.data['machine']?['name'] ?? '-',
                isTablet: isTablet,
              ),
            ),
          if (widget.data['machine_id'] != null) _buildVerticalDivider(),
          if (widget.data['machine_id'] != null)
            Expanded(
              child: _buildQuickInfoItem(
                icon: Icons.location_on_outlined,
                label: 'Lokasi',
                value: widget.data['machine']?['location'] ?? '-',
                isTablet: isTablet,
              ),
            ),
        ],
      ),
    );
  }

  /// Quick Info Item
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
          color: Colors.white,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('sm'),
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: isTablet ? 13 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.white),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ].separatedBy(CustomTheme().vGap('sm')),
    );
  }

  /// Vertical Divider
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withOpacity(0.2),
    );
  }

  /// Layout untuk Tablet
  Widget _buildTabletLayout(bool isLargeTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          title: 'Informasi Work Order',
          icon: Icons.description_outlined,
          child: _buildWorkOrderInfo(true),
        ),
        if (widget.withItemGrade == false)
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
        if (widget.withItemGrade == true && widget.existingGrades.isNotEmpty)
          _buildInfoCard(
            title: 'Informasi Grade',
            icon: Icons.grade_outlined,
            child: _buildGradeInfo(true),
          ),
        if (widget.label == 'Packing')
          _buildInfoCard(
            title: 'Informasi Berat',
            icon: Icons.scale_outlined,
            child: _buildWeightInfo(true),
          ),
        _buildInfoCard(
          title: 'Timeline Proses',
          icon: Icons.timeline_outlined,
          child: _buildTimelineInfo(true),
        ),
        _buildInfoCard(
          title: 'Catatan Proses',
          icon: Icons.note_outlined,
          child: _buildNote(true),
        ),
        _buildInfoCard(
          title: 'Lampiran Proses',
          icon: Icons.attachment_outlined,
          child: _buildAttachment(true),
        ),
        _buildInfoCard(
          title: 'Catatan dari Work Order',
          icon: Icons.note_outlined,
          child: _buildNoteWo(true),
        ),
        _buildInfoCard(
          title: 'Material Work Order',
          icon: Icons.inventory_2_outlined,
          child: _buildMaterial(
            true,
          ),
        ),
      ].separatedBy(CustomTheme().vGap('xl')),
    );
  }

  /// Layout untuk Mobile
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          title: 'Informasi Work Order',
          icon: Icons.description_outlined,
          child: _buildWorkOrderInfo(false),
        ),
        if (widget.withItemGrade == false)
          _buildInfoCard(
            title: 'Informasi Proses',
            icon: Icons.settings_outlined,
            child: _buildProcessInfo(false),
          ),
        if (widget.data['rework'] == true)
          _buildInfoCard(
            title: 'Informasi Rework',
            icon: Icons.replay_outlined,
            child: _buildReworkInfo(true),
          ),
        if (widget.withItemGrade == true && widget.existingGrades.isNotEmpty)
          _buildInfoCard(
            title: 'Informasi Grade',
            icon: Icons.layers_outlined,
            child: _buildGradeInfo(false),
          ),
        if (widget.label == 'Packing')
          _buildInfoCard(
            title: 'Informasi Berat',
            icon: Icons.layers_outlined,
            child: _buildWeightInfo(false),
          ),
        _buildInfoCard(
          title: 'Timeline Proses',
          icon: Icons.timeline_outlined,
          child: _buildTimelineInfo(false),
        ),
        _buildInfoCard(
          title: 'Catatan Proses',
          icon: Icons.note_outlined,
          child: _buildNote(true),
        ),
        _buildInfoCard(
          title: 'Lampiran Proses',
          icon: Icons.attachment_outlined,
          child: _buildAttachment(true),
        ),
        _buildInfoCard(
          title: 'Catatan dari Work Order',
          icon: Icons.note_outlined,
          child: _buildNoteWo(true),
        ),
        _buildInfoCard(
          title: 'Material Work Order',
          icon: Icons.inventory_2_outlined,
          child: _buildMaterial(
            true,
          ),
        ),
      ],
    );
  }

  /// Info Card Container
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

  /// Work Order Info Section
  Widget _buildWorkOrderInfo(bool isTablet) {
    final items = [
      {
        'label': 'No. Work Order',
        'value': widget.data['work_orders']?['wo_no'] ?? '-',
        'id': widget.data['work_orders']?['id'] ?? '-',
        'icon': Icons.content_paste_outlined,
        'navigate': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkOrderDetail(
                id: widget.data['work_orders']?['id'].toString() ?? '-',
              ),
            ),
          );
        },
        'right-icon': Icons.chevron_right_outlined,
      },
      {
        'label': 'Tanggal Work Order',
        'value': widget.data['work_orders']['wo_date'] != null
            ? DateFormat("dd MMM yyyy")
                .format(DateTime.parse(widget.data['work_orders']['wo_date']))
            : '-',
        'id': widget.data['work_orders']?['id'] ?? '-',
        'icon': Icons.calendar_today_outlined,
        'right-icon': null,
        'navigate': null
      },
      {
        'label': 'Qty Greige',
        'value': widget.data['work_orders']?['greige_qty'] != null
            ? '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']?['code'] ?? ''}'
            : '-',
        'icon': Icons.layers_outlined,
        'navigate': null,
        'right-icon': null,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /// Greige Info Section
  Widget _buildGradeInfo(bool isTablet) {
    double getTotalGradeQty() {
      final List<dynamic>? grades = widget.existingGrades;

      if (grades == null || grades.isEmpty) return 0;

      return grades.fold<double>(0.0, (sum, item) {
        final qty = double.tryParse(item['qty']?.toString() ?? '0') ?? 0;
        return sum + qty;
      });
    }

    final totalQty = getTotalGradeQty();

    final items = [
      for (int i = 0; i < widget.existingGrades.length; i++)
        {
          'label': ' Grade ${widget.existingGrades[i]['item_grade']['code']}',
          'value': widget.existingGrades[i]['qty'] != null
              ? '${widget.existingGrades[i]['qty']} ${widget.existingGrades[i]['unit']['code']}'
              : '-',
          'icon': Icons.grade_outlined,
        },
      if (widget.existingGrades.isNotEmpty)
        {
          'label': 'Total Hasil ${widget.label}',
          'value': totalQty != null
              ? '${formatNumber(totalQty)} ${widget.existingGrades[0]['unit']['code'] ?? ''}'
              : '-',
          'icon': Icons.layers_outlined,
        },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /// Process Info Section
  Widget _buildProcessInfo(bool isTablet) {
    final items = [
      {
        'label': 'Panjang',
        'value':
            '${widget.data['length'] != null ? formatNumber(widget.data['length']) : '0'} ${widget.data['length_unit'] != null ? widget.data['length_unit']['code'] : 'CM'}',
        'icon': Icons.numbers_outlined,
      },
      {
        'label': 'Lebar',
        'value':
            '${widget.data['width'] != null ? formatNumber(widget.data['width']) : '0'} ${widget.data['width_unit'] != null ? widget.data['width_unit']['code'] : 'CM'}',
        'icon': Icons.width_normal_outlined,
      },
      if (widget.forDyeing == true)
        {
          'label': 'Qty Hasil ${widget.label}',
          'value': widget.data['qty'] != null
              ? '${formatNumber(widget.data['qty'])} ${widget.data['unit']['code']}'
              : '0 ${widget.data['unit'] != null ? widget.data['unit']['code'] : ''}',
          'icon': Icons.layers_outlined,
        },
      if (widget.withQtyAndWeight == true)
        {
          'label': 'Qty Hasil ${widget.label}',
          'value': widget.data['item_qty'] != null
              ? '${formatNumber(widget.data['item_qty'])} ${widget.data['item_unit']['code']}'
              : '0 ${widget.data['item_unit'] != null ? widget.data['item_unit']['code'] : ''}',
          'icon': Icons.trolley,
        },
      if (widget.forDyeing == false)
        {
          'label': 'Berat',
          'value': widget.data['weight'] != null
              ? '${formatNumber(widget.data['weight'])} ${widget.data['weight_unit']['code']}'
              : '0 ${widget.data['weight_unit'] != null ? widget.data['weight_unit']['code'] : ''}',
          'icon': Icons.layers_outlined,
        },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  Widget _buildReworkInfo(bool isTablet) {
    final items = [
      {
        'label': 'Referensi Rework',
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
      {
        'label': 'Mesin',
        'value': widget.data['rework_reference']['machine'] != null
            ? widget.data['rework_reference']['machine']['name']
            : '-',
        'icon': Icons.paste_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  Widget _buildWeightInfo(bool isTablet) {
    final items = [
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
        'label': 'Total Berat',
        'value':
            '${widget.data['total_weight'] != null ? formatNumber(widget.data['total_weight']) : '0'} ${'KG'}',
        'icon': Icons.numbers_outlined,
      },
    ];

    return _buildInfoGrid(items, isTablet);
  }

  /// Timeline Info Section
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
            icon: Icons.check_circle_outline,
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

  /// Info Grid Builder
  Widget _buildInfoGrid(List<Map<String, dynamic>> items, bool isTablet) {
    if (isTablet) {
      return items.length > 3
          ? Wrap(
              spacing: 8,
              runSpacing: 16,
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

  Widget _buildNoteWo(bool isTablet) {
    return widget.data['work_orders']['notes'] != null
        ? Text(
            htmlToPlainText(widget.data['work_orders']['notes']),
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
            ),
          )
        : NoData();
  }

  Widget _buildAttachment(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: widget.existingAttachment.isEmpty
              ? NoData()
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.handleBuildAttachment(context),
                ),
        ),
      ],
    );
  }

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
            ListItem(item: items[index]),
            if (index != items.length - 1) SizedBox(height: 12),
          ].separatedBy(CustomTheme().vGap('xl')),
        );
      }),
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
      rightIcon}) {
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
            // Container(
            //   padding: EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Icon(
            //     icon,
            //     size: isTablet ? 18 : 16,
            //     color: CustomTheme().buttonColor('primary'),
            //   ),
            // ),
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

  /// Timeline Item
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
}
