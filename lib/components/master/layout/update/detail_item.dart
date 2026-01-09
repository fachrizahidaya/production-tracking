import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/card/custom_detail_badge.dart';
import 'package:textile_tracking/components/master/layout/detail/material_item.dart';
import 'package:textile_tracking/components/master/text/clickable_text.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class DetailItem extends StatefulWidget {
  final data;
  final form;
  final notes;
  final withQtyAndWeight;
  final handleBuildAttachment;
  final label;
  final forDyeing;

  const DetailItem(
      {super.key,
      this.data,
      this.form,
      this.forDyeing,
      this.handleBuildAttachment,
      this.label,
      this.notes,
      this.withQtyAndWeight});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> with TickerProviderStateMixin {
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
      child: Padding(
        padding: CustomTheme().padding('card-detail'),
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
        Padding(
          padding: CustomTheme().padding('card-detail'),
          child: Row(
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
        ),
        Container(
          child: items.isEmpty
              ? Center(child: Text('No Data'))
              : ListView.separated(
                  padding: CustomTheme().padding('content'),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return MaterialItem(item: item);
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

    return SingleChildScrollView(
        child: Padding(
      padding: CustomTheme().padding('content-detail'),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: CustomTheme().padding('card-detail'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomCard(child: Placeholder()),
                  ),
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
                              width: 180.0,
                              status: 'Menunggu Diproses',
                              label: 'Nomor Work Order',
                              child: ClickableText(
                                text: widget.data['work_orders']?['wo_no']
                                        ?.toString() ??
                                    'No Data',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkOrderDetail(
                                        id: widget.data['work_orders']['id']
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
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
                          ],
                        )
                      ].separatedBy(CustomTheme().vGap('lg')),
                    )))
                ].separatedBy(CustomTheme().hGap('2xl')),
              ),
            ),
            if (isPortrait)
              Padding(
                padding: CustomTheme().padding('card-detail'),
                child: Row(
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomDetailBadge(
                                width: 220.0,
                                status: 'Menunggu Diproses',
                                label: 'Nomor Work Order',
                                child: ClickableText(
                                  text: widget.data['work_orders']?['wo_no']
                                          ?.toString() ??
                                      'No Data',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkOrderDetail(
                                          id: widget.data['work_orders']['id']
                                              .toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              CustomDetailBadge(
                                width: 220.0,
                                status: 'Menunggu Diproses',
                                label: 'Tanggal Work Order',
                                value: widget.data['start_time'] != null
                                    ? DateFormat("dd MMM yyyy").format(
                                        DateTime.parse(
                                            widget.data['start_time']))
                                    : NoData(),
                              ),
                              CustomDetailBadge(
                                width: 220.0,
                                status: 'Menunggu Diproses',
                                label: 'Qty Greige',
                                value:
                                    '${formatNumber(widget.data['work_orders']['greige_qty'])} ${widget.data['work_orders']['greige_unit']['code']}',
                              ),
                            ],
                          )
                        ].separatedBy(CustomTheme().vGap('lg')),
                      )),
                    ),
                  ],
                ),
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
          ].separatedBy(CustomTheme().vGap('xl'))),
    ));
  }
}
