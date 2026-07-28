import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Sizing {
  final int? id;
  final String? sizingNo;
  final int? machineId;

  final orderGreigeId;
  final yarnQty;
  final length;
  final section;
  final notes;
  final panjangGulungan;

  Sizing(
      {this.id,
      this.sizingNo,
      this.machineId,
      this.length,
      this.orderGreigeId,
      this.section,
      this.yarnQty,
      this.notes,
      this.panjangGulungan});

  factory Sizing.fromJson(Map<String, dynamic> json) {
    return Sizing(
        id: json['id'],
        sizingNo: json['sizing_no'],
        machineId: json['machine_id'],
        orderGreigeId: json['order_greige_id'],
        yarnQty: json['yarn_qty'],
        notes: json['notes'],
        length: json['length'],
        section: json['section'],
        panjangGulungan: json['roll_length']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sizing_no': sizingNo,
      'machine_id': machineId,
      'order_greige_id': orderGreigeId,
      'yarn_qty': yarnQty,
      'notes': notes,
      'length': length,
      'section': section,
      'roll_length': panjangGulungan
    };
  }
}

class SizingService extends BaseCrudService<Sizing> {
  SizingService()
      : super(
          endpoint: 'sizings',
          fromJson: (json) => Sizing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
