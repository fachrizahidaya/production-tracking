// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';
import 'package:textile_tracking/screens/sizing/model/sizing.dart';

class SizingDetailScreen extends StatefulWidget {
  final id;
  final no;
  final canDelete;
  final canUpdate;
  final bool openUpdateOnStart;

  const SizingDetailScreen(
      {super.key,
      this.id,
      this.no,
      this.canDelete,
      this.canUpdate,
      this.openUpdateOnStart = false});

  @override
  State<SizingDetailScreen> createState() => _SizingDetailScreenState();
}

class _SizingDetailScreenState extends State<SizingDetailScreen> {
  final SizingService _sizingService = SizingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Sizing>(
      id: widget.id,
      no: widget.no,
      label: 'Sizing',
      prefix: 'SIZ',
      isMultiMachine: false,
      service: Provider.of<SizingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<SizingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<SizingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Sizing(
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      route: '/sizing',
      canDelete: widget.canDelete,
      canUpdate: widget.canUpdate,
      openUpdateOnStart: widget.openUpdateOnStart,
      fetchMachine: (service, _) => service.fetchOptionsSizing(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'sizing_id',
      processService: _sizingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchSizingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final sizing = Sizing(
          notes: form['notes'],
          attachments: form['attachments'],
        );

        final message = await Provider.of<SizingService>(context, listen: false)
            .finishItem(context, id, sizing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/sizing', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Sizing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "SIZ",
              ));
        });
      },
    );
  }
}
