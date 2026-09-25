class ReworkComparison {
  final List<ReworkComparisonItem> data;

  ReworkComparison({required this.data});

  factory ReworkComparison.fromJson(Map<String, dynamic> json) {
    return ReworkComparison(
      data: (json['data'] as List? ?? [])
          .map(
            (item) => ReworkComparisonItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class ReworkComparisonItem {
  final type;
  final count;

  ReworkComparisonItem({this.count, this.type});

  factory ReworkComparisonItem.fromJson(Map<String, dynamic> json) {
    return ReworkComparisonItem(
        count: json['wo_count'] ?? 0, type: json['type'] ?? '');
  }
}
