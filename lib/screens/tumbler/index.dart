// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/dialog/action_dialog.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/card/item_process_card.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/process/process_list.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/models/process/tumbler.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/tumbler/%5Btumbler_id%5D.dart';
import 'package:textile_tracking/screens/tumbler/create/create_tumbler.dart';
import 'package:textile_tracking/screens/tumbler/finish/finish_tumbler.dart';

class TumblerScreen extends StatefulWidget {
  const TumblerScreen({super.key});

  @override
  State<TumblerScreen> createState() => _TumblerScreenState();
}

class _TumblerScreenState extends State<TumblerScreen> {
  final MenuService _menuService = MenuService();
  final UserMenu _userMenu = UserMenu();

  bool _isFiltered = false;
  bool _firstLoading = true;
  bool _hasMore = true;
  bool _canRead = false;
  bool _canDelete = false;
  bool _canUpdate = false;
  bool _isLoadMore = false;
  bool _showFab = true;
  bool _menuLoaded = false;

  final ValueNotifier<bool> _deleteLoading = ValueNotifier(false);

  final List<dynamic> _dataList = [];
  String _search = '';
  Map<String, String> params = {'search': '', 'page': '0'};

  Timer? _debounce;

  String dariTanggal = '';
  String sampaiTanggal = '';

  @override
  void initState() {
    super.initState();

    params = {
      'search': _search,
      'page': '0',
      'start_date': '',
      'end_date': '',
    };

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
    await _menuService.handleFetchMenu(context);
    await _userMenu.handleLoadMenu();

    if (!mounted) return;

    setState(() {
      _canRead = _userMenu.checkMenu('Tumbler', 'read');
      _canDelete = _userMenu.checkMenu('Tumbler', 'delete');
      _canUpdate = _userMenu.checkMenu('Tumbler', 'update');

      _menuLoaded = true;

      if (_canRead) {
        _loadMore();
      }
    });
  }

  Future<void> _handleSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
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

  Future<void> _loadMore() async {
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

    await Provider.of<TumblerService>(context, listen: false)
        .getDataList(context, params);

    List<dynamic> loadData =
        Provider.of<TumblerService>(context, listen: false).items;

    if (loadData.isEmpty) {
      setState(() {
        _firstLoading = false;
        _hasMore = false;
      });
    } else {
      setState(() {
        _dataList.addAll(loadData);
        _firstLoading = false;
      });
    }
  }

  _refetch() {
    _debounce?.cancel();
    setState(() {
      _search = '';
      dariTanggal = '';
      sampaiTanggal = '';
      _isFiltered = false;

      params = {
        'search': '',
        'page': '0',
        'start_date': '',
        'end_date': '',
      };
    });

    _loadMore();
  }

  Future<void> _openProcessDetail(
    dynamic item, {
    bool openUpdateOnStart = false,
  }) async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TumblerDetail(
          id: item['id'].toString(),
          no: item['tumbler_no'].toString(),
          canDelete: _canDelete,
          canUpdate: _canUpdate,
        ),
      ),
    );

    if (value == true) {
      _refetch();
    }
  }

  Future<void> _handleDeleteItem(dynamic item) async {
    if (item['can_delete'] == false) {
      await showAlertDialog(
        context: context,
        title: 'Tidak Bisa Hapus',
        message:
            'Proses tidak bisa dihapus karena sudah diproses di proses selanjutnya.',
      );
      return;
    }

    showConfirmationDialog(
      context: context,
      title: 'Hapus Data',
      message: 'Apakah Anda yakin ingin menghapus proses?',
      isLoading: _deleteLoading,
      buttonBackground: CustomTheme().buttonColor('danger'),
      onConfirm: () async {
        try {
          final message =
              await Provider.of<TumblerService>(context, listen: false)
                  .deleteItem(context, item['id'].toString(), _deleteLoading);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          await showAlertDialog(
            context: context,
            title: 'Tumbler Deleted',
            message: message,
          );
          _refetch();
        } catch (e) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          await showAlertDialog(
            context: context,
            title: 'Error',
            message: e.toString(),
          );
        }
      },
    );
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
          title: 'Tumbler',
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
        ),
        body: !_menuLoaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: NotificationListener(
                  onNotification: (notification) {
                    if (notification is UserScrollNotification) {
                      if (notification.direction == ScrollDirection.reverse) {
                        if (_showFab) {
                          setState(() => _showFab = false);
                        }
                      } else if (notification.direction ==
                          ScrollDirection.forward) {
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
                          Provider.of<TumblerService>(context, listen: false);
                      await service.getDataList(context, params);
                      return service.items;
                    },
                    isLoadMore: _isLoadMore,
                    canRead: _canRead,
                    itemBuilder: (item) => ItemProcessCard(
                      label: 'No. Tumbler',
                      item: item,
                      titleKey: 'tumbler_no',
                      subtitleKey: 'work_orders',
                      subtitleField: 'wo_no',
                      canUpdate: _canUpdate,
                      canDelete: _canDelete,
                    ),
                    onItemTap: (context, item) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TumblerDetail(
                              id: item['id'].toString(),
                              no: item['tumbler_no'].toString(),
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
                      params: params,
                      onHandleFilter: _handleFilter,
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
              ),
        floatingActionButton: AnimatedSlide(
          duration: Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : Offset(0, 1),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: CustomFloatingButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final actions = [
                        DialogActionItem(
                          icon: Icons.add,
                          iconColor: CustomTheme().buttonColor('primary'),
                          title: 'Mulai Tumbler',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateTumbler(),
                              ),
                            );
                          },
                        ),
                        DialogActionItem(
                          icon: Icons.task_alt_outlined,
                          iconColor: CustomTheme().buttonColor('warning'),
                          title: 'Selesai Tumbler',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FinishTumbler(),
                              ),
                            );
                          },
                        ),
                      ];
                      return ActionDialog(actions: actions);
                    },
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 72,
                )),
          ),
        ),
      ),
    );
  }
}
