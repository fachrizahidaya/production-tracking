import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/machine/machine_section.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';
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

class _ActiveMachineState extends State<ActiveMachine> {
  String selectedProcess = 'All';

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

    return Column(
      children: [
        CustomCard(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: PaddingColumn.screen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status Mesin'),
                      Text(
                        'Pemantauan ketersediaan mesin secara real-time',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: IconButton(
                          icon: Stack(
                            children: [
                              const Icon(
                                Icons.refresh_outlined,
                              ),
                            ],
                          ),
                          onPressed: () {
                            widget.handleRefetch();
                          },
                        ),
                      ),
                      CustomBadge(
                        withStatus: true,
                        icon: Icons.check_circle_outline,
                        title: '${(widget.available ?? []).length} Tersedia',
                      ),
                      CustomBadge(
                        withStatus: true,
                        icon: Icons.warning_outlined,
                        title: '${(widget.unavailable ?? []).length} Digunakan',
                      ),
                    ].separatedBy(const SizedBox(width: 8)),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: PaddingColumn.screen,
                child: Row(
                  children: processFilters
                      .map((type) {
                        bool isSelected = selectedProcess == type;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedProcess = type;
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            elevation: isSelected ? 3 : 1,
                            color:
                                isSelected ? Colors.blue.shade50 : Colors.white,
                            child: Padding(
                              padding: PaddingColumn.screen,
                              child: Text(type),
                            ),
                          ),
                        );
                      })
                      .toList()
                      .separatedBy(SizedBox(
                        width: 8,
                      )),
                ),
              ),
            ),
            Divider(),
            if (widget.isFetching)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: MachineSection(
                      title: 'Mesin Tersedia',
                      icon: Icons.check_circle_outline,
                      headerColor: Colors.green.shade100,
                      data: filteredAvailable,
                      isPortrait: isPortrait,
                    ),
                  ),
                  Expanded(
                    child: MachineSection(
                      title: 'Mesin Sedang Digunakan',
                      icon: Icons.warning_outlined,
                      headerColor: Colors.green.shade100,
                      data: filteredUnavailable,
                      isPortrait: isPortrait,
                    ),
                  ),
                ],
              )
          ].separatedBy(SizedBox(
            height: 16,
          )),
        )),
      ],
    );
  }
}
