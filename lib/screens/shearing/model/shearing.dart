<<<<<<< HEAD
// ignore_for_file: non_constant_identifier_names

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Shearing {
  final int? id;
  final String? shearingNo;
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
  final int? woId;
=======
  final int? orderGreigeId;
>>>>>>> 95d1a035 (fix: weaving, shearing)
  final int? machineId;
  final qty;
  final weight;
  final String? notes;

<<<<<<< HEAD
  final bool? canDelete;
  final bool? canUpdate;
  final bool? canRework;

  final List<dynamic> attachments;
  final List<dynamic> semifinishedProducts;

  final dynamic workOrders;
  final dynamic machine;
  final dynamic startBy;
  final dynamic endBy;
  final dynamic unit;
  final dynamic reworkReference;

  Shearing({
    this.id,
    this.shearingNo,
    this.woId,
    this.machineId,
    this.startTime,
    this.endTime,
    this.startById,
    this.endById,
    this.unitId,
    this.qty,
    this.notes,
    this.status,
    this.rework,
    this.reworkReferenceId,
    this.lotCelupNo,
    this.greigeItemId,
    this.cycleNo,
    this.canDelete,
    this.canUpdate,
    this.canRework,
    this.attachments = const [],
    this.semifinishedProducts = const [],
    this.workOrders,
    this.machine,
    this.startBy,
    this.endBy,
    this.unit,
    this.reworkReference,
  });
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
  Shearing(
      {this.id,
      this.shearingNo,
      this.machineId,
      this.orderGreigeId,
      this.notes,
      this.qty,
      this.weight});
>>>>>>> 95d1a035 (fix: weaving, shearing)

  factory Shearing.fromJson(Map<String, dynamic> json) {
    return Shearing(
      id: json['id'],
      shearingNo: json['shearing_no'],
<<<<<<< HEAD
<<<<<<< HEAD
      machineId: json['machine_id'],
      notes: json['notes'],
      orderGreigeId: json['order_greige_id'],
      qty: json['qty'],
      weight: json['weight'],
      machines: json['machines'] ?? [],
      machine_ids: json['machine_ids'] ?? [],
      attachments: json['attachments'] ?? [],
=======
      woId: json['wo_id'],
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
      machineId: json['machine_id'],
      notes: json['notes'],
<<<<<<< HEAD
      status: json['status'],
      rework: json['rework'],
      reworkReferenceId: json['rework_reference_id'],
      lotCelupNo: json['lot_celup_no'],
      greigeItemId: json['greige_item_id'],
      cycleNo: json['cycle_no'],
      canDelete: json['can_delete'],
      canUpdate: json['can_update'],
      canRework: json['can_rework'],
      attachments: json['attachments'] ?? [],
      semifinishedProducts: json['semifinished_products'] ?? [],
      workOrders: json['work_orders'],
      machine: json['machine'],
      startBy: json['start_by'],
      endBy: json['end_by'],
      unit: json['unit'],
      reworkReference: json['rework_reference'],
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
      orderGreigeId: json['order_greige_id'],
      qty: json['qty'],
      weight: json['weight'],
>>>>>>> 95d1a035 (fix: weaving, shearing)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shearing_no': shearingNo,
<<<<<<< HEAD
<<<<<<< HEAD
      'machine_id': machineId,
      'notes': notes,
      'order_greige_id': orderGreigeId,
      'qty': qty,
      'weight': weight,
      'machines': machines,
      'machine_ids': machine_ids,
      'attachments': attachments,
=======
      'wo_id': woId,
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
      'machine_id': machineId,
      'notes': notes,
<<<<<<< HEAD
      'status': status,
      'rework': rework == true ? 1 : 0,
      'rework_reference_id': reworkReferenceId,
      'lot_celup_no': lotCelupNo,
      'greige_item_id': greigeItemId,
      'cycle_no': cycleNo,
      'attachments': attachments,
      'semifinished_products': semifinishedProducts,
      'work_orders': workOrders,
      'machine': machine,
      'start_by': startBy,
      'end_by': endBy,
      'unit': unit,
      'rework_reference': reworkReference,
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
      'order_greige_id': orderGreigeId,
      'qty': qty,
      'weight': weight
>>>>>>> 95d1a035 (fix: weaving, shearing)
    };
  }
}

class ShearingService extends BaseCrudService<Shearing> {
  ShearingService()
      : super(
<<<<<<< HEAD
<<<<<<< HEAD
          endpoint: 'shearings',
=======
          endpoint: 'shearing',
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
          endpoint: 'shearings',
>>>>>>> a1ea7df (feat: warping)
          fromJson: (json) => Shearing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
