// ignore_for_file: non_constant_identifier_names

import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Shearing {
  final int? id;
  final String? shearingNo;
  final int? orderGreigeId;
  final int? machineId;
  final qty;
  final weight;
  final String? notes;
  final machines;
  final machine_ids;
  final attachments;

  Shearing(
      {this.id,
      this.shearingNo,
      this.machineId,
      this.orderGreigeId,
      this.notes,
      this.qty,
      this.weight,
      this.machines,
      this.machine_ids,
      this.attachments});

  factory Shearing.fromJson(Map<String, dynamic> json) {
    return Shearing(
      id: json['id'],
      shearingNo: json['shearing_no'],
      machineId: json['machine_id'],
      notes: json['notes'],
      orderGreigeId: json['order_greige_id'],
      qty: json['qty'],
      weight: json['weight'],
      machines: json['machines'] ?? [],
      machine_ids: json['machine_ids'] ?? [],
      attachments: json['attachments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shearing_no': shearingNo,
      'machine_id': machineId,
      'notes': notes,
      'order_greige_id': orderGreigeId,
      'qty': qty,
      'weight': weight,
      'machines': machines,
      'machine_ids': machine_ids,
      'attachments': attachments,
    };
  }
}

class ShearingService extends BaseCrudService<Shearing> {
  ShearingService()
      : super(
          endpoint: 'shearings',
          fromJson: (json) => Shearing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
