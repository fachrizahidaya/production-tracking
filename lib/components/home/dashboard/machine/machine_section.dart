import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/process_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_card.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class MachineSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final dynamic headerColor;
  final List<dynamic> data;
  final bool isPortrait;
  final dynamic status;
  final bool isMobile;

  const MachineSection({
    super.key,
    required this.title,
    required this.icon,
    this.headerColor,
    required this.data,
    required this.isPortrait,
    this.status,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProcessCard(
          forMachine: true,
          status: headerColor,
          child: Row(
            children: [
              Icon(
                icon,
                color: status,
                size: isMobile ? 20 : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$title (${data.length})',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : null,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 10 : 16),
        if (data.isEmpty)
          SizedBox(
            height: isMobile ? 120 : 200,
            child: NoData(),
          )
        else
          isMobile
              ? Column(
                  children: data.map<Widget>((machine) {
                    return MachineCard(
                      data: machine,
                      isPortrait: true,
                    );
                  }).toList(),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return MachineCard(
                        data: data[index],
                        isPortrait: isPortrait,
                      );
                    },
                  ),
                ),
      ],
    );
  }
}
