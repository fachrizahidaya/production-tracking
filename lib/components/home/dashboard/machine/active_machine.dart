import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dashboard_card.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_section.dart';
import 'package:textile_tracking/components/master/card/custom_badge.dart';
import 'package:textile_tracking/components/master/theme.dart';
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
  String selectedProcess = 'All';
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: processFilters.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  final List<String> processFilters = [
    'All',
    'Dyeing',
    'Press',
    'Tumbler',
    'Stenter',
    'Long Sitting',
    'Long Hemming',
    'Cross Cutting',
    'Sewing'
  ];

  int selectedIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                _tabController.animateTo(index);
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
      if (process == 'All') return source;

      return source.where((m) {
        final p = m is Map ? (m['process_type'] ?? '') : '';
        return p == process;
      }).toList();
    }

    return SizedBox(
      height: 600,
      child: TabBarView(
        controller: _tabController,
        children: processFilters.map((process) {
          final filteredAvailable = filterByProcess(available, process);
          final filteredUnavailable = filterByProcess(unavailable, process);

          return widget.isFetching
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: CustomTheme().padding('content'),
                  child: Row(
                    children: [
                      Expanded(
                        child: MachineSection(
                          title: 'Mesin Tersedia',
                          icon: Icons.check_circle_outline,
                          status: const Color(0xFF10b981),
                          headerColor: 'Selesai',
                          data: filteredAvailable,
                          isPortrait: isPortrait,
                        ),
                      ),
                      Expanded(
                        child: MachineSection(
                          title: 'Mesin Sedang Digunakan',
                          icon: Icons.warning_outlined,
                          status: const Color(0xfff18800),
                          headerColor: 'Diproses',
                          data: filteredUnavailable,
                          isPortrait: isPortrait,
                        ),
                      ),
                    ].separatedBy(CustomTheme().hGap('2xl')),
                  ),
                );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<dynamic> filterByProcess(
      List<dynamic>? source,
      String selectedProcess,
    ) {
      if (source == null) return [];
      if (selectedProcess == 'All') return source;

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
        Padding(
          padding: CustomTheme().padding('card'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Mesin'),
                  Text(
                    'Pemantauan ketersediaan mesin secara real-time',
                    style: TextStyle(
                        fontSize: CustomTheme().fontSize('sm'),
                        color: CustomTheme().colors('text-secondary')),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.refresh_outlined,
                    ),
                    onPressed: () {
                      widget.handleRefetch();
                    },
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
                ].separatedBy(CustomTheme().hGap('lg')),
              )
            ],
          ),
        ),
        _buildProcessFilter(),
        Divider(),
        _buildSwipeContent(filteredAvailable, filteredUnavailable, isPortrait)
      ],
    ));
  }
}
