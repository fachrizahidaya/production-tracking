import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/card/custom_card.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_number.dart';

class ProcessItem extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onTap;
  final bool isExpanded;
  final bool showDetails;

  const ProcessItem({
    super.key,
    required this.item,
    this.onTap,
    this.isExpanded = false,
    this.showDetails = true,
  });

  @override
  State<ProcessItem> createState() => _ProcessItemState();
}

class _ProcessItemState extends State<ProcessItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final data = widget.item['data'] as List<dynamic>? ?? [];
        final hasData = data.isNotEmpty;

        return Container(
          margin: EdgeInsets.only(bottom: isTablet ? 14 : 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isExpanded
                  ? CustomTheme().buttonColor('primary')
                  : Colors.grey[200]!,
              width: _isExpanded ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isExpanded
                    ? CustomTheme().buttonColor('primary').withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isExpanded ? 12 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(hasData, data, isTablet),

                // Expandable Details
                if (hasData && widget.showDetails)
                  _buildExpandableDetails(data.first, isTablet),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Header Section
  Widget _buildHeader(bool hasData, List<dynamic> data, bool isTablet) {
    final status = hasData
        ? (data.first['status']?.toString() ?? 'Menunggu Diproses')
        : 'Menunggu Diproses';
    final statusConfig = _getStatusConfig(status);

    return InkWell(
      onTap: widget.onTap ??
          (hasData && widget.showDetails ? _toggleExpanded : null),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusConfig['color'].withOpacity(0.08),
              statusConfig['color'].withOpacity(0.02),
            ],
          ),
          border: hasData && widget.showDetails
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            // Process Icon
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: statusConfig['color'].withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getProcessIcon(widget.item['label']),
                size: isTablet ? 24 : 20,
                color: statusConfig['color'],
              ),
            ),
            SizedBox(width: isTablet ? 14 : 12),

            // Process Label & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['label']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Status Indicator
                      Container(
                        width: isTablet ? 8 : 6,
                        height: isTablet ? 8 : 6,
                        decoration: BoxDecoration(
                          color: statusConfig['color'],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: statusConfig['color'].withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusConfig['label'],
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 11,
                          color: statusConfig['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Additional Info
                      if (hasData && data.first['qty'] != null) ...[
                        SizedBox(width: isTablet ? 12 : 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: isTablet ? 12 : 10,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formatNumber(data.first['qty']),
                                style: TextStyle(
                                  fontSize: isTablet ? 11 : 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Expand/Action Button
            if (hasData && widget.showDetails)
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isExpanded
                        ? CustomTheme().buttonColor('primary').withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: isTablet ? 24 : 20,
                    color: _isExpanded
                        ? CustomTheme().buttonColor('primary')
                        : Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Expandable Details Section
  Widget _buildExpandableDetails(Map<String, dynamic> data, bool isTablet) {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Section
            if (data['start_time'] != null || data['end_time'] != null) ...[
              _buildSectionTitle(
                icon: Icons.access_time_outlined,
                title: 'Waktu Proses',
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 14 : 12),
              _buildTimeSection(data, isTablet),
              SizedBox(height: isTablet ? 16 : 14),
            ],

            // Quantity & Weight Section
            if (data['qty'] != null || data['weight'] != null) ...[
              _buildSectionTitle(
                icon: Icons.scale_outlined,
                title: 'Kuantitas',
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 14 : 12),
              _buildQuantitySection(data, isTablet),
              SizedBox(height: isTablet ? 16 : 14),
            ],

            // Machine & Operator Section
            if (data['machine'] != null || data['operator'] != null) ...[
              _buildSectionTitle(
                icon: Icons.people_outline,
                title: 'Sumber Daya',
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 14 : 12),
              _buildResourceSection(data, isTablet),
              SizedBox(height: isTablet ? 16 : 14),
            ],

            // Grades Section
            if (data['grades'] != null &&
                (data['grades'] as List).isNotEmpty) ...[
              _buildSectionTitle(
                icon: Icons.grade_outlined,
                title: 'Grades',
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 14 : 12),
              _buildGradesSection(data['grades'], isTablet),
              SizedBox(height: isTablet ? 16 : 14),
            ],

            // Remarks Section
            if (data['remarks'] != null &&
                data['remarks'].toString().isNotEmpty) ...[
              _buildSectionTitle(
                icon: Icons.notes_outlined,
                title: 'Keterangan',
                isTablet: isTablet,
              ),
              SizedBox(height: isTablet ? 10 : 8),
              _buildRemarksSection(data['remarks'], isTablet),
            ],
          ],
        ),
      ),
    );
  }

  /// Section Title Widget
  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: CustomTheme().buttonColor('primary').withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: isTablet ? 16 : 14,
            color: CustomTheme().buttonColor('primary'),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 13 : 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// Time Section
  Widget _buildTimeSection(Map<String, dynamic> data, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          if (data['start_time'] != null)
            Expanded(
              child: _buildTimeItem(
                icon: Icons.play_circle_outline,
                label: 'Waktu Mulai',
                value: _formatTime(data['start_time']),
                color: Colors.green,
                isTablet: isTablet,
              ),
            ),
          if (data['start_time'] != null && data['end_time'] != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
              child: Icon(
                Icons.arrow_forward,
                size: isTablet ? 20 : 16,
                color: Colors.grey[400],
              ),
            ),
          if (data['end_time'] != null)
            Expanded(
              child: _buildTimeItem(
                icon: Icons.stop_circle_outlined,
                label: 'Waktu Selesai',
                value: _formatTime(data['end_time']),
                color: Colors.red,
                isTablet: isTablet,
              ),
            ),
        ],
      ),
    );
  }

  /// Time Item Widget
  Widget _buildTimeItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isTablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: isTablet ? 16 : 14,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 11 : 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 14 : 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  /// Quantity Section
  Widget _buildQuantitySection(Map<String, dynamic> data, bool isTablet) {
    return Row(
      children: [
        if (data['qty'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.inventory_2_outlined,
              label: 'Quantity',
              value: formatNumber(data['qty']),
              unit: data['unit']?.toString(),
              color: Colors.purple,
              isTablet: isTablet,
            ),
          ),
        if (data['qty'] != null && data['weight'] != null)
          SizedBox(width: isTablet ? 12 : 8),
        if (data['weight'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.scale_outlined,
              label: 'Berat',
              value: formatNumber(data['weight']),
              unit: 'kg',
              color: Colors.orange,
              isTablet: isTablet,
            ),
          ),
      ],
    );
  }

  /// Resource Section
  Widget _buildResourceSection(Map<String, dynamic> data, bool isTablet) {
    return Row(
      children: [
        if (data['machine'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.precision_manufacturing_outlined,
              label: 'Mesin',
              value: data['machine']['name']?.toString() ?? '-',
              color: Colors.teal,
              isTablet: isTablet,
            ),
          ),
        if (data['machine'] != null && data['operator'] != null)
          SizedBox(width: isTablet ? 12 : 8),
        if (data['operator'] != null)
          Expanded(
            child: _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Operator',
              value: data['operator']['name']?.toString() ?? '-',
              color: Colors.indigo,
              isTablet: isTablet,
            ),
          ),
      ],
    );
  }

  /// Info Card Widget
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    String? unit,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: isTablet ? 16 : 14,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 11 : 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 10 : 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Grades Section
  Widget _buildGradesSection(List<dynamic> grades, bool isTablet) {
    return Wrap(
      spacing: isTablet ? 10 : 8,
      runSpacing: isTablet ? 10 : 8,
      children: grades.map((grade) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 10,
            vertical: isTablet ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.purple.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.grade,
                size: isTablet ? 14 : 12,
                color: Colors.purple,
              ),
              const SizedBox(width: 6),
              Text(
                grade['name']?.toString() ?? grade.toString(),
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple[700],
                ),
              ),
              if (grade['qty'] != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    formatNumber(grade['qty']),
                    style: TextStyle(
                      fontSize: isTablet ? 11 : 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Remarks Section
  Widget _buildRemarksSection(dynamic remarks, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 14 : 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: isTablet ? 18 : 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              remarks.toString(),
              style: TextStyle(
                fontSize: isTablet ? 13 : 12,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper Methods
  Map<String, dynamic> _getStatusConfig(String status) {
    final lowerStatus = status.toLowerCase();

    if (lowerStatus.contains('selesai') || lowerStatus.contains('completed')) {
      return {
        'label': 'Selesai',
        'color': Colors.green,
      };
    }
    if (lowerStatus.contains('proses') || lowerStatus.contains('progress')) {
      return {
        'label': 'Sedang Diproses',
        'color': Colors.blue,
      };
    }
    if (lowerStatus.contains('rework')) {
      return {
        'label': 'Rework',
        'color': Colors.red,
      };
    }
    return {
      'label': 'Menunggu Diproses',
      'color': Colors.orange,
    };
  }

  IconData _getProcessIcon(String? label) {
    if (label == null) return Icons.settings_outlined;

    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('dyeing')) {
      return Icons.color_lens_outlined;
    }
    if (lowerLabel.contains('finishing')) {
      return Icons.auto_fix_high_outlined;
    }
    if (lowerLabel.contains('qc') || lowerLabel.contains('quality')) {
      return Icons.verified_outlined;
    }
    if (lowerLabel.contains('packing')) {
      return Icons.inventory_2_outlined;
    }
    if (lowerLabel.contains('printing')) {
      return Icons.print_outlined;
    }
    if (lowerLabel.contains('washing')) {
      return Icons.local_laundry_service_outlined;
    }

    return Icons.settings_outlined;
  }

  String _formatTime(dynamic time) {
    if (time == null) return '-';
    try {
      final dateTime = DateTime.parse(time.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time.toString();
    }
  }
}
