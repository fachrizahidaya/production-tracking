// ignore_for_file: annotate_overrides

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OptionGreigeOrder {
  final int? value;
  final String? label;

  OptionGreigeOrder({this.value, this.label});

  factory OptionGreigeOrder.fromJson(Map<String, dynamic> json) {
    return OptionGreigeOrder(
      value: json['value'] as int,
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
<<<<<<< HEAD
    return {'value': value, 'label': label};
=======
    return {
      'value': value,
      'label': label,
    };
>>>>>>> a1ea7df (feat: warping)
  }
}

class OptionGreigeOrderService extends BaseService<OptionGreigeOrder> {
  final String baseUrl = '${dotenv.env['API_URL']}/order-greiges/option';

  bool _isLoading = false;
  bool _hasMoreData = true;
  final List<dynamic> _listOption = [];
  List<dynamic> _dataListOption = [];
<<<<<<< HEAD
<<<<<<< HEAD
  Map<String, dynamic> _dataView = {};
=======
>>>>>>> a1ea7df (feat: warping)
=======
  Map<String, dynamic> _dataView = {};
>>>>>>> 230afad3 (feat: greige order detail)

  final List<OptionGreigeOrder> _wo = [];

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  List<dynamic> get listOption => _listOption;
  List<dynamic> get dataListOption => _dataListOption;
<<<<<<< HEAD
<<<<<<< HEAD
  Map<String, dynamic> get dataView => _dataView;
=======
>>>>>>> a1ea7df (feat: warping)
=======
  Map<String, dynamic> get dataView => _dataView;
>>>>>>> 230afad3 (feat: greige order detail)

  List<OptionGreigeOrder> get options => _wo;

  @override
<<<<<<< HEAD
  Future<void> fetchItems({
    bool isInitialLoad = false,
    String? searchQuery = '',
  }) async {}
=======
  Future<void> fetchItems(
      {bool isInitialLoad = false, String? searchQuery = ''}) async {}
>>>>>>> a1ea7df (feat: warping)

  @override
  Future<void> refetchItems() async {
    hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  @override
  Future<void> addItem(
<<<<<<< HEAD
    OptionGreigeOrder item,
    ValueNotifier<bool> isSubmitting,
  ) async {}

  @override
  Future<void> updateItem(
    String id,
    OptionGreigeOrder item,
    ValueNotifier<bool> isSubmitting,
  ) async {}
=======
      OptionGreigeOrder item, ValueNotifier<bool> isSubmitting) async {}

  @override
  Future<void> updateItem(String id, OptionGreigeOrder item,
      ValueNotifier<bool> isSubmitting) async {}
>>>>>>> a1ea7df (feat: warping)

  @override
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {}

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
  Future<void> getDataView(dynamic id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Access token is missing');

    final uri = Uri.parse('${dotenv.env['API_URL']}/order-greiges/$id');

    try {
      _dataView = {};
      notifyListeners();

<<<<<<< HEAD
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
=======
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });
>>>>>>> 230afad3 (feat: greige order detail)

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final responseData = decoded['data'];
        _dataView = responseData is Map<String, dynamic>
            ? Map<String, dynamic>.from(responseData)
            : Map<String, dynamic>.from(decoded);
        notifyListeners();
      } else {
        throw decoded['message'] ?? 'Failed to load greige order';
      }
    } catch (e) {
      rethrow;
    }
  }

<<<<<<< HEAD
  Future<void> _fetchOptionsGeneric({
    bool isInitialLoad = false,
    String searchQuery = '',
    required String endpoint,
  }) async {
=======
=======
>>>>>>> 230afad3 (feat: greige order detail)
  Future<void> _fetchOptionsGeneric(
      {bool isInitialLoad = false,
      String searchQuery = '',
      required String endpoint}) async {
>>>>>>> a1ea7df (feat: warping)
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _hasMoreData = true;
      _wo.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) throw Exception('Access token is missing');

<<<<<<< HEAD
      final uri =
          Uri.parse('${dotenv.env['API_URL']}/order-greige/option').replace(
        queryParameters: {
          'per_page': '100',
          'type': endpoint,
=======
      final uri = Uri.parse(
        '${dotenv.env['API_URL']}/order-greige/option',
      ).replace(
        queryParameters: {
          'per_page': '100',
<<<<<<< HEAD
>>>>>>> a1ea7df (feat: warping)
=======
          'type': endpoint,
>>>>>>> 230afad3 (feat: greige order detail)
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

<<<<<<< HEAD
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
=======
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });
>>>>>>> a1ea7df (feat: warping)

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final responseData = decoded['data'];

        if (responseData is List) {
          _dataListOption = responseData;
        } else if (responseData is Map<String, dynamic>) {
          _dataListOption = List<dynamic>.from(responseData['data'] ?? []);
        } else {
          _dataListOption = [];
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load work order: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWarpingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
        endpoint: 'warping',
      );

  Future<void> fetchWarpingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'warping_finish',
<<<<<<< HEAD
=======
        endpoint: 'warping-option',
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 230afad3 (feat: greige order detail)
      );

  Future<void> fetchWeavingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
        endpoint: 'weaving',
      );
  Future<void> fetchWeavingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'weaving_finish',
      );

  Future<void> fetchSizingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'sizing',
      );
  Future<void> fetchSizingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'sizing_finish',
<<<<<<< HEAD
=======
        endpoint: 'weaving-option',
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 230afad3 (feat: greige order detail)
      );

  Future<void> fetchShearingOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 230afad3 (feat: greige order detail)
        endpoint: 'shearing',
      );
  Future<void> fetchShearingFinishOptions({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) =>
      _fetchOptionsGeneric(
        isInitialLoad: isInitialLoad,
        searchQuery: searchQuery,
        endpoint: 'shearing_finish',
<<<<<<< HEAD
=======
        endpoint: 'shearing-option',
>>>>>>> a1ea7df (feat: warping)
=======
>>>>>>> 230afad3 (feat: greige order detail)
      );
}
