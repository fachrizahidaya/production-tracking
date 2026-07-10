import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

class WarpingDetailScreen extends StatefulWidget {
  final id;
  final no;

  const WarpingDetailScreen({super.key, this.id, this.no});

  @override
  State<WarpingDetailScreen> createState() => _WarpingDetailScreenState();
}

class _WarpingDetailScreenState extends State<WarpingDetailScreen> {
  final WarpingService _warpingService = WarpingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Warping>(
      id: widget.id,
      no: widget.no,
      label: 'Warping',
      prefix: 'WAR',
      isMultiMachine: false,
      service: Provider.of<WarpingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<WarpingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<WarpingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Warping(
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      route: '/warping',
      fetchMachine: (service, _) => service.fetchOptionsWarping(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'warping_id',
      processService: _warpingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchWarpingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final warping = Warping(
          notes: form['notes'],
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<WarpingService>(context, listen: false)
                .finishItem(context, id, warping, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/warping', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Warping Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "WAR",
              ));
        });
      },
    );
  }
}
