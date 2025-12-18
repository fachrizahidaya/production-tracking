import 'package:flutter/material.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ProcessFilterChips extends StatelessWidget {
  final List<String> processFilters;
  final String selectedProcess;
  final ValueChanged<String> onSelect;

  const ProcessFilterChips({
    super.key,
    required this.processFilters,
    required this.selectedProcess,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: processFilters
            .map((type) {
              final isSelected = selectedProcess == type;

              return GestureDetector(
                onTap: () => onSelect(type),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.grey.shade400,
                    ),
                  ),
                  elevation: isSelected ? 3 : 1,
                  color: isSelected ? Colors.blue.shade50 : Colors.white,
                  child: Padding(
                    padding: PaddingColumn.screen,
                    child: Text(type),
                  ),
                ),
              );
            })
            .toList()
            .separatedBy(const SizedBox(width: 8)),
      ),
    );
  }
}
