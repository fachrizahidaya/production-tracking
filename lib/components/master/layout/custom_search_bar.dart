import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) handleSearchChange;
  final Function() showFilter;
  final isFiltered;
  final withRefresh;
  final handleRefetch;

  const CustomSearchBar(
      {super.key,
      required this.handleSearchChange,
      required this.showFilter,
      this.isFiltered,
      this.withRefresh = false,
      this.handleRefetch});

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
    return Container(
        padding: MarginCard.screen,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Cari',
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
            Row(
              children: [
                if (!widget.withRefresh)
                  SizedBox()
                else
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: IconButton(
                      icon: Stack(
                        children: [
                          const Icon(
                            Icons.refresh_outlined,
                          ),
                        ],
                      ),
                      onPressed: () {
                        widget.handleRefetch();
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
                                    color: CustomTheme().buttonColor('danger'),
                                    shape: BoxShape.circle),
                              ))
                      ],
                    ),
                    onPressed: () {
                      widget.showFilter();
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
