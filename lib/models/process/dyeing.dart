// ignore_for_file: non_constant_identifier_names, annotate_overrides, prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:textile_tracking/helpers/service/base_crud_service.dart';
import 'package:textile_tracking/helpers/service/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Dyeing {
  final int? id;
  final String? dyeing_no;
  final String? wo_no;
  final String? start_time;
  final int? start_by_id;
  final int? end_by_id;
  final String? end_time;
  final String? qty;
  final String? width;
  final String? length;
  final String? notes;
  final String? status;
  final bool? rework;
  final int? unit_id;
  final int? width_unit_id;
  final int? length_unit_id;
  final int? wo_id;
  final int? machine_id;
  final int? rework_reference_id;
  final attachments;
  final dynamic work_orders;
  final dynamic start_by;
  final dynamic end_by;
  final machine;

  Dyeing(
      {this.id,
      this.dyeing_no,
      this.start_time,
      this.end_time,
      this.qty,
      this.width,
      this.length,
      this.notes,
      this.status,
      this.rework,
      this.unit_id,
      this.wo_id,
      this.machine_id,
      this.rework_reference_id,
      this.start_by_id,
      this.end_by_id,
      this.attachments,
      this.wo_no,
      this.work_orders,
      this.start_by,
      this.end_by,
      this.length_unit_id,
      this.width_unit_id,
      this.machine});

  factory Dyeing.fromJson(Map<String, dynamic> json) {
    return Dyeing(
        id: json['id'] as int?,
        unit_id: json['unit_id'] as int?,
        wo_id: json['wo_id'] as int?,
        machine_id: json['machine_id'] as int?,
        start_by_id: json['start_by_id'] as int?,
        end_by_id: json['end_by_id'] as int?,
        rework_reference_id: json['rework_reference_id'] as int?,
        dyeing_no: json['dyeing_no'] ?? '',
        start_time: json['start_time'] ?? '',
        end_time: json['end_time'] ?? '',
        qty: json['qty'] ?? '',
        width: json['width'] ?? '',
        length: json['length'] ?? '',
        status: json['status'] ?? '',
        rework: json['rework'] as bool?,
        notes: json['notes'] ?? '',
        attachments: json['attachments'] ?? [],
        machine: json['machine'] ?? {},
        work_orders: json['work_orders'],
        start_by: json['start_by'],
        end_by: json['end_by'],
        width_unit_id: json['width_unit_id'] as int?,
        wo_no: json['wo_no'],
        length_unit_id: json['length_unit_id'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_id': unit_id,
      'wo_id': wo_id,
      'machine_id': machine_id,
      'start_by_id': start_by_id,
      'end_by_id': end_by_id,
      'rework_reference_id': rework_reference_id,
      'dyeing_no': dyeing_no,
      'start_time': start_time,
      'end_time': end_time,
      'qty': qty,
      'width': width,
      'length': length,
      'status': status,
      'rework': rework,
      'attachments': attachments,
      'machine': machine,
      'work_orders': work_orders,
      'start_by': start_by,
      'end_by': end_by,
      'notes': notes,
      'length_unit_id': length_unit_id,
      'width_unit_id': width_unit_id,
      'wo_no': wo_no,
    };
  }
}

// class DyeingService extends BaseService<Dyeing> {
//   final String baseUrl = '${dotenv.env['API_URL']}/dyeings';

//   bool _isLoading = false;
//   bool _hasMoreData = true;
//   int _currentPage = 1;
//   final int _itemsPerPage = 20;
//   List<dynamic> _dataList = [];
//   Map<String, dynamic> _dataView = {};
//   int currentPage = 1;
//   int lastPage = 1;

//   bool get isLoading => _isLoading;
//   bool get hasMoreData => _hasMoreData;
//   List<dynamic> get dataList => _dataList;
//   Map<String, dynamic> get dataView => _dataView;

//   @override
//   Future<void> fetchItems(
//       {bool isInitialLoad = false, String? searchQuery = ''}) async {
//     if (isLoading || (!hasMoreData && !isInitialLoad)) return;

//     if (isInitialLoad) {
//       _currentPage = 1;
//       hasMoreData = true;
//       items.clear();
//       notifyListeners();
//     }

//     isLoading = true;
//     notifyListeners();

//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('access_token');

//       final response = await http.get(
//         Uri.parse('$baseUrl?page=$_currentPage&search=$searchQuery'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         final List<dynamic> dataList = responseData['data'];

//         List<Dyeing> newItems =
//             dataList.map((item) => Dyeing.fromJson(item)).toList();

//         if (newItems.length < _itemsPerPage) {
//           hasMoreData = false;
//         }

//         final existingIds = items.map((e) => e.id).toSet();
//         for (var newItem in newItems) {
//           if (!existingIds.contains(newItem.id)) {
//             items.add(newItem);
//           }
//         }
//         // items.addAll(newItems);

//         if (newItems.isNotEmpty) {
//           _currentPage++;
//         } else {
//           hasMoreData = false;
//         }
//       } else {
//         throw Exception('Failed to load dyeings');
//       }
//     } catch (e) {
//       throw Exception("Error fetching dyeings: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> getDataView(id) async {
//     final url = Uri.parse('$baseUrl/$id');
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('access_token').toString();

//     try {
//       _dataView = {};
//       notifyListeners();

//       final response = await http.get(url, headers: {
//         'Authorization': 'Bearer $token',
//       });

//       final responseData = json.decode(response.body);
//       switch (response.statusCode) {
//         case 200:
//           if (responseData != null) {
//             _dataView = responseData as Map<String, dynamic>;
//           }
//           notifyListeners();
//           break;
//         default:
//           throw responseData['message'];
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> getDataList(Map<String, dynamic> params) async {
//     final url = Uri.parse(baseUrl).replace(queryParameters: params);
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('access_token').toString();

//     try {
//       _dataList.clear();
//       notifyListeners();

//       final response = await http.get(url, headers: {
//         'Authorization': 'Bearer $token',
//       });

//       final responseData = jsonDecode(response.body);
//       switch (response.statusCode) {
//         case 200:
//           if (responseData['data'] != null) {
//             _dataList = responseData['data'];
//           }
//           notifyListeners();
//           break;
//         default:
//           throw responseData['message'];
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<void> refetchItems() async {
//     hasMoreData = true;
//     await fetchItems(isInitialLoad: true);
//   }

//   @override
//   Future<String> addItem(Dyeing item, ValueNotifier<bool> isSubmitting) async {
//     try {
//       isSubmitting.value = true;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('access_token');

//       var uri = Uri.parse(baseUrl);

//       bool hasAttachments = item.attachments != null &&
//           item.attachments is List &&
//           (item.attachments as List).isNotEmpty;

//       if (hasAttachments) {
//         var request = http.MultipartRequest('POST', uri);
//         request.headers['Authorization'] = 'Bearer $token';

//         request.fields['wo_id'] = item.wo_id?.toString() ?? '';
//         request.fields['machine_id'] = item.machine_id?.toString() ?? '';
//         request.fields['unit_id'] = item.unit_id?.toString() ?? '';
//         request.fields['rework_reference_id'] =
//             item.rework_reference_id?.toString() ?? '';
//         request.fields['start_by_id'] = item.start_by_id?.toString() ?? '';
//         request.fields['end_by_id'] = item.end_by_id?.toString() ?? '';
//         request.fields['qty'] = item.qty ?? '';
//         request.fields['width'] = item.width ?? '';
//         request.fields['length'] = item.length ?? '';
//         request.fields['notes'] = item.notes ?? '';
//         request.fields['rework'] = (item.rework == true ? '1' : '0');
//         request.fields['status'] = item.status ?? '';
//         request.fields['start_time'] = item.start_time ?? '';
//         request.fields['end_time'] = item.end_time ?? '';

//         for (int i = 0; i < item.attachments.length; i++) {
//           var file = item.attachments[i];
//           if (file is File) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file.path,
//             ));
//           } else if (file is Map && file['path'] != null) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file['path'],
//               filename: file['name'] ?? 'file_$i',
//             ));
//           }
//         }

//         var response = await request.send();
//         var responseBody = await response.stream.bytesToString();
//         if (response.statusCode == 201) {
//           final jsonResponse = jsonDecode(responseBody);
//           await refetchItems();
//           notifyListeners();
//           return jsonResponse['message'] ?? 'Update successful';
//         } else {
//           var responseData = await response.stream.bytesToString();
//           throw Exception(jsonDecode(responseData)['message'] ??
//               'Failed to add dyeing with attachments');
//         }
//       } else {
//         final response = await http.post(
//           uri,
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(item.toJson()),
//         );

//         if (response.statusCode == 201) {
//           final jsonResponse = jsonDecode(response.body);
//           await refetchItems();
//           notifyListeners();
//           return jsonResponse['message'] ?? 'Update successful';
//         } else {
//           final errorData = jsonDecode(response.body);
//           throw Exception(errorData['message'] ?? 'Failed to add dyeings');
//         }
//       }
//     } catch (e) {
//       throw Exception('Error adding dyeing: $e');
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   @override
//   Future<String> updateItem(
//     String id,
//     Dyeing item,
//     ValueNotifier<bool> isSubmitting,
//   ) async {
//     try {
//       isSubmitting.value = true;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('access_token');

//       bool hasAttachments = item.attachments != null &&
//           item.attachments is List &&
//           (item.attachments as List).isNotEmpty;

//       if (hasAttachments) {
//         var uri = Uri.parse('$baseUrl/$id?_method=PATCH');
//         var request = http.MultipartRequest('POST', uri);
//         request.headers['Authorization'] = 'Bearer $token';

//         request.fields['wo_id'] = item.wo_id?.toString() ?? '';
//         request.fields['machine_id'] = item.machine_id?.toString() ?? '';
//         request.fields['unit_id'] = item.unit_id?.toString() ?? '';
//         request.fields['rework_reference_id'] =
//             item.rework_reference_id?.toString() ?? '';
//         request.fields['start_by_id'] = item.start_by_id?.toString() ?? '';
//         request.fields['end_by_id'] = item.end_by_id?.toString() ?? '';
//         request.fields['qty'] = item.qty ?? '';
//         request.fields['width'] = item.width ?? '';
//         request.fields['length'] = item.length ?? '';
//         request.fields['notes'] = item.notes ?? '';
//         request.fields['rework'] = (item.rework == true ? '1' : '0');
//         request.fields['status'] = item.status ?? '';
//         request.fields['start_time'] = item.start_time ?? '';
//         request.fields['end_time'] = item.end_time ?? '';

//         for (int i = 0; i < item.attachments.length; i++) {
//           var file = item.attachments[i];
//           if (file is File) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file.path,
//             ));
//           } else if (file is Map && file['path'] != null) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file['path'],
//               filename: file['name'] ?? 'file_$i',
//             ));
//           }
//         }

//         var response = await request.send();
//         var responseBody = await response.stream.bytesToString();
//         if (response.statusCode == 200) {
//           final jsonResponse = jsonDecode(responseBody);
//           await refetchItems();
//           notifyListeners();
//           return jsonResponse['message'] ?? 'Update successful';
//         } else {
//           var responseData = await response.stream.bytesToString();
//           throw Exception(
//               jsonDecode(responseData)['message'] ?? 'Failed to update dyeing');
//         }
//       } else {
//         final body = {
//           ...item.toJson(),
//           '_method': 'PATCH',
//         };

//         final response = await http.post(
//           Uri.parse('$baseUrl/$id'),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(body),
//         );

//         if (response.statusCode == 200) {
//           await refetchItems();
//           return jsonDecode(response.body)['message'];
//         } else {
//           final error = jsonDecode(response.body);
//           throw Exception(error['message'] ?? 'Failed to update item');
//         }
//         // final response = await http.patch(
//         //   Uri.parse('$baseUrl/$id'),
//         //   headers: {
//         //     'Authorization': 'Bearer $token',
//         //     'Content-Type': 'application/json',
//         //   },
//         //   body: jsonEncode(updatedDyeing.toJson()),
//         // );

//         // if (response.statusCode == 200) {
//         //   final jsonResponse = jsonDecode(response.body);
//         //   await refetchItems();
//         //   notifyListeners();
//         //   return jsonResponse['message'] ?? 'Update successful';
//         // } else {
//         //   final errorData = jsonDecode(response.body);
//         //   throw Exception(errorData['message'] ?? 'Failed to update dyeing');
//         // }
//       }
//     } catch (e) {
//       throw Exception("$e");
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   Future<String> finishItem(String id, Dyeing finishedDyeing,
//       ValueNotifier<bool> isSubmitting) async {
//     try {
//       isSubmitting.value = true;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('access_token');

//       bool hasAttachments = finishedDyeing.attachments != null &&
//           finishedDyeing.attachments is List &&
//           (finishedDyeing.attachments as List).isNotEmpty;

//       if (hasAttachments) {
//         var uri = Uri.parse('$baseUrl/$id/complete?_method=PATCH');
//         var request = http.MultipartRequest('POST', uri);
//         request.headers['Authorization'] = 'Bearer $token';

//         request.fields['wo_id'] = finishedDyeing.wo_id?.toString() ?? '';
//         request.fields['machine_id'] =
//             finishedDyeing.machine_id?.toString() ?? '';
//         request.fields['unit_id'] = finishedDyeing.unit_id?.toString() ?? '';
//         request.fields['rework_reference_id'] =
//             finishedDyeing.rework_reference_id?.toString() ?? '';
//         request.fields['start_by_id'] =
//             finishedDyeing.start_by_id?.toString() ?? '';
//         request.fields['end_by_id'] =
//             finishedDyeing.end_by_id?.toString() ?? '';
//         request.fields['qty'] = finishedDyeing.qty ?? '';
//         request.fields['width'] = finishedDyeing.width ?? '';
//         request.fields['length'] = finishedDyeing.length ?? '';
//         request.fields['notes'] = finishedDyeing.notes ?? '';
//         request.fields['rework'] = (finishedDyeing.rework == true ? '1' : '0');
//         request.fields['status'] = finishedDyeing.status ?? '';
//         request.fields['start_time'] = finishedDyeing.start_time ?? '';
//         request.fields['end_time'] = finishedDyeing.end_time ?? '';

//         for (int i = 0; i < finishedDyeing.attachments.length; i++) {
//           var file = finishedDyeing.attachments[i];
//           if (file is File) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file.path,
//             ));
//           } else if (file is Map && file['path'] != null) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file['path'],
//               filename: file['name'] ?? 'file_$i',
//             ));
//           }
//         }

//         var response = await request.send();
//         var responseBody = await response.stream.bytesToString();
//         if (response.statusCode == 200) {
//           final jsonResponse = jsonDecode(responseBody);
//           await refetchItems();
//           notifyListeners();
//           return jsonResponse['message'] ?? 'Finish successful';
//         } else {
//           var responseData = await response.stream.bytesToString();
//           throw Exception(jsonDecode(responseData)['message'] ??
//               'Failed to add dyeing with attachments');
//         }
//       } else {
//         final body = {
//           ...finishedDyeing.toJson(),
//           '_method': 'PATCH',
//         };

//         final response = await http.post(
//           Uri.parse('$baseUrl/$id/complete'),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(body),
//         );

//         if (response.statusCode == 200) {
//           await refetchItems();
//           return jsonDecode(response.body)['message'];
//         } else {
//           final error = jsonDecode(response.body);
//           throw Exception(error['message'] ?? 'Failed to finish item');
//         }
//         // final response = await http.patch(
//         //   Uri.parse('$baseUrl/$id/complete'),
//         //   headers: {
//         //     'Authorization': 'Bearer $token',
//         //     'Content-Type': 'application/json',
//         //   },
//         //   body: jsonEncode(finishedDyeing.toJson()),
//         // );

//         // if (response.statusCode == 200) {
//         //   await refetchItems();
//         //   notifyListeners();
//         //   final responseData = jsonDecode(response.body);
//         //   return responseData['message'];
//         // } else {
//         //   final errorData = jsonDecode(response.body);
//         //   throw Exception(errorData['message'] ?? 'Failed to finish dyeing');
//         // }
//       }
//     } catch (e) {
//       throw Exception("$e");
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   Future<String> reworkItem(
//       String id, Dyeing reworkDyeing, ValueNotifier<bool> isSubmitting) async {
//     try {
//       isSubmitting.value = true;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('access_token');

//       var uri = Uri.parse('$baseUrl/$id/rework');

//       bool hasAttachments = reworkDyeing.attachments != null &&
//           reworkDyeing.attachments is List &&
//           (reworkDyeing.attachments as List).isNotEmpty;

//       if (hasAttachments) {
//         var request = http.MultipartRequest('POST', uri);
//         request.headers['Authorization'] = 'Bearer $token';

//         request.fields['wo_id'] = reworkDyeing.wo_id?.toString() ?? '';
//         request.fields['machine_id'] =
//             reworkDyeing.machine_id?.toString() ?? '';
//         request.fields['unit_id'] = reworkDyeing.unit_id?.toString() ?? '';
//         request.fields['rework_reference_id'] =
//             reworkDyeing.rework_reference_id?.toString() ?? '';
//         request.fields['start_by_id'] =
//             reworkDyeing.start_by_id?.toString() ?? '';
//         request.fields['end_by_id'] = reworkDyeing.end_by_id?.toString() ?? '';
//         request.fields['qty'] = reworkDyeing.qty ?? '';
//         request.fields['width'] = reworkDyeing.width ?? '';
//         request.fields['length'] = reworkDyeing.length ?? '';
//         request.fields['notes'] = reworkDyeing.notes ?? '';
//         request.fields['rework'] = (reworkDyeing.rework == true ? '1' : '0');
//         request.fields['status'] = reworkDyeing.status ?? '';
//         request.fields['start_time'] = reworkDyeing.start_time ?? '';
//         request.fields['end_time'] = reworkDyeing.end_time ?? '';

//         for (int i = 0; i < reworkDyeing.attachments.length; i++) {
//           var file = reworkDyeing.attachments[i];
//           if (file is File) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file.path,
//             ));
//           } else if (file is Map && file['path'] != null) {
//             request.files.add(await http.MultipartFile.fromPath(
//               'attachments[$i]',
//               file['path'],
//               filename: file['name'] ?? 'file_$i',
//             ));
//           }
//         }

//         var response = await request.send();
//         var responseBody = await response.stream.bytesToString();
//         if (response.statusCode == 201) {
//           final jsonResponse = jsonDecode(responseBody);
//           await refetchItems();
//           notifyListeners();
//           return jsonResponse['message'] ?? 'Rework successful';
//         } else {
//           var responseData = await response.stream.bytesToString();
//           throw Exception(jsonDecode(responseData)['message'] ??
//               'Failed to add dyeing with attachments');
//         }
//       } else {
//         final body = {
//           ...reworkDyeing.toJson(),
//         };

//         final response = await http.post(
//           Uri.parse('$baseUrl/$id/rework'),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(body),
//         );

//         if (response.statusCode == 201) {
//           await refetchItems();
//           return jsonDecode(response.body)['message'];
//         } else {
//           final error = jsonDecode(response.body);
//           throw Exception(error['message'] ?? 'Failed to rework item');
//         }
//         // final response = await http.post(
//         //   Uri.parse('$baseUrl/$id/rework'),
//         //   headers: {
//         //     'Authorization': 'Bearer $token',
//         //     'Content-Type': 'application/json',
//         //   },
//         //   body: jsonEncode(reworkDyeing.toJson()),
//         // );

//         // if (response.statusCode == 201) {
//         //   await refetchItems();
//         //   notifyListeners();
//         //   final responseData = jsonDecode(response.body);
//         //   return responseData['message'] ?? 'Rework created';
//         // } else {
//         //   final errorData = jsonDecode(response.body);
//         //   throw Exception(errorData['message'] ?? 'Failed to rework dyeing');
//         // }
//       }
//     } catch (e) {
//       throw Exception("Error rework dyeing: $e");
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   @override
//   Future<String> deleteItem(String id, ValueNotifier<bool> isSubmitting) async {
//     try {
//       isSubmitting.value = true;

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('access_token');

//       final response = await http.delete(
//         Uri.parse('$baseUrl/$id'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         await refetchItems();
//         notifyListeners();
//         final responseData = jsonDecode(response.body);
//         return responseData['message'];
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'Failed to delete dyeing');
//       }
//     } catch (e) {
//       throw Exception("Error deleting dyeing: $e");
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
// }

class DyeingService extends BaseCrudService<Dyeing> {
  DyeingService()
      : super(
          endpoint: 'dyeings',
          fromJson: (json) => Dyeing.fromJson(json),
          toJson: (item) => item.toJson(),
        );
}
