import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/container/template.dart';
<<<<<<< HEAD
<<<<<<< HEAD
=======
import 'package:textile_tracking/components/master/form/text_form.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
>>>>>>> 12b70b7 (fix: mulai weaving)
=======
>>>>>>> d91efd4f (fix: form warping, weaving)
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class WeavingSection extends StatefulWidget {
<<<<<<< HEAD
<<<<<<< HEAD
  final bool? skipShearing;
  final Function(bool value)? onSkipShearing;

  const WeavingSection({
    super.key,
    this.onSkipShearing,
    this.skipShearing,
  });
=======
  final items;
  final onChange;
  final data;

  const WeavingSection({super.key, this.data, this.items, this.onChange});
>>>>>>> 12b70b7 (fix: mulai weaving)
=======
  final bool? skipShearing;
  final Function(bool value)? onSkipShearing;

  const WeavingSection({
    super.key,
    this.onSkipShearing,
    this.skipShearing,
  });
>>>>>>> d91efd4f (fix: form warping, weaving)

  @override
  State<WeavingSection> createState() => _WeavingSectionState();
}

class _WeavingSectionState extends State<WeavingSection> {
<<<<<<< HEAD
<<<<<<< HEAD
  @override
  void initState() {
    super.initState();
=======
  final Map<int, TextEditingController> _beamWeightControllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      _beamWeightControllers[i] = TextEditingController(
        text: item['beam_weight']?.toString() ?? '0',
      );
    }
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
>>>>>>> 12b70b7 (fix: mulai weaving)
=======
  @override
  void initState() {
    super.initState();
>>>>>>> d91efd4f (fix: form warping, weaving)
  }

  @override
  void dispose() {
<<<<<<< HEAD
<<<<<<< HEAD
=======
    for (final controller in _beamWeightControllers.values) {
      controller.dispose();
    }
>>>>>>> 12b70b7 (fix: mulai weaving)
=======
>>>>>>> d91efd4f (fix: form warping, weaving)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d91efd4f (fix: form warping, weaving)
    return TemplateCard(
        title: 'Shearing',
        icon: Icons.cut_outlined,
        child: _buildItemContent(context, 0));
<<<<<<< HEAD
=======
    if (widget.items.isEmpty) {
      return NoData();
    }

    if (widget.items.length == 1) {
      return Expanded(
          child: TemplateCard(
              title: 'Berat Awal',
              icon: Icons.rule,
              child: _buildItemContent(context, 0, widget.items.first)));
    }

    return DefaultTabController(
        length: widget.items.length,
        child: Expanded(
            child: TemplateCard(
                title: 'Berat Awal',
                icon: Icons.rule,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: TabBar(
                          isScrollable: true,
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Colors.white,
                          indicator: BoxDecoration(
                            color: Colors.blue[800],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          tabAlignment: TabAlignment.start,
                          tabs: widget.items.asMap().entries.map((entry) {
                            final index = entry.key;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Tab(
                                text: 'Item ${index + 1}',
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 360,
                      child: TabBarView(
                        children: widget.items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ),
                            child: _buildItemContent(
                              context,
                              index,
                              item,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ))));
>>>>>>> 12b70b7 (fix: mulai weaving)
=======
>>>>>>> d91efd4f (fix: form warping, weaving)
  }

  Widget _buildItemContent(
    BuildContext context,
    int index,
<<<<<<< HEAD
<<<<<<< HEAD
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
=======
    dynamic item,
=======
>>>>>>> d91efd4f (fix: form warping, weaving)
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
<<<<<<< HEAD
>>>>>>> 12b70b7 (fix: mulai weaving)
=======
            value: widget.skipShearing ?? false,
            onChanged: (value) {
              widget.onSkipShearing?.call(value);
            },
>>>>>>> d91efd4f (fix: form warping, weaving)
          ),
        ),
      ].separatedBy(
        CustomTheme().vGap('lg'),
      ),
    );
  }
}
