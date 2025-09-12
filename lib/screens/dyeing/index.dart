import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:production_tracking/components/dyeing/item_dyeing.dart';
import 'package:production_tracking/components/master/filter/list_filter.dart';
import 'package:production_tracking/components/master/layout/custom_app_bar.dart';
import 'package:production_tracking/components/master/layout/custom_bottom_sheet.dart';
import 'package:production_tracking/components/master/layout/custom_list.dart';
import 'package:production_tracking/components/master/layout/custom_search_bar.dart';
import 'package:production_tracking/helpers/util/margin_card.dart';
import 'package:production_tracking/models/option/option_unit.dart';
import 'package:production_tracking/models/process/dyeing.dart';
import 'package:provider/provider.dart';

class DyeingScreen extends StatefulWidget {
  const DyeingScreen({super.key});

  @override
  State<DyeingScreen> createState() => _DyeingScreenState();
}

class _DyeingScreenState extends State<DyeingScreen> {
  String _searchQuery = '';
  final DyeingService _dyeingService = DyeingService();
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
  }

  void _handleChangeSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    _dyeingService.fetchItems(isInitialLoad: true, searchQuery: _searchQuery);
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

    if (params['dari_tanggal'] == null &&
        params['sampai_tanggal'] == null &&
        params['pemasok_id'] == null &&
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

    // await Provider.of<PurchaseOrderProviderService>(context, listen: false)
    //     .getDataList(params);

    // ignore: use_build_context_synchronously
    // List<dynamic> loadData =
    // ignore: use_build_context_synchronously
    // Provider.of<PurchaseOrderProviderService>(context, listen: false)
    //     .dataList;

    // if (loadData.isEmpty) {
    //   setState(() {
    //     _firstLoading = false;
    //     _isLoadMore = false;
    //     _hasMore = false;
    //   });
    // } else {
    //   setState(() {
    //     _dataList.addAll(loadData);
    //     _firstLoading = false;
    //     _isLoadMore = false;
    //   });
    // }
  }

  _refetch() {
    Future.delayed(Duration.zero, () {
      setState(() {
        params = {'search': _search, 'page': '0'};
      });
      _loadMore();
    });
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ListFilter(
          title: 'Filter',
          params: params,
          onHandleFilter: _handleFilter,
          onSubmitFilter: _submitFilter,
        );
      },
    );
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
            CustomSearchBar(
              handleSearchChange: _handleChangeSearch,
              showFilter: () {
                _showFilterSheet(context);
              },
            ),
            Expanded(
                child: CustomList(
              service: DyeingService(),
              searchQuery: _searchQuery,
              canCreate: true,
              canUpdate: null,
              itemBuilder: (item) => ItemDyeing(
                item: item,
                unitOptions: _unitService.options,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
