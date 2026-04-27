import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class QtyWeightSection extends StatefulWidget {
  final Map form;
  final String label;

  final bool withItemGrade;
  final bool withQtyAndWeight;
  final bool forDyeing;

  final TextEditingController qty;
  final TextEditingController dyeingQty;
  final TextEditingController weightGood;
  final TextEditingController weightDefect;

  final String? qtyWarning;
  final String? weightWarning;

  final Function(String key, dynamic value) onChange;
  final Function(String value) validateQty;
  final Function(String value) validateWeight;
  final VoidCallback calculateLongHemmingWeight;

  const QtyWeightSection({
    super.key,
    required this.form,
    required this.label,
    required this.withItemGrade,
    required this.withQtyAndWeight,
    required this.forDyeing,
    required this.qty,
    required this.dyeingQty,
    required this.weightGood,
    required this.weightDefect,
    required this.onChange,
    required this.validateQty,
    required this.validateWeight,
    required this.calculateLongHemmingWeight,
    this.qtyWarning,
    this.weightWarning,
  });

  @override
  State<QtyWeightSection> createState() => _QtyWeightSectionState();
}

class _QtyWeightSectionState extends State<QtyWeightSection> {
  @override
  Widget build(BuildContext context) {
    final isHidden = widget.withItemGrade == true ||
        widget.label == 'Packing' ||
        widget.label == 'Press' ||
        widget.label == 'Tumbler' ||
        widget.label == 'Stenter' ||
        widget.label == 'Long Slitting';

    if (isHidden) return SizedBox();

    return Expanded(
      child: TemplateCard(
        title: widget.label == 'Cross Cutting' || widget.label == 'Sewing'
            ? 'Qty'
            : 'Berat',
        icon: Icons.list_alt_outlined,
        child: Column(
          children: [
            /// ✅ LONG HEMMING
            if (widget.label == 'Long Hemming')
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextForm(
                          label: 'Berat Bagus (KG)',
                          initialValue:
                              widget.form['good_weight']?.toString() ?? '0',
                          req: true,
                          isNumber: true,
                          controller: widget.weightGood,
                          handleChange: (value) {
                            final safe = value.trim().isEmpty ? '0' : value;

                            widget.onChange('good_weight', safe);

                            setState(() {
                              widget.validateWeight(safe);
                            });

                            widget.calculateLongHemmingWeight();
                          },
                        ),
                        if (widget.weightWarning != null)
                          _buildWarning(widget.weightWarning!),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextForm(
                      label: 'Berat BS (KG)',
                      req: true,
                      initialValue: widget.form['bs_weight']?.toString() ?? '0',
                      isNumber: true,
                      controller: widget.weightDefect,
                      handleChange: (value) {
                        final safe = value.trim().isEmpty ? '0' : value;

                        widget.onChange('bs_weight', safe);
                        widget.calculateLongHemmingWeight();
                      },
                    ),
                  ),
                ].separatedBy(CustomTheme().hGap('xl')),
              ),

            /// ✅ QTY
            if (widget.withQtyAndWeight == true)
              Column(
                children: [
                  TextForm(
                    label: 'Qty Hasil ${widget.label} (PCS)',
                    req: true,
                    isNumber: true,
                    initialValue: widget.form['item_qty']?.toString() ?? '0',
                    controller: widget.qty,
                    handleChange: (value) {
                      final safe = value.trim().isEmpty ? '0' : value;

                      widget.onChange('item_qty', safe);

                      setState(() {
                        widget.validateQty(safe);
                      });
                    },
                  ),
                  if (widget.qtyWarning != null)
                    _buildWarning(widget.qtyWarning!),
                ],
              ),

            /// ✅ DYEING
            if (widget.forDyeing == true)
              Column(
                children: [
                  TextForm(
                    label: 'Berat Hasil ${widget.label} (KG)',
                    req: true,
                    isNumber: true,
                    initialValue: widget.form['qty']?.toString() ?? '0',
                    controller: widget.dyeingQty,
                    handleChange: (value) {
                      final safe = value.trim().isEmpty ? '0' : value;

                      widget.onChange('qty', safe);

                      setState(() {
                        widget.validateWeight(safe);
                      });
                    },
                  ),
                  if (widget.weightWarning != null)
                    _buildWarning(widget.weightWarning!),
                ],
              ),
          ].separatedBy(CustomTheme().vGap('lg')),
        ),
      ),
    );
  }

  Widget _buildWarning(String text) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: CustomTheme().colors('warning'),
              fontSize: CustomTheme().fontSize('sm'),
            ),
          ),
        ),
      ],
    );
  }
}
