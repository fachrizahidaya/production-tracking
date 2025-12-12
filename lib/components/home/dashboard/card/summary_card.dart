import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/summary_status_card.dart';

class SummaryCard extends StatefulWidget {
  final data;
  final completed;
  final inProgress;
  final waiting;
  final sumary;

  const SummaryCard(
      {super.key,
      this.data,
      this.sumary,
      this.completed,
      this.inProgress,
      this.waiting});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryStatusCard(
          summary: widget.sumary,
        )
      ],
    );
  }
}
