// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class CardContent extends StatefulWidget {
  final data;
  final isTablet;
  final processKey;

  const CardContent({super.key, this.data, this.isTablet, this.processKey});

  @override
  State<CardContent> createState() => _CardContentState();
}

class _CardContentState extends State<CardContent> {
  @override
  Widget build(BuildContext context) {
    final data = Map<String, dynamic>.from(widget.data);
    final processNumber = data['${widget.processKey}_no'];
    final machines = data['machines'] as List? ?? [];
    final brokenYarns = data['broken_yarns'] as List? ?? [];

    return Container(
      padding: CustomTheme().padding('content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (processNumber != null)
            _buildProcessNumber(processNumber.toString()),
          if (data['start_time'] != null || data['end_time'] != null)
            _buildTimeSection(data),
          if (_buildProcessDetails(data).isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildProcessDetails(data),
            ),
          if (machines.isNotEmpty) _buildMachines(machines),
          if (brokenYarns.isNotEmpty) _buildBrokenYarns(brokenYarns),
          if (data['notes'] != null &&
              data['notes'].toString().trim().isNotEmpty)
            _buildNotes(data['notes'].toString()),
        ].separatedBy(CustomTheme().vGap('xl')),
      ),
    );
  }

  Widget _buildProcessNumber(String value) {
    return _buildPanel(
      color: Colors.grey,
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: widget.isTablet ? 16 : 14,
            color: Colors.grey[700],
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                fontWeight: CustomTheme().fontWeight('bold'),
                color: Colors.grey[800],
              ),
            ),
          ),
        ].separatedBy(CustomTheme().hGap('md')),
      ),
    );
  }

  Widget _buildTimeSection(Map<String, dynamic> data) {
    return _buildPanel(
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['start_time'] != null)
            _buildDetailRow(
              Icons.access_time_outlined,
              'Waktu Mulai',
              _formatTime(data['start_time']),
              Colors.green,
            ),
          if (data['end_time'] != null)
            _buildDetailRow(
              Icons.task_alt_outlined,
              'Waktu Selesai',
              _formatTime(data['end_time']),
              Colors.red,
            ),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
    );
  }

  List<Widget> _buildProcessDetails(Map<String, dynamic> data) {
    final details = <Map<String, dynamic>>[];

    void addDetail(String key, String label, IconData icon, String unit) {
      if (data[key] != null) {
        details.add({
          'label': label,
          'value': formatNumber(data[key]),
          'unit': unit,
          'icon': icon,
        });
      }
    }

    switch (widget.processKey) {
      case 'warping':
        addDetail('length', 'Panjang', Icons.straighten_outlined, 'M');
        addDetail('section', 'Jumlah Section', Icons.view_column_outlined, '');
        addDetail('weight', 'Berat', Icons.scale_outlined, 'KG');
        addDetail(
          'broken_yarn_total',
          'Total Benang Putus',
          Icons.warning_amber_outlined,
          '',
        );
        break;
      case 'sizing':
        addDetail('length', 'Panjang', Icons.straighten_outlined, 'M');
        addDetail('weight', 'Berat', Icons.scale_outlined, 'KG');
        addDetail('waste', 'Waste', Icons.delete_outline, 'KG');
        break;
      case 'weaving':
        addDetail('qty', 'Qty', Icons.inventory_2_outlined, 'PCS');
        addDetail('weight', 'Berat', Icons.scale_outlined, 'KG');
        addDetail('waste', 'Waste', Icons.delete_outline, 'KG');
        break;
      case 'shearing':
        addDetail('qty', 'Qty', Icons.inventory_2_outlined, 'PCS');
        addDetail('weight', 'Berat', Icons.scale_outlined, 'KG');
        addDetail('waste', 'Waste', Icons.delete_outline, 'KG');
        break;
    }

    if (data['skip_shearing'] != null) {
      details.add({
        'label': 'Shearing',
        'value': data['skip_shearing'] == true ? 'Dilewati' : 'Diperlukan',
        'unit': '',
        'icon': Icons.content_cut_outlined,
      });
    }

    return details
        .map(
          (detail) => Container(
            constraints: const BoxConstraints(minWidth: 130),
            padding: CustomTheme().padding('process-content'),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.indigo.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  detail['icon'],
                  size: widget.isTablet ? 18 : 16,
                  color: Colors.indigo,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail['label'],
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('xs'),
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${detail['value']}${detail['unit'].isEmpty ? '' : ' ${detail['unit']}'}',
                      style: TextStyle(
                        fontSize: CustomTheme().fontSize('md'),
                        fontWeight: CustomTheme().fontWeight('bold'),
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ].separatedBy(CustomTheme().hGap('md')),
            ),
          ),
        )
        .toList();
  }

  Widget _buildMachines(List machines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Icons.precision_manufacturing_outlined, 'Mesin'),
        ...machines
            .map((machine) {
              final code = machine['code']?.toString() ?? '-';
              final name = machine['name']?.toString() ?? '-';
              final location = machine['location']?.toString();

              return _buildPanel(
                color: Colors.teal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.precision_manufacturing_outlined,
                      color: Colors.teal,
                      size: 18,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$code - $name',
                            style: TextStyle(
                              fontWeight: CustomTheme().fontWeight('bold'),
                            ),
                          ),
                          if (location != null)
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: CustomTheme().fontSize('sm'),
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ].separatedBy(CustomTheme().hGap('md')),
                ),
              );
            })
            .toList()
            .separatedBy(CustomTheme().vGap('md')),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildBrokenYarns(List brokenYarns) {
    final sortedItems = List.from(brokenYarns)
      ..sort(
        (a, b) => (a['sort_order'] as num? ?? 0)
            .compareTo(b['sort_order'] as num? ?? 0),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Icons.warning_amber_outlined, 'Benang Putus'),
        ...sortedItems.map(
          (item) => _buildDetailRow(
            Icons.remove_circle_outline,
            item['label']?.toString() ?? '-',
            formatNumber(item['qty']),
            Colors.orange,
          ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildNotes(String notes) {
    return _buildPanel(
      color: Colors.amber,
      child: _buildDetailRow(
        Icons.notes_outlined,
        'Catatan',
        notes,
        Colors.amber[800]!,
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          size: widget.isTablet ? 18 : 16,
          color: CustomTheme().colors('primary'),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: CustomTheme().fontSize('md'),
            fontWeight: CustomTheme().fontWeight('semibold'),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ].separatedBy(CustomTheme().hGap('lg')),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: widget.isTablet ? 18 : 16, color: color),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('xs'),
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ].separatedBy(CustomTheme().hGap('md')),
    );
  }

  Widget _buildPanel({required Color color, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: CustomTheme().padding('process-content'),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: child,
    );
  }

  String _formatTime(dynamic time) {
    try {
      final dateTime = DateTime.parse(time.toString());
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return '$day ${months[dateTime.month - 1]} ${dateTime.year}, $hour.$minute';
    } catch (_) {
      return time.toString();
    }
  }
}
