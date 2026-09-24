import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/screens/report/rework/rework_by_id.dart';

class ReworkList extends StatefulWidget {
  const ReworkList({super.key});

  @override
  State<ReworkList> createState() => _ReworkListState();
}

class _ReworkListState extends State<ReworkList> {
  final List<Map<String, dynamic>> _items = [
    {
      'reworkNo': 'RW-2026-0001',
      'woNo': 'WO-2026-0142',
      'status': 'Diproses',
      'dyeingProcessNo': 'DYE-2026-0089',
      'startedAt': '24 Sep 2026, 08:30',
      'qty': '125,5 KG',
      'semiFinishedProduct': 'Kain Grey Cotton 30s',
      'category': 'Warna tidak sesuai',
    },
    {
      'reworkNo': 'RW-2026-0002',
      'woNo': 'WO-2026-0138',
      'status': 'Selesai',
      'dyeingProcessNo': 'DYE-2026-0084',
      'startedAt': '23 Sep 2026, 10:15',
      'qty': '98 KG',
      'semiFinishedProduct': 'Kain Polyester PE 40s',
      'category': 'Belang',
    },
    {
      'reworkNo': 'RW-2026-0003',
      'woNo': 'WO-2026-0135',
      'status': 'Diproses',
      'dyeingProcessNo': 'DYE-2026-0081',
      'startedAt': '22 Sep 2026, 13:45',
      'qty': '150 KG',
      'semiFinishedProduct': 'Kain CVC 24s',
      'category': 'Ketuaan warna',
    },
    {
      'reworkNo': 'RW-2026-0004',
      'woNo': 'WO-2026-0129',
      'status': 'Selesai',
      'dyeingProcessNo': 'DYE-2026-0076',
      'startedAt': '20 Sep 2026, 09:00',
      'qty': '87,5 KG',
      'semiFinishedProduct': 'Kain Rayon 30s',
      'category': 'Kelunturan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rework',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFf9fafc),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _items.length - 1 ? 0 : 12,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReworkDetailScreen(data: item),
                    ),
                  );
                },
                child: Container(
                  decoration: CustomTheme().cardTheme(),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item['reworkNo'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(item['status']),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem('No. WO', item['woNo']),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color =
        status.toLowerCase() == 'selesai' ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
