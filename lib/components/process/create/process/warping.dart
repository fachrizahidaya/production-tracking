import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WarpingSection extends StatefulWidget {
  final items;
  final onChange;
  final data;

  const WarpingSection({super.key, this.data, this.items, this.onChange});

  @override
  State<WarpingSection> createState() => _WarpingSectionState();
}

class _WarpingSectionState extends State<WarpingSection> {
  final Map<int, TextEditingController> _beamWeightControllers = {};

  @override
  void initState() {
    super.initState();
  }

  void _handleQty(
    int index,
    String value,
  ) {
    final safeValue = value.toString().trim().isEmpty ? '0' : value.toString();

    widget.onChange(
      index,
      'beam_weight',
      safeValue,
    );
  }

  @override
  void dispose() {
    for (final controller in _beamWeightControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
        title: 'Berat Awal',
        icon: Icons.rule,
        child: _buildItemContent(context, 0));
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
  ) {
    final isTablet = MediaQuery.of(context).size.width > 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: isTablet
              ? (MediaQuery.of(context).size.width - 80) / 2
              : double.infinity,
          child: TextForm(
            label: 'Jumlah Benang (KG)',
            controller: _beamWeightControllers[index],
            req: false,
            isNumber: true,
            isSorting: true,
            handleChange: (value) => _handleQty(
              index,
              value,
            ),
          ),
        ),
      ].separatedBy(
        CustomTheme().vGap('lg'),
      ),
    );
  }
}
