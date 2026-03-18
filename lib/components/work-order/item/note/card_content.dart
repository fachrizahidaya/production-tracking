import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatelessWidget {
  final isTablet;
  final plainText;
  final isLongContent;
  final isExpandable;
  final isExpanded;
  final toggleExpanded;
  const CardContent(
      {super.key,
      this.isTablet,
      this.plainText,
      this.isLongContent,
      this.isExpandable,
      this.isExpanded,
      this.toggleExpanded});

  @override
  Widget build(BuildContext context) {
    final shouldTruncate = isLongContent && isExpandable && !isExpanded;

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: CustomTheme().padding('card'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content Container
            Container(
              width: double.infinity,
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quote Icon
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shouldTruncate
                              ? '${plainText.substring(0, 150)}...'
                              : plainText,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            color: Colors.grey[800],
                            height: 1.6,
                          ),
                        ),
                        // Show More / Less Button
                        if (isLongContent && isExpandable) ...[
                          GestureDetector(
                            onTap: toggleExpanded,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isExpanded
                                      ? 'Tampilkan Lebih Sedikit'
                                      : 'Selengkapnya',
                                  style: TextStyle(
                                    fontSize: CustomTheme().fontSize('sm'),
                                    fontWeight:
                                        CustomTheme().fontWeight('semibold'),
                                    color: CustomTheme().buttonColor('primary'),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: isTablet ? 18 : 16,
                                  color: CustomTheme().buttonColor('primary'),
                                ),
                              ].separatedBy(CustomTheme().hGap('sm')),
                            ),
                          ),
                        ],
                      ].separatedBy(CustomTheme().vGap('md')),
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
