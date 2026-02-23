// ignore_for_file: file_names, use_build_context_synchronously, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
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
  final DyeingService _dyeingService = DyeingService();

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
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<DyeingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Dyeing(
        wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
        unit_id: form['unit_id'] != null
            ? int.tryParse(form['unit_id'].toString())
            : 1,
        length_unit_id: form['length_unit_id'] != null
            ? int.tryParse(form['length_unit_id'].toString())
            : 3,
        width_unit_id: form['width_unit_id'] != null
            ? int.tryParse(form['width_unit_id'].toString())
            : 3,
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
      idProcess: 'dyeing_id',
      processService: _dyeingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final dyeing = Dyeing(
          wo_id: int.tryParse(form['wo_id']?.toString() ?? ''),
          machine_id: int.tryParse(form['machine_id']?.toString() ?? ''),
          unit_id: int.tryParse(form['unit_id']?.toString() ?? '1'),
          width_unit_id: int.tryParse(form['width_unit_id']?.toString() ?? '3'),
          length_unit_id:
              int.tryParse(form['length_unit_id']?.toString() ?? '3'),
          qty: form['qty'],
          width: form['width'] =
              (form['width'] == null || form['width'].toString().isEmpty)
                  ? '0'
                  : form['width'],
          length: form['length'] =
              (form['length'] == null || form['length'].toString().isEmpty)
                  ? '0'
                  : form['length'],
          notes: form['notes'],
          start_time: form['start_time'],
          end_time: form['end_time'],
          start_by_id: int.tryParse(form['start_by_id']?.toString() ?? ''),
          end_by_id: int.tryParse(form['end_by_id']?.toString() ?? ''),
          attachments: form['attachments'],
        );

        final message = await Provider.of<DyeingService>(context, listen: false)
            .finishItem(context, id, dyeing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/dyeings', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Dyeing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "DYE",
              ));
        });
      },
    );
  }
}
