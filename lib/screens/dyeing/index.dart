import 'package:flutter/material.dart';
import 'package:production_tracking/components/dyeing/item_dyeing.dart';
import 'package:production_tracking/components/master/filter/list_filter.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';
import 'package:production_tracking/components/master/layout/custom_list.dart';
import 'package:production_tracking/helpers/util/margin_card.dart';
import 'package:production_tracking/models/option/option_unit.dart';
import 'package:production_tracking/models/process/dyeing.dart';
import 'package:production_tracking/screens/dyeing/%5Bdyeing_id%5D.dart';
import 'package:provider/provider.dart';

class DyeingScreen extends StatefulWidget {
  const DyeingScreen({super.key});

  @override
  State<DyeingScreen> createState() => _DyeingScreenState();
}

class _DyeingScreenState extends State<DyeingScreen> {
  String _searchQuery = '';
  final OptionUnitService _unitService = OptionUnitService();
  bool _isFiltered = false;
  bool avaiableCreate = false;
  bool _firstLoading = true;
  final List<dynamic> _dataList = [];

  bool _isLoadMore = true;
  bool _hasMore = true;
  String _search = '';
  int page = 0;
  Map<String, String> params = {'search': '', 'page': '0'};

  @override
  void initState() {
    super.initState();
    _unitService.fetchOptions(isInitialLoad: true);
    setState(() {
      params = {'search': _search, 'page': '0'};
    });
    Future.delayed(Duration.zero, () {
      _loadMore();
    });
  }

  Future<void> _handleSearch(String value) async {
    setState(() {
      params = {'search': value.toString(), 'page': '0'};
    });

    _loadMore();
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
        params['mesin_id'] == null && params['status'] == null) {
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

    if (params['page'] == '0') {
      setState(() {
        _dataList.clear();
        _firstLoading = true;
        _hasMore = true;
      });
    }

    final currentPage = int.parse(params['page']!);

    List<Dyeing> loadData =
        await Provider.of<DyeingService>(context, listen: false)
            .getDataList(params);

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

        params['page'] = (currentPage + 1).toString();

        if (loadData.length < 20) {
          _hasMore = false;
        }
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dyeing',
        onReturn: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        padding: MarginCard.screen,
        color: const Color(0xFFEBEBEB),
        child: Column(
          children: [
            Expanded(
                child: CustomList(
              fetchData: (params) async {
                return await Provider.of<DyeingService>(context, listen: false)
                    .getDataList(params);
              },
              service: DyeingService(),
              searchQuery: _searchQuery,
              canCreate: true,
              canUpdate: null,
              itemBuilder: (item) => ItemDyeing(
                item: item,
                unitOptions: _unitService.options,
              ),
              onItemTap: (context, item) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DyeingDetail(
                        id: item.id.toString(),
                        no: item.dyeing_no.toString(),
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
              ),
              handleRefetch: _refetch,
              handleLoadMore: _loadMore,
              handleSearch: _handleSearch,
              dataList: _dataList,
              firstLoading: _firstLoading,
              hasMore: _hasMore,
              isFiltered: _isFiltered,
            ))
          ],
        ),
      ),
    );
  }
}
