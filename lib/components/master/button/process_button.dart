import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessButton extends StatefulWidget {
  final data;
  final form;
  final isSubmitting;
  final labelProcess;
  final processId;
  final formKey;
  final handleSubmit;
  final handleCancel;
  final qtyWarning;
  final weightWarning;
  final weight;
  final qty;
  final bool Function() isQtyFullyDistributed;
  final withItemGrade;
  final withItemQtyAndWeight;
  final isAllMachineDone;
  final label;

  const ProcessButton(
      {super.key,
      this.processId,
      this.data,
      this.form,
      this.labelProcess,
      this.isSubmitting,
      this.handleSubmit,
      this.formKey,
      this.handleCancel,
      this.weightWarning,
      this.qtyWarning,
      this.weight,
      this.qty,
      required this.isQtyFullyDistributed,
      this.withItemGrade,
      this.withItemQtyAndWeight,
      this.isAllMachineDone,
      this.label});

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  @override
  Widget build(BuildContext context) {
    final bool hasBasicError =
        widget.weightWarning != null || widget.qtyWarning != null;

    final bool isNeedMachineValidation = [
      'long hemming',
      'sewing',
      'cross cutting'
    ].contains(widget.label.toLowerCase());

    final result = widget.isAllMachineDone(widget.data?['machines'] ?? []);

    double parseSafeWeight(dynamic value) {
      if (value == null) return 0;

      if (value is num) return value.toDouble();

      String str = value.toString().trim();

      if (str.isEmpty) return 0;

      str = str.replaceAll('.', '');
      str = str.replaceAll(',', '.');

      return double.tryParse(str) ?? 0;
    }

    bool hasInvalidWeightItems() {
      final items = widget.form?['items'];

      if (items == null || items is! List || items.isEmpty) {
        return true;
      }

      return items.any((item) {
        final goodWeight = parseSafeWeight(item['good_weight']);
        final bsWeight = parseSafeWeight(item['bs_weight']);

        return goodWeight == 0 && bsWeight == 0;
      });
    }

    double parseSafeQty(dynamic value) {
      if (value == null) return 0;

      if (value is num) return value.toDouble();

      return double.tryParse(
            value.toString().replaceAll(',', '').trim(),
          ) ??
          0;
    }

    bool hasInvalidQtyItems() {
      final items = widget.form?['items'];

      if (items == null || items is! List || items.isEmpty) {
        return true;
      }

      return items.any((item) {
        final qty = parseSafeQty(item['qty']);
        return qty <= 0;
      });
    }

    final bool hasWeightItemError =
        widget.label == 'Long Hemming' ? hasInvalidWeightItems() : false;

    final bool hasQtyItemError =
        (widget.label == 'Cross Cutting' || widget.label == 'Sewing')
            ? hasInvalidQtyItems()
            : false;

    final bool isDisabled =
        hasBasicError || hasWeightItemError || hasQtyItemError;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.isSubmitting,
            builder: (context, isSubmitting, _) {
              return Row(
                children: [
                  Expanded(
                    child: CancelButton(
                      label: 'Batal',
                      customHeight: 56.0,
                      fontSize: CustomTheme().fontSize('xl'),
                      onPressed: () => widget.handleCancel(context),
                    ),
                  ),
                  Expanded(
                      child: FormButton(
                    label: widget.labelProcess,
                    isDisabled:
                        isDisabled || (isNeedMachineValidation && !result),
                    customHeight: 56.0,
                    fontSize: CustomTheme().fontSize('xl'),
                    onPressed: () async {
                      widget.isSubmitting.value = true;
                      try {
                        if (!widget.formKey.currentState!.validate()) {
                          return;
                        }

                        if (widget.processId != null) {
                          await widget.handleSubmit(context);
                        }
                      } finally {
                        widget.isSubmitting.value = false;
                      }
                    },
                  ))
                ].separatedBy(CustomTheme().hGap('xl')),
              );
            },
          ),
        ),
      ),
    );
  }
}
