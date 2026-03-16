import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class FetchFunction {
  Future<List<dynamic>> fetchWorkOrder(context,
      {customFetch, customGetter}) async {
    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    if (customFetch != null) {
      await customFetch(service);
    } else {
      await service.fetchOptions();
    }

    return customGetter != null
        ? customGetter(service)
        : service.dataListOption;
  }

  Future<void> fetchItemGrade(context, {customFetch, customGetter}) async {
    final service = Provider.of<OptionItemGradeService>(context, listen: false);

    if (customFetch != null) {
      await customFetch(service);
    } else {
      await service.fetchOptions();
    }

    return customGetter != null
        ? customGetter(service)
        : service.dataListOption;
  }

  Future<List<dynamic>> fetchUnit(BuildContext context) async {
    final service = Provider.of<OptionUnitService>(context, listen: false);

    await service.getDataListOption();
    return service.dataListOption;
  }
}
