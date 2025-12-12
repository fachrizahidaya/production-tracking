// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
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
import 'package:textile_tracking/models/process/long_hemming.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/long-hemming/%5Blong_hemming_id%5D.dart';
import 'package:textile_tracking/screens/long-hemming/create/create_long_hemming.dart';
import 'package:textile_tracking/screens/long-hemming/finish/finish_long_hemming.dart';

class LongHemmingScreen extends StatefulWidget {
  const LongHemmingScreen({super.key});

  @override
  State<LongHemmingScreen> createState() => _LongHemmingScreenState();
}

class _LongHemmingScreenState extends State<LongHemmingScreen> {
  final MenuService _menuService = MenuService();
  final UserMenu _userMenu = UserMenu();
  bool _isFiltered = false;
  bool avaiableCreate = false;
  bool _firstLoading = true;
  final List<dynamic> _dataList = [];

  bool _hasMore = true;
  bool _canRead = false;
  bool _canCreate = false;
  bool _canDelete = false;
  bool _canUpdate = false;
  bool _isLoading = false;
  bool _isLoadMore = false;
  String _search = '';
  Timer? _debounce;
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

  String dariTanggal = '';
  String sampaiTanggal = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final today = now;

    dariTanggal = DateFormat('yyyy-MM-dd').format(firstDayOfMonth);
    sampaiTanggal = DateFormat('yyyy-MM-dd').format(today);
    setState(() {
      params = {
        'search': _search,
        'page': '0',
        'start_date': dariTanggal,
        'end_date': sampaiTanggal,
      };
    });
    Future.delayed(Duration.zero, () {
      _loadMore();
    });
    _intializeMenus();
  }

  Future<void> _intializeMenus() async {
    try {
      await _menuService.handleFetchMenu();
      await _userMenu.handleLoadMenu();

      setState(() {
        _canRead = _userMenu.checkMenu('Long Hemming', 'read');
        _canCreate = _userMenu.checkMenu('Long Hemming', 'create');
        _canDelete = _userMenu.checkMenu('Long Hemming', 'delete');
        _canUpdate = _userMenu.checkMenu('Long Hemming', 'update');
      });
    } catch (e) {
      throw Exception('Error initializing menus: $e');
    }
  }

  Future<void> _handleSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        params = {'search': value, 'page': '0'};
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

    if (params['start_date'] == null &&
        params['end_date'] == null &&
        params['user_id'] == null &&
        params['status'] == null) {
      setState(() {
        _isFiltered = false;
      });
    } else {
      setState(() {
        _isFiltered = true;
      });
    }

    _loadMore();
  }

  Future<void> _submitFilter() async {
    Navigator.pop(context);
    _loadMore();
  }

  Future<void> _loadMore() async {
    _isLoadMore = true;

    _isLoading = true;

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

    await Provider.of<LongHemmingService>(context, listen: false)
        .getDataList(params);

    // ignore: use_build_context_synchronously
    List<dynamic> loadData =
        // ignore: use_build_context_synchronously
        Provider.of<LongHemmingService>(context, listen: false).items;

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

    _isLoading = false;
  }

  _refetch() {
    Future.delayed(Duration.zero, () {
      if (_isFiltered) {
        setState(() {
          _isFiltered = false;
        });
      }

      setState(() {
        params = {
          'search': _search,
          'page': '0',
          'start_date': dariTanggal,
          'end_date': sampaiTanggal,
        };
      });
      _loadMore();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Long Hemming',
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
                    Provider.of<LongHemmingService>(context, listen: false);
                await service.getDataList(params);
                return service.items;
              },
              isLoadMore: _isLoadMore,
              service: LongHemmingService(),
              searchQuery: _search,
              canCreate: _canCreate,
              canRead: _canRead,
              itemBuilder: (item) => ItemProcessCard(
                useCustomSize: true,
                customWidth: 930.0,
                customHeight: null,
                label: 'No. Long Hemming ',
                item: item,
                titleKey: 'lh_no',
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
                    status: item.status,
                    withDifferentColor: true,
                    color: status == 'Diproses'
                        ? Color(0xFFfff3c6)
                        : Color(0xffd1fae4)),
              ),
              onItemTap: (context, item) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LongHemmingDetail(
                        id: item.id.toString(),
                        no: item.lh_no.toString(),
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
                fetchMachine: (service) => service.fetchOptionsLongHemming(),
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.add,
                                  color: CustomTheme().buttonColor('primary')),
                              title: const Text("Mulai Long Hemming"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateLongHemming(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.check_circle,
                                  color: CustomTheme().buttonColor('warning')),
                              title: const Text("Selesai Long Hemming"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FinishLongHemming(),
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
        bottomNavigationBar: isPortrait
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.add,
                                    color:
                                        CustomTheme().buttonColor('primary')),
                                title: const Text("Mulai Long Hemming"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateLongHemming(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.check_circle,
                                    color:
                                        CustomTheme().buttonColor('warning')),
                                title: const Text("Selesai Long Hemming"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FinishLongHemming(),
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
