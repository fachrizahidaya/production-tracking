<<<<<<< HEAD
// ignore_for_file: non_constant_identifier_names

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Sizing {
  final int? id;
  final String? sizingNo;
<<<<<<< HEAD
  final int? machineId;

  final orderGreigeId;
  final yarnQty;
  final length;
  final section;
  final notes;
  final panjangGulungan;
  final attachments;
  final machines;
  final machine_ids;

  Sizing(
      {this.id,
      this.sizingNo,
      this.machineId,
      this.length,
      this.orderGreigeId,
      this.section,
      this.yarnQty,
      this.notes,
      this.panjangGulungan,
      this.attachments,
      this.machine_ids,
      this.machines});
=======
  final int? woId;
  final int? machineId;
  final String? startTime;
  final String? endTime;
  final int? startById;
  final int? endById;
  final int? unitId;
  final dynamic qty;
  final String? notes;
  final String? status;
  final bool? rework;
  final int? reworkReferenceId;
  final String? lotCelupNo;
  final int? greigeItemId;
  final int? cycleNo;

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

  Sizing({
    this.id,
    this.sizingNo,
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

  factory Sizing.fromJson(Map<String, dynamic> json) {
    return Sizing(
      id: json['id'],
      sizingNo: json['sizing_no'],
<<<<<<< HEAD
      machineId: json['machine_id'],
      orderGreigeId: json['order_greige_id'],
      yarnQty: json['yarn_qty'],
      notes: json['notes'],
      length: json['length'],
      section: json['section'],
      panjangGulungan: json['roll_length'],
      machines: json['machines'] ?? [],
      machine_ids: json['machine_ids'] ?? [],
=======
      woId: json['wo_id'],
      machineId: json['machine_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      startById: json['start_by_id'],
      endById: json['end_by_id'],
      unitId: json['unit_id'],
      qty: json['qty'],
      notes: json['notes'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sizing_no': sizingNo,
<<<<<<< HEAD
      'machine_id': machineId,
      'order_greige_id': orderGreigeId,
      'yarn_qty': yarnQty,
      'notes': notes,
      'length': length,
      'section': section,
      'roll_length': panjangGulungan,
      'machines': machines,
      'machine_ids': machine_ids,
=======
      'wo_id': woId,
      'machine_id': machineId,
      'start_time': startTime,
      'end_time': endTime,
      'start_by_id': startById,
      'end_by_id': endById,
      'unit_id': unitId,
      'qty': qty,
      'notes': notes,
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
    };
  }
}

class SizingService extends BaseCrudService<Sizing> {
  SizingService()
      : super(
<<<<<<< HEAD
<<<<<<< HEAD
          endpoint: 'sizings',
=======
          endpoint: 'sizing',
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
          endpoint: 'sizings',
>>>>>>> a1ea7df (feat: warping)
          fromJson: (json) => Sizing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
