// ignore_for_file: prefer_final_fields, non_constant_identifier_names, annotate_overrides

import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class WorkOrderProcess {
  final int? id;
  final String? spk_no;
  final String? wo_no;
  final String? status;
  final String? wo_date;
  final int? wo_qty;
  final String? greige_qty;
  final processes;
  final grades;

  WorkOrderProcess(
      {this.id,
      this.spk_no,
      this.wo_no,
      this.status,
      this.wo_date,
      this.wo_qty,
      this.greige_qty,
      this.processes,
      this.grades});

  factory WorkOrderProcess.fromJson(Map<String, dynamic> json) {
    return WorkOrderProcess(
      id: json['id'] as int?,
      spk_no: json['spk_no'] ?? '',
      wo_no: json['wo_no'] ?? '',
      status: json['status'] ?? '',
      wo_date: json['wo_date'] ?? '',
      wo_qty: json['wo_qty'] as int?,
      greige_qty: json['greige_qty'] ?? '',
      processes: json['processes'] ?? {},
      grades: json['grades'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spk_no': spk_no,
      'wo_no': wo_no,
      'status': status,
      'wo_date': wo_date,
      'wo_qty': wo_qty,
      'greige_qty': greige_qty,
      'processes': processes,
      'grades': grades,
    };
  }
}

class WorkOrderProcessService extends BaseCrudService<WorkOrderProcess> {
  WorkOrderProcessService()
      : super(
          endpoint: 'dashboard/wo-process',
          fromJson: (json) => WorkOrderProcess.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
