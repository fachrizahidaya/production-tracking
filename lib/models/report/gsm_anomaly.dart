class GsmAnomalyPage {
  final List<GsmAnomalyItem> data;
  final int currentPage;
  final int lastPage;

  const GsmAnomalyPage({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory GsmAnomalyPage.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final payload = rawData is Map<String, dynamic> ? rawData : json;
    final List<dynamic> rows = payload['data'] is List
        ? payload['data']
        : rawData is List
            ? rawData
            : <dynamic>[];

    return GsmAnomalyPage(
      data: rows
          .whereType<Map>()
          .map<GsmAnomalyItem>((row) => GsmAnomalyItem.fromJson(
                Map<String, dynamic>.from(row),
              ))
          .toList(),
      currentPage: int.tryParse(
            (payload['current_page'] ?? json['current_page'] ?? 1).toString(),
          ) ??
          1,
      lastPage: int.tryParse(
            (payload['last_page'] ?? json['last_page'] ?? 1).toString(),
          ) ??
          1,
    );
  }
}

class GsmAnomalyItem {
  final dynamic id;
  final String title;
  final String description;
  final String createdAt;
  final String itemCode;
  final String itemName;
  final String packingGsm;
  final String materialGsm;
  final String packingNo;
  final String workOrderNo;
  final String woStatus;
  final String status;

  const GsmAnomalyItem({
    this.id,
    this.title = 'GSM packing berbeda jauh dari material',
    this.description = '',
    this.createdAt = '',
    this.itemCode = '-',
    this.itemName = '-',
    this.packingGsm = '-',
    this.materialGsm = '-',
    this.packingNo = '-',
    this.workOrderNo = '-',
    this.woStatus = '-',
    this.status = 'open',
  });

  factory GsmAnomalyItem.fromJson(Map<String, dynamic> json) {
    final packing = json['packing'] is Map
        ? Map<String, dynamic>.from(json['packing'])
        : <String, dynamic>{};
    final workOrder = json['work_order'] is Map
        ? Map<String, dynamic>.from(json['work_order'])
        : <String, dynamic>{};
    final item = json['item'] is Map
        ? Map<String, dynamic>.from(json['item'])
        : json['packing_item']?['item'] is Map
            ? Map<String, dynamic>.from(json['packing_item']['item'])
            : <String, dynamic>{};

    return GsmAnomalyItem(
      id: json['id'],
      title: (json['title'] ?? json['name'] ??
              'GSM packing berbeda jauh dari material')
          .toString(),
      description: (json['description'] ?? json['message'] ?? json['reason'] ??
              'GSM packing ${json['packing_gsm'] ?? '-'} GSM, '
                  'berbeda jauh dari GSM material ${json['material_gsm'] ?? '-'} GSM.')
          .toString(),
      createdAt: (json['process_date'] ?? json['created_at'] ??
              json['date'] ?? '')
          .toString(),
      itemCode: (json['item_code'] ?? item['code'] ?? '-').toString(),
      itemName: (json['item_name'] ?? item['name'] ?? '-').toString(),
      packingGsm: (json['packing_gsm'] ?? packing['gsm'] ?? '-').toString(),
      materialGsm: (json['material_gsm'] ??
              (json['material'] is Map ? json['material']['gsm'] : null) ??
              '-')
          .toString(),
      packingNo: (json['packing_no'] ??
              json['no_packing'] ??
              packing['packing_no'] ??
              '-')
          .toString(),
      workOrderNo: (json['wo_no'] ??
              workOrder['wo_no'] ??
              json['work_order_no'] ??
              '-')
          .toString(),
      woStatus: (json['wo_status'] ?? '-').toString(),
      status: 'Open',
    );
  }
}
