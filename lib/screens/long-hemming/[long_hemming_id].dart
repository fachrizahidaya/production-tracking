// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/screens/master/process_detail.dart';

class LongHemmingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const LongHemmingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<LongHemmingDetail> createState() => _LongHemmingDetailState();
}

class _LongHemmingDetailState extends State<LongHemmingDetail> {
  @override
  Widget build(BuildContext context) {
    return ProcessDetail<LongHemming>(
      id: widget.id,
      no: widget.no,
      label: 'Long Hemming',
      service: Provider.of<LongHemmingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<LongHemmingService>(context, listen: false)
              .updateItem(id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<LongHemmingService>(context, listen: false)
              .deleteItem(id, isLoading),
      modelBuilder: (form, data) => LongHemming(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        weight_unit_id: form['weight_unit_id'] != null
            ? int.tryParse(form['weight_unit_id'].toString())
            : 1,
        length_unit_id: form['length_unit_id'] != null
            ? int.tryParse(form['length_unit_id'].toString())
            : 1,
        width_unit_id: form['width_unit_id'] != null
            ? int.tryParse(form['width_unit_id'].toString())
            : 1,
        machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
        weight: form['weight'] ?? '0',
        width: form['width'] ?? '0',
        length: form['length'] ?? '0',
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/long-hemmings',
      fetchMachine: (service) => service.fetchOptionsLongHemming(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
    );
  }
}
