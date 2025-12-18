import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class MachineCard extends StatelessWidget {
  final Map data;
  final bool isPortrait;

  const MachineCard({
    super.key,
    required this.data,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    Widget text(String value, double width) {
      return isPortrait
          ? SizedBox(
              width: width,
              child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
            )
          : Text(value, maxLines: 2, overflow: TextOverflow.ellipsis);
    }

    return CustomCard(
      withBorder: true,
      child: Padding(
        padding: PaddingColumn.screen,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBadge(
                  status: data['code'],
                  title: data['code'],
                  withDifferentColor: true,
                  color: const Color(0xffeaeaec),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    text(data['location'], 100),
                  ].separatedBy(const SizedBox(width: 4)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_laundry_service_outlined, size: 16),
                    text(data['name'], 150),
                  ].separatedBy(const SizedBox(width: 4)),
                ),
                CustomBadge(
                  status: data['process_type'],
                  title: data['process_type'],
                  withDifferentColor: true,
                  color: const Color(0xffd1fae4),
                ),
              ],
            ),
          ].separatedBy(const SizedBox(height: 8)),
        ),
      ),
    );
  }
}
