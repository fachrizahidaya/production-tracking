import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Embroidery {
  final int? id;
  final String? emb_no;
  final String? wo_no;
  final String? start_time;
  final int? start_by_id;
  final int? end_by_id;
  final String? end_time;
  final String? weight;
  final String? width;
  final String? length;
  final String? notes;
  final String? status;
  final int? weight_unit_id;
  final int? width_unit_id;
  final int? length_unit_id;
  final int? wo_id;
  final int? machine_id;
  final attachments;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;

  Embroidery(
      {this.id,
      this.emb_no,
      this.start_time,
      this.end_time,
      this.weight,
      this.width,
      this.length,
      this.notes,
      this.status,
      this.weight_unit_id,
      this.length_unit_id,
      this.width_unit_id,
      this.wo_id,
      this.machine_id,
      this.start_by_id,
      this.end_by_id,
      this.attachments,
      this.wo_no,
      this.work_orders,
      this.start_by,
      this.end_by});

  factory Embroidery.fromJson(Map<String, dynamic> json) {
    return Embroidery(
      id: json['id'] as int?,
      weight_unit_id: json['weight_unit_id'] as int?,
      width_unit_id: json['width_unit_id'] as int?,
      length_unit_id: json['length_unit_id'] as int?,
      wo_id: json['wo_id'] as int?,
      machine_id: json['machine_id'] as int?,
      start_by_id: json['start_by_id'] as int?,
      end_by_id: json['end_by_id'] as int?,
      emb_no: json['emb_no'] ?? '',
      start_time: json['start_time'] ?? '',
      end_time: json['end_time'] ?? '',
      weight: json['weight'] ?? '',
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight_unit_id': weight_unit_id,
      'length_unit_id': length_unit_id,
      'width_unit_id': width_unit_id,
      'wo_id': wo_id,
      'machine_id': machine_id,
      'start_by_id': start_by_id,
      'end_by_id': end_by_id,
      'emb_no': emb_no,
      'start_time': start_time,
      'end_time': end_time,
      'wo_no': wo_no,
      'weight': weight,
      'width': width,
      'length': length,
      'notes': notes,
      'status': status,
      'attachments': attachments,
      'start_by': start_by,
      'end_by': end_by,
      'work_orders': work_orders,
    };
  }
}

class EmbroideryService extends BaseCrudService<Embroidery> {
  EmbroideryService()
      : super(
          endpoint: 'embroideries',
          fromJson: (json) => Embroidery.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
