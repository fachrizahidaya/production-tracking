// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/card/item_process_card.dart';
import 'package:textile_tracking/components/master/layout/list/process_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/models/process/long_sitting.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/long-sitting/%5Blong_sitting_id%5D.dart';
import 'package:textile_tracking/screens/long-sitting/create/create_long_sitting.dart';
import 'package:textile_tracking/screens/long-sitting/finish/finish_long_sitting.dart';

class LongSittingScreen extends StatefulWidget {
  const LongSittingScreen({super.key});

  @override
  State<LongSittingScreen> createState() => _LongSittingScreenState();
}

class _LongSittingScreenState extends State<LongSittingScreen> {
  final MenuService _menuService = MenuService();
  final UserMenu _userMenu = UserMenu();

  bool _isFiltered = false;
  bool _firstLoading = true;
  bool _hasMore = true;
  bool _canRead = false;
  bool _canCreate = false;
  bool _canDelete = false;
  bool _canUpdate = false;
  bool _isLoadMore = false;

  final List<dynamic> _dataList = [];
  String _search = '';
  Map<String, String> params = {'search': '', 'page': '0'};

  Timer? _debounce;

  String dariTanggal = '';
  String sampaiTanggal = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      params = {
        'search': _search,
        'page': '0',
        'start_date': '',
        'end_date': '',
      };
    });
    Future.delayed(Duration.zero, () {
      _loadMore();
    });
    _intializeMenus();
  }

  bool _checkIsFiltered() {
    final filterKeys = [
      'status',
      'user_id',
      'start_date',
      'end_date',
    ];

    for (var key in filterKeys) {
      if (params[key] != null && params[key]!.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  Future<void> _intializeMenus() async {
    try {
      await _menuService.handleFetchMenu();
      await _userMenu.handleLoadMenu();

      setState(() {
        _canRead = _userMenu.checkMenu('Long Sitting', 'read');
        _canCreate = _userMenu.checkMenu('Long Sitting', 'create');
        _canDelete = _userMenu.checkMenu('Long Sitting', 'delete');
        _canUpdate = _userMenu.checkMenu('Long Sitting', 'update');
      });
    } catch (e) {
      throw Exception('Error initializing menus: $e');
    }
  }

  Future<void> _handleSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _search = value;
        params['search'] = value;
        params['page'] = '0';
      });
      _loadMore();
    });
  }

  Future<void> _handleFilter(key, value) async {
    setState(() {
      params['page'] = '0';
      if (value.toString() != '') {
        params[key.toString()] = value.toString();
      } else {
        params.remove(key.toString());
      }
    });

    _isFiltered = _checkIsFiltered();

    _loadMore();
  }

  Future<void> _submitFilter() async {
    Navigator.pop(context);
    setState(() {
      _isFiltered = _checkIsFiltered();
    });
    _loadMore();
  }

  Future<void> _loadMore() async {
    _isLoadMore = true;

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    String newPage = (int.parse(params['page']!) + 1).toString();
    setState(() {
      params['page'] = newPage;
    });

    await Provider.of<LongSittingService>(context, listen: false)
        .getDataList(params);

    List<dynamic> loadData =
        Provider.of<LongSittingService>(context, listen: false).items;

    if (loadData.isEmpty) {
      setState(() {
        _firstLoading = false;
        _isLoadMore = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _dataList.addAll(loadData);
        _firstLoading = false;
        _isLoadMore = false;
      });
    }
  }

  _refetch() {
    setState(() {
      params = {
        'search': _search,
        'page': '0',
        'start_date': dariTanggal,
        'end_date': sampaiTanggal,
      };
    });
    _loadMore();
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Long Sitting',
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
                final service =
                    Provider.of<LongSittingService>(context, listen: false);
                await service.getDataList(params);
                return service.items;
              },
              isLoadMore: _isLoadMore,
              service: LongSittingService(),
              searchQuery: _search,
              canCreate: _canCreate,
              canRead: _canRead,
              itemBuilder: (item) => ItemProcessCard(
                useCustomSize: true,
                customWidth: 930.0,
                customHeight: null,
                label: 'No. Long Sitting',
                item: item,
                titleKey: 'ls_no',
                subtitleKey: 'work_orders',
                subtitleField: 'wo_no',
                isRework: (item) => item['rework'] == false,
                getStartTime: (item) => formatDateSafe(item['start_time']),
                getEndTime: (item) => formatDateSafe(item['end_time']),
                getStartBy: (item) => item['start_by']?['name'] ?? '',
                getEndBy: (item) => item['end_by']?['name'] ?? '',
                getStatus: (item) => item['status'] ?? '-',
                customBadgeBuilder: (status) => CustomBadge(
                    title: status,
                    withStatus: true,
                    status: item['status'],
                    withDifferentColor: true,
                    color: status == 'Diproses'
                        ? Color(0xFFfff3c6)
                        : Color(0xffd1fae4)),
              ),
              onItemTap: (context, item) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LongSittingDetail(
                        id: item['id'].toString(),
                        no: item['ls_no'].toString(),
                        canDelete: _canDelete,
                        canUpdate: _canUpdate,
                      ),
                    )).then((value) {
                  if (value == true) {
                    _refetch();
                  } else {
                    return null;
                  }
                });
              },
              filterWidget: ListFilter(
                title: 'Filter',
                params: params,
                onHandleFilter: _handleFilter,
                onSubmitFilter: () {
                  _submitFilter();
                },
                fetchMachine: (service) => service.fetchOptionsLongSitting(),
                getMachineOptions: (service) => service.dataListOption,
                dariTanggal: dariTanggal,
                sampaiTanggal: sampaiTanggal,
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
                              title: Text("Mulai Long Sitting"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CreateLongSitting(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.check_circle,
                                  color: CustomTheme().buttonColor('warning')),
                              title: Text("Selesai Long Sitting"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FinishLongSitting(),
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
              firstLoading: _firstLoading,
              isFiltered: _isFiltered,
              hasMore: _hasMore,
              handleLoadMore: _loadMore,
              handleRefetch: _refetch,
              handleSearch: _handleSearch,
              dataList: _dataList,
            ))
          ],
        ),
        floatingActionButton: CustomFloatingButton(
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
                                color: CustomTheme().buttonColor('primary')),
                            title: Text("Mulai Long Sitting"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateLongSitting(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.check_circle,
                                color: CustomTheme().buttonColor('warning')),
                            title: Text("Selesai Long Sitting"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FinishLongSitting(),
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
            icon: Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}
