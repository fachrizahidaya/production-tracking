import 'package:flutter/material.dart';
import 'package:production_tracking/helpers/util/padding_column.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) handleSearchChange;
  const CustomSearchBar({super.key, required this.handleSearchChange});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingColumn.screen,
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white),
        onChanged: widget.handleSearchChange,
      ),
    );
  }
}
