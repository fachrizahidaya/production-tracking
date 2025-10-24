// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/process/stenter.dart';
import 'package:textile_tracking/screens/process_detail.dart';

class StenterDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const StenterDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<StenterDetail> createState() => _StenterDetailState();
}

class _StenterDetailState extends State<StenterDetail> {
  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Stenter>(
      id: widget.id,
      no: widget.no,
      label: 'Stenter',
      service: Provider.of<StenterService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<StenterService>(context, listen: false)
              .updateItem(id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<StenterService>(context, listen: false)
              .deleteItem(id, isLoading),
      modelBuilder: (form, data) => Stenter(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        weight_unit_id: int.tryParse(form['weight_unit_id']?.toString() ?? ''),
        length_unit_id: int.tryParse(form['length_unit_id']?.toString() ?? ''),
        width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
        machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
        weight: form['weight'] ?? data['weight'],
        width: form['width'] ?? data['width'],
        length: form['length'] ?? data['length'],
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/stenters',
    );
  }
}
