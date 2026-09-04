<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
import 'package:textile_tracking/helpers/service/base_crud_service.dart';

class DyeingPreparation {
  final id;
  final woId;
<<<<<<< HEAD
<<<<<<< HEAD
  final items;
  final notes;
  final attachments;
<<<<<<< HEAD
  final attachmentIds;

  DyeingPreparation(
      {this.id,
      this.woId,
      this.items,
      this.notes,
      this.attachments,
      this.attachmentIds});

  factory DyeingPreparation.fromJson(Map<String, dynamic> json) {
    return DyeingPreparation(
      id: json['id'],
      woId: json['wo_id'],
      items: json['items'] ?? [],
      notes: json['notes'],
      attachments: json['attachments'] ?? [],
      attachmentIds: json['attachment_ids'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'wo_id': woId,
      'items': items,
      'notes': notes,
      'attachments': attachments,
      'attachment_ids': attachmentIds,
    };
=======
=======
  final items;
  final notes;
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)

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
<<<<<<< HEAD
<<<<<<< HEAD
    final data = {'id': id, 'wo_id': woId};
>>>>>>> 57f45d55 (feat: persiapan dyeing)
=======
    final data = {'id': id, 'wo_id': woId, 'items': items, 'notes': notes};
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
    final data = {
      'id': id,
      'wo_id': woId,
      'items': items,
      'notes': notes,
      'attachments': attachments
    };
>>>>>>> 7a6d7992 (fix: attachment for dyeing preparation)

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
<<<<<<< HEAD

  Future<void> fetchPreparationList(
    BuildContext context,
    Map<String, String> params,
  ) {
    return getDyeingPreparationDataList(
      context,
      params,
    );
  }

  Future<void> fetchPreparationDetail(
    BuildContext context,
    dynamic id,
  ) {
    return getDyeingPreparationDataView(
      context,
      id,
    );
  }

  Future<String> createPreparation(
    BuildContext context,
    DyeingPreparation item,
    ValueNotifier<bool> isSubmitting,
  ) {
    return addDyeingPreparationItem(
      context,
      item,
      isSubmitting,
    );
  }

  Future<String> updatePreparation(
    BuildContext context,
    String id,
    DyeingPreparation item,
    ValueNotifier<bool> isSubmitting,
  ) {
    return updateDyeingPreparationItem(
      context,
      id,
      item,
      isSubmitting,
    );
  }
=======
>>>>>>> 57f45d55 (feat: persiapan dyeing)
}
