class BsAnomalyPage {
  final List<BsAnomalyItem> data;
  final int currentPage;
  final int lastPage;

  const BsAnomalyPage({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory BsAnomalyPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rows =
        json['data'] is List ? json['data'] as List : <dynamic>[];
    return BsAnomalyPage(
      data: rows
          .whereType<Map>()
          .map<BsAnomalyItem>(
              (row) => BsAnomalyItem.fromJson(Map<String, dynamic>.from(row)))
          .toList(),
      currentPage: int.tryParse('${json['current_page'] ?? 1}') ?? 1,
      lastPage: int.tryParse('${json['last_page'] ?? 1}') ?? 1,
    );
  }
}

class BsAnomalyItem {
  final dynamic id;
  final String woNo;
  final String woDate;
  final String woStatus;
  final String bsQty;
  final String totalWoQty;
  final String bsRate;
  final String materialCode;
  final String materialName;
  final List<Map<String, dynamic>> defects;

  const BsAnomalyItem({
    this.id,
    this.woNo = '-',
    this.woDate = '',
    this.woStatus = '-',
    this.bsQty = '-',
    this.totalWoQty = '-',
    this.bsRate = '-',
    this.materialCode = '-',
    this.materialName = '-',
    this.defects = const [],
  });

  factory BsAnomalyItem.fromJson(Map<String, dynamic> json) {
    return BsAnomalyItem(
      id: json['id'],
      woNo: '${json['wo_no'] ?? '-'}',
      woDate: '${json['wo_date'] ?? ''}',
      woStatus: '${json['wo_status'] ?? '-'}',
      bsQty: '${json['bs_qty'] ?? '-'}',
      totalWoQty: '${json['total_wo_qty'] ?? '-'}',
      bsRate: '${json['bs_rate'] ?? '-'}',
      materialCode: '${json['top_material_code'] ?? '-'}',
      materialName: '${json['top_material_name'] ?? '-'}',
      defects: (json['defects'] is List ? json['defects'] as List : const [])
          .whereType<Map>()
          .map((defect) => Map<String, dynamic>.from(defect))
          .toList(),
    );
  }
}
