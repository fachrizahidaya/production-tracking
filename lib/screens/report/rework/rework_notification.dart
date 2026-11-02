import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/report/rework/rework_by_id.dart';
import 'package:textile_tracking/screens/report/service.dart';

class ReworkNotificationScreen extends StatefulWidget {
  final String id;

  const ReworkNotificationScreen({super.key, required this.id});

  @override
  State<ReworkNotificationScreen> createState() =>
      _ReworkNotificationScreenState();
}

class _ReworkNotificationScreenState extends State<ReworkNotificationScreen> {
  final ReportService _reportService = ReportService();
  late Future<Map<String, dynamic>> _detail;

  @override
  void initState() {
    super.initState();
    _detail = _reportService.getReworkDetail(widget.id);
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
            appBar: AppBar(title: const Text('Rework')),
            body: const Center(child: Text('Gagal mengambil detail rework.')),
          );
        }
        return ReworkDetailScreen(data: snapshot.data!);
      },
    );
  }
}
