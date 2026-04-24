import 'dart:async';

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SelectFilterDialog extends StatefulWidget {
  final List<dynamic> statusOption;
  final List<dynamic> selectedStatuses;

  const SelectFilterDialog({
    super.key,
    required this.statusOption,
    required this.selectedStatuses,
  });

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

    // ✅ WAJIB: clone list
    _selectedStatuses = List.from(widget.selectedStatuses);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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

  bool isSelected(item) {
    return _selectedStatuses.any(
      (s) => s['value'].toString().trim() == item['value'].toString().trim(),
    );
  }

  void toggleItem(item, bool checked) {
    setState(() {
      if (checked) {
        // ✅ prevent duplicate
        if (!isSelected(item)) {
          _selectedStatuses.add(item);
        }
      } else {
        _selectedStatuses.removeWhere(
          (s) => s['value'] == item['value'],
        );
      }
    });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
              child: Text(
                "Pilih Status",
                style: TextStyle(
                    fontSize: CustomTheme().fontSize('xl'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    height: 1),
              ),
            ),
            Divider(),

            // SEARCH
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

            // LIST
            Expanded(
              child: ListView.separated(
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  final item = _filteredList[index];

                  return CheckboxListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 24),
                    value: isSelected(item),
                    title: Text(item['label']),
                    onChanged: (checked) {
                      toggleItem(item, checked ?? false);
                    },
                  );
                },
                separatorBuilder: (_, __) => Divider(),
              ),
            ),

            // ACTION
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
        ),
      ),
    );
  }
}
