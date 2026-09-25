class ProductionSummary {
  final totalWo;
  final totalActiveWO;
  final totalDoneWO;
  final reworkCount;
  final totalProcessQty;
  final totalSpkQty;
  final totalPackingQty;
  final totalSortingQty;
  final gradeAQty;
  final gradeBQty;
  final gradeBSQty;
  final totalWeight;
  final totalWeightGradeA;

  ProductionSummary(
      {this.totalWo,
      this.gradeAQty,
      this.gradeBQty,
      this.gradeBSQty,
      this.reworkCount,
      this.totalActiveWO,
      this.totalDoneWO,
      this.totalPackingQty,
      this.totalProcessQty,
      this.totalSortingQty,
      this.totalSpkQty,
      this.totalWeight,
      this.totalWeightGradeA});

  factory ProductionSummary.fromJson(Map<String, dynamic> json) {
    return ProductionSummary(
      gradeAQty: json['grade_a_qty'] ?? 0,
      gradeBQty: json['grade_b_qty'] ?? 0,
      gradeBSQty: json['grade_bs_qty'] ?? 0,
      reworkCount: json['rework_count'] ?? 0,
      totalActiveWO: json['total_active_wo'] ?? 0,
      totalDoneWO: json['total_done_wo'] ?? 0,
      totalPackingQty: json['total_packing_qty'] ?? 0,
      totalProcessQty: json['total_process_qty'] ?? 0,
      totalSortingQty: json['total_sorting_qty'] ?? 0,
      totalSpkQty: json['total_spk_qty'] ?? 0,
      totalWeight: (json['total_weight_qty'] ?? 0).toDouble(),
      totalWeightGradeA: (json['total_weight_grade_a'] ?? 0).toDouble(),
      totalWo: json['total_wo'] ?? 0,
    );
  }
}
