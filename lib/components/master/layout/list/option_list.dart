import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';

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
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            if (widget.dataList.isEmpty)
              const Center(child: NoData())
            else
              ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
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
        ))
      ],
    );
  }
}
