import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:textile_tracking/components/master/theme.dart';

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
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
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
          margin: EdgeInsets.only(bottom: isTablet ? 14 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
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
    final label = widget.item['label']?.toString() ?? 'Catatan';
    final noteType = _getNoteType(label);
    final timestamp = widget.item['created_at'] ?? widget.item['timestamp'];

    return InkWell(
      onTap: showExpandButton ? _toggleExpanded : null,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 14),
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
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: noteType['color'].withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
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
            SizedBox(width: isTablet ? 14 : 12),

            // Label & Timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Catatan $label',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: noteType['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          noteType['label'],
                          style: TextStyle(
                            fontSize: isTablet ? 10 : 9,
                            fontWeight: FontWeight.w600,
                            color: noteType['color'],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.showTimestamp && timestamp != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: isTablet ? 14 : 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimestamp(timestamp),
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Expand Button
            if (showExpandButton)
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isExpanded
                        ? CustomTheme().buttonColor('primary').withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: isTablet ? 22 : 20,
                    color: _isExpanded
                        ? CustomTheme().buttonColor('primary')
                        : Colors.grey[600],
                  ),
                ),
              ),
          ],
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
        padding: EdgeInsets.all(isTablet ? 16 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 14 : 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quote Icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          CustomTheme().buttonColor('primary').withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.format_quote_outlined,
                      size: isTablet ? 18 : 16,
                      color: CustomTheme().buttonColor('primary'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text Content
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
                          const SizedBox(height: 12),
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
                                    fontSize: isTablet ? 13 : 12,
                                    fontWeight: FontWeight.w600,
                                    color: CustomTheme().buttonColor('primary'),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: isTablet ? 18 : 16,
                                  color: CustomTheme().buttonColor('primary'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons (optional)
            if (_isExpanded) ...[
              SizedBox(height: isTablet ? 14 : 12),
              _buildActionButtons(isTablet),
            ],
          ],
        ),
      ),
    );
  }

  /// Action Buttons
  Widget _buildActionButtons(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(
          icon: Icons.copy_outlined,
          label: 'Salin',
          onTap: () {
            // Copy to clipboard action
          },
          isTablet: isTablet,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.share_outlined,
          label: 'Bagikan',
          onTap: () {
            // Share action
          },
          isTablet: isTablet,
        ),
      ],
    );
  }

  /// Action Button Widget
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 12 : 10,
          vertical: isTablet ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isTablet ? 16 : 14,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 12 : 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
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

    if (lowerLabel.contains('penting') || lowerLabel.contains('important')) {
      return {
        'label': 'Penting',
        'icon': Icons.priority_high_outlined,
        'color': Colors.red,
      };
    }
    if (lowerLabel.contains('warning') || lowerLabel.contains('peringatan')) {
      return {
        'label': 'Peringatan',
        'icon': Icons.warning_outlined,
        'color': Colors.orange,
      };
    }
    if (lowerLabel.contains('info') || lowerLabel.contains('informasi')) {
      return {
        'label': 'Info',
        'icon': Icons.info_outlined,
        'color': Colors.blue,
      };
    }
    if (lowerLabel.contains('success') || lowerLabel.contains('sukses')) {
      return {
        'label': 'Sukses',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
      };
    }
    if (lowerLabel.contains('instruksi') ||
        lowerLabel.contains('instruction')) {
      return {
        'label': 'Instruksi',
        'icon': Icons.list_alt_outlined,
        'color': Colors.purple,
      };
    }
    if (lowerLabel.contains('qc') || lowerLabel.contains('quality')) {
      return {
        'label': 'QC',
        'icon': Icons.verified_outlined,
        'color': Colors.indigo,
      };
    }
    if (lowerLabel.contains('dyeing')) {
      return {
        'label': 'Dyeing',
        'icon': Icons.color_lens_outlined,
        'color': Colors.purple,
      };
    }
    if (lowerLabel.contains('finishing')) {
      return {
        'label': 'Finishing',
        'icon': Icons.auto_fix_high_outlined,
        'color': Colors.teal,
      };
    }
    if (lowerLabel.contains('packing')) {
      return {
        'label': 'Packing',
        'icon': Icons.inventory_2_outlined,
        'color': Colors.brown,
      };
    }

    return {
      'label': 'Catatan',
      'icon': Icons.note_outlined,
      'color': Colors.blueGrey,
    };
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    try {
      final dateTime = DateTime.parse(timestamp.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Baru saja';
          }
          return '${difference.inMinutes} menit yang lalu';
        }
        return '${difference.inHours} jam yang lalu';
      }
      if (difference.inDays == 1) {
        return 'Kemarin';
      }
      if (difference.inDays < 7) {
        return '${difference.inDays} hari yang lalu';
      }

      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return timestamp.toString();
    }
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

    if (lowerLabel.contains('penting') || lowerLabel.contains('important')) {
      return {
        'label': 'Penting',
        'icon': Icons.priority_high_outlined,
        'color': Colors.red,
      };
    }
    if (lowerLabel.contains('warning') || lowerLabel.contains('peringatan')) {
      return {
        'label': 'Peringatan',
        'icon': Icons.warning_outlined,
        'color': Colors.orange,
      };
    }
    if (lowerLabel.contains('info') || lowerLabel.contains('informasi')) {
      return {
        'label': 'Info',
        'icon': Icons.info_outlined,
        'color': Colors.blue,
      };
    }

    return {
      'label': 'Catatan',
      'icon': Icons.note_outlined,
      'color': Colors.blueGrey,
    };
  }
}

/// Note List Grid for Tablet
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
