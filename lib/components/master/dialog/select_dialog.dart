import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

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
  final TextEditingController _controller = TextEditingController();

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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
              child: Text(
                'Pilih ${widget.label.toString()}',
                style: TextStyle(
                    fontSize: CustomTheme().fontSize('xl'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    height: 1),
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            // runSearch('');
                            setState(() {});
                          },
                          icon: Icon(Icons.close))
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
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
                                  if (isSelected)
                                    Icon(
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
          ],
        ),
      ),
    );
  }
}
