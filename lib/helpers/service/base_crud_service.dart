// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/models/process/dyeing.dart';
import 'package:textile_tracking/providers/api_client.dart';

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
    required BuildContext context,
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
      final url = Uri.parse(
          '$baseUrl/$endpoint?page=$_currentPage&search=$searchQuery');

      final response = await ApiClient.instance.get(
        context,
        url,
      );

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

  Future<void> refetchItems(BuildContext context) async {
    _hasMoreData = true;
    await fetchItems(
      context: context,
      isInitialLoad: true,
    );
  }

  Future<void> getDataView(BuildContext context, dynamic id) async {
    final url = Uri.parse('$baseUrl/$endpoint/$id');

    try {
      _dataView = {};
      notifyListeners();

      final response = await ApiClient.instance.get(
        context,
        url,
      );

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

  Future<void> getDataList(
    BuildContext context,
    Map<String, String> params,
  ) async {
    final url =
        Uri.parse('$baseUrl/$endpoint').replace(queryParameters: params);

    try {
      items.clear();
      notifyListeners();

      final response = await ApiClient.instance.get(
        context,
        url,
      );

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

  Future<String> addItem(
      BuildContext context, T newItem, ValueNotifier<bool> isSubmitting) async {
    isSubmitting.value = true;
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');

      final response = await ApiClient.instance.post(
        context,
        uri,
        body: jsonEncode(toJson(newItem)),
      );

      if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        await refetchItems(context);
        return '${res['message']}.';
      } else {
        final error = jsonDecode(response.body);
        throw (error['message'] ?? 'Gagal menambahkan proses');
      }
    } catch (e) {
      throw ('$e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> updateItem(BuildContext context, String id, T updatedItem,
      ValueNotifier<bool> isSubmitting) async {
    isSubmitting.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final data = toJson(updatedItem);

      {
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
          await refetchItems(context);
          return jsonDecode(response.body)['message'];
        } else {
          final error = jsonDecode(response.body);
          throw (error['message'] ?? 'Gagal mengubah proses');
        }
      }
    } catch (e) {
      throw ('$e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> updateItemPacking(
    BuildContext context,
    String id,
    T updatedItem,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final data = toJson(updatedItem);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/$endpoint/$id'),
      );

      final cleaned = <String, String>{};

      data.forEach((key, value) {
        if (value != null) {
          cleaned[key] = value.toString();
        }
      });

      /// 🔥 IMPORTANT FIXES
      cleaned['_method'] = 'PATCH';
      cleaned.remove('grades');
      cleaned.remove('attachments');
      cleaned.remove('items');
      cleaned['notes'] = cleaned['notes'] ?? '';

      /// ITEMS
      if (data['items'] != null && data['items'] is List) {
        final items = List<Map<String, dynamic>>.from(
          data['items'],
        );

        for (int i = 0; i < items.length; i++) {
          final item = items[i];

          request.fields['items[$i][item_id]'] =
              item['item_id']?.toString() ?? '';

          request.fields['items[$i][qty]'] = item['qty']?.toString() ?? '0';

          request.fields['items[$i][weight_per_dozen]'] =
              item['weight_per_dozen']?.toString() ?? '0';

          request.fields['items[$i][gsm]'] = item['gsm']?.toString() ?? '0';

          request.fields['items[$i][weight_grade_a]'] =
              item['weight_grade_a']?.toString() ?? '0';

          request.fields['items[$i][total_weight]'] =
              item['total_weight']?.toString() ?? '0';
        }
      }
      request.fields.addAll(cleaned);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await refetchItems(context);
        return jsonDecode(response.body)['message'];
      } else {
        final error = jsonDecode(response.body);
        throw (error['message'] ?? 'Gagal mengubah proses');
      }
    } catch (e) {
      throw ('$e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> updateItemCrossCutting(
    BuildContext context,
    String id,
    T updatedItem,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final data = toJson(updatedItem);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/$endpoint/$id'),
      );

      final cleaned = <String, String>{};

      data.forEach((key, value) {
        if (value == null) return;

        if (value is List) {
          for (int i = 0; i < value.length; i++) {
            final item = value[i];

            if (item is Map<String, dynamic>) {
              item.forEach((k, v) {
                if (v != null) {
                  cleaned['$key[$i][$k]'] = v.toString();
                }
              });
            } else {
              cleaned['$key[$i]'] = item.toString();
            }
          }
        }
      });

      /// 🔥 IMPORTANT FIXES
      cleaned['_method'] = 'PATCH';
      cleaned.remove('weight');
      cleaned.remove('weight_unit_id');
      cleaned.remove('attachments');
      cleaned['notes'] = cleaned['notes'] ?? '';

      request.fields.addAll(cleaned);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await refetchItems(context);
        return jsonDecode(response.body)['message'];
      } else {
        final error = jsonDecode(response.body);
        throw (error['message'] ?? 'Gagal mengubah proses');
      }
    } catch (e) {
      throw ('$e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> updateItemReworkDyeing(
    BuildContext context,
    String id,
    Map<String, dynamic> data,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final String? token = prefs.getString('access_token');

      final uri = Uri.parse(
        '$baseUrl/$endpoint/$id',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      /*
    |--------------------------------------------------------------------------
    | METHOD
    |--------------------------------------------------------------------------
    */

      request.fields['_method'] = 'PATCH';

      /*
    |--------------------------------------------------------------------------
    | BASIC FIELDS
    |--------------------------------------------------------------------------
    */

      void addField(
        String key,
        dynamic value,
      ) {
        if (value == null) return;

        request.fields[key] = value.toString();
      }

      addField(
        'wo_id',
        data['wo_id'],
      );

      addField(
        'unit_id',
        data['unit_id'],
      );

      addField(
        'qty',
        data['qty'],
      );

      addField(
        'notes',
        data['notes'],
      );

      addField(
        'rework',
        data['rework'],
      );

      addField(
        'rework_category',
        data['rework_category'],
      );

      /*
    |--------------------------------------------------------------------------
    | REWORK TYPE
    |--------------------------------------------------------------------------
    |
    | rework_type[]
    |
    | Contoh:
    |
    | rework_type[0] = perbaikan_warna
    | rework_type[1] = perbaikan_noda
    | rework_type[2] = pelemas_ulang
    |
    */

      final reworkTypes = data['rework_type'];

      if (reworkTypes is List) {
        for (int i = 0; i < reworkTypes.length; i++) {
          addField(
            'rework_type[$i]',
            reworkTypes[i],
          );
        }
      }

      /*
    |--------------------------------------------------------------------------
    | REWORK METHOD
    |--------------------------------------------------------------------------
    |
    | rework_method[]
    |
    | Contoh:
    |
    | rework_method[0] = cuci_panas
    | rework_method[1] = sabun_panas
    |
    */

      final reworkMethods = data['rework_method'];

      if (reworkMethods is List) {
        for (int i = 0; i < reworkMethods.length; i++) {
          addField(
            'rework_method[$i]',
            reworkMethods[i],
          );
        }
      }

      /*
    |--------------------------------------------------------------------------
    | MACHINE IDS
    |--------------------------------------------------------------------------
    */

      final machineIds = data['machine_ids'];

      if (machineIds is List) {
        for (int i = 0; i < machineIds.length; i++) {
          addField(
            'machine_ids[$i]',
            machineIds[i],
          );
        }
      }

      /*
    |--------------------------------------------------------------------------
    | ATTACHMENTS
    |--------------------------------------------------------------------------
    */

      final attachments = data['attachments'];

      if (attachments is List) {
        for (final file in attachments) {
          if (file is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file.path,
              ),
            );
          } else if (file is XFile) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file.path,
                filename: file.name,
              ),
            );
          } else if (file is Map &&
              file['path'] != null &&
              file['path'].toString().isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file['path'].toString(),
                filename: file['name']?.toString() ?? 'file',
              ),
            );
          }
        }
      }

      /*
    |--------------------------------------------------------------------------
    | REQUEST
    |--------------------------------------------------------------------------
    */

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      /*
    |--------------------------------------------------------------------------
    | DEBUG RESPONSE
    |--------------------------------------------------------------------------
    */

      /*
    |--------------------------------------------------------------------------
    | SUCCESS
    |--------------------------------------------------------------------------
    */

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        await refetchItems(context);

        return responseData['message'] ?? 'Berhasil mengubah rework Dyeing';
      }

      /*
    |--------------------------------------------------------------------------
    | ERROR
    |--------------------------------------------------------------------------
    */

      try {
        final error = jsonDecode(response.body);

        throw Exception(
          error['message'] ?? 'Gagal mengubah rework Dyeing',
        );
      } catch (_) {
        throw Exception(
          'Gagal mengubah rework Dyeing '
          '(${response.statusCode}). '
          'Response: ${response.body}',
        );
      }
    } catch (e) {
      throw e.toString();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> finishItem(
    BuildContext context,
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

      final uri = Uri.parse('$baseUrl/$endpoint/$id/complete');

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      void addFields(dynamic value, String key) {
        if (value == null) return;

        if (value is List) {
          for (int i = 0; i < value.length; i++) {
            addFields(value[i], '$key[$i]');
          }
        } else if (value is Map) {
          value.forEach((k, v) {
            addFields(v, '$key[$k]');
          });
        } else {
          request.fields[key] = value.toString();
        }
      }

      data.forEach((key, value) {
        if (key == 'attachments') return;
        addFields(value, key);
      });

      request.fields['_method'] = 'PATCH';

      if (attachments is List) {
        for (var file in attachments) {
          if (file is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file.path,
              ),
            );
          } else if (file is Map &&
              file['path'] != null &&
              file['path'].toString().isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file['path'],
                filename: file['name'] ?? 'file',
              ),
            );
          }
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        await refetchItems(context);

        return '${jsonDecode(responseBody)['message']}. Proses dapat dilanjutkan atau WO sudah selesai.';
      }

      final error = jsonDecode(responseBody);

      throw error['message'] ?? 'Gagal menyelesaikan proses';
    } catch (e) {
      throw e.toString();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> finishDyeingItem(
    BuildContext context,
    String id,
    Map<String, dynamic> data,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final attachments = data['attachments'];

      final uri = Uri.parse('$baseUrl/$endpoint/$id/complete');

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      void addFields(dynamic value, String key) {
        if (value == null) return;

        if (value is List) {
          for (int i = 0; i < value.length; i++) {
            addFields(value[i], '$key[$i]');
          }
        } else if (value is Map) {
          value.forEach((k, v) {
            addFields(v, '$key[$k]');
          });
        } else {
          request.fields[key] = value.toString();
        }
      }

      data.forEach((key, value) {
        if (key == 'attachments') return;
        addFields(value, key);
      });

      request.fields['_method'] = 'PATCH';

      if (attachments is List) {
        for (var file in attachments) {
          if (file is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file.path,
              ),
            );
          } else if (file is Map &&
              file['path'] != null &&
              file['path'].toString().isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'attachments[]',
                file['path'],
                filename: file['name'] ?? 'file',
              ),
            );
          }
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        await refetchItems(context);

        return '${jsonDecode(responseBody)['message']}. Proses dapat dilanjutkan atau WO sudah selesai.';
      }

      final error = jsonDecode(responseBody);

      throw error['message'] ?? 'Gagal menyelesaikan proses';
    } catch (e) {
      throw e.toString();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> finishSortingItem(
    BuildContext context,
    String id,
    Map<String, dynamic> data,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('access_token');

      final attachments = data['attachments'] ?? [];

      final uri = Uri.parse('$baseUrl/$endpoint/$id/complete');

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['_method'] = 'PATCH';

      /*
    |--------------------------------------------------------------------------
    | BASIC FIELDS
    |--------------------------------------------------------------------------
    */

      void addField(String key, dynamic value) {
        if (value == null) return;

        if (value is double) {
          request.fields[key] = value.toInt().toString();
        } else {
          request.fields[key] = value.toString();
        }
      }

      addField('notes', data['notes']);
      addField('wo_id', data['wo_id']);
      addField('qty', data['qty']);
      addField('weight', data['weight']);
      addField('spraying', data['spraying']);
      addField('combing', data['combing']);
      addField(
        'rework_long_hemming',
        data['rework_long_hemming'],
      );

      /*
    |--------------------------------------------------------------------------
    | GRADES
    |--------------------------------------------------------------------------
    */

      final grades = data['grades'] ?? [];

      for (int i = 0; i < grades.length; i++) {
        final grade = grades[i];

        addField(
          'grades[$i][item_grade_id]',
          grade['item_grade_id'],
        );

        addField(
          'grades[$i][notes]',
          grade['notes'],
        );

        final items = grade['items'] ?? [];

        for (int j = 0; j < items.length; j++) {
          final item = items[j];

          addField(
            'grades[$i][items][$j][item_id]',
            item['item_id'],
          );

          addField(
            'grades[$i][items][$j][semifinished_product_id]',
            item['semifinished_product_id'],
          );

          /*
        |--------------------------------------------------------------------------
        | FORCE INTEGER
        |--------------------------------------------------------------------------
        */

          addField(
            'grades[$i][items][$j][qty]',
            (item['qty'] ?? 0).toInt(),
          );

          addField(
            'grades[$i][items][$j][spraying]',
            (item['spraying'] ?? 0).toInt(),
          );

          addField(
            'grades[$i][items][$j][combing]',
            (item['combing'] ?? 0).toInt(),
          );

          addField(
            'grades[$i][items][$j][rework_long_hemming]',
            (item['rework_long_hemming'] ?? 0).toInt(),
          );

          final defects = item['defects'] ?? [];

          for (int k = 0; k < defects.length; k++) {
            final defect = defects[k];

            addField(
              'grades[$i][items][$j][defects][$k][defect_type_id]',
              defect['defect_type_id'],
            );

            addField(
              'grades[$i][items][$j][defects][$k][qty]',
              (defect['qty'] ?? 0).toInt(),
            );
          }
        }
      }

      /*
    |--------------------------------------------------------------------------
    | ATTACHMENTS
    |--------------------------------------------------------------------------
    */

      for (final file in attachments) {
        /*
  |--------------------------------------------------------------------------
  | FILE
  |--------------------------------------------------------------------------
  */
        if (file is File) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'attachments[]',
              file.path,
            ),
          );
        }

        /*
  |--------------------------------------------------------------------------
  | MAP
  |--------------------------------------------------------------------------
  */
        else if (file is Map && file['path'] != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'attachments[]',
              file['path'],
              filename: file['name'] ?? 'file',
            ),
          );
        }

        /*
  |--------------------------------------------------------------------------
  | XFILE
  |--------------------------------------------------------------------------
  */
        else if (file is XFile) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'attachments[]',
              file.path,
              filename: file.name,
            ),
          );
        }
      }

      final response = await request.send();

      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        await refetchItems(context);

        return jsonDecode(body)['message'];
      }

      throw jsonDecode(body)['message'];
    } catch (e) {
      throw '$e';
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> reworkItem(
    BuildContext context,
    String id,
    Dyeing reworkedItem,
    ValueNotifier<bool> isSubmitting,
  ) async {
    isSubmitting.value = true;

    try {
      final uri = Uri.parse('$baseUrl/$endpoint/$id/rework');

      final body = {
        ...reworkedItem.toJson(),
      };

      final response = await ApiClient.instance.post(
        context,
        uri,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);

        await refetchItems(context);

        return '${res['message']}.';
      } else {
        final error = jsonDecode(response.body);

        throw (error['message'] ?? 'Gagal rework proses');
      }
    } catch (e) {
      throw ('$e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> deleteItem(
      BuildContext context, String id, ValueNotifier<bool> isSubmitting) async {
    isSubmitting.value = true;
    try {
      final response = await ApiClient.instance.delete(
        context,
        Uri.parse('$baseUrl/$endpoint/$id'),
      );

      if (response.statusCode == 200) {
        await refetchItems(context);
        final res = jsonDecode(response.body);
        return res['message'];
      } else {
        final error = jsonDecode(response.body);
        throw (error['message'] ?? 'Gagal menghapus proses');
      }
    } catch (e) {
      throw ('$e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
