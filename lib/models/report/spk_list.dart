class SpkList {
  final List<SpkListItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String search;

  SpkList(
      {required this.data,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      this.search = ''});

  factory SpkList.fromJson(Map<String, dynamic> json) {
    return SpkList(
        data: (json['data'] as List? ?? [])
            .map(
              (item) => SpkListItem.fromJson(
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

class SpkListItem {
  final spkId;
  final spkNo;
  final date;
  final status;
  final designs;
  final woQty;
  final spkQty;
  final dozenWeight;
  final weight;
  final packingQty;
  final gradeAWeight;
  final sortingQty;
  final gradeA;
  final gradeB;
  final gradeBs;

  SpkListItem(
      {this.spkId,
      this.date,
      this.gradeAWeight,
      this.packingQty,
      this.sortingQty,
      this.spkNo,
      this.status,
      this.weight,
      this.woQty,
      this.designs,
      this.dozenWeight,
      this.spkQty,
      this.gradeA,
      this.gradeB,
      this.gradeBs});

  factory SpkListItem.fromJson(Map<String, dynamic> json) {
    return SpkListItem(
        spkId: json['spk_id'] ?? '',
        date: json['spk_date'] ?? '',
        gradeAWeight: json['weight_grade_a'] ?? 0,
        packingQty: json['total_packing'] ?? 0,
        sortingQty: json['total_sorting'] ?? 0,
        spkNo: json['spk_no'] ?? '',
        status: json['spk_status'] ?? '',
        weight: json['total_weight'] ?? 0,
        woQty: json['qty_wo'] ?? 0,
        designs: json['designs'] ?? [],
        dozenWeight: json['weight_per_dozen'] ?? 0,
        gradeA: json['grade_a'] ?? 0,
        gradeB: json['grade_b'] ?? 0,
        gradeBs: json['grade_bs'] ?? 0,
        spkQty: json['qty_spk'] ?? 0);
  }
}
