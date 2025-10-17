class Sewing {
  final int? id;
  final String? dyeing_no;
  final String? wo_no;
  final String? start_time;
  final int? start_by_id;
  final int? end_by_id;
  final String? end_time;
  final String? qty;
  final String? width;
  final String? length;
  final String? notes;
  final String? status;
  final int? unit_id;
  final int? wo_id;
  final int? machine_id;
  final attachments;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;

  Sewing(
      {this.id,
      this.dyeing_no,
      this.start_time,
      this.end_time,
      this.qty,
      this.width,
      this.length,
      this.notes,
      this.status,
      this.unit_id,
      this.wo_id,
      this.machine_id,
      this.start_by_id,
      this.end_by_id,
      this.attachments,
      this.wo_no,
      this.work_orders,
      this.start_by,
      this.end_by});

  factory Sewing.fromJson(Map<String, dynamic> json) {
    return Sewing(
      id: json['id'] as int?,
      unit_id: json['unit_id'] as int?,
      wo_id: json['wo_id'] as int?,
      machine_id: json['machine_id'] as int?,
      start_by_id: json['start_by_id'] as int?,
      end_by_id: json['end_by_id'] as int?,
      dyeing_no: json['dyeing_no'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
      qty: json['qty'] ?? '',
      width: json['width'] ?? '',
      length: json['length'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      attachments: json['attachments'] ?? [],
      work_orders: json['work_orders'],
      start_by: json['start_by'],
      end_by: json['end_by'],
    );
  }
}
