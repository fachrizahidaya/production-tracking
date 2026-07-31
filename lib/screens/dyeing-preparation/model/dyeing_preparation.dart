import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class DyeingPreparation {
  final id;
  final woId;

  DyeingPreparation({this.id, this.woId});

  factory DyeingPreparation.fromJson(Map<String, dynamic> json) {
    return DyeingPreparation(id: json['id'], woId: json['wo_id']);
  }

  Map<String, dynamic> toJson() {
    final data = {'id': id, 'wo_id': woId};

    data.removeWhere((key, value) => value == null);

    return data;
  }
}

class DyeingPreparationService extends BaseCrudService<DyeingPreparation> {
  DyeingPreparationService()
      : super(
          endpoint: 'dyeing-preparations',
          fromJson: (json) => DyeingPreparation.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
