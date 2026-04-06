import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/cancel_button.dart';
import 'package:textile_tracking/components/master/button/form_button.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<dynamic> items;
  final List<dynamic> initialSelectedIds;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initialSelectedIds,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<dynamic> _dataList;
  late List<dynamic> _selectedIds;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataList = widget.items;
    _selectedIds = [...widget.initialSelectedIds];
  }

  void _search(String value) {
    setState(() {
      _dataList = widget.items
          .where((e) =>
              e['label'].toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _toggle(dynamic id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds = List.from(_selectedIds)..remove(id);
      } else {
        _selectedIds = List.from(_selectedIds)..add(id);
      }
    });
  }

  void _submit() {
    Navigator.pop(context, _selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            /// HEADER
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
                            _search('');
                            setState(() {});
                          },
                          icon: Icon(Icons.close))
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
                onChanged: _search,
              ),
            ),

            /// SEARCH
            Divider(),

            /// LIST
            Expanded(
              child: _dataList.isEmpty
                  ? Center(child: NoData())
                  : ListView.separated(
                      itemCount: _dataList.length,
                      separatorBuilder: (_, __) => Divider(),
                      itemBuilder: (context, index) {
                        final item = _dataList[index];
                        final id = item['value'];
                        final isSelected = _selectedIds.contains(id);

                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(item['label']),
                          activeColor: Colors.green,
                          onChanged: (_) => _toggle(id),
                        );
                      },
                    ),
            ),

            /// ACTION
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
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                      fontSize: CustomTheme().fontSize('xl'),
                    ),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: SizedBox(
                    height: 56,
                    child: FormButton(
                      label: 'Terapkan',
                      onPressed: () {
                        _submit();
                      },
                      fontSize: CustomTheme().fontSize('xl'),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
