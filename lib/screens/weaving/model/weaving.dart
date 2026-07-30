import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class Weaving {
  final int? id;
  final String? weavingNo;
  final int? orderGreigeId;
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

  factory Weaving.fromJson(Map<String, dynamic> json) {
    return Weaving(
      id: json['id'],
      weavingNo: json['weaving_no'],
      machineId: json['machine_id'],
      qty: json['qty'],
      notes: json['notes'],
      orderGreigeId: json['order_greige_id'],
      skipShearing: json['skip_shearing'],
      waste: json['waste'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weaving_no': weavingNo,
      'machine_id': machineId,
      'qty': qty,
      'notes': notes,
      'order_greige_id': orderGreigeId,
      'skip_shearing': skipShearing,
      'waste': waste,
      'weight': weight
    };
  }
}

class WeavingService extends BaseCrudService<Weaving> {
  WeavingService()
      : super(
          endpoint: 'weavings',
          fromJson: (json) => Weaving.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
