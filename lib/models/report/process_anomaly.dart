class ProcessAnomalyPage {
  final List<ProcessAnomalyItem> data;
  final int currentPage;
  final int lastPage;

  const ProcessAnomalyPage({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory ProcessAnomalyPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rows =
        json['data'] is List ? json['data'] as List : <dynamic>[];
    return ProcessAnomalyPage(
      data: rows.whereType<Map>().map<ProcessAnomalyItem>((row) {
        return ProcessAnomalyItem.fromJson(Map<String, dynamic>.from(row));
      }).toList(),
      currentPage: int.tryParse('${json['current_page'] ?? 1}') ?? 1,
      lastPage: int.tryParse('${json['last_page'] ?? 1}') ?? 1,
    );
  }
}

class ProcessAnomalyItem {
  final dynamic id;
  final String title;
  final String description;
  final String date;
  final String woNo;
  final String processName;
  final String status;

  const ProcessAnomalyItem({
    this.id,
    this.title = 'Input proses tidak sesuai',
    this.description = '',
    this.date = '',
    this.woNo = '-',
    this.processName = '-',
    this.status = 'Open',
  });

  factory ProcessAnomalyItem.fromJson(Map<String, dynamic> json) {
    final workOrder = json['work_order'] is Map
        ? Map<String, dynamic>.from(json['work_order'])
        : <String, dynamic>{};
    return ProcessAnomalyItem(
      id: json['id'],
      title: (json['title'] ?? json['name'] ??
              'Input proses tidak sesuai')
          .toString(),
      description: (json['description'] ?? json['message'] ?? json['reason'] ??
              'Ditemukan ketidaksesuaian pada rantai proses.')
          .toString(),
      date: (json['process_date'] ?? json['created_at'] ?? json['date'] ?? '')
          .toString(),
      woNo: (json['wo_no'] ??
              workOrder['wo_no'] ??
              json['work_order_no'] ??
              '-')
          .toString(),
      processName: (json['process_name'] ??
              json['process'] ??
              json['process_chain'] ??
              '-')
          .toString(),
      status: 'Open',
    );
  }
}
