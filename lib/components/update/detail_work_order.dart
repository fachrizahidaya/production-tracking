import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_detail_badge.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class DetailWorkOrder extends StatefulWidget {
  final data;
  final form;
  final notes;
  final withQtyAndWeight;
  final handleBuildAttachment;
  final label;
  final forDyeing;
  final withNote;

  const DetailWorkOrder(
      {super.key,
      this.data,
      this.form,
      this.forDyeing,
      this.handleBuildAttachment,
      this.label,
      this.notes,
      this.withQtyAndWeight,
      this.withNote});

  @override
  State<DetailWorkOrder> createState() => _DetailWorkOrderState();
}

class _DetailWorkOrderState extends State<DetailWorkOrder>
    with TickerProviderStateMixin {
  late TabController _tabWoController;
  late TabController _tabController;

  @override
  void initState() {
    _tabWoController = TabController(
      length: itemWoFilters.length,
      vsync: this,
    );

    _tabController = TabController(
      length: itemFilters.length,
      vsync: this,
    );

    _tabWoController.addListener(() {
      if (_tabWoController.indexIsChanging) return;

      setState(() {
        selectedItemWoIndex = _tabWoController.index;
      });
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  final List<String> itemWoFilters = [
    'Catatan Work Order',
    'Material Work Order',
  ];

  final List<String> itemFilters = [
    'Catatan Proses',
    'Lampiran Proses',
  ];

  int selectedIndex = 0;
  int selectedItemWoIndex = 0;

  @override
  void dispose() {
    _tabWoController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildProcessWoFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(itemWoFilters.length, (index) {
          final isSelected = selectedItemWoIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedItemWoIndex = index;
              });

              _tabWoController.animateTo(index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? CustomTheme().buttonColor('primary')
                      : Colors.grey.shade400,
                ),
                color: isSelected
                    ? CustomTheme().buttonColor('primary')
                    : Colors.white,
                boxShadow: [CustomTheme().boxShadowTheme()],
              ),
              padding: CustomTheme().padding('badge'),
              child: Text(
                itemWoFilters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }).separatedBy(CustomTheme().hGap('lg')),
      ),
    );
  }

  Widget _buildSwipeWoContent() {
    final List<Map<String, dynamic>> items =
        (widget.data['work_orders']['items'] ?? [])
            .cast<Map<String, dynamic>>();
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabWoController,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: widget.data['work_orders']['notes'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              htmlToPlainText(
                                  widget.data['work_orders']['notes']),
                              style: TextStyle(
                                fontSize: CustomTheme().fontSize('lg'),
                              ),
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        )
                      : NoData(),
                ),
              ),
            ],
          ),
          Container(
            child: items.isEmpty
                ? Center(child: Text('No Data'))
                : ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListItem(item: item);
                    },
                    separatorBuilder: (context, index) =>
                        CustomTheme().vGap('xl'),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkOrderCard(isTablet),
            _buildProcessWoFilter(),
            _buildSwipeWoContent()
          ].separatedBy(CustomTheme().vGap('')),
        );
      },
    );
  }

  Widget _buildWorkOrderCard(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(isTablet),
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isTablet ? _buildTabletInfoLayout() : _buildMobileInfoLayout(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CustomTheme().buttonColor('primary'),
            CustomTheme().buttonColor('primary').withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    size: isTablet ? 28 : 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['work_orders']['wo_no']?.toString() ?? '-',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.data['work_orders']['wo_date'] != null
                            ? DateFormat("dd MMM yyyy").format(DateTime.parse(
                                widget.data['work_orders']['wo_date']))
                            : '-',
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 11,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(isTablet),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isTablet) {
    final status =
        widget.data['work_orders']['status']?.toString().toLowerCase() ??
            'pending';
    final statusConfig = _getStatusConfig(status);

    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 14 : 12,
          vertical: isTablet ? 8 : 6,
        ),
        child: CustomBadge(
          title: widget.data['work_orders']['status']?.toString() ?? '-',
          withStatus: true,
          status: widget.data['work_orders']['status']?.toString() ?? '-',
        ));
  }

  Widget _buildQuickInfoRow(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: CustomTheme().buttonColor('primary').withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CustomTheme().buttonColor('primary').withOpacity(0.1),
        ),
      ),
      child: isTablet
          ? Row(
              children: [
                Expanded(
                  child: _buildQuickInfoItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Qty Greige',
                    value: _formatGreigeQty(),
                    isTablet: isTablet,
                  ),
                ),
                _buildVerticalDivider(),
              ],
            )
          : Column(
              children: [
                _buildQuickInfoItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Qty Greige',
                  value: _formatGreigeQty(),
                  isTablet: isTablet,
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [],
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
    bool isFullWidth = false,
  }) {
    return Row(
      mainAxisAlignment:
          isFullWidth ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.grey[300],
    );
  }

  Widget _buildTabletInfoLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInfoSection(
                title: 'Informasi Greige',
                icon: Icons.layers_outlined,
                children: [
                  _buildInfoRow(
                    label: 'Qty Greige',
                    value:
                        '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']?['code']}',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        if (widget.withNote == true)
          Expanded(
            child: Column(
              children: [
                _buildInfoSection(
                  title: 'Catatan Work Order',
                  icon: Icons.description_outlined,
                  children: [
                    _buildInfo(
                      value: _getNoteContentByLabel(
                        notes: widget.data['work_orders']['notes'],
                        label: widget.label,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMobileInfoLayout() {
    return Column(
      children: [
        _buildInfoSection(
          title: 'Informasi Greige',
          icon: Icons.layers_outlined,
          children: [
            _buildInfoRow(
              label: 'Qty Greige',
              value: widget.data['greige']?['name']?.toString() ?? '-',
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.withNote == true)
          _buildInfoSection(
            title: 'Catatan Work Order',
            icon: Icons.description_outlined,
            children: [
              _buildInfo(
                  value: widget.data['work_orders']['notes'] is Map
                      ? htmlToPlainText(widget.data['notes'][widget.label])
                      : 'No Data')
            ],
          ),
      ],
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: CustomTheme().buttonColor('primary'),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            ':',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNoteContentByLabel({
    required dynamic notes,
    required String label,
  }) {
    if (notes == null || notes is! List) return 'No Data';

    final note = notes.whereType<Map<String, dynamic>>().firstWhere(
          (n) => n['label'] == label,
          orElse: () => {},
        );

    final content = note['content'];

    if (content == null || content.toString().isEmpty) {
      return 'No Data';
    }

    return htmlToPlainText(content.toString());
  }

  Widget _buildInfo({
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  String _formatGreigeQty() {
    if (widget.data['work_orders']['greige_qty'] == null ||
        widget.data['work_orders']['greige_qty'].toString().isEmpty) {
      return '-';
    }

    final qty = widget.data['work_orders']['greige_qty'];
    final unit = widget.data['work_orders']['greige_unit']?['code'] ?? '';

    if (qty is num) {
      return '${NumberFormat("#,###.#").format(qty)} $unit'.trim();
    }
    return '$qty $unit'.trim();
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'selesai':
        return {
          'label': 'Selesai',
          'icon': Icons.check_circle,
          'bgColor': Colors.white,
          'textColor': Colors.green[700],
        };
      case 'in_progress':
      case 'proses':
        return {
          'label': 'Dalam Proses',
          'icon': Icons.hourglass_top,
          'bgColor': Colors.white,
          'textColor': Colors.blue[700],
        };
      case 'pending':
      case 'menunggu':
        return {
          'label': 'Menunggu',
          'icon': Icons.schedule,
          'bgColor': Colors.white,
          'textColor': Colors.orange[700],
        };
      case 'rework':
        return {
          'label': 'Rework',
          'icon': Icons.replay,
          'bgColor': Colors.white,
          'textColor': Colors.red[700],
        };
      default:
        return {
          'label': status,
          'icon': Icons.info_outline,
          'bgColor': Colors.white,
          'textColor': Colors.grey[700],
        };
    }
  }
}
