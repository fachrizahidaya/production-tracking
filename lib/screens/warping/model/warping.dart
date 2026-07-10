<<<<<<< HEAD
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';
import 'package:textile_tracking/providers/api_client.dart';

class Warping {
  final id;
  final warpingNo;
  final orderGreigeId;
  final machineId;
  final warpingType;
  final notes;
  final yarnQty;
  final beamQty;
  final lengths;
  final section;
  final attachments;
  final machines;
  final machine_ids;
  final length;
  final weight;
  final brokenYarns;

  Warping(
      {this.id,
      this.warpingNo,
      this.machineId,
      this.orderGreigeId,
      this.warpingType,
      this.yarnQty,
      this.notes,
      this.lengths,
      this.section,
      this.beamQty,
      this.attachments,
      this.machine_ids,
      this.machines,
      this.length,
      this.weight,
      this.brokenYarns});
=======
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
>>>>>>> 7fd183d (feat: create and finish warping, weaving)

  factory Warping.fromJson(Map<String, dynamic> json) {
    return Warping(
      id: json['id'],
      warpingNo: json['warping_no'],
<<<<<<< HEAD
      machineId: json['machine_id'],
      orderGreigeId: json['order_greige_id'],
      warpingType: json['warping_type'],
      yarnQty: json['yarn_qty'],
      notes: json['notes'],
      lengths:
          json['lengths'] != null ? List<dynamic>.from(json['lengths']) : null,
      section: json['section'],
      beamQty: json['beam_qty'],
      attachments: json['attachments'] ?? [],
      machines: json['machines'] ?? [],
      machine_ids: json['machine_ids'] ?? [],
      length: json['length'],
      weight: json['weight'],
      brokenYarns: json['broken_yarns'] ?? [],
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
<<<<<<< HEAD
    final data = {
      'id': id,
      'warping_no': warpingNo,
      'machine_id': machineId,
      'order_greige_id': orderGreigeId,
      'warping_type': warpingType,
      'yarn_qty': yarnQty,
      'notes': notes,
      'lengths': lengths,
      'section': section,
      'beam_qty': beamQty,
      'attachments': attachments,
      'machines': machines,
      'machine_ids': machine_ids,
      'length': length,
      'weight': weight,
      'broken_yarns': brokenYarns,
    };

    data.removeWhere((key, value) => value == null);

    return data;
=======
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
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
  }
}

class WarpingService extends BaseCrudService<Warping> {
  WarpingService()
      : super(
<<<<<<< HEAD
          endpoint: 'warpings',
          fromJson: (json) => Warping.fromJson(json),
          toJson: (item) => item.toJson(),
        );

  Future<List<Map<String, dynamic>>> fetchBrokenYarnTypes(
    BuildContext context,
  ) async {
    final response = await ApiClient.instance.get(
      context,
      Uri.parse('$baseUrl/$endpoint/broken-yarn-types'),
    );
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(decoded['data'] ?? []);
    }

    throw decoded['message'] ?? 'Gagal mengambil jenis benang putus';
  }
=======
          endpoint: 'warping',
          fromJson: (json) => Warping.fromJson(json),
          toJson: (item) => item.toJson(),
        );
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
}
