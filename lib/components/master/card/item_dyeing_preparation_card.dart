// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ItemDyeingPreparationCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDyeingPreparationCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d6f95f88 (fix: ui order greige detail)
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isTablet),
                  const Divider(),
                ],
              ),
              _buildInformation(isTablet),
            ].separatedBy(CustomTheme().vGap('lg')),
          ),
        );
      },
<<<<<<< HEAD
=======
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(),
          _buildInformation(),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
    );
  }

  Widget _buildHeader() {
    return Row(
<<<<<<< HEAD
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
=======
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(),
          _buildInformation(),
        ].separatedBy(CustomTheme().vGap('lg')),
      ),
=======
>>>>>>> d6f95f88 (fix: ui order greige detail)
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Row(
<<<<<<< HEAD
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['prep_no'] ?? '-',
                style: TextStyle(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
=======
                  fontSize: CustomTheme().fontSize('lg'),
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
                  fontSize: CustomTheme().fontSize(isTablet ? 'lg' : 'md'),
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
                  fontSize: CustomTheme().fontSize('lg'),
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
              Text(
                item['wo_no'] ?? '-',
                style: TextStyle(
                  color: Colors.grey[600],
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  fontSize: CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
                ),
                overflow: TextOverflow.ellipsis,
=======
                  fontSize: CustomTheme().fontSize('md'),
                ),
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
                  fontSize: CustomTheme().fontSize(isTablet ? 'xl' : 'lg'),
                ),
                overflow: TextOverflow.ellipsis,
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
                  fontSize: CustomTheme().fontSize('md'),
                ),
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d6f95f88 (fix: ui order greige detail)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item['status'] != null)
              CustomBadge(
                title: _getStatusLabel(item['status']),
                status: item['status'],
                withStatus: true,
              ),
          ].separatedBy(CustomTheme().hGap('md')),
<<<<<<< HEAD
=======
        CustomBadge(
          title: item['status'] ?? '-',
          status: item['status'],
          withStatus: true,
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
        ),
      ],
    );
  }

  Widget _buildInformation() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoRow(
            Icons.calendar_today_outlined,
            "Tanggal Persiapan",
            formatDateSafe(item['prep_date']),
          ),
        ),
        Expanded(
          child: _buildInfoRow(
            Icons.person_outline,
            "Dibuat Oleh",
            item['start_by'] ?? "-",
          ),
        ),
      ].separatedBy(CustomTheme().vGap('lg')),
    );
  }

  Widget _buildInfoRow(
<<<<<<< HEAD
    bool isTablet,
=======
        CustomBadge(
          title: item['status'] ?? '-',
          status: item['status'],
          withStatus: true,
=======
>>>>>>> d6f95f88 (fix: ui order greige detail)
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildInformation(bool isTablet) {
    final children = [
      _buildInfoSection(
        isTablet,
        icon: Icons.calendar_today_outlined,
        title: 'Tanggal Persiapan',
        value: formatDateSafe(item['prep_date']),
      ),
      _buildInfoSection(
        isTablet,
        icon: Icons.person_outline,
        title: 'Dibuat Oleh',
        value: _getUserName(item['start_by']),
      ),
    ];

    return Row(
      children: children
          .map(
            (child) => Expanded(
              child: Container(
                padding: CustomTheme().padding('card'),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: child,
              ),
            ),
          )
          .toList()
          .separatedBy(CustomTheme().hGap('xl')),
    );
  }

  Widget _buildInfoSection(
    bool isTablet, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return isTablet
        ? Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  isTablet,
                  icon,
                  title,
                  value,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                isTablet,
                icon,
                title,
                value,
              ),
            ],
          );
  }

  Widget _buildInfoRow(
<<<<<<< HEAD
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
    bool isTablet,
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
      mainAxisSize: MainAxisSize.min,
=======
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
      mainAxisSize: MainAxisSize.min,
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
      children: [
        Container(
          padding: CustomTheme().padding('process-content'),
          decoration: BoxDecoration(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
=======
            color: CustomTheme().buttonColor('primary').withOpacity(.1),
            borderRadius: BorderRadius.circular(6),
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
          ),
          child: Icon(
            icon,
            size: 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
<<<<<<< HEAD
        Flexible(
=======
            color: CustomTheme().buttonColor('primary').withOpacity(.1),
            borderRadius: BorderRadius.circular(6),
=======
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
>>>>>>> d6f95f88 (fix: ui order greige detail)
          ),
          child: Icon(
            icon,
            size: isTablet ? 20 : 18,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
<<<<<<< HEAD
        Expanded(
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
        Flexible(
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
        Expanded(
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  fontSize: CustomTheme().fontSize(isTablet ? 12 : 10),
                  fontWeight: CustomTheme().fontWeight('semibold'),
=======
                  fontSize: CustomTheme().fontSize('sm'),
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
                  fontSize: CustomTheme().fontSize(isTablet ? 12 : 10),
                  fontWeight: CustomTheme().fontWeight('semibold'),
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
                  fontSize: CustomTheme().fontSize('sm'),
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: CustomTheme().fontWeight('semibold'),
                  fontSize: CustomTheme().fontSize('md'),
                ),
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                overflow: TextOverflow.ellipsis,
=======
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
                overflow: TextOverflow.ellipsis,
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
              ),
            ].separatedBy(CustomTheme().vGap('sm')),
          ),
        ),
      ].separatedBy(CustomTheme().hGap('xl')),
    );
  }
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d6f95f88 (fix: ui order greige detail)

  String _getUserName(dynamic user) {
    if (user is Map) {
      return user['name']?.toString() ?? '-';
    }

    return user?.toString() ?? '-';
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'Diproses':
        return 'Diproses';
      case 'Selesai':
        return 'Selesai';
      case 'Rework':
        return 'Rework';
      default:
        return status ?? '-';
    }
  }
<<<<<<< HEAD
=======
>>>>>>> 7e9db1cc (feat: buat persiapan dyeing)
=======
>>>>>>> d6f95f88 (fix: ui order greige detail)
=======
>>>>>>> c0b3008b (feat: buat persiapan dyeing)
}
