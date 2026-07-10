import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class WeavingDetailScreen extends StatefulWidget {
  final id;
  final no;
  final canDelete;
  final canUpdate;
  final bool openUpdateOnStart;

  const WeavingDetailScreen(
      {super.key,
      this.id,
      this.no,
      this.canDelete,
      this.canUpdate,
      this.openUpdateOnStart = false});

  @override
  State<WeavingDetailScreen> createState() => _WeavingDetailScreenState();
}

class _WeavingDetailScreenState extends State<WeavingDetailScreen> {
  final WeavingService _weavingService = WeavingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Weaving>(
      id: widget.id,
      no: widget.no,
      label: 'Weaving',
      prefix: 'WEA',
      isMultiMachine: false,
      service: Provider.of<WeavingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<WeavingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<WeavingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Weaving(
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      route: '/weaving',
      canUpdate: widget.canUpdate,
      canDelete: widget.canDelete,
      openUpdateOnStart: widget.openUpdateOnStart,
      fetchMachine: (service, _) => service.fetchOptionsWeaving(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'weaving_id',
      processService: _weavingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchWeavingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final weaving = Weaving(
          notes: form['notes'],
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<WeavingService>(context, listen: false)
                .finishItem(context, id, weaving, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/weaving', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Weaving Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "WEA",
              ));
        });
      },
    );
  }
}
