import 'package:flutter/material.dart';
import 'package:production_tracking/components/master/theme.dart';
import 'package:production_tracking/helpers/util/separated_column.dart';

class SelectSheet extends StatefulWidget {
  final String label;
  final List<dynamic> options;
  final selected;
  final handleChangeValue;

  const SelectSheet(
      {super.key,
      required this.label,
      required this.options,
      this.selected,
      this.handleChangeValue});

  @override
  State<SelectSheet> createState() => _SelectSheetState();
}

class _SelectSheetState extends State<SelectSheet> {
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
          Column(
            children: [
              Text(
                widget.label.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                style: TextStyle(
                  fontSize: 14,
                ),
                decoration: CustomTheme().inputDecoration('Pencarian...'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  _searchDataOption(value);
                },
              )
            ].separatedBy(SizedBox(
              height: 16,
            )),
          ),
          Expanded(
              child: Scrollbar(
                  thickness: 4,
                  child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) =>
                          GestureDetector(
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
                                      fontWeight: _dataList[index]["value"]
                                                  .toString() ==
                                              widget.selected
                                          ? FontWeight.w800
                                          : FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14),
                                )),
                          ),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 0.5,
                        );
                      },
                      itemCount: _dataList.length)))
        ].separatedBy(SizedBox(
          height: 16,
        )),
      ),
    );
  }
}
