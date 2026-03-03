import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0),
              child: Text(
                'Pilih ${widget.label.toString()}',
                style: TextStyle(
                    fontSize: CustomTheme().fontSize('xl'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    height: 1),
              ),
            ),
            Divider(),
            // Container(
            //     padding: EdgeInsets.symmetric(horizontal: 8),
            //     decoration: BoxDecoration(
            //       border: Border(
            //         bottom: BorderSide(
            //           color: Colors.grey.shade300,
            //           width: 1,
            //         ),
            //       ),
            //       color: Colors.white,
            //     ),
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: TextField(
            //             // controller: _controller,
            //             decoration: InputDecoration(
            //               hintText: 'Cari',
            //               prefixIcon: const Icon(Icons.search),
            //               // suffixIcon: _controller.text.isNotEmpty
            //               //     ? IconButton(
            //               //         onPressed: () {
            //               //           _controller.clear();
            //               //           widget.handleSearchChange('');
            //               //           setState(() {});
            //               //         },
            //               //         icon: const Icon(Icons.close))
            //               //     : null,
            //               border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(8),
            //                   borderSide: BorderSide.none),
            //               filled: true,
            //               fillColor: Colors.white,
            //             ),
            //             onChanged: (value) {
            //               // widget.handleSearchChange(value);
            //               setState(() {});
            //             },
            //           ),
            //         ),
            //       ],
            //     )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                decoration: CustomTheme().inputDecoration('Pencarian...'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  _searchDataOption(value);
                },
              ),
            ),
            Divider(),
            Expanded(
              child: _dataList.isEmpty
                  ? Center(
                      child: NoData(),
                    )
                  : Scrollbar(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _dataList.length,
                        itemBuilder: (BuildContext context, index) {
                          final isSelected =
                              _dataList[index]['value'].toString() ==
                                  widget.selected;

                          return GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                widget.handleChangeValue(null);
                              } else {
                                widget.handleChangeValue(_dataList[index]);
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Label
                                  Expanded(
                                    child: Text(
                                      '${_dataList[index]["label"]}',
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.w800
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  // Check icon for selected
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      ),
                    ),
            ),
          ].separatedBy(CustomTheme().vGap('lg')),
        ),
      ),
    );
  }
}
