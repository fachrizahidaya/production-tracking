class SortingResult {
  final List<SortingResultItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String search;

  SortingResult(
      {required this.data,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      this.search = ''});

  factory SortingResult.fromJson(Map<String, dynamic> json) {
    return SortingResult(
        data: (json['data'] as List? ?? [])
            .map(
              (item) => SortingResultItem.fromJson(
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

class SortingResultItem {
  final woNo;
  final gradeA;
  final gradeB;
  final gradeBS;
  final totalQty;
  final woQty;
  final diff;

  SortingResultItem(
      {this.woNo,
      this.gradeA,
      this.gradeB,
      this.gradeBS,
      this.totalQty,
      this.woQty,
      this.diff});

  factory SortingResultItem.fromJson(Map<String, dynamic> json) {
    return SortingResultItem(
        woNo: json['wo_no'] ?? '',
        gradeA: json['grade_a'] ?? 0,
        gradeB: json['grade_b'] ?? '',
        gradeBS: json['grade_bs'] ?? '',
        totalQty: json['total_sorting'] ?? '',
        woQty: json['total_wo_qty'] ?? 0,
        diff: json['diff_qty'] ?? 0);
  }
}
