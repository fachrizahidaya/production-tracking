import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';

class MachineSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final dynamic headerColor;
  final List<dynamic> data;
  final bool isPortrait;
  final dynamic status;
  final bool isMobile;
  final bool showStatus;
  final bool compact;

  const MachineSection({
    super.key,
    required this.title,
    required this.icon,
    this.headerColor,
    required this.data,
    required this.isPortrait,
    this.status,
    this.isMobile = false,
    this.showStatus = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final listHeight =
        compact ? (isMobile ? 52.0 : 68.0) : (isMobile ? 88.0 : 112.0);
    final cardWidth = isMobile ? 180.0 : 220.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              Icon(
                icon,
                color: status,
                size: isMobile ? 18 : 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$title (${data.length})',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        if (data.isEmpty)
          SizedBox(
            height: isMobile ? 72 : 88,
            child: const NoData(),
          )
        else
          SizedBox(
            height: listHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.length,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              itemBuilder: (context, index) {
                final isLast = index == data.length - 1;

                return SizedBox(
                  width: cardWidth,
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: MachineCard(
                        data: data[index],
                        isPortrait: isPortrait,
                        showStatus: showStatus,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
