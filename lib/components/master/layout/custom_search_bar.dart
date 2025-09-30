import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/margin_search.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) handleSearchChange;
  final Function() showFilter;
  final isFiltered;

  const CustomSearchBar(
      {super.key,
      required this.handleSearchChange,
      required this.showFilter,
      this.isFiltered});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MarginSearch.screen,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _controller.clear();
                                widget.handleSearchChange('');
                                setState(() {});
                              },
                              icon: const Icon(Icons.close))
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      widget.handleSearchChange(value);
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: IconButton(
                    icon: Stack(
                      children: [
                        const Icon(
                          Icons.tune,
                        ),
                        if (widget.isFiltered)
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                              ))
                      ],
                    ),
                    onPressed: () {
                      widget.showFilter();
                    },
                  ),
                )
              ],
            )));
  }
}
