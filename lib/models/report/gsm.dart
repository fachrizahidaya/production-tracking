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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
>>>>>>> 0c3d8444 (fix:)
  final item;
  final topMaterialCode;
  final topMaterialName;
=======
<<<<<<< HEAD
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
  final item;
  final topMaterialCode;
  final topMaterialName;
>>>>>>> 5e38e0f3 (fix:)
=======
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
<<<<<<< HEAD
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
=======
  final item;
  final topMaterialCode;
  final topMaterialName;
>>>>>>> aa49533 (fix:)
>>>>>>> 0c3d8444 (fix:)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
>>>>>>> 0c3d8444 (fix:)
      this.item,
      this.topMaterialCode,
      this.topMaterialName,
=======
<<<<<<< HEAD
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
      this.item,
      this.topMaterialCode,
      this.topMaterialName,
>>>>>>> 5e38e0f3 (fix:)
=======
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
<<<<<<< HEAD
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
=======
      this.item,
      this.topMaterialCode,
      this.topMaterialName,
>>>>>>> aa49533 (fix:)
>>>>>>> 0c3d8444 (fix:)
      this.endDate,
      this.startDate});

  factory GsmListItem.fromJson(Map<String, dynamic> json) {
    final packing = json['packing'] ?? {};
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
>>>>>>> 0c3d8444 (fix:)
    final wo = json['work_order'] ?? {};
    final woItems = wo is Map ? wo['items'] : null;
    final woItem = woItems is List && woItems.isNotEmpty ? woItems.first : null;
=======
<<<<<<< HEAD
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
    final wo = json['work_order'] ?? {};
    final woItems = wo is Map ? wo['items'] : null;
    final woItem = woItems is List && woItems.isNotEmpty ? woItems.first : null;
>>>>>>> 5e38e0f3 (fix:)
=======
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
<<<<<<< HEAD
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
=======
    final wo = json['work_order'] ?? {};
    final woItems = wo is Map ? wo['items'] : null;
    final woItem = woItems is List && woItems.isNotEmpty ? woItems.first : null;
>>>>>>> aa49533 (fix:)
>>>>>>> 0c3d8444 (fix:)
    return GsmListItem(
        id: json['id'] ?? '',
        startDate: json['created_at'] ?? '',
        endDate: json['completed_at'] ?? '',
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        wo: wo,
=======
        wo: json['work_order'] ?? {},
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
        wo: wo,
>>>>>>> 5e38e0f3 (fix:)
=======
=======
>>>>>>> 0c3d8444 (fix:)
        wo: wo,
=======
        wo: json['work_order'] ?? {},
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
<<<<<<< HEAD
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
=======
        wo: wo,
>>>>>>> aa49533 (fix:)
>>>>>>> 0c3d8444 (fix:)
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
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
>>>>>>> 0c3d8444 (fix:)
        item: woItem ?? json['item'] ?? json['packing_item']?['item'] ?? {},
        topMaterialCode: json['top_material_code'] ?? '',
        topMaterialName: json['top_material_name'] ?? '',
=======
<<<<<<< HEAD
>>>>>>> b77e0195 (fix: bs, gsm, rework)
=======
        item: woItem ?? json['item'] ?? json['packing_item']?['item'] ?? {},
        topMaterialCode: json['top_material_code'] ?? '',
        topMaterialName: json['top_material_name'] ?? '',
>>>>>>> 5e38e0f3 (fix:)
=======
>>>>>>> 53bbc04 (fix: bs, gsm, rework)
<<<<<<< HEAD
>>>>>>> 25f345ae (fix: bs, gsm, rework)
=======
=======
        item: woItem ?? json['item'] ?? json['packing_item']?['item'] ?? {},
        topMaterialCode: json['top_material_code'] ?? '',
        topMaterialName: json['top_material_name'] ?? '',
>>>>>>> aa49533 (fix:)
>>>>>>> 0c3d8444 (fix:)
        status: json['status'] ?? '',
        submitted: json['submitted_by'] ?? {});
  }
}
