class BsList {
  final List<BsListItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String search;

  BsList(
      {required this.data,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      this.search = ''});

  factory BsList.fromJson(Map<String, dynamic> json) {
    return BsList(
        data: (json['data'] as List? ?? [])
            .map(
              (item) => BsListItem.fromJson(
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

class BsListItem {
  final id;
  final wo;
  final status;
  final reason;
  final actionPlan;
  final preventivePlan;
  final submitted;
  final sorting;
  final qtyBs;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
  final bsRate;
  final material;
  final item;
  final topMaterialCode;
  final topMaterialName;
<<<<<<< HEAD
<<<<<<< HEAD
=======
  final material;
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 5e38e0f3 (fix:)
=======
=======
  final material;
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
  final defects;
  final startDate;
  final endDate;

  BsListItem(
      {this.id,
      this.wo,
      this.status,
      this.reason,
      this.actionPlan,
      this.preventivePlan,
      this.submitted,
      this.sorting,
      this.qtyBs,
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
      this.bsRate,
      this.material,
      this.item,
      this.topMaterialCode,
      this.topMaterialName,
<<<<<<< HEAD
<<<<<<< HEAD
=======
      this.material,
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 5e38e0f3 (fix:)
=======
=======
      this.material,
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
      this.defects,
      this.endDate,
      this.startDate});

  factory BsListItem.fromJson(Map<String, dynamic> json) {
    final sorting = json['sorting'] ?? {};
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
    final wo = json['work_order'] ?? {};
    final woItems = wo is Map ? wo['items'] : null;
    final woItem = woItems is List && woItems.isNotEmpty ? woItems.first : null;
=======
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
    final wo = json['work_order'] ?? {};
    final woItems = wo is Map ? wo['items'] : null;
    final woItem = woItems is List && woItems.isNotEmpty ? woItems.first : null;
>>>>>>> 5e38e0f3 (fix:)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
    return BsListItem(
        id: json['id'] ?? '',
        startDate: json['created_at'] ?? '',
        endDate: json['completed_at'] ?? '',
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        wo: wo,
=======
        wo: json['work_order'] ?? {},
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
        wo: wo,
>>>>>>> 5e38e0f3 (fix:)
=======
        wo: wo,
=======
        wo: json['work_order'] ?? {},
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
        actionPlan: json['action_plan'] ?? '',
        preventivePlan: json['preventive_plan'] ?? '',
        reason: json['reason'] ?? json['reasons'] ?? '',
        sorting: sorting,
        qtyBs: json['qty_bs'] ??
            json['bs_qty'] ??
            json['qty'] ??
            sorting['qty_bs'] ??
            '',
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e7b9ec75 (fix: UI evaluasi)
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
=======
>>>>>>> d256f82 (fix: UI evaluasi)
>>>>>>> db08c830 (fix: UI evaluasi)
        bsRate: json['bs_rate'] ?? sorting['bs_rate'] ?? '',
        material: json['material'] ??
            json['semi_finished_product'] ??
            '',
        item: woItem ?? json['item'] ?? {},
        topMaterialCode: json['top_material_code'] ?? '',
        topMaterialName: json['top_material_name'] ?? '',
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8f5aac6d (feat: evaluasi bs)
=======
        material: json['material'] ??
            json['semi_finished_product'] ??
            '',
<<<<<<< HEAD
>>>>>>> b2b87875 (feat: evaluasi bs)
=======
>>>>>>> 5e38e0f3 (fix:)
=======
>>>>>>> aa02f1b (feat: evaluasi bs)
>>>>>>> 8f5aac6d (feat: evaluasi bs)
        defects: json['defects'] ?? [],
        status: json['status'] ?? '',
        submitted: json['submitted_by'] ?? {});
  }
}
