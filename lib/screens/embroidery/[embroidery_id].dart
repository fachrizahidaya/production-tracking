// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/process/embroidery.dart';
import 'package:textile_tracking/screens/process_detail.dart';

class EmbroideryDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const EmbroideryDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<EmbroideryDetail> createState() => _EmbroideryDetailState();
}

class _EmbroideryDetailState extends State<EmbroideryDetail> {
  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Embroidery>(
      id: widget.id,
      no: widget.no,
      label: 'Embroidery',
      service: Provider.of<EmbroideryService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<EmbroideryService>(context, listen: false)
              .updateItem(id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<EmbroideryService>(context, listen: false)
              .deleteItem(id, isLoading),
      modelBuilder: (form, data) => Embroidery(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          unit_id: form['item_unit_id'] != null
              ? int.tryParse(form['item_unit_id'].toString())
              : 1,
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
          qty: form['item_qty'] ?? '0',
          weight: form['weight'] ?? '0',
          width: form['width'] ?? '0',
          length: form['length'] ?? '0',
          notes: form['notes'] ?? data['notes'],
          attachments: [
            ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
            ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
          ],
          maklon: form['maklon'],
          maklon_name: form['maklon_name']),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/embroideries',
      withItemGrade: false,
      withQtyAndWeight: true,
      withMaklon: true,
    );
  }
}
