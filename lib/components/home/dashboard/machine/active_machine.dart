import 'package:flutter/material.dart';
import 'package:textile_tracking/components/home/dashboard/card/dasboard_card.dart';
import 'package:textile_tracking/helpers/util/padding_column.dart';

class ActiveMachine extends StatefulWidget {
  final data;
  final available;
  final unavailable;

  const ActiveMachine({super.key, this.data, this.available, this.unavailable});

  @override
  State<ActiveMachine> createState() => _ActiveMachineState();
}

class _ActiveMachineState extends State<ActiveMachine> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DasboardCard(
            child: Padding(
          padding: PaddingColumn.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Status Mesin'),
                  ),
                ],
              )
            ],
          ),
        )),
        SizedBox(
            height: 500,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  child: DasboardCard(
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widget.available?.length; i++)
                            DasboardCard(
                                child: Padding(
                              padding: PaddingColumn.screen,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.available[i]['name']),
                                  Text(widget.available[i]['location']),
                                ],
                              ),
                            ))
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: DasboardCard(
                    child: Padding(
                      padding: PaddingColumn.screen,
                      child: Column(
                        children: [
                          for (int i = 0; i < widget.unavailable?.length; i++)
                            DasboardCard(
                                child: Padding(
                              padding: PaddingColumn.screen,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.unavailable[i]['name']),
                                  Text(widget.unavailable[i]['location']),
                                ],
                              ),
                            ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
