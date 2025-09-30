import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ViewText<T> extends StatelessWidget {
  final String viewLabel;
  final String viewValue;
  final T? item;
  final void Function(BuildContext context, T item)? onItemTap;

  const ViewText({
    super.key,
    required this.viewLabel,
    required this.viewValue,
    this.item,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isClickable = onItemTap != null && item != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          viewLabel,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
          ),
        ),
        CustomTheme().vGap('xs'),
        GestureDetector(
          onTap: isClickable ? () => onItemTap!(context, item as T) : null,
          child: Text(
            viewValue,
            style: TextStyle(
              fontSize: CustomTheme().fontSize('lg'),
              fontWeight: CustomTheme().fontWeight('semibold'),
              color: isClickable ? Colors.blue : Colors.black,
              decoration: isClickable ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}
