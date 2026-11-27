class StockUsageAnomalyPage {
  final List<StockUsageAnomalyItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const StockUsageAnomalyPage({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory StockUsageAnomalyPage.fromJson(Map<String, dynamic> json) {
    final rows = json['data'] is List ? json['data'] as List : const [];

    return StockUsageAnomalyPage(
      data: rows
          .whereType<Map>()
          .map((row) => StockUsageAnomalyItem.fromJson(
                Map<String, dynamic>.from(row),
              ))
          .toList(),
      currentPage: _toInt(json['current_page'], 1),
      lastPage: _toInt(json['last_page'], 1),
      perPage: _toInt(json['per_page'], 20),
      total: _toInt(json['total'], 0),
    );
  }
}

class StockUsageAnomalyItem {
  final String type;
  final dynamic id;
  final dynamic qty;
  final dynamic fromPackingQty;
  final dynamic fromSortingQty;
  final dynamic toPackingQty;
  final dynamic toSortingQty;
  final String itemCode;
  final String itemName;
  final dynamic fromWoId;
  final String fromWoNo;
  final String fromWoStatus;
  final dynamic toWoId;
  final String toWoNo;
  final String toWoStatus;
  final dynamic fromPackingId;
  final String fromPackingNo;
  final String fromPackingStatus;
  final dynamic toPackingId;
  final String toPackingNo;
  final String toPackingStatus;
  final String createdAt;

  const StockUsageAnomalyItem({
    this.type = '',
    this.id,
    this.qty,
    this.fromPackingQty,
    this.fromSortingQty,
    this.toPackingQty,
    this.toSortingQty,
    this.itemCode = '-',
    this.itemName = '-',
    this.fromWoId,
    this.fromWoNo = '-',
    this.fromWoStatus = '-',
    this.toWoId,
    this.toWoNo = '-',
    this.toWoStatus = '-',
    this.fromPackingId,
    this.fromPackingNo = '-',
    this.fromPackingStatus = '-',
    this.toPackingId,
    this.toPackingNo = '-',
    this.toPackingStatus = '-',
    this.createdAt = '',
  });

  factory StockUsageAnomalyItem.fromJson(Map<String, dynamic> json) {
    return StockUsageAnomalyItem(
      type: _toString(json['type']),
      id: json['id'],
      qty: json['qty'],
      fromPackingQty: json['from_packing_qty'],
      fromSortingQty: json['from_sorting_qty'],
      toPackingQty: json['to_packing_qty'],
      toSortingQty: json['to_sorting_qty'],
      itemCode: _toString(json['item_code'], '-'),
      itemName: _toString(json['item_name'], '-'),
      fromWoId: json['from_wo_id'],
      fromWoNo: _toString(json['from_wo_no'], '-'),
      fromWoStatus: _toString(json['from_wo_status'], '-'),
      toWoId: json['to_wo_id'],
      toWoNo: _toString(json['to_wo_no'], '-'),
      toWoStatus: _toString(json['to_wo_status'], '-'),
      fromPackingId: json['from_packing_id'],
      fromPackingNo: _toString(json['from_packing_no'], '-'),
      fromPackingStatus: _toString(json['from_packing_status'], '-'),
      toPackingId: json['to_packing_id'],
      toPackingNo: _toString(json['to_packing_no'], '-'),
      toPackingStatus: _toString(json['to_packing_status'], '-'),
      createdAt: _toString(json['created_at']),
    );
  }
}

int _toInt(dynamic value, int fallback) {
  return value is int ? value : int.tryParse('$value') ?? fallback;
}

String _toString(dynamic value, [String fallback = '']) {
  return value == null ? fallback : value.toString();
}
