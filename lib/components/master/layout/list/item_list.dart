import 'package:flutter/material.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/layout/card/item_process_card.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/list/process_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';

class ItemList extends StatefulWidget {
  final dataList;
  final params;
  final search;
  final canCreate;
  final canUpdate;
  final canRead;
  final canDelete;
  final submitFilter;
  final handleFilter;
  final handleSearch;
  final refetch;
  final isPortrait;
  final isFiltered;
  final dariTanggal;
  final sampaiTanggal;
  final firstLoading;
  final loadMore;
  final hasMore;
  final processService;
  final screenDetail;
  final screenCreate;
  final screenFinish;
  final title;

  const ItemList(
      {super.key,
      this.canCreate,
      this.canDelete,
      this.canRead,
      this.canUpdate,
      this.dariTanggal,
      this.dataList,
      this.firstLoading,
      this.handleFilter,
      this.handleSearch,
      this.hasMore,
      this.isFiltered,
      this.isPortrait,
      this.loadMore,
      this.params,
      this.processService,
      this.refetch,
      this.sampaiTanggal,
      this.search,
      this.submitFilter,
      this.screenCreate,
      this.screenDetail,
      this.screenFinish,
      this.title});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: widget.title,
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
        ),
        body: Column(
          children: [
            Expanded(
                child: ProcessList(
              fetchData: (params) async {
                return await widget.processService.getDataList(params);
              },
              service: widget.processService(),
              searchQuery: widget.search,
              canCreate: widget.canCreate,
              canRead: widget.canRead,
              itemBuilder: (item) => Align(
                alignment: Alignment.centerLeft,
                child: ItemProcessCard(
                  useCustomSize: true,
                  customWidth: 930.0,
                  customHeight: null,
                  label: 'No. ${widget.title}',
                  item: item,
                  titleKey: 'pt_no',
                  subtitleKey: 'work_orders',
                  subtitleField: 'wo_no',
                  isRework: (item) => item.rework == false,
                  getStartTime: (item) => formatDateSafe(item.start_time),
                  getEndTime: (item) => formatDateSafe(item.end_time),
                  getStartBy: (item) => item.start_by?['name'] ?? '',
                  getEndBy: (item) => item.end_by?['name'] ?? '',
                  getStatus: (item) => item.status ?? '-',
                  customBadgeBuilder: (status) => CustomBadge(
                      title: status,
                      withStatus: true,
                      status: null,
                      withDifferentColor: true,
                      color: status == 'Diproses'
                          ? Color(0xFFfff3c6)
                          : Color(0xffd1fae4)),
                ),
              ),
              onItemTap: (context, item) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.screenDetail(
                        id: null,
                        no: null,
                        canDelete: widget.canDelete,
                        canUpdate: widget.canUpdate,
                      ),
                    )).then((value) {
                  if (value == true) {
                    widget.refetch();
                  } else {
                    return null;
                  }
                });
              },
              filterWidget: ListFilter(
                title: 'Filter',
                params: widget.params,
                onHandleFilter: widget.handleFilter,
                onSubmitFilter: () {
                  widget.submitFilter();
                },
                fetchMachine: (service) => service.fetchOptionsPressTumbler(),
                getMachineOptions: (service) => service.dataListOption,
                dariTanggal: widget.dariTanggal,
                sampaiTanggal: widget.sampaiTanggal,
              ),
              showActions: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.add,
                                  color: CustomTheme().buttonColor('primary')),
                              title: Text('Mulai ${widget.title}'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => widget.screenCreate(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.check_circle,
                                  color: CustomTheme().buttonColor('warning')),
                              title: Text('Selesai ${widget.title}'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => widget.screenFinish(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              firstLoading: widget.firstLoading,
              isFiltered: widget.isFiltered,
              hasMore: widget.hasMore,
              handleLoadMore: widget.loadMore,
              handleRefetch: widget.refetch,
              handleSearch: widget.handleSearch,
              dataList: widget.dataList,
            ))
          ],
        ),
        bottomNavigationBar: widget.isPortrait
            ? CustomFloatingButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.add,
                                    color:
                                        CustomTheme().buttonColor('primary')),
                                title: Text("Mulai ${widget.title}"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          widget.screenCreate(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.check_circle,
                                    color:
                                        CustomTheme().buttonColor('warning')),
                                title: Text("Selesai ${widget.title}"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          widget.screenFinish(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 128,
                ))
            : null,
      ),
    );
  }
}
