class SpkSummary {
  final totalSpk;
  final totalQtySpk;
  final totalActiveSpk;
  final totalDoneSpk;
  final overdueSpk;
  final noDeadlineSpk;
  final waitingSpk;

  SpkSummary(
      {this.totalSpk,
      this.totalQtySpk,
      this.totalActiveSpk,
      this.totalDoneSpk,
      this.overdueSpk,
      this.noDeadlineSpk,
      this.waitingSpk});

  factory SpkSummary.fromJson(Map<String, dynamic> json) {
    return SpkSummary(
      totalSpk: json['total_spk'] ?? 0,
      totalActiveSpk: json['total_active_spk'] ?? 0,
      totalDoneSpk: json['total_done_spk'] ?? 0,
      totalQtySpk: json['total_spk_qty'] ?? 0,
      overdueSpk: json['overdue_spk'] ?? 0,
      noDeadlineSpk: json['no_deadline_end_spk'] ?? 0,
      waitingSpk: json['waiting_spk'] ?? 0,
    );
  }
}
