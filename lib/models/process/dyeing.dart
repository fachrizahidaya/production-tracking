// ignore_for_file: non_constant_identifier_names, annotate_overrides, prefer_final_fields

import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Dyeing {
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
  final bool? rework;
  final int? unit_id;
  final int? width_unit_id;
  final int? length_unit_id;
  final int? wo_id;
  final int? machine_id;
  final int? rework_reference_id;
  final attachments;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;
  final machine;

  Dyeing(
      {this.id,
      this.dyeing_no,
      this.start_time,
      this.end_time,
      this.qty,
      this.width,
      this.length,
      this.notes,
      this.status,
      this.rework,
      this.unit_id,
      this.wo_id,
      this.machine_id,
      this.rework_reference_id,
      this.start_by_id,
      this.end_by_id,
      this.attachments,
      this.wo_no,
      this.work_orders,
      this.start_by,
      this.end_by,
      this.length_unit_id,
      this.width_unit_id,
      this.machine});

  factory Dyeing.fromJson(Map<String, dynamic> json) {
    return Dyeing(
        id: json['id'] as int?,
        unit_id: json['unit_id'] as int?,
        wo_id: json['wo_id'] as int?,
        machine_id: json['machine_id'] as int?,
        start_by_id: json['start_by_id'] as int?,
        end_by_id: json['end_by_id'] as int?,
        rework_reference_id: json['rework_reference_id'] as int?,
        dyeing_no: json['dyeing_no'] ?? '',
        start_time: json['start_time'] ?? '',
        end_time: json['end_time'] ?? '',
        qty: json['qty'] ?? '',
        width: json['width'] ?? '',
        length: json['length'] ?? '',
        status: json['status'] ?? '',
        rework: json['rework'] as bool?,
        notes: json['notes'] ?? '',
        attachments: json['attachments'] ?? [],
        machine: json['machine'] ?? {},
        work_orders: json['work_orders'],
        start_by: json['start_by'],
        end_by: json['end_by'],
        width_unit_id: json['width_unit_id'] as int?,
        wo_no: json['wo_no'],
        length_unit_id: json['length_unit_id'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_id': unit_id,
      'wo_id': wo_id,
      'machine_id': machine_id,
      'start_by_id': start_by_id,
      'end_by_id': end_by_id,
      'rework_reference_id': rework_reference_id,
      'dyeing_no': dyeing_no,
      'start_time': start_time,
      'end_time': end_time,
      'qty': qty,
      'width': width,
      'length': length,
      'status': status,
      'rework': rework,
      'attachments': attachments,
      'machine': machine,
      'work_orders': work_orders,
      'start_by': start_by,
      'end_by': end_by,
      'notes': notes,
      'length_unit_id': length_unit_id,
      'width_unit_id': width_unit_id,
      'wo_no': wo_no,
    };
  }
}

class DyeingService extends BaseCrudService<Dyeing> {
  DyeingService()
      : super(
          endpoint: 'dyeings',
          fromJson: (json) => Dyeing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
