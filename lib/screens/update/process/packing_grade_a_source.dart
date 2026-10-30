import 'package:flutter/material.dart';
import 'package:textile_tracking/screens/update/process/sorting_grade_a_source.dart';

class PackingGradeASourceSection extends StatelessWidget {
  final List<Map<String, dynamic>> initialUsages;
  final dynamic itemId;
  final dynamic excludeWoId;
  final dynamic packingId;
  final ValueChanged<List<Map<String, dynamic>>>? onRowsChanged;
  final ValueChanged<bool>? onExceededChanged;
  final label;

  const PackingGradeASourceSection(
      {super.key,
      this.initialUsages = const [],
      this.itemId,
      this.excludeWoId,
      this.packingId,
      this.onRowsChanged,
      this.onExceededChanged,
      this.label});

  @override
  Widget build(BuildContext context) {
    return SortingGradeASourceSection(
      initialTransfers: initialUsages,
      itemId: itemId,
      excludeWoId: excludeWoId,
      packingId: packingId,
      isPacking: true,
      onRowsChanged: onRowsChanged,
      onSourceQtyInvalid: onExceededChanged,
      label: 'Packing',
    );
  }
}
