import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WarpingSection extends StatefulWidget {
  final onChange;
  final controller;

  const WarpingSection({super.key, this.onChange, this.controller});

  @override
  State<WarpingSection> createState() => _WarpingSectionState();
}

class _WarpingSectionState extends State<WarpingSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateCard(
        title: 'Jumlah Benang',
        icon: Icons.join_inner_outlined,
        child: _buildItemContent(context, 0));
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextForm(
          label: 'Jumlah Benang (KG)',
          controller: widget.controller,
          req: false,
          isNumber: true,
          isSorting: true,
          handleChange: (value) {
            if (widget.onChange != null) {
              widget.onChange(value);
            }
          },
        ),
      ].separatedBy(
        CustomTheme().vGap('lg'),
      ),
    );
  }
}
