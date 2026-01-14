// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/dialog/action_dialog.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/card/item_process_card.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/process_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/item_field.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/screens/dyeing/%5Bdyeing_id%5D.dart';
import 'package:textile_tracking/screens/dyeing/create/create_dyeing.dart';
import 'package:textile_tracking/screens/dyeing/finish/finish_dyeing.dart';
import 'package:textile_tracking/screens/dyeing/rework/rework_dyeing.dart';

class DyeingScreen extends StatefulWidget {
  const DyeingScreen({super.key});

  @override
  State<DyeingScreen> createState() => _DyeingScreenState();
}

class _DyeingScreenState extends State<DyeingScreen> {
  final MenuService _menuService = MenuService();
  final UserMenu _userMenu = UserMenu();

  bool _isFiltered = false;

  bool _firstLoading = true;
  bool _hasMore = true;
  bool _canRead = false;
  bool _canDelete = false;
  bool _isLoadMore = false;
  bool _canUpdate = false;
  bool _showFab = true;

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
    await _menuService.handleFetchMenu();
    await _userMenu.handleLoadMenu();

    setState(() {
      _canRead = _userMenu.checkMenu('Dyeing', 'read');
      _canDelete = _userMenu.checkMenu('Dyeing', 'delete');
      _canUpdate = _userMenu.checkMenu('Dyeing', 'update');
    });
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

    await Provider.of<DyeingService>(context, listen: false)
        .getDataList(params);

    List<dynamic> loadData =
        Provider.of<DyeingService>(context, listen: false).items;

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
        backgroundColor: const Color(0xFFf9fafc),
        appBar: CustomAppBar(
          title: 'Dyeing',
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              if (notification.direction == ScrollDirection.reverse) {
                // scrolling down
                if (_showFab) {
                  setState(() => _showFab = false);
                }
              } else if (notification.direction == ScrollDirection.forward) {
                // scrolling up
                if (!_showFab) {
                  setState(() => _showFab = true);
                }
              }
            }
            return false;
          },
          child: ProcessList(
            fetchData: (params) async {
              final service =
                  Provider.of<DyeingService>(context, listen: false);
              await service.getDataList(params);
              return service.items;
            },
            canRead: _canRead,
            isLoadMore: _isLoadMore,
            itemBuilder: (item) => ItemProcessCard(
              label: 'No. Dyeing',
              item: item,
              titleKey: 'dyeing_no',
              subtitleKey: 'work_orders',
              subtitleField: 'wo_no',
              itemField: ItemField.get,
              nestedField: ItemField.nested,
            ),
            onItemTap: (context, item) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DyeingDetail(
                      id: item['id'].toString(),
                      no: item['dyeing_no'].toString(),
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
              fetchMachine: (service) => service.fetchOptionsDyeing(),
              getMachineOptions: (service) => service.dataListOption,
              dariTanggal: dariTanggal,
              sampaiTanggal: sampaiTanggal,
            ),
            firstLoading: _firstLoading,
            isFiltered: _isFiltered,
            hasMore: _hasMore,
            handleLoadMore: _loadMore,
            handleRefetch: _refetch,
            handleSearch: _handleSearch,
            dataList: _dataList,
          ),
        ),
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: CustomFloatingButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final actions = [
                      DialogActionItem(
                        icon: Icons.add_outlined,
                        iconColor: CustomTheme().buttonColor('primary'),
                        title: 'Mulai Dyeing',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateDyeing(),
                            ),
                          );
                        },
                      ),
                      DialogActionItem(
                        icon: Icons.check_circle_outline,
                        iconColor: CustomTheme().buttonColor('warning'),
                        title: 'Selesai Dyeing',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const FinishDyeing(),
                            ),
                          );
                        },
                      ),
                      DialogActionItem(
                        icon: Icons.replay_outlined,
                        iconColor: CustomTheme().buttonColor('danger'),
                        title: 'Rework Dyeing',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ReworkDyeing(),
                            ),
                          );
                        },
                      ),
                    ];
                    return ActionDialog(actions: actions);
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
