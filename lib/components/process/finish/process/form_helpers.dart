import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';

class FormHelpers {
  static Widget buildEmptyState(isUpdate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(isUpdate
              ? 'Silakan keluar dan masuk kembali'
              : 'Silakan Edit dan Simpan terlebih dahulu'),
        ],
      ),
    );
  }

  static Widget buildMachine({
    required BuildContext context,
    required List machines,
  }) {
    if (machines.isEmpty) return NoData();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: machines.map((machine) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          width: machines.length > 1
              ? (MediaQuery.of(context).size.width - 80) / 2
              : double.infinity,
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                machine['machine'] != null
                    ? '${machine['machine']['code']} - ${machine['machine']['name']}'
                    : '-',
              ),
              CustomBadge(
                title: machine['status'] ?? '-',
                status: machine['status'] == 'Selesai' ? 'Selesai' : 'Diproses',
                withStatus: true,
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  static Widget buildSortingQty({
    required Map<String, dynamic> processData,
  }) {
    final gradesList = processData['sorting']?['grades'] ?? [];

    double parse(String v) {
      return double.tryParse(
            v.replaceAll('.', '').replaceAll(',', '.'),
          ) ??
          0;
    }

    final data = processData['sorting'];

    final total = parse(data?['rework_long_hemming'] ?? '0') +
        parse(data?['spraying'] ?? '0') +
        parse(data?['combing'] ?? '0');

    double totalQty = 0;
    for (var g in gradesList) {
      totalQty += parse(g['qty'] ?? '0');
    }

    final grandTotal = totalQty + total;

    return Text('Total: $grandTotal'); // simplify dulu
  }
}
