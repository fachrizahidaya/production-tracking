import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_section.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ActiveMachine extends StatefulWidget {
  final data;
  final available;
  final unavailable;
  final handleRefetch;
  final isFetching;
  final Iterable<String> processNames;

  const ActiveMachine(
      {super.key,
      this.data,
      this.available,
      this.unavailable,
      this.handleRefetch,
      this.isFetching,
      this.processNames = const []});

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

  bool get _shouldShowProcessFilter {
    return processFilters.length > 1;
  }

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
                ),
              ),
            );
          }).separatedBy(CustomTheme().hGap('lg')),
        ),
      ),
    );
  }

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

      return source.where((m) {
        final p = m is Map ? (m['process_type'] ?? '') : '';
        return p == process;
      }).toList();
    }

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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (processFilters.isEmpty) {
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

    final filteredAvailable =
        filterByProcess(widget.available, selectedProcess);

    final filteredUnavailable =
        filterByProcess(widget.unavailable, selectedProcess);

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
  }
}
