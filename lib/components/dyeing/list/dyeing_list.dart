import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/dyeing/card/item_dyeing.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/list/main_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/screens/dyeing/%5Bdyeing_id%5D.dart';
import 'package:textile_tracking/screens/dyeing/create/create_dyeing.dart';
import 'package:textile_tracking/screens/dyeing/finish/finish_dyeing.dart';
import 'package:textile_tracking/screens/dyeing/rework/rework_dyeing.dart';

class DyeingList extends StatefulWidget {
  final search;
  final canCreate;
  final canRead;
  final canDelete;
  final canUpdate;
  final refetch;
  final params;
  final hasMore;
  final loadMore;
  final isLoadMore;
  final isFiltered;
  final firstLoading;
  final isPortrait;
  final handleFilter;
  final handleSearch;
  final submitFilter;
  final dataList;
  final dariTanggal;
  final sampaiTanggal;

  const DyeingList(
      {super.key,
      this.search,
      this.canCreate,
      this.canDelete,
      this.canRead,
      this.canUpdate,
      this.refetch,
      this.isPortrait,
      this.params,
      this.handleFilter,
      this.submitFilter,
      this.hasMore,
      this.isFiltered,
      this.loadMore,
      this.dataList,
      this.handleSearch,
      this.firstLoading,
      this.dariTanggal,
      this.sampaiTanggal,
      this.isLoadMore});

  @override
  State<DyeingList> createState() => _DyeingListState();
}

class _DyeingListState extends State<DyeingList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      // child: Scaffold(
      //   backgroundColor: const Color(0xFFf9fafc),
      //   appBar: CustomAppBar(
      //     title: 'Pencelupan (Dyeing)',
      //     onReturn: () {
      //       if (Navigator.canPop(context)) {
      //         Navigator.pop(context);
      //       } else {
      //         Navigator.pushReplacementNamed(context, '/dashboard');
      //       }
      //     },
      //   ),
      //   body: Column(
      //     children: [
      //       Expanded(
      //           child: MainList(
      //         fetchData: (params) async {
      //           final service =
      //               Provider.of<DyeingService>(context, listen: false);
      //           await service.getDataList(params);
      //           return service.dataList;
      //         },
      //         isLoadMore: widget.isLoadMore,
      //         service: DyeingService(),
      //         searchQuery: widget.search,
      //         canCreate: widget.canCreate,
      //         canRead: widget.canRead,
      //         itemBuilder: (item) {
      //           return Align(
      //             alignment: Alignment.centerLeft,
      //             child: ItemDyeing(
      //               useCustomSize: true,
      //               customWidth: 930.0,
      //               customHeight: null,
      //               item: item,
      //             ),
      //           );
      //         },
      //         onItemTap: (context, item) {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => DyeingDetail(
      //                   id: item.id.toString(),
      //                   no: item.dyeing_no.toString(),
      //                   canDelete: widget.canDelete,
      //                   canUpdate: widget.canUpdate,
      //                 ),
      //               )).then((value) {
      //             if (value == true) {
      //               widget.refetch();
      //             } else {
      //               return null;
      //             }
      //           });
      //         },
      //         filterWidget: ListFilter(
      //           title: 'Filter',
      //           params: widget.params,
      //           onHandleFilter: widget.handleFilter,
      //           onSubmitFilter: () {
      //             widget.submitFilter();
      //           },
      //           fetchMachine: (service) => service.fetchOptionsDyeing(),
      //           getMachineOptions: (service) => service.dataListOption,
      //           fetchOperators: null,
      //           getOperatorOptions: null,
      //           dariTanggal: widget.dariTanggal,
      //           sampaiTanggal: widget.sampaiTanggal,
      //         ),
      //         handleRefetch: widget.refetch,
      //         handleLoadMore: widget.loadMore,
      //         handleSearch: widget.handleSearch,
      //         dataList: widget.dataList,
      //         firstLoading: widget.firstLoading,
      //         hasMore: widget.hasMore,
      //         isFiltered: widget.isFiltered,
      //         showActions: () {
      //           showDialog(
      //             context: context,
      //             builder: (context) {
      //               return Dialog(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(8),
      //                 ),
      //                 insetPadding: const EdgeInsets.symmetric(
      //                     horizontal: 80, vertical: 80),
      //                 child: Padding(
      //                   padding: const EdgeInsets.symmetric(vertical: 8),
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       ListTile(
      //                         leading: Icon(Icons.add,
      //                             color: CustomTheme().buttonColor('primary')),
      //                         title: const Text("Mulai Dyeing"),
      //                         onTap: () {
      //                           Navigator.pop(context);
      //                           Navigator.of(context).push(
      //                             MaterialPageRoute(
      //                               builder: (context) => const CreateDyeing(),
      //                             ),
      //                           );
      //                         },
      //                       ),
      //                       const Divider(height: 1),
      //                       ListTile(
      //                         leading: Icon(Icons.check_circle,
      //                             color: CustomTheme().buttonColor('warning')),
      //                         title: const Text("Selesai Dyeing"),
      //                         onTap: () {
      //                           Navigator.pop(context);
      //                           Navigator.of(context).push(
      //                             MaterialPageRoute(
      //                               builder: (context) => const FinishDyeing(),
      //                             ),
      //                           );
      //                         },
      //                       ),
      //                       const Divider(height: 1),
      //                       ListTile(
      //                         leading: Icon(Icons.replay_outlined,
      //                             color: CustomTheme().buttonColor('warning')),
      //                         title: const Text("Rework Dyeing"),
      //                         onTap: () {
      //                           Navigator.pop(context);
      //                           Navigator.of(context).push(
      //                             MaterialPageRoute(
      //                               builder: (context) => const ReworkDyeing(),
      //                             ),
      //                           );
      //                         },
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ))
      //     ],
      //   ),
      //   bottomNavigationBar: widget.isPortrait
      //       ? CustomFloatingButton(
      //           onPressed: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) {
      //                 return Dialog(
      //                   insetPadding: const EdgeInsets.symmetric(
      //                       horizontal: 80, vertical: 80),
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(8),
      //                   ),
      //                   child: Padding(
      //                     padding: const EdgeInsets.symmetric(vertical: 8),
      //                     child: Column(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         ListTile(
      //                           leading: Icon(Icons.add,
      //                               color:
      //                                   CustomTheme().buttonColor('primary')),
      //                           title: const Text("Mulai Dyeing"),
      //                           onTap: () {
      //                             Navigator.pop(context);
      //                             Navigator.of(context).push(
      //                               MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     const CreateDyeing(),
      //                               ),
      //                             );
      //                           },
      //                         ),
      //                         const Divider(height: 1),
      //                         ListTile(
      //                           leading: Icon(Icons.check_circle,
      //                               color:
      //                                   CustomTheme().buttonColor('warning')),
      //                           title: const Text("Selesai Dyeing"),
      //                           onTap: () {
      //                             Navigator.pop(context);
      //                             Navigator.of(context).push(
      //                               MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     const FinishDyeing(),
      //                               ),
      //                             );
      //                           },
      //                         ),
      //                         const Divider(height: 1),
      //                         ListTile(
      //                           leading: Icon(Icons.replay_outlined,
      //                               color:
      //                                   CustomTheme().buttonColor('warning')),
      //                           title: const Text("Rework Dyeing"),
      //                           onTap: () {
      //                             Navigator.pop(context);
      //                             Navigator.of(context).push(
      //                               MaterialPageRoute(
      //                                 builder: (context) =>
      //                                     const ReworkDyeing(),
      //                               ),
      //                             );
      //                           },
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //           icon: const Icon(
      //             Icons.add,
      //             color: Colors.white,
      //             size: 128,
      //           ),
      //         )
      //       : null,
      // ),
    );
  }
}
