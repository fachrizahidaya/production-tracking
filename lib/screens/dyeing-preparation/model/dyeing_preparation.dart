import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class DyeingPreparation {
  final id;
  final woId;
  final items;
  final notes;
  final attachments;

  DyeingPreparation(
      {this.id, this.woId, this.items, this.notes, this.attachments});

  factory DyeingPreparation.fromJson(Map<String, dynamic> json) {
    return DyeingPreparation(
      id: json['id'],
      woId: json['wo_id'],
      items: json['items'] ?? [],
      notes: json['notes'],
      attachments: json['attachments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'wo_id': woId,
      'items': items,
      'notes': notes,
      'attachments': attachments
    };

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
