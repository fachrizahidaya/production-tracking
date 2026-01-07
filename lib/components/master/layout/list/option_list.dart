import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

class OptionList extends StatefulWidget {
  final dataList;
  final itemBuilder;
  final onItemTap;

  const OptionList(
      {super.key, this.dataList, this.itemBuilder, this.onItemTap});

  @override
  State<OptionList> createState() => _OptionListState();
}

class _OptionListState extends State<OptionList> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.dataList.isEmpty)
          const Center(child: NoData())
        else
          ListView.separated(
            separatorBuilder: (context, index) => CustomTheme().vGap('xl'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: CustomTheme().padding('content'),
            itemCount: widget.dataList.length,
            itemBuilder: (context, index) {
              final item = widget.dataList[index];
              return GestureDetector(
                onTap: () => widget.onItemTap?.call(context, item),
                child: widget.itemBuilder(item),
              );
            },
          ),
      ],
    );
  }
}
