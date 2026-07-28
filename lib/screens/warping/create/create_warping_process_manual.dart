import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/create/create_greige_order_process_manual.dart';
import 'package:textile_tracking/screens/warping/model/warping.dart';

class CreateWarpingProcessManual extends StatelessWidget {
  final dynamic id;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? form;
  final handleSubmit;
  final processId;

  const CreateWarpingProcessManual({
    super.key,
    this.id,
    this.data,
    this.form,
    this.handleSubmit,
    this.processId,
  });

  @override
  Widget build(BuildContext context) {
    final WarpingService warpingService = WarpingService();

    return CreateGreigeOrderProcessManual(
      title: 'Mulai Warping',
      label: 'Warping',
      id: id,
      data: data,
      form: form,
      processId: processId,
      processService: warpingService,
      idProcess: 'warping_id',
      handleSubmit: handleSubmit,
      fetchGreigeOrder: (service) => service.fetchWarpingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
      fetchMachine: (service) => service.fetchOptionsWarping(),
      getMachineOptions: (service) => service.dataListOption,
    );
  }
}
