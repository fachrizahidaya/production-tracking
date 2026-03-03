import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardHeader extends StatelessWidget {
  final item;
  final showExpandButton;
  final toggleExpanded;
  final isTablet;
  const CardHeader(
      {super.key,
      this.item,
      this.showExpandButton,
      this.toggleExpanded,
      this.isTablet});

  @override
  Widget build(BuildContext context) {
    final label = item['label']?.toString() ?? '-';
    final noteType = _getNoteType(label);

    return InkWell(
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
    if (lowerLabel.contains('long slitting')) {
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
