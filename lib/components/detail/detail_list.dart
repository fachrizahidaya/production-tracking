// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/form/select_form.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/card/custom_detail_badge.dart';
import 'package:textile_tracking/components/master/card/list_item.dart';
import 'package:textile_tracking/components/master/text/clickable_text.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/text/view_text.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';
import 'package:textile_tracking/screens/work-order/%5Bwork_order_id%5D.dart';

class DetailList extends StatefulWidget {
  final data;
  final form;
  final existingAttachment;
  final qty;
  final notes;
  final handleSelectQtyUnit;
  final handleBuildAttachment;
  final no;
  final withItemGrade;
  final existingGrades;
  final withQtyAndWeight;
  final label;
  final forDyeing;

  const DetailList({
    super.key,
    this.data,
    this.form,
    this.existingAttachment,
    this.no,
    this.withItemGrade = false,
    this.qty,
    this.handleSelectQtyUnit,
    this.existingGrades,
    this.notes,
    this.withQtyAndWeight = false,
    this.handleBuildAttachment,
    this.label,
    this.forDyeing = false,
  });

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> with TickerProviderStateMixin {
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

  Widget _buildProcessFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: CustomTheme().padding('card-detail'),
        child: Row(
          children: List.generate(itemFilters.length, (index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });

                _tabController.animateTo(index);
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
                  itemFilters[index],
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
                    return ListItem(item: item);
                  },
                  separatorBuilder: (context, index) =>
                      CustomTheme().vGap('xl'),
                ),
        ),
      ],
    );
  }

  Widget _buildSwipeContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        Padding(
          padding: CustomTheme().padding('card-detail'),
          child: Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: widget.data['notes'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              htmlToPlainText(widget.data['notes']),
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
        Padding(
          padding: CustomTheme().padding('card-detail'),
          child: Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: widget.existingAttachment.isEmpty
                      ? NoData()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.handleBuildAttachment(context),
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final grades = widget.existingGrades;

    return SingleChildScrollView(
        child: Padding(
      padding: CustomTheme().padding('content-detail'),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: CustomTheme().padding('card-detail'),
              child: CustomCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.no ?? '-',
                                style: TextStyle(
                                    fontSize: CustomTheme().fontSize('2xl'),
                                    fontWeight:
                                        CustomTheme().fontWeight('bold')),
                              ),
                              if (widget.data['rework'] == true)
                                CustomBadge(
                                  title: 'Rework',
                                  status: 'Rework',
                                  withStatus: true,
                                  rework: true,
                                ),
                            ].separatedBy(CustomTheme().hGap('lg')),
                          ),
                          Row(
                            children: [
                              Text(
                                  'Dibuat pada ${widget.data['start_time'] != null ? DateFormat("dd MMMM yyyy, HH:mm").format(DateTime.parse(widget.data['start_time'])) : '-'}'),
                            ].separatedBy(CustomTheme().hGap('sm')),
                          ),
                        ].separatedBy(CustomTheme().vGap('sm')),
                      ),
                      CustomBadge(
                        title: widget.data['status'] ?? '-',
                        withStatus: true,
                        status: widget.data['status'],
                      ),
                    ],
                  ),
                ].separatedBy(CustomTheme().vGap('lg')),
              )),
            ),
            Padding(
              padding: CustomTheme().padding('card-detail'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.data['status'] == 'Selesai')
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (widget.forDyeing == true)
                                              ViewText(
                                                viewLabel:
                                                    'Qty Hasil ${widget.label}',
                                                viewValue: widget.data['qty'] !=
                                                        null
                                                    ? '${formatNumber(widget.data['qty'])} ${widget.data['unit']['code']}'
                                                    : '0',
                                              ),
                                            if (widget.forDyeing == false)
                                              ViewText(
                                                viewLabel: 'Berat',
                                                viewValue: widget
                                                            .data['weight'] !=
                                                        null
                                                    ? '${formatNumber(widget.data['weight'])} ${widget.data['weight_unit']['code']}'
                                                    : '0',
                                              ),
                                            if (widget.withQtyAndWeight == true)
                                              ViewText(
                                                viewLabel:
                                                    'Qty Hasil ${widget.label}',
                                                viewValue: widget
                                                            .data['item_qty'] !=
                                                        null
                                                    ? '${formatNumber(widget.data['item_qty'])} ${widget.data['item_unit']['code']}'
                                                    : '0',
                                              ),
                                            // ViewText(
                                            //   viewLabel: 'Panjang',
                                            //   viewValue:
                                            //       '${widget.data['length'] != null ? formatNumber(widget.data['length']) : '0'} ${widget.data['length_unit']['code']}',
                                            // ),
                                            // ViewText(
                                            //   viewLabel: 'Lebar',
                                            //   viewValue:
                                            //       '${widget.data['width'] != null ? formatNumber(widget.data['width']) : '0'} ${widget.data['width_unit']['code']}',
                                            // ),
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  if (widget.data['machine_id'] != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Informasi Mesin',
                                          style: TextStyle(
                                              fontSize:
                                                  CustomTheme().fontSize('lg'),
                                              fontWeight: CustomTheme()
                                                  .fontWeight('bold')),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CustomDetailBadge(
                                              width: isPortrait ? 340.0 : 280.0,
                                              status: 'Menunggu Diproses',
                                              label: 'Mesin',
                                              value: widget.data['machine']
                                                      ['name'] ??
                                                  NoData(),
                                            ),
                                            CustomDetailBadge(
                                              width: isPortrait ? 340.0 : 280.0,
                                              status: 'Menunggu Diproses',
                                              label: 'Lokasi',
                                              value: widget.data['machine']
                                                      ['location'] ??
                                                  NoData(),
                                            ),
                                          ],
                                        ),
                                      ].separatedBy(CustomTheme().vGap('xl')),
                                    ),
                                  if (widget.data['maklon'] == true)
                                    ViewText(
                                      viewLabel: 'Nama Maklon',
                                      viewValue: widget.data['maklon_name'],
                                    ),
                                  Divider(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Timeline Proses',
                                        style: TextStyle(
                                            fontSize:
                                                CustomTheme().fontSize('lg'),
                                            fontWeight: CustomTheme()
                                                .fontWeight('bold')),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ViewText(
                                            childLabel: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 12,
                                                  color: CustomTheme()
                                                      .colors('primary'),
                                                ),
                                                Text('Mulai Proses')
                                              ].separatedBy(
                                                  CustomTheme().hGap('md')),
                                            ),
                                            childValue: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(Icons.person_2_outlined),
                                                Text(
                                                    'Oleh: ${widget.data['start_by']['name']}, ${widget.data['start_time'] != null ? DateFormat("dd MMMM yyyy, HH.mm").format(DateTime.parse(widget.data['start_time'])) : '-'}')
                                              ].separatedBy(
                                                  CustomTheme().hGap('md')),
                                            ),
                                          ),
                                          if (widget.data['end_by'] != null)
                                            ViewText(
                                              childLabel: Row(
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    size: 12,
                                                    color: CustomTheme()
                                                        .statusColor('Selesai'),
                                                  ),
                                                  Text('Selesai Proses')
                                                ].separatedBy(
                                                    CustomTheme().hGap('md')),
                                              ),
                                              childValue: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(Icons.person_2_outlined),
                                                  Text(
                                                      'Oleh: ${widget.data['end_by']['name']}, ${widget.data['end_time'] != null ? DateFormat("dd MMMM yyyy, HH.mm").format(DateTime.parse(widget.data['end_time'])) : '-'}')
                                                ].separatedBy(
                                                    CustomTheme().hGap('md')),
                                              ),
                                            ),
                                        ].separatedBy(CustomTheme().vGap('xl')),
                                      ),
                                    ].separatedBy(CustomTheme().vGap('xl')),
                                  ),
                                ].separatedBy(CustomTheme().vGap('lg')),
                              ),
                            ].separatedBy(CustomTheme().vGap('lg')),
                          ),
                        ].separatedBy(CustomTheme().vGap('lg')),
                      ),
                    ),
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
            if (widget.withItemGrade == true &&
                widget.data['status'] == 'Selesai')
              CustomCard(
                  child: Column(
                children: [
                  for (int i = 0; i < grades.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ViewText(
                              viewLabel: grades[i]['item_grade']['description']
                                      ?.split('-')
                                      .first
                                      .trim() ??
                                  '-',
                              viewValue: grades[i]['item_grade']['description']
                                      ?.split('-')
                                      .last
                                      .trim() ??
                                  '-'),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextForm(
                            label: 'Jumlah',
                            req: false,
                            controller: (i < widget.qty.length)
                                ? widget.qty[i]
                                : TextEditingController(
                                    text: grades[i]['qty']?.toString() ?? ''),
                            handleChange: (value) {
                              setState(() {
                                if (widget.form['grades'] == null ||
                                    i >= widget.form['grades'].length) {
                                  widget.form['grades'] = List.from(grades);
                                }
                                widget.form['grades'][i]['qty'] =
                                    double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SelectForm(
                              label: 'Satuan',
                              onTap: () => widget.handleSelectQtyUnit(i),
                              selectedLabel: widget.form['grades'][i]['unit']
                                      ['name'] ??
                                  '-',
                              selectedValue: widget.form['grades'][i]['unit_id']
                                  .toString(),
                              required: false),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextForm(
                            label: 'Catatan',
                            req: false,
                            controller: (i < widget.notes.length)
                                ? TextEditingController(
                                    text: htmlToPlainText(
                                      widget.notes[i] is TextEditingController
                                          ? widget.notes[i].text
                                          : widget.notes[i].toString(),
                                    ),
                                  )
                                : TextEditingController(
                                    text: htmlToPlainText(
                                      grades[i]['notes']?.toString() ?? '',
                                    ),
                                  ),
                            handleChange: (value) {
                              setState(() {
                                if (widget.form['grades'] == null ||
                                    i >= widget.form['grades'].length) {
                                  widget.form['grades'] = List.from(grades);
                                }
                                widget.form['grades'][i]['notes'] = value;
                              });
                            },
                          ),
                        ),
                      ].separatedBy(CustomTheme().hGap('xl')),
                    ),
                ].separatedBy(CustomTheme().vGap('xl')),
              )),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProcessFilter(),
                SizedBox(
                  height: 300,
                  child: _buildSwipeContent(),
                ),
              ].separatedBy(CustomTheme().vGap('xl')),
            )
          ].separatedBy(CustomTheme().vGap('xl'))),
    ));
  }
}
