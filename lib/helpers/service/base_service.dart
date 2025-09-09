import 'package:flutter/material.dart';

abstract class BaseService<T> extends ChangeNotifier {
  List<T> items = [];
  bool isLoading = false;
  bool hasMoreData = true;

  Future<void> fetchItems({bool isInitialLoad = false, String? searchQuery});
  Future<void> refetchItems();
  Future<void> addItem(T item, ValueNotifier<bool> isSubmitting);
  Future<void> updateItem(String id, T item, ValueNotifier<bool> isSubmitting);
  Future<void> deleteItem(String id, ValueNotifier<bool> isSubmitting);
}
