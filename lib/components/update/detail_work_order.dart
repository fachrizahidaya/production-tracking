// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/info_tab.dart';
import 'package:textile_tracking/components/work-order/tab/item_tab.dart';
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoTab(
              data: widget.data,
              label: widget.label,
              isTablet: isTablet,
              withNote: true,
            ),
            ItemTab(
              data: widget.data,
            )
          ].separatedBy(CustomTheme().vGap('xl')),
        );
      },
    );
  }
}
