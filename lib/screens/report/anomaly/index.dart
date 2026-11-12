import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';

class AnomalyScreen extends StatelessWidget {
  const AnomalyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifikasi Anomali',
        onReturn: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _AnomalyMenuCard(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red.shade700,
              iconBackgroundColor: Colors.red.shade50,
              title: 'BS melebihi 3%',
              description: 'Lihat daftar anomali BS yang melebihi toleransi.',
              onTap: () => Navigator.pushNamed(context, '/bs-anomalies'),
            ),
            const SizedBox(height: 12),
            _AnomalyMenuCard(
              icon: Icons.straighten_rounded,
              iconColor: Colors.orange.shade800,
              iconBackgroundColor: Colors.orange.shade50,
              title: 'GSM Packing',
              description: 'Lihat daftar anomali GSM pada packing.',
              onTap: () => Navigator.pushNamed(context, '/gsm-anomalies'),
            ),
            const SizedBox(height: 12),
            _AnomalyMenuCard(
              icon: Icons.input_rounded,
              iconColor: Colors.blue.shade700,
              iconBackgroundColor: Colors.blue.shade50,
              title: 'Input Proses',
              description: 'Lihat daftar anomali input proses.',
              onTap: () => Navigator.pushNamed(context, '/process-anomalies'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnomalyMenuCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AnomalyMenuCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ],
          ),
        ),
      ),
    );
  }
}
