class WoList {
  final List<WoListItem> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String search;

  WoList(
      {required this.data,
      required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total,
      this.search = ''});

  factory WoList.fromJson(Map<String, dynamic> json) {
    return WoList(
        data: (json['data'] as List? ?? [])
            .map(
              (item) => WoListItem.fromJson(
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

class WoListItem {
  final woNo;
  final spkNo;
  final date;
  final status;
  final materialName;
  final materialCode;
  final woQty;
  final gsm;
  final weight;
  final weightPerDozen;
  final packingQty;
  final gradeAWeight;
  final sortingQty;
  final sortingGrades;

  WoListItem(
      {this.date,
      this.gradeAWeight,
      this.gsm,
      this.materialCode,
      this.materialName,
      this.packingQty,
      this.sortingGrades,
      this.sortingQty,
      this.spkNo,
      this.status,
      this.weight,
      this.woNo,
      this.woQty,
      this.weightPerDozen});

  factory WoListItem.fromJson(Map<String, dynamic> json) {
    return WoListItem(
        date: json['wo_date'] ?? '',
        gradeAWeight: json['weight_grade_a'] ?? 0,
        gsm: json['total_gsm'] ?? 0,
        materialCode: json['material_code'] ?? '',
        materialName: json['material_name'] ?? '',
        packingQty: json['total_packing'] ?? 0,
        sortingGrades: json['sorting_grades'] ?? [],
        sortingQty: json['total_sorting'] ?? 0,
        spkNo: json['spk_no'] ?? '',
        status: json['status'] ?? '',
        weight: json['total_weight'] ?? 0,
        woNo: json['wo_no'] ?? '',
        woQty: json['qty_wo_item'] ?? 0,
        weightPerDozen: json['weight_per_dozen'] ?? 0);
  }
}
