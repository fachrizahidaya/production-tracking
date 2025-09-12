import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/theme.dart';

class SelectDialog extends StatefulWidget {
  final String label;
  final List<dynamic> options;
  final selected;
  final handleChangeValue;

  const SelectDialog(
      {super.key,
      required this.label,
      required this.options,
      this.selected,
      this.handleChangeValue});

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  late List<dynamic> _dataList;

  _searchDataOption(value) {
    setState(() {
      _dataList = widget.options
          .where((element) => element['label']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _dataList = widget.options;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomTheme().containerBottomSheetDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTheme().horizontalLineBottomSheet(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label.toString(),
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('xl'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('md'),
                    ),
                    decoration: CustomTheme().inputDecoration('Pencarian...'),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _searchDataOption(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Scrollbar(
            thickness: 4,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _dataList.length,
              itemBuilder: (BuildContext context, index) => GestureDetector(
                onTap: () {
                  widget.handleChangeValue(_dataList[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Text(
                    '${_dataList[index]["label"]}',
                    style: TextStyle(
                      fontWeight: _dataList[index]["value"].toString() ==
                              widget.selected
                          ? FontWeight.w800
                          : FontWeight.w400,
                      color: Colors.black,
                      fontSize: CustomTheme().fontSize('md'),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                  thickness: 0.5,
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}
