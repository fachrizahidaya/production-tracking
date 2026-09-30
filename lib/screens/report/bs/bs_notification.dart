import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/report/bs/bs_by_id.dart';
import 'package:textile_tracking/screens/report/service.dart';

class BsNotificationScreen extends StatefulWidget {
  final String id;

  const BsNotificationScreen({super.key, required this.id});

  @override
  State<BsNotificationScreen> createState() => _BsNotificationScreenState();
}

class _BsNotificationScreenState extends State<BsNotificationScreen> {
  final ReportService _reportService = ReportService();
  late Future<Map<String, dynamic>> _detail;

  @override
  void initState() {
    super.initState();
    _detail = _reportService.getBsDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _detail,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Evaluasi BS')),
            body: const Center(child: Text('Gagal mengambil detail BS.')),
          );
        }
        return BsDetailScreen(data: snapshot.data!);
      },
    );
  }
}
