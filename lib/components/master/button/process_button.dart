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
  final hasItemQtyWarning;
<<<<<<< HEAD
<<<<<<< HEAD
  final attachments;
  final hasAttachment;
<<<<<<< HEAD
=======
>>>>>>> 6451ceb8 (Release/version 1.2.1 (#30))
=======
  final attachments;
  final hasAttachment;
>>>>>>> eeae9f55 (fix: attachment mandatory for packing)
=======
  final bool hasPackingGradeAStocks;
>>>>>>> 66533988 (fix: finish packing ambil stok)

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
      this.label,
<<<<<<< HEAD
<<<<<<< HEAD
      this.hasItemQtyWarning = false,
      this.attachments,
<<<<<<< HEAD
      this.hasAttachment});
=======
      this.hasItemQtyWarning = false});
>>>>>>> 6451ceb8 (Release/version 1.2.1 (#30))
=======
      this.hasItemQtyWarning = false,
      this.attachments,
      this.hasAttachment});
>>>>>>> eeae9f55 (fix: attachment mandatory for packing)
=======
      this.hasAttachment,
      this.hasPackingGradeAStocks = false});
>>>>>>> 66533988 (fix: finish packing ambil stok)

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  @override
  Widget build(BuildContext context) {
    final bool hasBasicError =
        widget.weightWarning != null || widget.qtyWarning != null;

<<<<<<< HEAD
    final bool isDyeingRework =
        widget.label == 'Dyeing' && widget.data?['rework'] == true;
    final bool isNeedMachineValidation = [
      'dyeing',
      'press',
      'tumbler',
      'long slitting',
      'long hemming',
      'sewing',
      'cross cutting'
    ].contains(widget.label.toLowerCase());

<<<<<<< HEAD
=======
    final machines = widget.data?['machines'] ?? widget.form?['machines'] ?? [];
    final result = widget.isAllMachineDone(machines);
=======
>>>>>>> 9965df4b (fix: hilangkan cek status mesin saat selesai)
    final bool isDyeingRework =
        widget.label == 'Dyeing' && widget.data?['rework'] == true;
    final bool isNeedMachineValidation = [
      'dyeing',
      'press',
      'tumbler',
      'long slitting',
      'long hemming',
      'sewing',
      'cross cutting'
    ].contains(widget.label.toLowerCase());

>>>>>>> b2f13701 (fix: kondisi button finish process)
    bool hasDyeingReworkError() {
      if (!isDyeingRework) {
        return false;
      }

      final reworkCategory = widget.form?['rework_category']?.toString();
      final reworkType = widget.form?['rework_type'] as List? ?? [];
      final reworkMethod = widget.form?['rework_method'] as List? ?? [];

      return reworkCategory == null ||
          reworkCategory.isEmpty ||
          (reworkCategory == 'perbaikan' && reworkType.isEmpty) ||
          (reworkType.contains('perbaikan_warna') && reworkMethod.isEmpty);
    }
<<<<<<< HEAD
=======

<<<<<<< HEAD
    bool hasMachineError() {
      if (!isNeedMachineValidation) {
        return false;
      }

      if (isDyeingRework) {
        return machines.isNotEmpty && !result;
      }

      return !result;
    }
>>>>>>> b2f13701 (fix: kondisi button finish process)

=======
>>>>>>> 9965df4b (fix: hilangkan cek status mesin saat selesai)
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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> eeae9f55 (fix: attachment mandatory for packing)
    final bool hasPackingAttachmentError = widget.label == 'Packing' &&
        ((widget.attachments == null) ||
            (widget.attachments is! List) ||
            (widget.attachments as List)
                .where((e) => e['is_add_button'] != true)
                .isEmpty);

    final bool isDisabled = hasBasicError ||
        hasWeightItemError ||
        hasQtyItemError ||
        hasDyeingReworkError() ||
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        // hasPackingAttachmentError ||
<<<<<<< HEAD
=======
    final bool isDisabled = hasBasicError ||
        hasWeightItemError ||
        hasQtyItemError ||
>>>>>>> 6451ceb8 (Release/version 1.2.1 (#30))
=======
        hasMachineError() ||
>>>>>>> b2f13701 (fix: kondisi button finish process)
=======
>>>>>>> 9965df4b (fix: hilangkan cek status mesin saat selesai)
=======
        hasPackingAttachmentError ||
>>>>>>> eeae9f55 (fix: attachment mandatory for packing)
=======
        // hasPackingAttachmentError ||
>>>>>>> 6578af90 (fix: button untuk persiapan dyeing)
        widget.hasItemQtyWarning == true;
=======
        (widget.hasItemQtyWarning == true &&
            !widget.hasPackingGradeAStocks);
>>>>>>> 66533988 (fix: finish packing ambil stok)

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
                    isDisabled: isDisabled,
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
