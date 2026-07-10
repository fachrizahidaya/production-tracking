import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/util/bold_message.dart';
import 'package:textile_tracking/screens/detail/%5Bprocess_id%5D.dart';
import 'package:textile_tracking/screens/shearing/model/shearing.dart';

class ShearingDetailScreen extends StatefulWidget {
  final id;
  final no;

  const ShearingDetailScreen({super.key, this.id, this.no});

  @override
  State<ShearingDetailScreen> createState() => _ShearingDetailScreenState();
}

class _ShearingDetailScreenState extends State<ShearingDetailScreen> {
  final ShearingService _shearingService = ShearingService();

  @override
  Widget build(BuildContext context) {
    return ProcessDetail<Shearing>(
      id: widget.id,
      no: widget.no,
      label: 'Shearing',
      prefix: 'SHE',
      isMultiMachine: false,
      service: Provider.of<ShearingService>(context, listen: false),
      handleUpdateService: (context, id, item, isLoading) =>
          Provider.of<ShearingService>(context, listen: false)
              .updateItem(context, id, item, isLoading),
      handleDeleteService: (context, id, isLoading) =>
          Provider.of<ShearingService>(context, listen: false)
              .deleteItem(context, id, isLoading),
      modelBuilder: (form, data) => Shearing(
        notes: form['notes'] ?? data['notes'],
        attachments: [
          ...List<Map<String, dynamic>>.from(data['attachments'] ?? []),
          ...List<Map<String, dynamic>>.from(form['attachments'] ?? []),
        ],
      ),
      route: '/shearing',
      fetchMachine: (service, _) => service.fetchOptionsShearing(),
      getMachineOptions: (service) => service.dataListOption,
      withItemGrade: false,
      withMaklon: false,
      forDyeing: false,
      idProcess: 'shearing_id',
      processService: _shearingService,
      forPacking: false,
      fetchFinish: (service) => service.fetchShearingFinishOptions(),
      handleSubmitToService: (context, id, form, isLoading) async {
        final shearing = Shearing(
          notes: form['notes'],
          attachments: form['attachments'],
        );

        final message =
            await Provider.of<ShearingService>(context, listen: false)
                .finishItem(context, id, shearing, isLoading);

        Navigator.pushNamedAndRemoveUntil(context, '/shearing', (_) => false);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog(
              context: context,
              title: 'Shearing Selesai',
              child: buildBoldMessage(
                message: message,
                prefix: "SHE",
              ));
        });
      },
    );
  }
}
