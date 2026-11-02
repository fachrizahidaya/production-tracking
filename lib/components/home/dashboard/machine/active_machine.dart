import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_section.dart';
import 'package:textile_tracking/components/master/theme.dart';

class ActiveMachine extends StatefulWidget {
  final data;
  final available;
  final unavailable;
  final handleRefetch;
  final isFetching;
  final Iterable<String> processNames;
  final bool isMobile;

  const ActiveMachine({
    super.key,
    this.data,
    this.available,
    this.unavailable,
    this.handleRefetch,
    this.isFetching,
    this.processNames = const [],
    this.isMobile = true,
  });

  @override
  State<ActiveMachine> createState() => _ActiveMachineState();
}

class _ActiveMachineState extends State<ActiveMachine> {
  static const List<String> _productionProcesses = [
    'Dyeing',
    'Press',
    'Tumbler',
    'Stenter',
    'Long Slitting',
    'Long Hemming',
    'Cross Cutting',
    'Sewing',
  ];

  static const List<String> _greigeProcesses = [
    'Warping',
    'Sizing',
    'Weaving',
    'Shearing',
  ];

  String get selectedProcess =>
      processFilters.isNotEmpty ? processFilters[selectedIndex] : '';
  List<String> productionFilters = [];
  List<String> greigeFilters = [];
  String selectedCategory = 'production';
  int selectedIndex = 0;

  List<String> get processFilters =>
      selectedCategory == 'greige' ? greigeFilters : productionFilters;

  @override
  void initState() {
    super.initState();
    _loadProcessFilters();
  }

  @override
  void didUpdateWidget(covariant ActiveMachine oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.processNames != widget.processNames) {
      _loadProcessFilters();
    }
  }

  void _loadProcessFilters() {
    final allowedProcessNames =
        widget.processNames.map((name) => name.trim().toLowerCase()).toSet();

    productionFilters = _productionProcesses
        .where((process) => allowedProcessNames.contains(process.toLowerCase()))
        .toList();
    greigeFilters = _greigeProcesses
        .where((process) => allowedProcessNames.contains(process.toLowerCase()))
        .toList();

    if (productionFilters.isEmpty && greigeFilters.isNotEmpty) {
      selectedCategory = 'greige';
    } else if (greigeFilters.isEmpty && productionFilters.isNotEmpty) {
      selectedCategory = 'production';
    }

    selectedIndex = 0;
  }

  bool get _shouldShowProcessFilter => processFilters.length > 1;

  bool get _shouldShowCategoryFilter =>
      productionFilters.isNotEmpty && greigeFilters.isNotEmpty;

  List<dynamic> _filterByProcess(List<dynamic>? source, String process) {
    if (source == null) return [];

    return source.where((m) {
      final p = m is Map ? (m['process_type'] ?? '') : '';
      return p == process;
    }).toList();
  }

  void _openCategoryFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Kategori',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('xl'),
                  fontWeight: CustomTheme().fontWeight('bold'),
                ),
              ),
              const Divider(height: 24),
              _buildCategoryOption(
                sheetContext: sheetContext,
                label: 'Proses',
                value: 'production',
              ),
              const SizedBox(height: 8),
              _buildCategoryOption(
                sheetContext: sheetContext,
                label: 'Greige',
                value: 'greige',
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryOption({
    required BuildContext sheetContext,
    required String label,
    required String value,
  }) {
    final selected = selectedCategory == value;
    final color = CustomTheme().colors('primary');

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          selectedCategory = value;
          selectedIndex = 0;
        });
        Navigator.pop(sheetContext);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : Colors.white,
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      selected ? color : CustomTheme().colors('text-primary'),
                ),
              ),
            ),
            if (selected) Icon(Icons.check, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required bool isMobile}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 20,
        isMobile ? 12 : 20,
        isMobile ? 16 : 20,
        isMobile ? 8 : 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Mesin',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 18,
                    fontWeight: CustomTheme().fontWeight('bold'),
                    color: CustomTheme().colors('text-primary'),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile
                      ? 'Pemantauan ketersediaan mesin'
                      : 'Pemantauan ketersediaan mesin secara real-time',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 14,
                    color: CustomTheme().colors('text-secondary'),
                  ),
                ),
              ],
            ),
          ),
          if (_shouldShowCategoryFilter)
            IconButton(
              onPressed: _openCategoryFilterSheet,
              icon: const Icon(Icons.tune_outlined),
              iconSize: isMobile ? 20 : 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              visualDensity: VisualDensity.compact,
            ),
          IconButton(
            onPressed: widget.handleRefetch,
            icon: const Icon(Icons.refresh_outlined),
            iconSize: isMobile ? 20 : 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildProcessTabs() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              for (int i = 0; i < processFilters.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _buildProcessTab(
                  label: processFilters[i],
                  index: i,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessTab({
    required String label,
    required int index,
  }) {
    final selected = selectedIndex == index;
    final color = CustomTheme().colors('primary');

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: selected
          ? null
          : () {
              setState(() {
                selectedIndex = index;
              });
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMachineContent({
    required List<dynamic> available,
    required List<dynamic> unavailable,
    required bool isMobile,
    required bool isPortrait,
  }) {
    if (widget.isFetching == true) {
      return DashboardCard(
        child: SizedBox(
          height: isMobile ? 120 : 200,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MachineSection(
          title: 'Mesin Tersedia',
          icon: Icons.task_alt_outlined,
          status: const Color(0xFF10b981),
          headerColor: 'Selesai',
          data: available,
          isPortrait: isPortrait,
          isMobile: isMobile,
          showStatus: false,
          compact: true,
        ),
        const SizedBox(height: 12),
        MachineSection(
          title: 'Mesin Digunakan',
          icon: Icons.error_outline,
          status: const Color(0xfff18800),
          headerColor: 'Diproses',
          data: unavailable,
          isPortrait: isPortrait,
          isMobile: isMobile,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (processFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = widget.isMobile;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final filteredAvailable =
        _filterByProcess(widget.available, selectedProcess);
    final filteredUnavailable =
        _filterByProcess(widget.unavailable, selectedProcess);

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile: isMobile),
            if (_shouldShowProcessFilter) _buildProcessTabs(),
          ],
        ),
        const SizedBox(height: 12),
        _buildMachineContent(
          available: filteredAvailable,
          unavailable: filteredUnavailable,
          isMobile: isMobile,
          isPortrait: isPortrait,
        ),
      ],
    );
  }
}
