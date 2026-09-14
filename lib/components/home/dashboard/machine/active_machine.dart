import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_section.dart';
import 'package:textile_tracking/components/master/theme.dart';
<<<<<<< HEAD
=======
import 'package:textile_tracking/helpers/util/separated_column.dart';
>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)

class ActiveMachine extends StatefulWidget {
  final data;
  final available;
  final unavailable;
  final handleRefetch;
  final isFetching;
  final Iterable<String> processNames;
<<<<<<< HEAD
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
=======

  const ActiveMachine(
      {super.key,
      this.data,
      this.available,
      this.unavailable,
      this.handleRefetch,
      this.isFetching,
      this.processNames = const []});
>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)

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
<<<<<<< HEAD
=======
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
>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)
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

<<<<<<< HEAD
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
=======
  bool get _shouldShowCategoryTabs {
    return productionFilters.isNotEmpty && greigeFilters.isNotEmpty;
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DefaultTabController(
        length: 2,
        initialIndex: selectedCategory == 'greige' ? 1 : 0,
        child: TabBar(
          onTap: (index) {
            setState(() {
              selectedCategory = index == 0 ? 'production' : 'greige';
              selectedIndex = 0;
            });
          },
          tabs: const [
            Tab(text: 'Proses'),
            Tab(text: 'Greige'),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: CustomTheme().padding('badge'),
        child: Row(
          children: List.generate(processFilters.length, (index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? CustomTheme().buttonColor('primary')
                        : Colors.grey.shade400,
                  ),
                  color: isSelected
                      ? CustomTheme().buttonColor('primary')
                      : Colors.white,
                ),
                padding: CustomTheme().padding('badge'),
                child: Text(
                  processFilters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)
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

<<<<<<< HEAD
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
=======
  Widget _buildSwipeContent(
    List<dynamic>? available,
    List<dynamic>? unavailable,
    bool isPortrait,
  ) {
    List<dynamic> filterByProcess(
      List<dynamic>? source,
      String process,
    ) {
      if (source == null) return [];
>>>>>>> 83d26bbb (fix: UI mobile dashboard)

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

<<<<<<< HEAD
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
=======
    final isMobile = MediaQuery.of(context).size.width < 600;

    // ============================================================
    // MOBILE
    // ============================================================
    if (isMobile) {
      final filteredAvailable = filterByProcess(available, selectedProcess);

      final filteredUnavailable = filterByProcess(unavailable, selectedProcess);

      if (widget.isFetching == true) {
        return const SizedBox(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MachineSection(
              title: 'Mesin Tersedia',
              icon: Icons.task_alt_outlined,
              status: Color(0xFF10b981),
              headerColor: 'Selesai',
              data: filteredAvailable,
              isPortrait: true,
              isMobile: true,
            ),
            SizedBox(height: 20),
            MachineSection(
              title: 'Mesin Digunakan',
              icon: Icons.error_outline,
              status: Color(0xfff18800),
              headerColor: 'Diproses',
              data: filteredUnavailable,
              isPortrait: true,
              isMobile: true,
            ),
          ],
        ),
      );
    }

    // ============================================================
    // TABLET / DESKTOP
    // ============================================================

    final filteredAvailable = filterByProcess(available, selectedProcess);
    final filteredUnavailable = filterByProcess(unavailable, selectedProcess);

    if (widget.isFetching == true) {
      return const SizedBox(
        height: 600,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      height: 600,
      child: Padding(
        padding: CustomTheme().padding('content'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MachineSection(
                title: 'Mesin Tersedia',
                icon: Icons.task_alt_outlined,
                status: Color(0xFF10b981),
                headerColor: 'Selesai',
                data: filteredAvailable,
                isPortrait: isPortrait,
                isMobile: false,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: MachineSection(
                title: 'Mesin Digunakan',
                icon: Icons.error_outline,
                status: Color(0xfff18800),
                headerColor: 'Diproses',
                data: filteredUnavailable,
                isPortrait: isPortrait,
                isMobile: false,
              ),
            ),
          ],
        ),
      ),
>>>>>>> 83d26bbb (fix: UI mobile dashboard)
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
    if (processFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMobile = widget.isMobile;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

=======
    if (_tabController == null) {
=======
    if (processFilters.isEmpty) {
>>>>>>> 04b6e1a6 (fix: filter dashboard data by accessible processes)
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<dynamic> filterByProcess(
      List<dynamic>? source,
      String selectedProcess,
    ) {
      if (source == null) return [];

      return source.where((m) {
        final process = m is Map ? (m['process_type'] ?? '') : '';

        return process == selectedProcess;
      }).toList();
    }

>>>>>>> 83d26bbb (fix: UI mobile dashboard)
    final filteredAvailable =
        _filterByProcess(widget.available, selectedProcess);
    final filteredUnavailable =
        _filterByProcess(widget.unavailable, selectedProcess);

<<<<<<< HEAD
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
=======
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // HEADER
          // ======================================================
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: isMobile
                ? _buildMobileHeader(
                    filteredAvailable,
                    filteredUnavailable,
                  )
                : _buildTabletHeader(
                    filteredAvailable,
                    filteredUnavailable,
                  ),
          ),

          if (_shouldShowCategoryTabs) _buildCategoryTabs(),

          // ======================================================
          // PROCESS FILTER
          // ======================================================
          if (_shouldShowProcessFilter) ...[
            _buildProcessFilter(),
          ],

          const Divider(),

          // ======================================================
          // CONTENT
          // ======================================================
          _buildSwipeContent(
            widget.available,
            widget.unavailable,
            isPortrait,
          ),
        ],
      ),
    );
  }

  Widget _buildMachineHeader(bool isMobile) {
    final availableCount = (widget.available ?? []).length;

    final unavailableCount = (widget.unavailable ?? []).length;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Mesin',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Pemantauan ketersediaan mesin secara real-time',
                        style: TextStyle(
                          fontSize: 11,
                          color: CustomTheme().colors('text-secondary'),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.refresh_outlined,
                    size: 21,
                  ),
                  onPressed: widget.handleRefetch,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMachineCountBadge(
                    count: availableCount,
                    title: 'Tersedia',
                    status: 'Selesai',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMachineCountBadge(
                    count: unavailableCount,
                    title: 'Digunakan',
                    status: 'Diproses',
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // TABLET
    return Padding(
      padding: CustomTheme().padding('card'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Mesin',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('lg'),
                ),
              ),
              Text(
                'Pemantauan ketersediaan mesin secara real-time',
                style: TextStyle(
                  fontSize: CustomTheme().fontSize('md'),
                  color: CustomTheme().colors('text-secondary'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.refresh_outlined,
                ),
                onPressed: widget.handleRefetch,
              ),
              CustomBadge(
                withStatus: true,
                title: '$availableCount Tersedia',
                status: 'Selesai',
              ),
              CustomBadge(
                withStatus: true,
                title: '$unavailableCount Digunakan',
                status: 'Diproses',
              ),
            ].separatedBy(
              CustomTheme().hGap('lg'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(
    List<dynamic> available,
    List<dynamic> unavailable,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Mesin',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('lg'),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pemantauan ketersediaan mesin',
                    style: TextStyle(
                      fontSize: CustomTheme().fontSize('sm'),
                      color: CustomTheme().colors('text-secondary'),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: widget.handleRefetch,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CustomBadge(
                withStatus: true,
                title: '${available.length} Tersedia',
                status: 'Selesai',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomBadge(
                withStatus: true,
                title: '${unavailable.length} Digunakan',
                status: 'Diproses',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletHeader(
    List<dynamic> available,
    List<dynamic> unavailable,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Mesin',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('lg'),
              ),
            ),
            Text(
              'Pemantauan ketersediaan mesin secara real-time',
              style: TextStyle(
                fontSize: CustomTheme().fontSize('md'),
                color: CustomTheme().colors('text-secondary'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: widget.handleRefetch,
            ),
            CustomBadge(
              withStatus: true,
              title: '${available.length} Tersedia',
              status: 'Selesai',
            ),
            CustomBadge(
              withStatus: true,
              title: '${unavailable.length} Digunakan',
              status: 'Diproses',
            ),
          ].separatedBy(
            CustomTheme().hGap('lg'),
          ),
        ),
      ],
    );
  }

  Widget _buildMachineCountBadge({
    required int count,
    required String title,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomBadge(
            withStatus: true,
            title: '$count',
            status: status,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
>>>>>>> 83d26bbb (fix: UI mobile dashboard)
  }
}
