import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_detail_badge.dart';
import 'package:textile_tracking/components/master/layout/card/list_item.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
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

  const DetailWorkOrder(
      {super.key,
      this.data,
      this.form,
      this.forDyeing,
      this.handleBuildAttachment,
      this.label,
      this.notes,
      this.withQtyAndWeight});

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
    return TabBarView(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isPortrait)
                Expanded(
                    child: CustomCard(
                        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Work Order',
                      style: TextStyle(
                          fontSize: CustomTheme().fontSize('lg'),
                          fontWeight: CustomTheme().fontWeight('bold')),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomDetailBadge(
                            width: 280.0,
                            status: 'Menunggu Diproses',
                            label: 'Nomor Work Order',
                            value: widget.data['work_orders']?['wo_no']
                                    ?.toString() ??
                                'No Data'),
                        CustomDetailBadge(
                          width: 280.0,
                          status: 'Menunggu Diproses',
                          label: 'Tanggal Work Order',
                          value: widget.data['start_time'] != null
                              ? DateFormat("dd MMM yyyy").format(
                                  DateTime.parse(widget.data['start_time']))
                              : NoData(),
                        ),
                        CustomDetailBadge(
                          width: 280.0,
                          status: 'Menunggu Diproses',
                          label: 'Qty Greige',
                          value:
                              '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']['code']}',
                        ),
                        CustomDetailBadge(
                          width: 280.0,
                          status: 'Menunggu Diproses',
                          label: 'Dibuat oleh',
                          value: widget.data['work_orders']['user']['name'] ??
                              'No Data',
                        ),
                      ],
                    )
                  ].separatedBy(CustomTheme().vGap('lg')),
                )))
            ].separatedBy(CustomTheme().hGap('2xl')),
          ),
          if (isPortrait)
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Work Order',
                        style: TextStyle(
                            fontSize: CustomTheme().fontSize('lg'),
                            fontWeight: CustomTheme().fontWeight('bold')),
                      ),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          CustomDetailBadge(
                              width: 180.0,
                              status: 'Menunggu Diproses',
                              label: 'Nomor Work Order',
                              value: widget.data['work_orders']?['wo_no']
                                      ?.toString() ??
                                  'No Data'),
                          CustomDetailBadge(
                            width: 180.0,
                            status: 'Menunggu Diproses',
                            label: 'Tanggal Work Order',
                            value: widget.data['start_time'] != null
                                ? DateFormat("dd MMM yyyy").format(
                                    DateTime.parse(widget.data['start_time']))
                                : NoData(),
                          ),
                          CustomDetailBadge(
                            width: 180.0,
                            status: 'Menunggu Diproses',
                            label: 'Qty Greige',
                            value:
                                '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']['code']}',
                          ),
                          CustomDetailBadge(
                            width: 180.0,
                            status: 'Menunggu Diproses',
                            label: 'Dibuat oleh',
                            value: widget.data['work_orders']['user']['name'] ??
                                'No Data',
                          ),
                        ],
                      )
                    ].separatedBy(CustomTheme().vGap('lg')),
                  )),
                ),
              ],
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProcessWoFilter(),
              SizedBox(
                height: 300,
                child: _buildSwipeWoContent(),
              ),
            ].separatedBy(CustomTheme().vGap('xl')),
          ),
        ].separatedBy(CustomTheme().vGap('xl')));
  }
}
