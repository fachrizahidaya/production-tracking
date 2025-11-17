import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ViewText<T> extends StatelessWidget {
  final String viewLabel;
  final viewValue;
  final childValue;
  final T? item;
  final void Function(BuildContext context, T item)? onItemTap;

  const ViewText({
    super.key,
    required this.viewLabel,
    this.viewValue,
    this.item,
    this.onItemTap,
    this.childValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isClickable = onItemTap != null && item != null;
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

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
            child: childValue ??
                Container(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  child: Text(
                    viewValue ?? '',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                      fontWeight: CustomTheme().fontWeight('semibold'),
                      color: isClickable
                          ? CustomTheme().colors('primary')
                          : CustomTheme().colors('text-primary'),
                      decoration: isClickable ? TextDecoration.underline : null,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: null,
                  ),
                )),
      ],
    );
  }
}
