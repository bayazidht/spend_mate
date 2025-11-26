import 'package:flutter/material.dart';
import 'package:spend_mate/models/category_model.dart';
import 'package:spend_mate/services/category_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  CategoryService? _service;
  late StreamSubscription<List<CategoryModel>> _categorySubscription;

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get incomeCategories => _categories.where((c) => c.type == CategoryType.income).toList();
  List<CategoryModel> get expenseCategories => _categories.where((c) => c.type == CategoryType.expense).toList();

  CategoryProvider(User? user) {
    if (user != null) {
      _service = CategoryService();
      _startListeningToCategories();
    }
  }

  void _startListeningToCategories() {
    if (_service != null) {
      _categorySubscription = _service!.getCategories().listen((catList) {
        _categories = catList;
        notifyListeners();
      });
    }
  }

  Future<void> addCategory(String name, CategoryType type) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (_service != null && userId != null) {
      final newCategory = CategoryModel(
        id: '',
        name: name,
        type: type,
        userId: userId,
      );
      await _service!.addCategory(newCategory);
    }
  }

  Future<void> deleteCategory(String id) async {
    if (_service != null) {
      await _service!.deleteCategory(id);
    }
  }

  @override
  void dispose() {
    _categorySubscription.cancel();
    super.dispose();
  }
}