class ReworkList {
  final List<ReworkListItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String search;

  ReworkList(
      {required this.data,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      this.search = ''});

  factory ReworkList.fromJson(Map<String, dynamic> json) {
    return ReworkList(
        data: (json['data'] as List? ?? [])
            .map(
              (item) => ReworkListItem.fromJson(
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

class ReworkListItem {
  final id;
  final reworkNo;
  final wo;
  final status;
  final reason;
  final actionPlan;
  final preventivePlan;
  final submitted;
  final dyeing;
  final reworkReference;
  final reworkCategories;
  final startDate;
  final endDate;

  ReworkListItem(
      {this.id,
      this.reworkNo,
      this.wo,
      this.status,
      this.reason,
      this.actionPlan,
      this.preventivePlan,
      this.submitted,
      this.dyeing,
      this.reworkReference,
      this.reworkCategories,
      this.endDate,
      this.startDate});

  factory ReworkListItem.fromJson(Map<String, dynamic> json) {
    return ReworkListItem(
        id: json['id'] ?? '',
        reworkNo: json['rework_no'] ??
            json['evaluation_no'] ??
            json['rework_evaluation_no'] ??
            json['number'] ??
            '',
        startDate: json['created_at'] ?? '',
        endDate: json['completed_at'] ?? '',
        wo: json['work_order'] ?? {},
        actionPlan: json['action_plan'] ?? '',
        preventivePlan: json['preventive_plan'] ?? '',
        reason: json['reasons'] ?? [],
        dyeing: json['dyeing'] ?? {},
        reworkReference: json['rework_reference'] ?? {},
        reworkCategories: json['rework_categories'] ??
            json['dyeing']?['rework_categories'] ??
            [],
        status: json['status'] ?? '',
        submitted: json['submitted_by'] ?? {});
  }
}
