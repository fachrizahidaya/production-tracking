import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/filter/list_filter.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/custom_badge.dart';
import 'package:textile_tracking/components/master/layout/item_process_card.dart';
import 'package:textile_tracking/components/master/layout/process_list.dart';
import 'package:textile_tracking/components/master/sheet/process_sheet.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/util/format_date_safe.dart';
import 'package:textile_tracking/helpers/util/margin_card.dart';
import 'package:textile_tracking/models/process/stenter.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';
import 'package:textile_tracking/screens/stenter/%5Bstenter_id%5D.dart';
import 'package:textile_tracking/screens/stenter/create/create_stenter.dart';
import 'package:textile_tracking/screens/stenter/finish/finish_stenter.dart';

class StenterScreen extends StatefulWidget {
  const StenterScreen({super.key});

  @override
  State<StenterScreen> createState() => _StenterScreenState();
}

class _StenterScreenState extends State<StenterScreen> {
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
  String _search = '';
  Timer? _debounce;
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

  @override
  void initState() {
    super.initState();
    setState(() {
      params = {'search': _search, 'page': '0'};
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
        _canRead = _userMenu.checkMenu('Stenter', 'read');
        _canCreate = _userMenu.checkMenu('Stenter', 'create');
        _canDelete = _userMenu.checkMenu('Stenter', 'delete');
        _canUpdate = _userMenu.checkMenu('Stenter', 'update');
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

    if (
        // params['dari_tanggal'] == null &&
        //   params['sampai_tanggal'] == null &&
        params['machine_id'] == null && params['status'] == null) {
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
    if (_isLoading) return;
    _isLoading = true;

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    final currentPage = int.parse(params['page']!);

    try {
      List<Stenter> loadData =
          await Provider.of<StenterService>(context, listen: false)
              .getDataList(params);

      if (loadData.isEmpty) {
        setState(() {
          _firstLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _dataList.addAll(loadData);
          _firstLoading = false;
          params['page'] = (currentPage + 1).toString();
          if (loadData.length < 20) {
            _hasMore = false;
          }
        });
      }
    } finally {
      _isLoading = false;
    }
  }

  _refetch() {
    Future.delayed(Duration.zero, () {
      setState(() {
        params = {'search': _search, 'page': '0'};
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
    return Scaffold(
        backgroundColor: const Color(0xFFEBEBEB),
        appBar: CustomAppBar(
          title: 'Stenter',
          onReturn: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
        ),
        body: Container(
          padding: MarginCard.screen,
          child: Column(
            children: [
              Expanded(
                  child: ProcessList(
                fetchData: (params) async {
                  return await Provider.of<StenterService>(context,
                          listen: false)
                      .getDataList(params);
                },
                service: StenterService(),
                searchQuery: _search,
                canCreate: _canCreate,
                canRead: _canRead,
                itemBuilder: (item) => ItemProcessCard(
                  label: 'Stenter No',
                  item: item,
                  titleKey: 'stenter_no',
                  subtitleKey: 'work_orders',
                  subtitleField: 'wo_no',
                  isRework: (item) => item.rework == false,
                  getStartTime: (item) => formatDateSafe(item.start_time),
                  getEndTime: (item) => formatDateSafe(item.end_time),
                  getStartBy: (item) => item.start_by?['name'] ?? '',
                  getEndBy: (item) => item.end_by?['name'] ?? '',
                  getStatus: (item) => item.status ?? '-',
                  customBadgeBuilder: (status) => CustomBadge(title: status),
                ),
                onItemTap: (context, item) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StenterDetail(
                          id: item.id.toString(),
                          no: item.stenter_no.toString(),
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
                  fetchMachine: (service) => service.fetchOptionsStenter(),
                  getMachineOptions: (service) => service.dataListOption,
                ),
                showActions: () {
                  ProcessSheet.showOptions(
                    context,
                    options: [
                      BottomSheetOption(
                        title: "Mulai Stenter",
                        icon: Icons.add,
                        iconColor: CustomTheme().buttonColor('primary'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CreateStenter()),
                        ),
                      ),
                      BottomSheetOption(
                        title: "Selesai Stenter",
                        icon: Icons.check_circle,
                        iconColor: CustomTheme().buttonColor('warning'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FinishStenter()),
                        ),
                      ),
                    ],
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
        ));
  }
}
