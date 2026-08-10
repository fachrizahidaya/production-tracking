import 'package:textile_tracking/helpers/service/base_crud_service.dart';

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
      this.beamQty});

  factory Warping.fromJson(Map<String, dynamic> json) {
    return Warping(
        id: json['id'],
        warpingNo: json['warping_no'],
        machineId: json['machine_id'],
        orderGreigeId: json['order_greige_id'],
        warpingType: json['warping_type'],
        yarnQty: json['yarn_qty'],
        notes: json['notes'],
        lengths: json['lengths'] != null
            ? List<dynamic>.from(json['lengths'])
            : null,
        section: json['section'],
        beamQty: json['beam_qty']);
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
      'beam_qty': beamQty
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
}
