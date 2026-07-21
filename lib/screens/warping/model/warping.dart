import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Warping {
  final int? id;
  final String? warpingNo;
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

  Warping({
    this.id,
    this.warpingNo,
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

  factory Warping.fromJson(Map<String, dynamic> json) {
    return Warping(
      id: json['id'],
      warpingNo: json['warping_no'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'warping_no': warpingNo,
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
    };
  }
}

class WarpingService extends BaseCrudService<Warping> {
  WarpingService()
      : super(
          endpoint: 'warpings',
          fromJson: (json) => Warping.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
