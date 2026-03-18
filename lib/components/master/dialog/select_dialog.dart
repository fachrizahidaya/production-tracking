import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

class SelectDialog extends StatefulWidget {
  final String label;
  final List<dynamic> options;
  final selected;
  final handleChangeValue;
  final isAnyAdditionalData;
  final bool isManyOption;
  final bool isLoading;
  final bool hasMoreData;

  final Function(String)? onSearch;
  final Function()? onLoadMore;

  const SelectDialog(
      {super.key,
      required this.label,
      required this.options,
      this.selected,
      this.handleChangeValue,
      this.isAnyAdditionalData = false,
      this.isManyOption = false,
      this.hasMoreData = false,
      this.isLoading = false,
      this.onLoadMore,
      this.onSearch});

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  late List<dynamic> _dataList;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.isManyOption) {
      _scrollController.addListener(_handleScroll);
    } else {
      _dataList = widget.options;
    }
  }

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

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 100) {
      if (!widget.isLoading && widget.hasMoreData) {
        widget.onLoadMore?.call();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listData = widget.options;
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
                  if (widget.isManyOption) {
                    widget.onSearch?.call(value);
                  } else {
                    _searchDataOption(value);
                  }
                },
              ),
            ),
            Divider(),
            Expanded(
              child: listData.isEmpty
                  ? Center(
                      child: NoData(),
                    )
                  : Scrollbar(
                      child: ListView.separated(
                        controller:
                            widget.isManyOption ? _scrollController : null,
                        itemCount: widget.isManyOption
                            ? listData.length + (widget.isLoading ? 1 : 0)
                            : listData.length,
                        itemBuilder: (context, index) {
                          if (widget.isManyOption && index >= listData.length) {
                            return Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final item = listData[index];

                          final isSelected =
                              item['value'].toString() == widget.selected;

                          return GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                widget.handleChangeValue(null);
                              } else {
                                widget.handleChangeValue(item);
                              }

                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['label'],
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                    ],
                                  ),
                                  if (widget.isAnyAdditionalData)
                                    Text(
                                      '${item["code"]}',
                                      style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Divider(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
