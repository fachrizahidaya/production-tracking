class GsmList {
  final List<GsmListItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String search;

  GsmList(
      {required this.data,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      this.search = ''});

  factory GsmList.fromJson(Map<String, dynamic> json) {
    return GsmList(
        data: (json['data'] as List? ?? [])
            .map(
              (item) => GsmListItem.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList(),
        currentPage: json['current_page'] ?? 1,
        lastPage: json['last_page'] ?? 1,
        perPage: json['per_page'] ?? 20,
        total: json['total'] ?? 0,
        search: json['search']?.toString() ?? '');
  }
}

class GsmListItem {
  final id;
  final wo;
  final status;
  final reason;
  final actionPlan;
  final preventivePlan;
  final submitted;
  final packing;
  final packingNo;
  final packingGsm;
  final materialGsm;
  final qtyBs;
  final material;
  final item;
  final topMaterialCode;
  final topMaterialName;
  final startDate;
  final endDate;

  GsmListItem(
      {this.id,
      this.wo,
      this.status,
      this.reason,
      this.actionPlan,
      this.preventivePlan,
      this.submitted,
      this.packing,
      this.packingNo,
      this.packingGsm,
      this.materialGsm,
      this.qtyBs,
      this.material,
      this.item,
      this.topMaterialCode,
      this.topMaterialName,
      this.endDate,
      this.startDate});

  factory GsmListItem.fromJson(Map<String, dynamic> json) {
    final packing = json['packing'] ?? {};
    final wo = json['work_order'] ?? {};
    final woItems = wo is Map ? wo['items'] : null;
    final woItem = woItems is List && woItems.isNotEmpty ? woItems.first : null;
    return GsmListItem(
        id: json['id'] ?? '',
        startDate: json['created_at'] ?? '',
        endDate: json['completed_at'] ?? '',
        wo: wo,
        actionPlan: json['action_plan'] ?? '',
        preventivePlan: json['preventive_plan'] ?? '',
        reason: json['reason'] ?? json['reasons'] ?? '',
        packing: packing,
        packingNo: json['packing_no'] ??
            json['no_packing'] ??
            packing['packing_no'] ??
            packing['no'] ??
            '',
        packingGsm: json['packing_gsm'] ?? packing['packing_gsm'] ?? '',
        materialGsm: json['material_gsm'] ?? packing['material_gsm'] ?? '',
        qtyBs: json['qty_bs'] ?? json['bs_qty'] ?? json['qty'] ?? '',
        material: json['material'] ??
            json['semi_finished_product'] ??
            '',
        item: woItem ?? json['item'] ?? json['packing_item']?['item'] ?? {},
        topMaterialCode: json['top_material_code'] ?? '',
        topMaterialName: json['top_material_name'] ?? '',
        status: json['status'] ?? '',
        submitted: json['submitted_by'] ?? {});
  }
}
