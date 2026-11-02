class TopBs {
  final List<TopBsItem> data;

  TopBs({required this.data});

  factory TopBs.fromJson(Map<String, dynamic> json) {
    return TopBs(
      data: (json['data'] as List? ?? [])
          .map(
            (item) => TopBsItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class TopBsItem {
  final woNo;
  final bsQty;
  final bsPercentage;

  TopBsItem({this.woNo, this.bsQty, this.bsPercentage});

  factory TopBsItem.fromJson(Map<String, dynamic> json) {
    return TopBsItem(
      bsPercentage: json['bs_rate'] ?? 0,
      bsQty: json['bs_qty'] ?? 0,
      woNo: json['wo_no'] ?? '',
    );
  }
}
