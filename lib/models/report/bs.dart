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
  final bsRate;
  final material;
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
      this.bsRate,
      this.material,
      this.defects,
      this.endDate,
      this.startDate});

  factory BsListItem.fromJson(Map<String, dynamic> json) {
    final sorting = json['sorting'] ?? {};
    return BsListItem(
        id: json['id'] ?? '',
        startDate: json['created_at'] ?? '',
        endDate: json['completed_at'] ?? '',
        wo: json['work_order'] ?? {},
        actionPlan: json['action_plan'] ?? '',
        preventivePlan: json['preventive_plan'] ?? '',
        reason: json['reason'] ?? json['reasons'] ?? '',
        sorting: sorting,
        qtyBs: json['qty_bs'] ??
            json['bs_qty'] ??
            json['qty'] ??
            sorting['qty_bs'] ??
            '',
        bsRate: json['bs_rate'] ?? sorting['bs_rate'] ?? '',
        material: json['material'] ??
            json['semi_finished_product'] ??
            '',
        defects: json['defects'] ?? [],
        status: json['status'] ?? '',
        submitted: json['submitted_by'] ?? {});
  }
}
