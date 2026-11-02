import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/report/gsm/gsm_by_id.dart';
import 'package:textile_tracking/screens/report/service.dart';

class GsmNotificationScreen extends StatefulWidget {
  final String id;

  const GsmNotificationScreen({super.key, required this.id});

  @override
  State<GsmNotificationScreen> createState() => _GsmNotificationScreenState();
}

class _GsmNotificationScreenState extends State<GsmNotificationScreen> {
  final ReportService _reportService = ReportService();
  late Future<Map<String, dynamic>> _detail;

  @override
  void initState() {
    super.initState();
    _detail = _reportService.getGsmDetail(widget.id);
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
            appBar: AppBar(title: const Text('Evaluasi GSM')),
            body: const Center(child: Text('Gagal mengambil detail GSM.')),
          );
        }
        return GsmDetailScreen(data: snapshot.data!);
      },
    );
  }
}
