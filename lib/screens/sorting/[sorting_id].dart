// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/process/sorting.dart';
import 'package:textile_tracking/screens/process_detail.dart';

class SortingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const SortingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<SortingDetail> createState() => _SortingDetailState();
}

class _SortingDetailState extends State<SortingDetail> {
  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Sorting>(
      id: widget.id,
      no: widget.no,
      label: 'Sorting',
      service: Provider.of<SortingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<SortingService>(context, listen: false)
              .updateItem(id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<SortingService>(context, listen: false)
              .deleteItem(id, isLoading),
      modelBuilder: (form, data) => Sorting(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          weight_unit_id:
              int.tryParse(form['weight_unit_id']?.toString() ?? ''),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? ''),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? ''),
          unit_id: int.tryParse(form['unit_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          qty: form['qty'] ?? data['qty'],
          weight: form['weight'] ?? data['weight'],
          width: form['width'] ?? data['width'],
          length: form['length'] ?? data['length'],
          notes: form['notes'] ?? data['notes'],
          attachments: [
            ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
            ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
          ],
          grades: [
            ...List<Map<String, dynamic>>.from(data['grades'] ?? []),
            ...List<Map<String, dynamic>>.from(form['grades'] ?? []),
          ]),
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      route: '/sortings',
      withItemGrade: true,
    );
  }
}
