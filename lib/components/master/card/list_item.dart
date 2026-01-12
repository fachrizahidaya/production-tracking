import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

class ListItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showActions;

  const ListItem({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Left Accent Bar
                    _buildAccentBar(),
                    // Main Content
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 16 : 12),
                        child: isTablet
                            ? _buildTabletLayout()
                            : _buildMobileLayout(),
                      ),
                    ),
                    // Quantity Section
                    _buildQuantitySection(isTablet),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Left Accent Bar berdasarkan status
  Widget _buildAccentBar() {
    final status = item['status']?.toString().toLowerCase() ?? 'pending';
    Color accentColor;

    switch (status) {
      case 'completed':
      case 'Selesai':
        accentColor = Colors.green;
        break;
      case 'in_progress':
      case 'Diproses':
        accentColor = Colors.blue;
        break;
      default:
        accentColor = Colors.orange;
    }

    return Container(
      width: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor,
            accentColor.withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  /// Layout untuk Tablet
  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Item Icon
        _buildItemIcon(true),
        const SizedBox(width: 16),
        // Item Info
        Expanded(
          flex: 2,
          child: _buildItemInfo(true),
        ),
        const SizedBox(width: 16),
        // Additional Info
        Expanded(
          flex: 2,
          child: _buildAdditionalInfo(true),
        ),
        const SizedBox(width: 16),
        // Status Badge
        _buildStatusSection(true),
      ],
    );
  }

  /// Layout untuk Mobile
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Icon + Info + Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemIcon(false),
            const SizedBox(width: 12),
            Expanded(child: _buildItemInfo(false)),
            _buildStatusSection(false),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom Row: Additional Info
        _buildAdditionalInfo(false),
      ],
    );
  }

  /// Item Icon
  Widget _buildItemIcon(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CustomTheme().buttonColor('primary').withOpacity(0.15),
            CustomTheme().buttonColor('primary').withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: isTablet ? 28 : 24,
        color: CustomTheme().buttonColor('primary'),
      ),
    );
  }

  /// Item Info (Code + Name)
  Widget _buildItemInfo(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Item Code Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            item['item_code']?.toString() ?? '-',
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: isTablet ? 8 : 6),
        // Item Name
        Text(
          item['item_name']?.toString() ?? '-',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (item['variants'][0] != null) ...[
          const SizedBox(height: 4),
          Text(
            item['variants'][0]['value'].toString(),
            style: TextStyle(
              fontSize: isTablet ? 13 : 11,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// Additional Info (Category, Supplier, etc.)
  Widget _buildAdditionalInfo(bool isTablet) {
    if (isTablet) {
      return Row(
        children: [
          if (item['variants'][3] != null)
            Expanded(
              child: _buildInfoChip(
                icon: Icons.design_services_outlined,
                label: item['variants'][3]['value']?.toString() ?? '-',
                isTablet: isTablet,
              ),
            ),
          if (item['variants'][2] != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoChip(
                icon: Icons.color_lens_outlined,
                label: item['variants'][2]['value']?.toString() ?? '-',
                isTablet: isTablet,
              ),
            ),
          ],
        ],
      );
    }

    // Mobile: Horizontal scroll chips
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (item['category'] != null)
            _buildInfoChip(
              icon: Icons.category_outlined,
              label: item['category']['name']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          if (item['supplier'] != null) ...[
            const SizedBox(width: 8),
            _buildInfoChip(
              icon: Icons.local_shipping_outlined,
              label: item['supplier']['name']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          ],
          if (item['location'] != null) ...[
            const SizedBox(width: 8),
            _buildInfoChip(
              icon: Icons.location_on_outlined,
              label: item['location']?.toString() ?? '-',
              isTablet: isTablet,
            ),
          ],
        ],
      ),
    );
  }

  /// Info Chip Widget
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 10,
        vertical: isTablet ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isTablet ? 16 : 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 13 : 11,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Status Section dengan Badge
  Widget _buildStatusSection(bool isTablet) {
    final status = item['status']?.toString() ?? 'Menunggu Diproses';
    final isRework = item['rework'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isRework) ...[
          SizedBox(height: isTablet ? 8 : 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.replay,
                  size: isTablet ? 14 : 12,
                  color: Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  'Rework',
                  style: TextStyle(
                    fontSize: isTablet ? 11 : 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Quantity Section
  Widget _buildQuantitySection(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: isTablet ? 16 : 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CustomTheme().buttonColor('primary').withOpacity(0.08),
            CustomTheme().buttonColor('primary').withOpacity(0.03),
          ],
        ),
        border: Border(
          left: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: isTablet ? 24 : 20,
            color: CustomTheme().buttonColor('primary'),
          ),
          SizedBox(height: isTablet ? 8 : 6),
          Text(
            _formatQuantity(item['qty']),
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: CustomTheme().buttonColor('primary'),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item['unit']?['code']?.toString() ?? '-',
            style: TextStyle(
              fontSize: isTablet ? 12 : 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Format Quantity
  String _formatQuantity(dynamic qty) {
    if (qty == null) return '0';
    if (qty is num) {
      return formatNumber(qty);
    }
    return qty.toString();
  }
}
