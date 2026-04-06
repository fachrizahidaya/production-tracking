import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SelectFilterDialog extends StatefulWidget {
  final statusOption;
  final selectedStatuses;

  const SelectFilterDialog(
      {super.key, this.statusOption, this.selectedStatuses});

  @override
  State<SelectFilterDialog> createState() => _SelectFilterDialogState();
}

class _SelectFilterDialogState extends State<SelectFilterDialog> {
  Timer? _debounce;
  List<dynamic> _filteredList = [];
  late TextEditingController _controller;
  late List<dynamic> _selectedStatuses;

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(widget.statusOption);
    _controller = TextEditingController();
    _selectedStatuses = widget.selectedStatuses ?? [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
        child: StatefulBuilder(
          builder: (context, setState) {
            void runSearch(String value) {
              if (_debounce?.isActive ?? false) {
                _debounce!.cancel();
              }

              _debounce = Timer(Duration(milliseconds: 300), () {
                setState(() {
                  if (value.isEmpty) {
                    _filteredList = List.from(widget.statusOption);
                  } else {
                    _filteredList = widget.statusOption
                        .where((e) => e['label']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  }
                });
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
                  child: Text(
                    "Pilih Status",
                    style: TextStyle(
                      height: 1,
                      fontSize: CustomTheme().fontSize('xl'),
                      fontWeight: CustomTheme().fontWeight('semibold'),
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _controller.clear();
                                runSearch('');
                                setState(() {});
                              },
                              icon: Icon(Icons.close))
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    onChanged: runSearch,
                  ),
                ),
                Divider(),
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) {
                        final item = _filteredList[index];

                        final isSelected = _selectedStatuses
                            .any((s) => s['value'] == item['value']);

                        return CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 24),
                          value: isSelected,
                          title: Text(item['label']), // ✅ pakai item
                          activeColor: Colors.green,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedStatuses.add(item);
                              } else {
                                _selectedStatuses.removeWhere((s) =>
                                    s['value'] == item['value']); // ✅ safer
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: CancelButton(
                            label: 'Reset',
                            onPressed: () {
                              setState(() {
                                _selectedStatuses.clear();
                                _filteredList = List.from(widget.statusOption);
                              });
                            },
                            fontSize: CustomTheme().fontSize('xl'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: FormButton(
                            label: 'Terapkan',
                            onPressed: () {
                              Navigator.pop(context, _selectedStatuses);
                            },
                            fontSize: CustomTheme().fontSize('xl'),
                          ),
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('lg')),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
