import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_html.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SpkCardContent extends StatefulWidget {
  final String notes;

  const SpkCardContent({
    super.key,
    required this.notes,
  });

  @override
  State<SpkCardContent> createState() => _SpkCardContentState();
}

class _SpkCardContentState extends State<SpkCardContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final plainText = htmlToPlainText(widget.notes);

    final isLongContent = plainText.length > 150;

    final shouldTruncate = isLongContent && !_isExpanded;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: CustomTheme().padding('card'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(
                  Icons.sticky_note_2_outlined,
                  size: 18,
                  color: CustomTheme().buttonColor('primary'),
                ),
                Text(
                  'Catatan',
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('lg'),
                    fontWeight: CustomTheme().fontWeight('bold'),
                  ),
                ),
              ].separatedBy(
                CustomTheme().hGap('sm'),
              ),
            ),

            CustomTheme().vGap('md'),

            /// Content Container
            Container(
              width: double.infinity,
              padding: CustomTheme().padding('card'),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shouldTruncate
                            ? Text(
                                '${plainText.substring(0, 150)}...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                  height: 1.6,
                                ),
                              )
                            : formattedHtmlContent(
                                widget.notes,
                                textStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                  height: 1.6,
                                ),
                              ),
                        if (isLongContent) ...[
                          CustomTheme().vGap('md'),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isExpanded
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
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: CustomTheme().buttonColor('primary'),
                                ),
                              ].separatedBy(
                                CustomTheme().hGap('sm'),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
