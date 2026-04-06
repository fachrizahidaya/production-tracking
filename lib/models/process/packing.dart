// ignore_for_file: non_constant_identifier_names

import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Packing {
  final int? id;
  final String? packing_no;
  final String? wo_no;
  final String? start_time;
  final int? start_by_id;
  final int? end_by_id;
  final String? end_time;
  final String? weight_per_dozen;
  final String? gsm;
  final String? total_weight;
  final String? notes;
  final String? status;
  final int? wo_id;
  final attachments;
  final grades;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;
  final String? qty;
  final int? unit_id;
  final int? greige_item_id;

  Packing(
      {this.id,
      this.packing_no,
      this.start_time,
      this.end_time,
      this.notes,
      this.status,
      this.wo_id,
      this.start_by_id,
      this.end_by_id,
      this.attachments,
      this.wo_no,
      this.work_orders,
      this.start_by,
      this.end_by,
      this.grades,
      this.weight_per_dozen,
      this.gsm,
      this.total_weight,
      this.greige_item_id,
      this.qty,
      this.unit_id});

  factory Packing.fromJson(Map<String, dynamic> json) {
    return Packing(
        id: json['id'] as int?,
        wo_id: json['wo_id'] as int?,
        start_by_id: json['start_by_id'] as int?,
        end_by_id: json['end_by_id'] as int?,
        packing_no: json['packing_no'] ?? '',
        start_time: json['start_time'] ?? '',
        end_time: json['end_time'] ?? '',
        weight_per_dozen: json['weight_per_dozen'] ?? '',
        gsm: json['gsm'] ?? '',
        total_weight: json['total_weight'] ?? '',
        status: json['status'] ?? '',
        notes: json['notes'] ?? '',
        attachments: json['attachments'] ?? [],
        work_orders: json['work_orders'],
        start_by: json['start_by'],
        end_by: json['end_by'],
        grades: json['grades'] ?? [],
        qty: json['qty'] ?? '',
        unit_id: json['unit_id'] as int?,
        greige_item_id: json['greige_item_id'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wo_id': wo_id,
      'start_by_id': start_by_id,
      'end_by_id': end_by_id,
      'packing_no': packing_no,
      'start_time': start_time,
      'end_time': end_time,
      'wo_no': wo_no,
      'notes': notes,
      'status': status,
      'attachments': attachments,
      'start_by': start_by,
      'end_by': end_by,
      'work_orders': work_orders,
      'grades': grades,
      'weight_per_dozen': weight_per_dozen,
      'gsm': gsm,
      'total_weight': total_weight,
      'qty': qty,
      'unit_id': unit_id,
      'greige_item_id': greige_item_id,
    };
  }
}

class PackingService extends BaseCrudService<Packing> {
  PackingService()
      : super(
          endpoint: 'packings',
          fromJson: (json) => Packing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
