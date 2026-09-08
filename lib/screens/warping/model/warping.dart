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

  factory Warping.fromJson(Map<String, dynamic> json) {
    return Warping(
      id: json['id'],
      warpingNo: json['warping_no'],
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
    );
  }

  Map<String, dynamic> toJson() {
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
  }
}

class WarpingService extends BaseCrudService<Warping> {
  WarpingService()
      : super(
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
}
