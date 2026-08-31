import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_section.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/auth/storage.dart';
import 'package:textile_tracking/helpers/util/separated_column.dart';

class ActiveMachine extends StatefulWidget {
  final data;
  final available;
  final unavailable;
  final handleRefetch;
  final isFetching;

  const ActiveMachine(
      {super.key,
      this.data,
      this.available,
      this.unavailable,
      this.handleRefetch,
      this.isFetching});

  @override
  State<ActiveMachine> createState() => _ActiveMachineState();
}

class _ActiveMachineState extends State<ActiveMachine>
    with TickerProviderStateMixin {
  String get selectedProcess =>
      processFilters.isNotEmpty ? processFilters[selectedIndex] : '';
  TabController? _tabController;
  List<String> processFilters = [''];
  int selectedIndex = 0;

  VoidCallback? _tabListener;

  @override
  void initState() {
    super.initState();
    _loadProcessFilters();
  }

  Future<void> _loadProcessFilters() async {
    final menus = await Storage.instance.getMenus();
    if (!mounted) return;

    final productionProcesses = getProductionProcesses(menus);

    final allowedProcesses = [
      'Dyeing',
      'Press',
      'Tumbler',
      'Stenter',
      'Long Slitting',
      'Long Hemming',
      'Cross Cutting',
      'Sewing',
    ];

    final filtered =
        allowedProcesses.where((p) => productionProcesses.contains(p)).toList();

    _tabController?.removeListener(_tabListener ?? () {});
    _tabController?.dispose();

    _tabListener = () {
      if (!mounted) return;
      if (_tabController!.indexIsChanging) return;

      setState(() {
        selectedIndex = _tabController!.index;
      });
    };

    setState(() {
      processFilters = filtered;

      _tabController = TabController(
        length: processFilters.length,
        vsync: this,
      )..addListener(_tabListener!);
    });
  }

  List<String> getProductionProcesses(List<dynamic> menus) {
    for (final menu in menus) {
      if (menu['name'] == 'Produksi') {
        final children = menu['children'] as List<dynamic>? ?? [];
        return children.map((e) => e['name'].toString()).toList();
      }
    }
    return [];
  }

  @override
  void dispose() {
    _tabController?.removeListener(_tabListener ?? () {});
    _tabController?.dispose();
    super.dispose();
  }

  bool get _shouldShowProcessFilter {
    return processFilters.length > 1;
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
                _tabController!.animateTo(index);
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

    return SizedBox(
      height: 600,
      child: TabBarView(
        controller: _tabController,
        children: processFilters.map((process) {
          final filteredAvailable = filterByProcess(available, process);

          final filteredUnavailable = filterByProcess(unavailable, process);

          if (widget.isFetching == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
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
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
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
            child: isMobile ? _buildMobileHeader() : _buildTabletHeader(),
          ),

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
            filteredAvailable,
            filteredUnavailable,
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

  Widget _buildMobileHeader() {
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
                title: '${(widget.available ?? []).length} Tersedia',
                status: 'Selesai',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomBadge(
                withStatus: true,
                title: '${(widget.unavailable ?? []).length} Digunakan',
                status: 'Diproses',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletHeader() {
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
              title: '${(widget.available ?? []).length} Tersedia',
              status: 'Selesai',
            ),
            CustomBadge(
              withStatus: true,
              title: '${(widget.unavailable ?? []).length} Digunakan',
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
