import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) handleSearchChange;
  final Function() showFilter;
  final isFiltered;
  final withRefresh;
  final handleRefetch;

  const CustomSearchBar({
    super.key,
    required this.handleSearchChange,
    required this.showFilter,
    this.isFiltered,
    this.withRefresh = false,
    this.handleRefetch,
  });

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

  Widget _buildIconButton({
    required Widget icon,
    required VoidCallback? onPressed,
    required bool isMobile,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: isMobile ? 20 : 24,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Row(
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
                      icon: const Icon(Icons.close),
                    )
                  : null,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              widget.handleSearchChange(value);
              setState(() {});
            },
          ),
        ),
        _buildIconButton(
          isMobile: isMobile,
          onPressed: widget.showFilter,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.tune_outlined),
              if (widget.isFiltered == true)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: CustomTheme().buttonColor('danger'),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.withRefresh)
          _buildIconButton(
            isMobile: isMobile,
            onPressed: widget.handleRefetch,
            icon: const Icon(Icons.refresh_outlined),
          ),
      ],
    );
  }
}
