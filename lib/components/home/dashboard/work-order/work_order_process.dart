// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dasboard_card.dart';
import 'package:textile_tracking/components/master/layout/dashboard_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WorkOrderProcessScreen extends StatefulWidget {
  final data;
  final onHandleFilter;
  final dariTanggal;
  final sampaiTanggal;
  final filterWidget;
  final handleSearch;
  final search;
  final firstLoading;
  final hasMore;
  final handleRefetch;
  final handleLoadMore;
  final handleFetchData;
  final handleBuildItem;
  final service;

  const WorkOrderProcessScreen(
      {super.key,
      this.dariTanggal,
      this.data,
      this.onHandleFilter,
      this.sampaiTanggal,
      this.filterWidget,
      this.handleSearch,
      this.search,
      this.handleRefetch,
      this.handleLoadMore,
      this.firstLoading,
      this.hasMore,
      this.handleFetchData,
      this.handleBuildItem,
      this.service});

  @override
  State<WorkOrderProcessScreen> createState() => _WorkOrderProcessScreenState();
}

class _WorkOrderProcessScreenState extends State<WorkOrderProcessScreen> {
  final double width = 14;
  double maxY = 0;
  int? touchedIndex;

  final TextEditingController dariTanggalInput = TextEditingController();
  final TextEditingController sampaiTanggalInput = TextEditingController();

  @override
  void initState() {
    super.initState();

    dariTanggalInput.text = widget.dariTanggal;
    sampaiTanggalInput.text = widget.sampaiTanggal;
  }

  @override
  void didUpdateWidget(covariant WorkOrderProcessScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dariTanggal != dariTanggalInput.text) {
      dariTanggalInput.text = widget.dariTanggal;
    }
    if (widget.sampaiTanggal != sampaiTanggalInput.text) {
      sampaiTanggalInput.text = widget.sampaiTanggal;
    }
  }

  Future<void> _pickDate({
    required TextEditingController controller,
    required String type,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateTime.tryParse(controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomTheme().colors('base'),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
      widget.onHandleFilter(type, formattedDate);
    }
  }

  @override
  void dispose() {
    dariTanggalInput.dispose();
    sampaiTanggalInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: PaddingColumn.screen,
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: DashboardList(
                fetchData: widget.handleFetchData,
                service: widget.service,
                searchQuery: widget.search,
                itemBuilder: widget.handleBuildItem,
                filterWidget: widget.filterWidget,
                handleRefetch: widget.handleRefetch,
                handleLoadMore: widget.handleLoadMore,
                handleSearch: widget.handleSearch,
                dataList: widget.data,
                firstLoading: widget.firstLoading,
                hasMore: widget.hasMore,
                isFiltered: false,
              ),
            )
          ].separatedBy(const SizedBox(height: 16)),
        ));
  }
}
