// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class NoteItem extends StatefulWidget {
  final dynamic item;
  final bool isExpandable;
  final bool showTimestamp;

  const NoteItem({
    super.key,
    this.item,
    this.isExpandable = true,
    this.showTimestamp = true,
  });

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final content = widget.item['content'];
        final hasContent = content != null && content.toString().isNotEmpty;
        final plainText = _htmlToPlainText(content);
        final isLongContent = plainText.length > 150;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isExpanded
                  ? CustomTheme().buttonColor('primary').withOpacity(0.3)
                  : Colors.grey[200]!,
              width: _isExpanded ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isExpanded
                    ? CustomTheme().buttonColor('primary').withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isExpanded ? 12 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(isTablet, isLongContent && widget.isExpandable),

                // Content Section
                if (hasContent)
                  _buildContent(content, plainText, isTablet, isLongContent),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Header Section
  Widget _buildHeader(bool isTablet, bool showExpandButton) {
    final label = widget.item['label']?.toString() ?? '-';
    final noteType = _getNoteType(label);

    return InkWell(
      onTap: showExpandButton ? _toggleExpanded : null,
      child: Container(
        padding: CustomTheme().padding('card'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              noteType['color'].withOpacity(0.12),
              noteType['color'].withOpacity(0.04),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: noteType['color'].withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: CustomTheme().padding('process-content'),
              decoration: BoxDecoration(
                color: noteType['color'].withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: noteType['color'].withOpacity(0.3),
                ),
              ),
              child: Icon(
                noteType['icon'],
                size: isTablet ? 24 : 20,
                color: noteType['color'],
              ),
            ),

            // Label & Timestamp
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Catatan $label',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('lg'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Type Badge
                ].separatedBy(CustomTheme().hGap('md')),
              ),
            ),

            // Expand Button
          ].separatedBy(CustomTheme().hGap('md')),
        ),
      ),
    );
  }

  /// Content Section
  Widget _buildContent(
    dynamic content,
    String plainText,
    bool isTablet,
    bool isLongContent,
  ) {
    final shouldTruncate = isLongContent && widget.isExpandable && !_isExpanded;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
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
                        if (isLongContent && widget.isExpandable) ...[
                          GestureDetector(
                            onTap: _toggleExpanded,
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

  /// Helper Methods
  String _htmlToPlainText(dynamic htmlString) {
    if (htmlString == null) return '';

    if (htmlString is List) {
      return htmlString.join(" ");
    }

    if (htmlString is! String) {
      return htmlString.toString();
    }

    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  Map<String, dynamic> _getNoteType(String label) {
    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('dyeing')) {
      return {
        'label': 'Dyeing',
        'icon': Icons.invert_colors_on_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('press')) {
      return {
        'label': 'Press',
        'icon': Icons.layers_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('tumbler')) {
      return {
        'label': 'Tumbler',
        'icon': Icons.dry_cleaning_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('stenter')) {
      return {
        'label': 'Stenter',
        'icon': Icons.air_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('long sitting')) {
      return {
        'label': 'Long Slitting',
        'icon': Icons.content_paste_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('long hemming')) {
      return {
        'label': 'Long Hemming',
        'icon': Icons.cut_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('cross cutting')) {
      return {
        'label': 'Cross Cutting',
        'icon': Icons.cut_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('sewing')) {
      return {
        'label': ' Sewing',
        'icon': Icons.link_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('embroidery')) {
      return {
        'label': 'Embroidery',
        'icon': Icons.color_lens_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('printing')) {
      return {
        'label': 'Printing',
        'icon': Icons.print_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('sorting')) {
      return {
        'label': 'Sorting',
        'icon': Icons.sort_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('packing')) {
      return {
        'label': 'Packing',
        'icon': Icons.inventory_2_outlined,
        'color': Colors.blueGrey,
      };
    }

    return {
      'label': '',
      'icon': Icons.note_outlined,
      'color': Colors.blueGrey,
    };
  }
}

/// Compact Note Item untuk List View
class CompactNoteItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback? onTap;

  const CompactNoteItem({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;
        final label = item['label']?.toString() ?? 'Catatan';
        final noteType = _getNoteType(label);
        final content = item['content'];
        final plainText = _htmlToPlainText(content);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 10 : 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left Color Indicator
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: noteType['color'],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 14 : 12),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: noteType['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              noteType['icon'],
                              size: isTablet ? 22 : 20,
                              color: noteType['color'],
                            ),
                          ),
                          SizedBox(width: isTablet ? 14 : 12),

                          // Text Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Catatan $label',
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            noteType['color'].withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        noteType['label'],
                                        style: TextStyle(
                                          fontSize: isTablet ? 9 : 8,
                                          fontWeight: FontWeight.w600,
                                          color: noteType['color'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plainText,
                                  style: TextStyle(
                                    fontSize: isTablet ? 12 : 11,
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Arrow
                          Icon(
                            Icons.chevron_right,
                            size: isTablet ? 22 : 20,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _htmlToPlainText(dynamic htmlString) {
    if (htmlString == null) return '';

    if (htmlString is List) {
      return htmlString.join(" ");
    }

    if (htmlString is! String) {
      return htmlString.toString();
    }

    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  Map<String, dynamic> _getNoteType(String label) {
    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('dyeing')) {
      return {
        'label': 'Dyeing',
        'icon': Icons.invert_colors_on_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('press')) {
      return {
        'label': 'Press',
        'icon': Icons.layers_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('tumbler')) {
      return {
        'label': 'Tumbler',
        'icon': Icons.dry_cleaning_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('stenter')) {
      return {
        'label': 'Stenter',
        'icon': Icons.air_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('long sitting')) {
      return {
        'label': 'Long Slitting',
        'icon': Icons.content_paste_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('long hemming')) {
      return {
        'label': 'Long Hemming',
        'icon': Icons.cut_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('cross cutting')) {
      return {
        'label': 'Cross Cutting',
        'icon': Icons.cut_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('sewing')) {
      return {
        'label': ' Sewing',
        'icon': Icons.link_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('embroidery')) {
      return {
        'label': 'Embroidery',
        'icon': Icons.color_lens_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('printing')) {
      return {
        'label': 'Printing',
        'icon': Icons.print_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('sorting')) {
      return {
        'label': 'Sorting',
        'icon': Icons.sort_outlined,
        'color': Colors.blueGrey,
      };
    }
    if (lowerLabel.contains('packing')) {
      return {
        'label': 'Packing',
        'icon': Icons.inventory_2_outlined,
        'color': Colors.blueGrey,
      };
    }

    return {
      'label': '',
      'icon': Icons.note_outlined,
      'color': Colors.blueGrey,
    };
  }
}

class NoteListGrid extends StatelessWidget {
  final List<dynamic> notes;
  final Function(dynamic)? onNoteTap;

  const NoteListGrid({
    super.key,
    required this.notes,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final crossAxisCount = isTablet ? 2 : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 4 : 0,
                vertical: isTablet ? 12 : 8,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          CustomTheme().buttonColor('primary').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notes_outlined,
                      size: isTablet ? 22 : 20,
                      color: CustomTheme().buttonColor('primary'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Catatan',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          CustomTheme().buttonColor('primary').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${notes.length} catatan',
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 12,
                        fontWeight: FontWeight.w600,
                        color: CustomTheme().buttonColor('primary'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),

            // Notes Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: isTablet ? 14 : 0,
                mainAxisSpacing: 0,
                childAspectRatio: isTablet ? 2.2 : 2.8,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return CompactNoteItem(
                  item: notes[index],
                  onTap: () => onNoteTap?.call(notes[index]),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
