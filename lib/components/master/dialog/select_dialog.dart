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
  final String? badgeKey;

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
      this.badgeKey,
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

    _dataList = widget.options;

    if (widget.isManyOption) {
      _scrollController.addListener(_handleScroll);
    }
  }

  _searchDataOption(value) {
    final query = value.toString().toLowerCase();

    setState(() {
      _dataList = widget.options.where((element) {
        final label = element['label'].toString().toLowerCase();
        final badge = _badgeText(element)?.toLowerCase() ?? '';

        return label.contains(query) || badge.contains(query);
      }).toList();
    });
  }

  String? _badgeText(dynamic item) {
    final key = widget.badgeKey;
    if (key == null || item is! Map) return null;

    final raw = _badgeValue(item, key);
    if (raw == null || raw.toString().trim().isEmpty) return null;

    return raw
        .toString()
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  dynamic _badgeValue(Map item, String key, [int depth = 0]) {
    final direct = item[key];
    if (direct != null && direct is! Map && direct.toString().trim().isNotEmpty) {
      return direct;
    }

    if (depth >= 3) return null;

    for (final value in item.values) {
      if (value is Map) {
        final found = _badgeValue(value, key, depth + 1);
        if (found != null) return found;
      }
    }

    return null;
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
    final listData = widget.isManyOption ? widget.options : _dataList;

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
                          final badgeText = _badgeText(item);

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
                                  if (widget.isAnyAdditionalData)
                                    Text(
                                      '${item["code"]}',
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.w800
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          item['label'],
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      if (badgeText != null) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: CustomTheme()
                                                .buttonColor('primary')
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: CustomTheme()
                                                  .buttonColor('primary')
                                                  .withOpacity(0.18),
                                            ),
                                          ),
                                          child: Text(
                                            badgeText,
                                            style: TextStyle(
                                              color: CustomTheme()
                                                  .buttonColor('primary'),
                                              fontSize:
                                                  CustomTheme().fontSize('sm'),
                                              fontWeight: CustomTheme()
                                                  .fontWeight('bold'),
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (isSelected) ...[
                                        SizedBox(width: 8),
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 20),
                                      ],
                                    ],
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
