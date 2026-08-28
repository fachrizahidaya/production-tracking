// ignore_for_file: non_constant_identifier_names, annotate_overrides, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';
import 'package:textile_tracking/providers/api_client.dart';

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
  final dynamic rework_reference;
  final int? rework_reference_id;
  final attachments;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;
  final machine;
  final dyeingLotNo;
  final greige_item_id;
  final semifinished_products;
  final machines;
  final machine_ids;
  final String? rework_category;
  final rework_type;
  final rework_method;

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
      this.machine,
      this.rework_reference,
      this.dyeingLotNo,
      this.greige_item_id,
      this.semifinished_products,
      this.machine_ids,
      this.machines,
      this.rework_category,
      this.rework_type,
      this.rework_method});

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
      work_orders: json['work_orders'],
      notes: json['notes'] ?? '',
      attachments: json['attachments'] ?? [],
      machine: json['machine'] ?? {},
      rework_reference: json['rework_reference'],
      start_by: json['start_by'],
      end_by: json['end_by'],
      width_unit_id: json['width_unit_id'] as int?,
      wo_no: json['wo_no'],
      length_unit_id: json['length_unit_id'] as int?,
      dyeingLotNo: json['lot_celup_no'],
      greige_item_id: json['greige_item_id'] as int?,
      semifinished_products: json['semifinished_products'] ?? [],
      machines: json['machines'] ?? [],
      machine_ids: json['machine_ids'] ?? [],
      rework_category: json['rework_category'],
      rework_type: json['rework_type'] ?? [],
      rework_method: json['rework_method'] ?? [],
    );
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
      'rework_reference': rework_reference,
      'start_by': start_by,
      'end_by': end_by,
      'notes': notes,
      'length_unit_id': length_unit_id,
      'width_unit_id': width_unit_id,
      'wo_no': wo_no,
      'lot_celup_no': dyeingLotNo,
      'greige_item_id': greige_item_id,
      'semifinished_products': semifinished_products,
      'machines': machines,
      'machine_ids': machine_ids,
      'rework_category': rework_category,
      'rework_type': rework_type,
      'rework_method': rework_method,
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

  Future<List<dynamic>> fetchReworkCategoryOptions(BuildContext context) async {
    final url = Uri.parse('$baseUrl/dyeings/rework-category-options');

    final response = await ApiClient.instance.get(context, url);
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return decoded['data'] ?? [];
    }

    throw (decoded['message'] ?? 'Gagal mengambil kategori rework');
  }
}
