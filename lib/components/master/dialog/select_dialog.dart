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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
        height:
            MediaQuery.of(context).size.height * 0.6, // 60% of screen height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 8),
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
                  itemCount: _dataList.length,
                  itemBuilder: (BuildContext context, index) => GestureDetector(
                    onTap: () {
                      widget.handleChangeValue(_dataList[index]);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
