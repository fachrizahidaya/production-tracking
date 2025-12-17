import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textile_tracking/components/master/button/custom_floating_button.dart';
import 'package:textile_tracking/components/master/layout/custom_app_bar.dart';
import 'package:textile_tracking/components/master/layout/list/process_list.dart';
import 'package:textile_tracking/components/master/theme.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:textile_tracking/screens/auth/user_menu.dart';

class ProcessAction {
  final IconData icon;
  final Color color;
  final String label;
  final Widget page;
  ProcessAction(
      {required this.icon,
      required this.color,
      required this.label,
      required this.page});
}

class BaseProcessScreen extends StatefulWidget {
  final String title;
  final String processLabel;
  final String menuName;
  final service;
  final Future<List<dynamic>> Function(Map<String, String>) fetchData;
  final Widget Function(dynamic item) detailPageBuilder;

  final Widget? createPage;
  final Widget? finishPage;
  final Widget? reworkPage;

  final fetchMachineOptions;
  final getMachineOptions;

  const BaseProcessScreen({
    super.key,
    required this.title,
    required this.menuName,
    required this.service,
    required this.fetchData,
    required this.detailPageBuilder,
    required this.processLabel,
    required this.fetchMachineOptions,
    required this.getMachineOptions,
    this.createPage,
    this.finishPage,
    this.reworkPage,
  });

  @override
  State<BaseProcessScreen> createState() => _BaseProcessScreenState();
}

class _BaseProcessScreenState extends State<BaseProcessScreen> {
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

  List<dynamic> _dataList = [];
  String _search = '';
  Map<String, String> params = {'search': '', 'page': '0'};

  Timer? _debounce;

  String dariTanggal = '';
  String sampaiTanggal = '';

  @override
  void initState() {
    super.initState();
    params = {'search': '', 'page': '0', 'start_date': '', 'end_date': ''};
    Future.delayed(Duration.zero, _loadMore);
    _initializeMenus();
  }

  Future<void> _initializeMenus() async {
    await _menuService.handleFetchMenu();
    await _userMenu.handleLoadMenu();

    setState(() {
      _canRead = _userMenu.checkMenu(widget.menuName, 'read');
      _canCreate = _userMenu.checkMenu(widget.menuName, 'create');
      _canDelete = _userMenu.checkMenu(widget.menuName, 'delete');
      _canUpdate = _userMenu.checkMenu(widget.menuName, 'update');
    });
  }

  Future<void> _handleSearch(String value) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _search = value;
        params['search'] = value;
        params['page'] = '0';
      });
      _loadMore();
    });
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

    params['page'] = (int.parse(params['page']!) + 1).toString();
    List<dynamic> loadData = await widget.fetchData(params);

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

  List<ProcessAction> _buildActions() {
    final List<ProcessAction> actions = [];

    if (widget.createPage != null) {
      actions.add(ProcessAction(
        icon: Icons.add,
        color: CustomTheme().buttonColor('primary'),
        label: 'Mulai ${widget.processLabel}',
        page: widget.createPage!,
      ));
    }

    if (widget.finishPage != null) {
      actions.add(ProcessAction(
        icon: Icons.check_circle,
        color: CustomTheme().buttonColor('warning'),
        label: 'Selesai ${widget.processLabel}',
        page: widget.finishPage!,
      ));
    }

    if (widget.reworkPage != null) {
      actions.add(ProcessAction(
        icon: Icons.replay_outlined,
        color: CustomTheme().buttonColor('danger'),
        label: 'Rework ${widget.processLabel}',
        page: widget.reworkPage!,
      ));
    }

    return actions;
  }

  void _showActions() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildActions()
                .map((action) => ListTile(
                      leading: Icon(action.icon, color: action.color),
                      title: Text(action.label),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => action.page));
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9fafc),
      appBar: CustomAppBar(title: widget.title),
      body: Column(children: [
        Expanded(
          child: ProcessList(
            fetchData: widget.fetchData,
            service: widget.service,
            searchQuery: _search,
            canCreate: _canCreate,
            canRead: _canRead,
            isLoadMore: _isLoadMore,
            itemBuilder: widget.detailPageBuilder,
            onItemTap: (context, item) async {
              var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => widget.detailPageBuilder(item)));
              if (result == true) _refetch();
            },
            filterWidget: Container(),
            showActions: _showActions,
            firstLoading: _firstLoading,
            isFiltered: _isFiltered,
            hasMore: _hasMore,
            handleLoadMore: _loadMore,
            handleRefetch: _refetch,
            handleSearch: _handleSearch,
            dataList: _dataList,
          ),
        )
      ]),
      floatingActionButton: CustomFloatingButton(
        onPressed: _showActions,
        icon: const Icon(Icons.add, color: Colors.white, size: 128),
      ),
    );
  }
}
