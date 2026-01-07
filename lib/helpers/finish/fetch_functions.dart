// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/models/master/work_order.dart';
import 'package:textile_tracking/models/option/option_item_grade.dart';
import 'package:textile_tracking/models/option/option_unit.dart';
import 'package:textile_tracking/models/option/option_work_order.dart';

class FetchFunctions {
  static Future<void> fetchWorkOrder({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onFinish,
    required Function(List<dynamic>) onSuccess,
    Future<void> Function(dynamic service)? fetchWorkOrder,
    List<dynamic> Function(dynamic service)? getWorkOrderOptions,
  }) async {
    onStart();

    final service = Provider.of<OptionWorkOrderService>(context, listen: false);

    try {
      if (fetchWorkOrder != null) {
        await fetchWorkOrder(service);
      } else {
        await service.fetchOptions();
      }

      final data = getWorkOrderOptions != null
          ? getWorkOrderOptions(service)
          : service.dataListOption;

      onSuccess(data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      onFinish();
    }
  }

  static Future<void> fetchItemGrade({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onFinish,
    required Function(List<dynamic>) onSuccess,
    Future<void> Function(dynamic service)? fetchItemGrade,
    List<dynamic> Function(dynamic service)? getItemGradeOptions,
  }) async {
    onStart();

    final service = Provider.of<OptionItemGradeService>(context, listen: false);

    try {
      if (fetchItemGrade != null) {
        await fetchItemGrade(service);
      } else {
        await service.fetchOptions();
      }

      final data = getItemGradeOptions != null
          ? getItemGradeOptions(service)
          : service.dataListOption;

      onSuccess(data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      onFinish();
    }
  }

  static Future<void> fetchUnit({
    required BuildContext context,
    required VoidCallback onStart,
    required VoidCallback onFinish,
    required Function(List<dynamic>) onSuccess,
  }) async {
    onStart();

    try {
      final service = Provider.of<OptionUnitService>(context, listen: false);

      await service.getDataListOption();
      onSuccess(service.dataListOption);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      onFinish();
    }
  }

  static Future<void> fetchWorkOrderView({
    required VoidCallback onStart,
    required VoidCallback onFinish,
    required WorkOrderService service,
    required String id,
    required Function(Map<String, dynamic>) onSuccess,
  }) async {
    onStart();
    await service.getDataView(id);
    onSuccess(service.dataView);
    onFinish();
  }

  static Future<void> fetchProcessView({
    required dynamic processService,
    required String id,
    required Function(Map<String, dynamic>) onSuccess,
  }) async {
    await processService.getDataView(id);
    onSuccess(processService.dataView);
  }
}
