// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class TemplateCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const TemplateCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Container(
            padding: CustomTheme().padding('card'),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: CustomTheme().padding('process-content'),
                  decoration: BoxDecoration(
                    color:
                        CustomTheme().buttonColor('primary').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: CustomTheme().buttonColor('primary'),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: CustomTheme().fontSize('md'),
                    fontWeight: CustomTheme().fontWeight('semibold'),
                    color: Colors.grey[800],
                  ),
                ),
              ].separatedBy(CustomTheme().hGap('xl')),
            ),
          ),

          /// Content
          Padding(
            padding: CustomTheme().padding('item-detail'),
            child: child,
          ),
        ],
      ),
    );
  }
}
