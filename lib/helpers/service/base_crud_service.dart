import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/models/process/dyeing.dart';

abstract class BaseCrudService<T> extends ChangeNotifier {
  final String endpoint;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  BaseCrudService({
    required this.endpoint,
    required this.fromJson,
    required this.toJson,
  });

  final String baseUrl = dotenv.env['API_URL'] ?? '';
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  List<dynamic> items = [];
  Map<String, dynamic> _dataView = {};

  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  Map<String, dynamic> get dataView => _dataView;

  Future<void> fetchItems({
    bool isInitialLoad = false,
    String searchQuery = '',
  }) async {
    if (_isLoading || (!_hasMoreData && !isInitialLoad)) return;

    if (isInitialLoad) {
      _currentPage = 1;
      _hasMoreData = true;
      items.clear();
      notifyListeners();
    }

    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final url = Uri.parse(
          '$baseUrl/$endpoint?page=$_currentPage&search=$searchQuery');

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? [];

        List<T> newItems = data.map((e) => fromJson(e)).toList();

        if (newItems.length < _itemsPerPage) _hasMoreData = false;

        final existingIds = items.map((e) => (e as dynamic).id).toSet();
        for (var item in newItems) {
          if (!existingIds.contains((item as dynamic).id)) items.add(item);
        }

        if (newItems.isNotEmpty) _currentPage++;
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refetchItems() async {
    _hasMoreData = true;
    await fetchItems(isInitialLoad: true);
  }

  Future<void> getDataView(dynamic id) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    try {
      _dataView = {};
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        _dataView = jsonDecode(response.body);
        notifyListeners();
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getDataList(Map<String, String> params) async {
    final url =
        Uri.parse('$baseUrl/$endpoint').replace(queryParameters: params);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    try {
      items.clear();
      notifyListeners();

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      final responseData = jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          if (responseData['data'] != null) {
            items = responseData['data'];
          }
          notifyListeners();
          break;
        default:
          throw responseData['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addItem(T newItem, ValueNotifier<bool> isSubmitting) async {
    isSubmitting.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final uri = Uri.parse('$baseUrl/$endpoint');

      final response = await http.post(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(toJson(newItem)));

      if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        await refetchItems();
        return res['message'] ?? 'Proses telah ditambahkan';
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal menambahkan proses');
      }
    } catch (e) {
      throw Exception('Gagal menambahkan proses: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> updateItem(
      String id, T updatedItem, ValueNotifier<bool> isSubmitting) async {
    isSubmitting.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final data = toJson(updatedItem);
      final attachments = data['attachments'];

      if (attachments != null &&
          attachments is List &&
          attachments.isNotEmpty) {
        var uri = Uri.parse('$baseUrl/$endpoint/$id');
        var request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token';

        data.forEach((key, value) {
          if (key != 'attachments' && value != null) {
            request.fields[key] = value.toString();
          }
        });

        request.fields['_method'] = 'PATCH';

        for (int i = 0; i < attachments.length; i++) {
          var file = attachments[i];
          if (file is File) {
            request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]',
              file.path,
            ));
          } else if (file is Map && file['path'] != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]',
              file['path'],
              filename: file['name'] ?? 'file_$i',
            ));
          }
        }

        final response = await request.send();
        final body = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          await refetchItems();
          return jsonDecode(body)['message'] ?? 'Proses telah diubah';
        } else {
          throw Exception(
              jsonDecode(body)['message'] ?? 'Gagal mengubah proses');
        }
      } else {
        final body = {
          ...data,
          '_method': 'PATCH',
        };

        final response = await http.post(
          Uri.parse('$baseUrl/$endpoint/$id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          await refetchItems();
          return jsonDecode(response.body)['message'];
        } else {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Gagal mengubah proses');
        }
      }
    } catch (e) {
      throw Exception('Gagal mengubah proses: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> finishItem(
    String id,
    T finishedItem,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final data = toJson(finishedItem);
      final attachments = data['attachments'];

      if (attachments != null &&
          attachments is List &&
          attachments.isNotEmpty) {
        var uri = Uri.parse('$baseUrl/$endpoint/$id/complete');
        var request = http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token';

        data.forEach((key, value) {
          if (key != 'attachments' && value != null) {
            request.fields[key] = value.toString();
          }
        });

        request.fields['_method'] = 'PATCH';

        for (int i = 0; i < attachments.length; i++) {
          var file = attachments[i];
          if (file is File) {
            request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]',
              file.path,
            ));
          } else if (file is Map && file['path'] != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]',
              file['path'],
              filename: file['name'] ?? 'file_$i',
            ));
          }
        }

        final response = await request.send();
        final body = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          await refetchItems();
          return jsonDecode(body)['message'] ?? 'Proses telah selesai';
        } else {
          throw Exception(
              jsonDecode(body)['message'] ?? 'Gagal menyelesaikan proses');
        }
      } else {
        final body = {
          ...data,
          '_method': 'PATCH',
        };

        final response = await http.post(
          Uri.parse('$baseUrl/$endpoint/$id/complete'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          await refetchItems();
          return jsonDecode(response.body)['message'];
        } else {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Gagal menyelesaikan proses');
        }
      }
    } catch (e) {
      throw Exception('Gagal menyelesaikan proses: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> reworkItem(
      String id, Dyeing reworkedItem, ValueNotifier<bool> isSubmitting) async {
    try {
      isSubmitting.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      var uri = Uri.parse('$baseUrl/$endpoint/$id/rework');

      bool hasAttachments = reworkedItem.attachments != null &&
          reworkedItem.attachments is List &&
          (reworkedItem.attachments as List).isNotEmpty;

      if (hasAttachments) {
        var request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';

        request.fields['wo_id'] = reworkedItem.wo_id?.toString() ?? '';
        request.fields['machine_id'] =
            reworkedItem.machine_id?.toString() ?? '';
        request.fields['unit_id'] = reworkedItem.unit_id?.toString() ?? '';
        request.fields['rework_reference_id'] =
            reworkedItem.rework_reference_id?.toString() ?? '';
        request.fields['start_by_id'] =
            reworkedItem.start_by_id?.toString() ?? '';
        request.fields['end_by_id'] = reworkedItem.end_by_id?.toString() ?? '';
        request.fields['qty'] = reworkedItem.qty ?? '';
        request.fields['width'] = reworkedItem.width ?? '';
        request.fields['length'] = reworkedItem.length ?? '';
        request.fields['notes'] = reworkedItem.notes ?? '';
        request.fields['rework'] = (reworkedItem.rework == true ? '1' : '0');
        request.fields['status'] = reworkedItem.status ?? '';
        request.fields['start_time'] = reworkedItem.start_time ?? '';
        request.fields['end_time'] = reworkedItem.end_time ?? '';

        for (int i = 0; i < reworkedItem.attachments.length; i++) {
          var file = reworkedItem.attachments[i];
          if (file is File) {
            request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]',
              file.path,
            ));
          } else if (file is Map && file['path'] != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'attachments[$i]',
              file['path'],
              filename: file['name'] ?? 'file_$i',
            ));
          }
        }

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        if (response.statusCode == 201) {
          final jsonResponse = jsonDecode(responseBody);
          await refetchItems();
          notifyListeners();
          return jsonResponse['message'] ?? 'Proses telah Rework';
        } else {
          var responseData = await response.stream.bytesToString();
          throw Exception(
              jsonDecode(responseData)['message'] ?? 'Gagal Rework proses');
        }
      } else {
        final body = {
          ...reworkedItem.toJson(),
        };

        final response = await http.post(
          Uri.parse('$baseUrl/$endpoint/$id/rework'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          await refetchItems();
          return jsonDecode(response.body)['message'];
        } else {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Gagal Rework proses');
        }
      }
    } catch (e) {
      throw Exception("Gagal Rework proses: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {
    isSubmitting.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await refetchItems();
        final res = jsonDecode(response.body);
        return res['message'];
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal menghapus proses');
      }
    } catch (e) {
      throw Exception('Gagal menghapus proses: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
