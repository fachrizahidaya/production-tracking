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
        final isTablet = constraints.maxWidth > 400;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? CustomTheme().buttonColor('primary')
                    : Colors.grey[200]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? CustomTheme().buttonColor('primary').withOpacity(0.15)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isSelected ? 12 : 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  CardHeader(
                    data: data,
                    isTablet: isTablet,
                  ),

                  // Content Section
                  CardContent(
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

/// Grid Layout untuk Machine Cards
class MachineCardGrid extends StatelessWidget {
  final List<dynamic> machines;
  final Function(dynamic)? onItemTap;
  final int? selectedIndex;

  const MachineCardGrid({
    super.key,
    required this.machines,
    this.onItemTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final crossAxisCount = isTablet ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isTablet ? 16 : 12,
            mainAxisSpacing: isTablet ? 16 : 12,
            childAspectRatio: isTablet ? 1.1 : 0.95,
          ),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            return MachineCard(
              data: machines[index],
              isSelected: selectedIndex == index,
              onTap: () => onItemTap?.call(machines[index]),
            );
          },
        );
      },
    );
  }
}

/// Compact Machine Card untuk List View
class CompactMachineCard extends StatelessWidget {
  final dynamic data;
  final VoidCallback? onTap;

  const CompactMachineCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 400;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 10 : 8),
            padding: EdgeInsets.all(isTablet ? 14 : 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Status Indicator
                Container(
                  width: 4,
                  height: isTablet ? 50 : 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: isTablet ? 14 : 12),

                // Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.precision_manufacturing_outlined,
                    size: isTablet ? 24 : 20,
                  ),
                ),
                SizedBox(width: isTablet ? 14 : 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['name']?.toString() ?? 'Mesin',
                        style: TextStyle(
                          fontSize: isTablet ? 15 : 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              data['code']?.toString() ?? '-',
                              style: TextStyle(
                                fontSize: isTablet ? 11 : 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          if (data['location'] != null) ...[
                            SizedBox(width: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: isTablet ? 14 : 12,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: 2),
                            Text(
                              data['location'].toString(),
                              style: TextStyle(
                                fontSize: isTablet ? 11 : 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 10 : 8,
                    vertical: isTablet ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                SizedBox(width: isTablet ? 10 : 8),
                Icon(
                  Icons.chevron_right,
                  size: isTablet ? 24 : 20,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
