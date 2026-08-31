// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/machine/card_content.dart';
import 'package:textile_tracking/components/home/dashboard/machine/card_header.dart';
import 'package:textile_tracking/components/master/theme.dart';

class MachineCard extends StatelessWidget {
  final dynamic data;
  final bool isPortrait;
  final VoidCallback? onTap;
  final bool isSelected;

  const MachineCard({
    super.key,
    required this.data,
    this.isPortrait = true,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        // Pastikan selalu bool
        final selected = isSelected == true;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(
              bottom: isTablet ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? CustomTheme().buttonColor('primary')
                    : Colors.grey[200]!,
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? CustomTheme().buttonColor('primary').withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: selected ? 12 : 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MachineCardHeader(
                    data: data,
                    isTablet: isTablet,
                  ),
                  MachineCardContent(
                    data: data,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
