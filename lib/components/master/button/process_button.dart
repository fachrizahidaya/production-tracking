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
      this.withItemGrade});

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  double _parseNum(String? value) {
    return double.tryParse(value?.trim() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final qty = _parseNum(widget.qty);
    final weight = _parseNum(widget.weight);

    final bool hasBasicError =
        widget.weightWarning != null || widget.qtyWarning != null
        // ||
        // qty <= 0 ||
        // weight <= 0
        ;

    final bool isDisabled = widget.withItemGrade == true
        ? !widget.isQtyFullyDistributed()
        : hasBasicError;

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: CustomTheme().padding('card'),
        child: ValueListenableBuilder<bool>(
          valueListenable: widget.isSubmitting,
          builder: (context, isSubmitting, _) {
            return Row(
              children: [
                Expanded(
                  child: CancelButton(
                    label: 'Batal',
                    customHeight: 48.0,
                    onPressed: () => widget.handleCancel(context),
                  ),
                ),
                Expanded(
                    child: FormButton(
                  label: widget.labelProcess,
                  isDisabled: isDisabled,
                  customHeight: 48.0,
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
    );
  }
}
