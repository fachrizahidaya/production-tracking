import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/work-order/list/list_info.dart';

class InfoTab extends StatefulWidget {
  final data;
  final isLoading;

  const InfoTab({super.key, this.data, this.isLoading});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.data.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const NoData(),
      );
    }

    return SingleChildScrollView(
      padding: CustomTheme().padding('content'),
      child: ListInfo(
        data: widget.data,
      ),
    );
  }
}
