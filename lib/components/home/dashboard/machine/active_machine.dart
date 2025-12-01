import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/layout/card/custom_card.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/text/no_data.dart';
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
    'Press Tumbler',
    'Stenter',
    'Long Sitting',
    'Long Hemming',
    'Cross Cutting',
    'Sewing'
  ];

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredAvailable = selectedProcess == 'All'
        ? (widget.available ?? [])
        : (widget.available ?? []).where((m) {
            final process = m is Map ? (m['process_type'] ?? '') : '';
            return process == selectedProcess;
          }).toList();

    List<dynamic> filteredUnavailable = selectedProcess == 'All'
        ? (widget.unavailable ?? [])
        : (widget.unavailable ?? []).where((m) {
            final process = m is Map ? (m['process_type'] ?? '') : '';
            return process == selectedProcess;
          }).toList();

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
                  Text('Status Mesin'),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CustomCard(
                          color: Colors.green.shade100,
                          child: Padding(
                            padding: PaddingColumn.screen,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                ),
                                Text(
                                    'Mesin Tersedia (${filteredAvailable.length.toString()})')
                              ].separatedBy(SizedBox(
                                width: 8,
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: filteredAvailable.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Center(child: NoData()))
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < filteredAvailable.length;
                                          i++)
                                        CustomCard(
                                            withBorder: true,
                                            child: Padding(
                                              padding: PaddingColumn.screen,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomBadge(
                                                        status:
                                                            filteredAvailable[i]
                                                                ['code'],
                                                        title:
                                                            filteredAvailable[i]
                                                                ['code']!,
                                                        withDifferentColor:
                                                            true,
                                                        color:
                                                            Color(0xffeaeaec),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                              filteredAvailable[
                                                                      i]
                                                                  ['location']),
                                                        ].separatedBy(SizedBox(
                                                          width: 4,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .local_laundry_service_outlined,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                              filteredAvailable[
                                                                  i]['name']),
                                                        ].separatedBy(SizedBox(
                                                          width: 4,
                                                        )),
                                                      ),
                                                      CustomBadge(
                                                        status:
                                                            filteredAvailable[i]
                                                                [
                                                                'process_type'],
                                                        title: filteredAvailable[
                                                            i]['process_type']!,
                                                        withDifferentColor:
                                                            true,
                                                        color:
                                                            Color(0xffd1fae4),
                                                      ),
                                                    ].separatedBy(SizedBox(
                                                      height: 8,
                                                    )),
                                                  ),
                                                ].separatedBy(SizedBox(
                                                  height: 8,
                                                )),
                                              ),
                                            ))
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CustomCard(
                          color: Colors.green.shade100,
                          child: Padding(
                            padding: PaddingColumn.screen,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.warning_outlined),
                                Text(
                                    'Mesin Sedang Digunakan (${filteredUnavailable.length.toString()})')
                              ].separatedBy(SizedBox(
                                width: 8,
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: filteredUnavailable.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Center(child: NoData()))
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (int i = 0;
                                          i < filteredUnavailable.length;
                                          i++)
                                        CustomCard(
                                            withBorder: true,
                                            child: Padding(
                                              padding: PaddingColumn.screen,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomBadge(
                                                        status:
                                                            filteredUnavailable[
                                                                i]['code'],
                                                        title:
                                                            filteredUnavailable[
                                                                i]['code']!,
                                                        withDifferentColor:
                                                            true,
                                                        color:
                                                            Color(0xffeaeaec),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                              filteredUnavailable[
                                                                      i]
                                                                  ['location']),
                                                        ].separatedBy(SizedBox(
                                                          width: 4,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .local_laundry_service_outlined,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                              filteredUnavailable[
                                                                  i]['name']),
                                                        ].separatedBy(SizedBox(
                                                          width: 4,
                                                        )),
                                                      ),
                                                      CustomBadge(
                                                        status:
                                                            filteredUnavailable[
                                                                    i][
                                                                'process_type'],
                                                        title:
                                                            filteredUnavailable[
                                                                    i][
                                                                'process_type']!,
                                                        withDifferentColor:
                                                            true,
                                                        color:
                                                            Color(0xffd1fae4),
                                                      ),
                                                    ].separatedBy(SizedBox(
                                                      height: 8,
                                                    )),
                                                  ),
                                                ].separatedBy(SizedBox(
                                                  height: 8,
                                                )),
                                              ),
                                            ))
                                    ],
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            // SizedBox(
            //     height: 500,
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //           flex: 1,
            //           child: filteredAvailable.isEmpty
            //               ? SizedBox(
            //                   height: MediaQuery.of(context).size.height * 0.7,
            //                   child: Center(child: NoData()))
            //               : SingleChildScrollView(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       for (int i = 0;
            //                           i < filteredAvailable.length;
            //                           i++)
            //                         CustomCard(
            //                             withBorder: true,
            //                             child: Padding(
            //                               padding: PaddingColumn.screen,
            //                               child: Column(
            //                                 children: [
            //                                   Row(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.center,
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceBetween,
            //                                     children: [
            //                                       CustomBadge(
            //                                         status: filteredAvailable[i]
            //                                             ['code'],
            //                                         title: filteredAvailable[i]
            //                                             ['code']!,
            //                                         withDifferentColor: true,
            //                                         color: Color(0xffeaeaec),
            //                                       ),
            //                                       Row(
            //                                         children: [
            //                                           Icon(
            //                                             Icons
            //                                                 .location_on_outlined,
            //                                             size: 16,
            //                                           ),
            //                                           Text(filteredAvailable[i]
            //                                               ['location']),
            //                                         ].separatedBy(SizedBox(
            //                                           width: 4,
            //                                         )),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   Row(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.center,
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceBetween,
            //                                     children: [
            //                                       Row(
            //                                         children: [
            //                                           Icon(
            //                                             Icons
            //                                                 .local_laundry_service_outlined,
            //                                             size: 16,
            //                                           ),
            //                                           Text(filteredAvailable[i]
            //                                               ['name']),
            //                                         ].separatedBy(SizedBox(
            //                                           width: 4,
            //                                         )),
            //                                       ),
            //                                       CustomBadge(
            //                                         status: filteredAvailable[i]
            //                                             ['process_type'],
            //                                         title: filteredAvailable[i]
            //                                             ['process_type']!,
            //                                         withDifferentColor: true,
            //                                         color: Color(0xffd1fae4),
            //                                       ),
            //                                     ].separatedBy(SizedBox(
            //                                       height: 8,
            //                                     )),
            //                                   ),
            //                                 ].separatedBy(SizedBox(
            //                                   height: 8,
            //                                 )),
            //                               ),
            //                             ))
            //                     ],
            //                   ),
            //                 ),
            //         ),
            //         Expanded(
            //           flex: 1,
            //           child: filteredUnavailable.isEmpty
            //               ? SizedBox(
            //                   height: MediaQuery.of(context).size.height * 0.7,
            //                   child: Center(child: NoData()))
            //               : SingleChildScrollView(
            //                   child: Column(
            //                     children: [
            //                       for (int i = 0;
            //                           i < filteredUnavailable.length;
            //                           i++)
            //                         CustomCard(
            //                             withBorder: true,
            //                             child: Padding(
            //                               padding: PaddingColumn.screen,
            //                               child: Column(
            //                                 children: [
            //                                   Row(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.center,
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceBetween,
            //                                     children: [
            //                                       CustomBadge(
            //                                         status:
            //                                             filteredUnavailable[i]
            //                                                 ['code'],
            //                                         title:
            //                                             filteredUnavailable[i]
            //                                                 ['code']!,
            //                                         withDifferentColor: true,
            //                                         color: Color(0xffeaeaec),
            //                                       ),
            //                                       Row(
            //                                         children: [
            //                                           Icon(
            //                                             Icons
            //                                                 .location_on_outlined,
            //                                             size: 16,
            //                                           ),
            //                                           Text(
            //                                               filteredUnavailable[i]
            //                                                   ['location']),
            //                                         ].separatedBy(SizedBox(
            //                                           width: 4,
            //                                         )),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                   Row(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.center,
            //                                     mainAxisAlignment:
            //                                         MainAxisAlignment
            //                                             .spaceBetween,
            //                                     children: [
            //                                       Row(
            //                                         children: [
            //                                           Icon(
            //                                             Icons
            //                                                 .local_laundry_service_outlined,
            //                                             size: 16,
            //                                           ),
            //                                           Text(
            //                                               filteredUnavailable[i]
            //                                                   ['name']),
            //                                         ].separatedBy(SizedBox(
            //                                           width: 4,
            //                                         )),
            //                                       ),
            //                                       CustomBadge(
            //                                         status:
            //                                             filteredUnavailable[i]
            //                                                 ['process_type'],
            //                                         title:
            //                                             filteredUnavailable[i]
            //                                                 ['process_type']!,
            //                                         withDifferentColor: true,
            //                                         color: Color(0xffd1fae4),
            //                                       ),
            //                                     ].separatedBy(SizedBox(
            //                                       height: 8,
            //                                     )),
            //                                   ),
            //                                 ].separatedBy(SizedBox(
            //                                   height: 8,
            //                                 )),
            //                               ),
            //                             ))
            //                     ],
            //                   ),
            //                 ),
            //         ),
            //       ],
            //     ))
          ].separatedBy(SizedBox(
            height: 16,
          )),
        )),
      ],
    );
  }
}
