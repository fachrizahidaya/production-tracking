import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WeavingSection extends StatefulWidget {
  final bool? skipShearing;
  final Function(bool value)? onSkipShearing;

  const WeavingSection({
    super.key,
    this.onSkipShearing,
    this.skipShearing,
  });

  @override
  State<WeavingSection> createState() => _WeavingSectionState();
}

class _WeavingSectionState extends State<WeavingSection> {
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
        title: 'Shearing',
        icon: Icons.cut_outlined,
        child: _buildItemContent(context, 0));
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SwitchListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: const Text('Skip Shearing'),
            subtitle: Text(
              widget.skipShearing == true ? 'Ya' : 'Tidak',
            ),
            value: widget.skipShearing ?? false,
            onChanged: (value) {
              widget.onSkipShearing?.call(value);
            },
          ),
        ),
      ].separatedBy(
        CustomTheme().vGap('lg'),
      ),
    );
  }
}
