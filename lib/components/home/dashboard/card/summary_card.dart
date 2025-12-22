import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class SummaryCard extends StatefulWidget {
  final data;
  final completed;
  final inProgress;
  final waiting;
  final sumary;
  final name;
  final icon;

  const SummaryCard(
      {super.key,
      this.data,
      this.sumary,
      this.completed,
      this.inProgress,
      this.waiting,
      this.name,
      this.icon});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final List<Map<String, dynamic>> mixed = [
      ...List<Map<String, dynamic>>.from(widget.data['completed'] ?? [])
          .map((e) => {
                'value': e['wo_no'],
                'status': 'Selesai',
              }),
      ...List<Map<String, dynamic>>.from(widget.data['in_progress'] ?? [])
          .map((e) => {
                'value': e['wo_no'],
                'status': 'Diproses',
              }),
      ...List<Map<String, dynamic>>.from(widget.data['waiting'] ?? [])
          .map((e) => {
                'value': e['wo_no'],
                'status': 'Menunggu Diproses',
              }),
    ];

    int maxItems = 9;

    final bool hasExtra = mixed.length > maxItems;

    final int visibleCount = hasExtra ? maxItems - 1 : mixed.length;

    final int extraCount = hasExtra ? mixed.length - visibleCount : 0;

    final List<Map<String, dynamic>> visibleItems =
        mixed.take(visibleCount).toList();

    Color getSummaryColor(Map<String, dynamic> summary) {
      final int completed = summary['completed'] ?? 0;
      final int inProgress = summary['in_progress'] ?? 0;
      final int waiting = summary['waiting'] ?? 0;

      if (inProgress > 0) {
        return CustomTheme().statusColor('Diproses');
      }

      if (waiting > 0) {
        return CustomTheme().statusColor('Menunggu Diproses');
      }

      if (completed > 0) {
        return CustomTheme().statusColor('Selesai');
      }

      return CustomTheme().statusColor('Selesai');
    }

    final color = getSummaryColor(widget.data['summary']);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomCard(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  padding: CustomTheme().padding('card'),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.data['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(widget.icon)
                    ].separatedBy(CustomTheme().vGap('lg')),
                  ),
                ),
                if (!isPortrait)
                  Container(
                    padding: CustomTheme().padding('card'),
                    decoration: BoxDecoration(
                      color: Color(0xFFf9fafc),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(widget.data['summary']['completed'] == 0
                                ? '-'
                                : widget.data['summary']['completed']
                                    .toString()),
                            CustomBadge(
                              title: 'Selesai',
                              withStatus: true,
                              status: 'Selesai',
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                        Column(
                          children: [
                            Text(widget.data['summary']['in_progress'] == 0
                                ? '-'
                                : widget.data['summary']['in_progress']
                                    .toString()),
                            CustomBadge(
                              title: 'Diproses',
                              withStatus: true,
                              status: 'Diproses',
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                        Column(
                          children: [
                            Text(widget.data['summary']['waiting'] == 0
                                ? '-'
                                : widget.data['summary']['waiting'].toString()),
                            CustomBadge(
                              title: 'Menunggu Diproses',
                              withStatus: true,
                              status: 'Menunggu Diproses',
                            ),
                          ].separatedBy(CustomTheme().vGap('lg')),
                        ),
                      ].separatedBy(CustomTheme().hGap('2xl')),
                    ),
                  ),
                if (isPortrait)
                  Expanded(
                    child: Container(
                      padding: CustomTheme().padding('card'),
                      decoration: BoxDecoration(
                        color: Color(0xFFf9fafc),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(widget.data['summary']['completed'] == 0
                                  ? '-'
                                  : widget.data['summary']['completed']
                                      .toString()),
                              CustomBadge(
                                title: 'Selesai',
                                withStatus: true,
                                status: 'Selesai',
                              ),
                            ].separatedBy(CustomTheme().vGap('lg')),
                          ),
                          Column(
                            children: [
                              Text(widget.data['summary']['in_progress'] == 0
                                  ? '-'
                                  : widget.data['summary']['in_progress']
                                      .toString()),
                              CustomBadge(
                                title: 'Diproses',
                                withStatus: true,
                                status: 'Diproses',
                              ),
                            ].separatedBy(CustomTheme().vGap('lg')),
                          ),
                          Column(
                            children: [
                              Text(widget.data['summary']['waiting'] == 0
                                  ? '-'
                                  : widget.data['summary']['waiting']
                                      .toString()),
                              CustomBadge(
                                title: 'Menunggu Diproses',
                                withStatus: true,
                                status: 'Menunggu Diproses',
                              ),
                            ].separatedBy(CustomTheme().vGap('lg')),
                          ),
                        ].separatedBy(CustomTheme().hGap('2xl')),
                      ),
                    ),
                  ),
                if (!isPortrait)
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        ...visibleItems.map((e) {
                          return Container(
                            decoration: CustomTheme().badgeTheme(e['status']),
                            padding: CustomTheme().padding('badge-rework'),
                            child: Text(
                              e['value'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }),
                        if (extraCount > 0)
                          Container(
                            decoration: CustomTheme().badgeTheme('more'),
                            padding: CustomTheme().padding('badge-rework'),
                            child: Text(
                              '+$extraCount',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
              ].separatedBy(CustomTheme().hGap('2xl')),
            ),
            if (isPortrait)
              SizedBox(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    ...visibleItems.map((e) {
                      return Container(
                        decoration: CustomTheme().badgeTheme(e['status']),
                        padding: CustomTheme().padding('badge-rework'),
                        child: Text(
                          e['value'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }),
                    if (extraCount > 0)
                      Container(
                        decoration: CustomTheme().moreDataBadgeTheme('more'),
                        padding: CustomTheme().padding('badge-rework'),
                        child: Text(
                          '+$extraCount',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              )
          ].separatedBy(CustomTheme().vGap('xl')),
        ),
      ),
    );
  }
}
