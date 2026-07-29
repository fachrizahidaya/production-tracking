<<<<<<< HEAD
// ignore_for_file: non_constant_identifier_names

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Weaving {
  final int? id;
  final String? weavingNo;
<<<<<<< HEAD
<<<<<<< HEAD
  final int? orderGreigeId;
  final int? machineId;

  final dynamic qty;
  final dynamic weight;
  final dynamic waste;
  final String? notes;
  final skipShearing;
  final machines;
  final machine_ids;
  final attachments;

  Weaving(
      {this.id,
      this.weavingNo,
      this.machineId,
      this.qty,
      this.notes,
      this.orderGreigeId,
      this.skipShearing,
      this.waste,
      this.weight,
      this.machine_ids,
      this.machines,
      this.attachments});
=======
  final int? woId;
=======
  final int? orderGreigeId;
>>>>>>> 95d1a035 (fix: weaving, shearing)
  final int? machineId;

  final dynamic qty;
  final dynamic weight;
  final dynamic waste;
  final String? notes;
  final skipShearing;

  Weaving({
    this.id,
    this.weavingNo,
    this.machineId,
    this.qty,
    this.notes,
    this.orderGreigeId,
    this.skipShearing,
    this.waste,
    this.weight,
  });
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

  factory Weaving.fromJson(Map<String, dynamic> json) {
    return Weaving(
      id: json['id'],
      weavingNo: json['weaving_no'],
<<<<<<< HEAD
<<<<<<< HEAD
      machineId: json['machine_id'],
      qty: json['qty'],
      notes: json['notes'],
      orderGreigeId: json['order_greige_id'],
      skipShearing: json['skip_shearing'],
      waste: json['waste'],
      weight: json['weight'],
      machines: json['machines'] ?? [],
      machine_ids: json['machine_ids'] ?? [],
      attachments: json['attachments'] ?? [],
=======
      woId: json['wo_id'],
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
      machineId: json['machine_id'],
      qty: json['qty'],
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
      skipShearing: json['skip_shearing'],
      waste: json['waste'],
      weight: json['weight'],
>>>>>>> 95d1a035 (fix: weaving, shearing)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weaving_no': weavingNo,
<<<<<<< HEAD
<<<<<<< HEAD
      'machine_id': machineId,
      'qty': qty,
      'notes': notes,
      'order_greige_id': orderGreigeId,
      'skip_shearing': skipShearing,
      'waste': waste,
      'weight': weight,
      'machines': machines,
      'machine_ids': machine_ids,
      'attachments': attachments,
=======
      'wo_id': woId,
=======
>>>>>>> 95d1a035 (fix: weaving, shearing)
      'machine_id': machineId,
      'qty': qty,
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
      'skip_shearing': skipShearing,
      'waste': waste,
      'weight': weight
>>>>>>> 95d1a035 (fix: weaving, shearing)
    };
  }
}

class WeavingService extends BaseCrudService<Weaving> {
  WeavingService()
      : super(
<<<<<<< HEAD
<<<<<<< HEAD
          endpoint: 'weavings',
=======
          endpoint: 'weaving',
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
          endpoint: 'weavings',
>>>>>>> a1ea7df (feat: warping)
          fromJson: (json) => Weaving.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
