// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/spk/tab/spk_info_tab.dart';
import 'package:textile_tracking/components/spk/tab/spk_note_tab.dart';
import 'package:textile_tracking/models/master/spk.dart';

class SpkDetail extends StatefulWidget {
  final String id;

  const SpkDetail({
    super.key,
    required this.id,
  });

  @override
  State<SpkDetail> createState() => _SpkDetailState();
}

class _SpkDetailState extends State<SpkDetail> {
  final SpkService _spkService = SpkService();
  bool _firstLoading = true;
  Map<String, dynamic> data = {};

  Future<void> _getDataView() async {
    setState(() {
      _firstLoading = true;
    });

    await _spkService.getDataView(widget.id);

    setState(() {
      data = _spkService.dataView;
      _firstLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataView();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'SPK Detail',
          onReturn: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  isScrollable: false,
                  tabs: [
                    Tab(text: 'Informasi'),
                    Tab(text: 'Catatan'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SpkInfoTab(
                      data: data,
                      isLoading: _firstLoading,
                    ),
                    SpkNoteTab(data: data),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
