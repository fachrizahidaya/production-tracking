<<<<<<< HEAD
<<<<<<< HEAD
// ignore_for_file: use_build_context_synchronously

=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
// ignore_for_file: use_build_context_synchronously

>>>>>>> d8439a4 (fix: refactor code)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/appbar/custom_app_bar.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/card/item_process_card.dart';
import 'package:textile_tracking/components/master/dialog/action_dialog.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/components/process/process_list.dart';
import 'package:textile_tracking/helpers/result/show_alert_dialog.dart';
import 'package:textile_tracking/helpers/result/show_confirmation_dialog.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/weaving/create/create_weaving.dart';
import 'package:textile_tracking/screens/weaving/detail/edit_weaving.dart';
=======
import 'package:textile_tracking/helpers/util/item_field.dart';
=======
>>>>>>> d8439a4 (fix: refactor code)
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/weaving/create/create_weaving.dart';
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
import 'package:textile_tracking/screens/weaving/detail/weaving_by_id.dart';
import 'package:textile_tracking/screens/weaving/finish/finish_weaving.dart';
import 'package:textile_tracking/screens/weaving/model/weaving.dart';

class WeavingScreen extends StatefulWidget {
  const WeavingScreen({super.key});

  @override
  State<WeavingScreen> createState() => _WeavingScreenState();
}

class _WeavingScreenState extends State<WeavingScreen> {
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
<<<<<<< HEAD
<<<<<<< HEAD
  bool _menuLoaded = false;
=======
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
  bool _menuLoaded = false;
>>>>>>> d8439a4 (fix: refactor code)

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

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d8439a4 (fix: refactor code)
    params = {
      'search': _search,
      'page': '0',
      'start_date': '',
      'end_date': '',
    };

<<<<<<< HEAD
=======
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
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> d8439a4 (fix: refactor code)
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
<<<<<<< HEAD
<<<<<<< HEAD
    await _menuService.handleFetchMenu(context);
    await _userMenu.handleLoadMenu();

    if (!mounted) return;

    setState(() {
      _canRead = _userMenu.checkMenu('Weaving', 'read');
      _canDelete = _userMenu.checkMenu('Weaving', 'delete');
      _canUpdate = _userMenu.checkMenu('Weaving', 'update');

      _menuLoaded = true;

      if (_canRead) {
        _loadMore();
      }
    });
=======
    try {
      await _menuService.handleFetchMenu(context);
      await _userMenu.handleLoadMenu();

      setState(() {
        _canRead = _userMenu.checkMenu('Weaving', 'read');
        _canDelete = _userMenu.checkMenu('Weaving', 'delete');
        _canUpdate = _userMenu.checkMenu('Weaving', 'update');
      });
    } catch (e) {
      throw Exception('Error initializing menus: $e');
    }
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
    await _menuService.handleFetchMenu(context);
    await _userMenu.handleLoadMenu();

    if (!mounted) return;

    setState(() {
      _canRead = _userMenu.checkMenu('Weaving', 'read');
      _canDelete = _userMenu.checkMenu('Weaving', 'delete');
      _canUpdate = _userMenu.checkMenu('Weaving', 'update');

      _menuLoaded = true;

      if (_canRead) {
        _loadMore();
      }
    });
>>>>>>> d8439a4 (fix: refactor code)
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

<<<<<<< HEAD
<<<<<<< HEAD
  Future<void> _loadMore() async {
=======
  Future<void> _submitFilter() async {
    Navigator.pop(context);
    setState(() {
      _isFiltered = _checkIsFiltered();
    });
    _loadMore();
  }

  Future<void> _loadMore() async {
    _isLoadMore = true;

>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
  Future<void> _loadMore() async {
>>>>>>> d8439a4 (fix: refactor code)
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

    await Provider.of<WeavingService>(context, listen: false)
        .getDataList(context, params);

    List<dynamic> loadData =
        Provider.of<WeavingService>(context, listen: false).items;

    if (loadData.isEmpty) {
      setState(() {
        _firstLoading = false;
<<<<<<< HEAD
<<<<<<< HEAD
=======
        _isLoadMore = false;
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> d8439a4 (fix: refactor code)
        _hasMore = false;
      });
    } else {
      setState(() {
        _dataList.addAll(loadData);
        _firstLoading = false;
<<<<<<< HEAD
<<<<<<< HEAD
=======
        _isLoadMore = false;
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
>>>>>>> d8439a4 (fix: refactor code)
      });
    }
  }

  _refetch() {
<<<<<<< HEAD
<<<<<<< HEAD
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

=======
=======
    _debounce?.cancel();
>>>>>>> d8439a4 (fix: refactor code)
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
<<<<<<< HEAD
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======

>>>>>>> d8439a4 (fix: refactor code)
    _loadMore();
  }

  Future<void> _openProcessDetail(
    dynamic item, {
    bool openUpdateOnStart = false,
  }) async {
<<<<<<< HEAD
    final status = item['status']?.toString().toLowerCase() ?? '';
    final isInProgress = status == 'diproses' || status.contains('diproses');

    final value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (isInProgress) {
            return EditWeavingScreen(id: item['id'].toString());
          }

          return WeavingDetailScreen(
            id: item['id'].toString(),
            no: item['weaving_no'].toString(),
            canDelete: _canDelete,
            canUpdate: _canUpdate,
            openUpdateOnStart: openUpdateOnStart,
          );
        },
=======
    final value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeavingDetailScreen(
          id: item['id'].toString(),
          no: item['weaving_no'].toString(),
          canDelete: _canDelete,
          canUpdate: _canUpdate,
        ),
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
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
              await Provider.of<WeavingService>(context, listen: false)
                  .deleteItem(context, item['id'].toString(), _deleteLoading);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          await showAlertDialog(
            context: context,
<<<<<<< HEAD
<<<<<<< HEAD
            title: 'Weaving Dihapus',
=======
            title: 'Sizing Deleted',
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
            title: 'Weaving Dihapus',
>>>>>>> d8439a4 (fix: refactor code)
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
          title: 'Weaving',
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
        ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> d8439a4 (fix: refactor code)
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
                          Provider.of<WeavingService>(context, listen: false);
                      await service.getDataList(context, params);
                      return service.items;
                    },
                    isLoadMore: _isLoadMore,
                    canRead: _canRead,
                    itemBuilder: (item) => ItemProcessCard(
                      label: 'No. Weaving',
                      item: item,
                      titleKey: 'weaving_no',
<<<<<<< HEAD
                      subtitleKey: 'order_greige',
                      subtitleField: 'og_no',
                      canUpdate: _canUpdate,
                      canDelete: _canDelete,
=======
                      subtitleKey: 'work_orders',
                      subtitleField: 'wo_no',
                      canUpdate: _canUpdate,
                      canDelete: _canDelete,
                      onUpdate: () =>
                          _openProcessDetail(item, openUpdateOnStart: true),
                      onDelete: () => _handleDeleteItem(item),
>>>>>>> d8439a4 (fix: refactor code)
                    ),
                    onItemTap: (context, item) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeavingDetailScreen(
                              id: item['id'].toString(),
<<<<<<< HEAD
                              no: item['weaving_no'].toString(),
                              canDelete: _canDelete,
                              canUpdate: _canUpdate,
=======
>>>>>>> d8439a4 (fix: refactor code)
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
<<<<<<< HEAD
              ),
=======
        body: SafeArea(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.reverse) {
                  if (_showFab) {
                    setState(() => _showFab = false);
                  }
                } else if (notification.direction == ScrollDirection.forward) {
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
                    Provider.of<WeavingService>(context, listen: false);
                await service.getDataList(context, params);
                return service.items;
              },
              isLoadMore: _isLoadMore,
              canRead: _canRead,
              itemBuilder: (item) => ItemProcessCard(
                label: 'No. Weaving',
                item: item,
                titleKey: 'weaving_no',
                subtitleKey: 'work_orders',
                subtitleField: 'wo_no',
                itemField: ItemField.get,
                nestedField: ItemField.nested,
                canUpdate: _canUpdate,
                canDelete: _canDelete,
                onUpdate: () =>
                    _openProcessDetail(item, openUpdateOnStart: true),
                onDelete: () => _handleDeleteItem(item),
              ),
              onItemTap: (context, item) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeavingDetailScreen(
                        id: item['id'].toString(),
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
>>>>>>> 7fd183d (feat: create and finish warping, weaving)
=======
              ),
>>>>>>> d8439a4 (fix: refactor code)
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
                          title: 'Mulai Weaving',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateWeavng(),
                              ),
                            );
                          },
                        ),
                        DialogActionItem(
                          icon: Icons.task_alt_outlined,
                          iconColor: CustomTheme().buttonColor('warning'),
                          title: 'Selesai Weaving',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FinishWeaving(),
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
