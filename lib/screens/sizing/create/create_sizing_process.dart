import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/create/greige_order_index.dart';

class CreateSizingProcess extends StatelessWidget {
  final String title;
  final Widget Function(
    BuildContext context,
    dynamic id,
    dynamic processId,
    Map<String, dynamic> data,
    Map<String, dynamic> form,
    Future<void> Function() handleSubmit,
  ) formPageBuilder;
  final handleSubmitToService;

  const CreateSizingProcess({
    super.key,
    required this.title,
    required this.formPageBuilder,
    this.handleSubmitToService,
  });

  @override
  Widget build(BuildContext context) {
    return CreateGreigeOrderProcess(
      title: title,
      handleSubmitToService: handleSubmitToService,
      formPageBuilder: formPageBuilder,
      fetchGreigeOrder: (service) => service.fetchSizingOptions(),
      getGreigeOrderOptions: (service) => service.dataListOption,
    );
  }
}
