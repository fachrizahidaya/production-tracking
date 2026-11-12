class WorkOrderListPage {
  final List<WorkOrderListItem> data;
  final int currentPage;
  final int lastPage;

  const WorkOrderListPage({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory WorkOrderListPage.fromJson(Map<String, dynamic> json) {
    final rows = json['data'] is List ? json['data'] as List : const [];

    return WorkOrderListPage(
      data: rows
          .whereType<Map>()
          .map((row) => WorkOrderListItem.fromJson(
                Map<String, dynamic>.from(row),
              ))
          .toList(),
      currentPage: _toInt(json['current_page'], fallback: 1),
      lastPage: _toInt(json['last_page'], fallback: 1),
    );
  }
}

class WorkOrderListItem {
  final int? id;
  final String woNo;
  final String woDate;
  final String status;
  final bool urgent;
  final String? urgentNote;
  final String? userName;
  final List<String> spkNumbers;
  final List<String> designs;
  final bool canDelete;
  final bool canUpdate;

  const WorkOrderListItem({
    this.id,
    this.woNo = '-',
    this.woDate = '',
    this.status = '-',
    this.urgent = false,
    this.urgentNote,
    this.userName,
    this.spkNumbers = const [],
    this.designs = const [],
    this.canDelete = false,
    this.canUpdate = false,
  });

  factory WorkOrderListItem.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : <String, dynamic>{};
    final items = json['items'] is List ? json['items'] as List : const [];
    final spkNumbers = <String>[];

    for (final row in items.whereType<Map>()) {
      final spkItem = row['spk_item'];
      final spk = spkItem is Map ? spkItem['spk'] : null;
      if (spk is Map && spk['spk_no'] != null) {
        spkNumbers.add(spk['spk_no'].toString());
      }
    }

    final rawDesigns = json['design_item'] is List
        ? json['design_item'] as List
        : const [];

    return WorkOrderListItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      woNo: (json['wo_no'] ?? '-').toString(),
      woDate: (json['wo_date'] ?? '').toString(),
      status: (json['status'] ?? '-').toString(),
      urgent: json['urgent'] == true,
      urgentNote: json['urgent_note']?.toString(),
      userName: user['name']?.toString(),
      spkNumbers: spkNumbers,
      designs: rawDesigns.map((value) => value.toString()).toList(),
      canDelete: json['can_delete'] == true,
      canUpdate: json['can_update'] == true,
    );
  }
}

int _toInt(dynamic value, {required int fallback}) {
  return value is int ? value : int.tryParse('$value') ?? fallback;
}
