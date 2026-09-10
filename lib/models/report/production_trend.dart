class ProductionTrend {
  final List<ProductionTrendItem> data;

  ProductionTrend({required this.data});

  factory ProductionTrend.fromJson(Map<String, dynamic> json) {
    return ProductionTrend(
      data: (json['data'] as List? ?? [])
          .map(
            (item) => ProductionTrendItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class ProductionTrendItem {
  final gradeA;
  final gradeB;
  final gradeBS;
  final totalSorting;

  ProductionTrendItem(
      {this.gradeA, this.gradeB, this.gradeBS, this.totalSorting});

  factory ProductionTrendItem.fromJson(Map<String, dynamic> json) {
    return ProductionTrendItem(
      gradeA: json['grade_a'] ?? 0,
      gradeB: json['grade_b'] ?? 0,
      gradeBS: json['grade_bs'] ?? 0,
      totalSorting: json['total_sorting'] ?? 0,
    );
  }
}
