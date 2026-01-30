// ignore_for_file: file_names, use_build_context_synchronously, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';

class DyeingDetail extends StatefulWidget {
  final String id;
  final String no;
  final canDelete;
  final canUpdate;

  const DyeingDetail(
      {super.key,
      required this.id,
      required this.no,
      this.canDelete,
      this.canUpdate});

  @override
  State<DyeingDetail> createState() => _DyeingDetailState();
}

class _DyeingDetailState extends State<DyeingDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Dyeing>(
      id: widget.id,
      no: widget.no,
      label: 'Dyeing',
      service: Provider.of<DyeingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<DyeingService>(context, listen: false)
              .updateItem(id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<DyeingService>(context, listen: false)
              .deleteItem(id, isLoading),
      modelBuilder: (form, data) => Dyeing(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        unit_id: form['unit_id'] != null
            ? int.tryParse(form['unit_id'].toString())
            : 1,
        length_unit_id: form['length_unit_id'] != null
            ? int.tryParse(form['length_unit_id'].toString())
            : 1,
        width_unit_id: form['width_unit_id'] != null
            ? int.tryParse(form['width_unit_id'].toString())
            : 1,
        machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
        qty: form['qty'] ?? '0',
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
      route: '/dyeings',
      withItemGrade: false,
      withQtyAndWeight: false,
      withMaklon: false,
      forDyeing: true,
      getMachineOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsDyeing(),
    );
  }
}
