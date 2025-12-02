import 'package:flutter/material.dart';
import 'package:spend_mate/models/category_model.dart';
import 'package:spend_mate/services/category_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import '../services/transaction_service.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  TransactionService? _transactionService;
  CategoryService? _service;
  StreamSubscription<List<CategoryModel>>? _categorySubscription;

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get incomeCategories => _categories.where((c) => c.type == CategoryType.income).toList();
  List<CategoryModel> get expenseCategories => _categories.where((c) => c.type == CategoryType.expense).toList();

  CategoryProvider(User? user) {
    if (user != null) {
      _service = CategoryService();
      _transactionService = TransactionService();
      _startListeningToCategories();
    }
  }

  CategoryModel getCategoryById(String id) {
    return _categories.firstWhere((cat) => cat.id == id, orElse: () {
      return CategoryModel(
        id: 'uncategorized',
        name: 'Uncategorized',
        type: CategoryType.expense,
        iconName: 'general',
      );
    });
  }

  void _startListeningToCategories() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (_service != null) {
      _categorySubscription = _service!.getCategories().listen((catList) {
        _categories = catList;
        if (_categories.isEmpty && userId != null) {
          _checkAndSetDefaultCategories(userId);
        }
        notifyListeners();
      });
    }
  }

  Future<void> _checkAndSetDefaultCategories(String userId) async {
    await _service?.saveDefaultCategories(userId);
  }

  Future<void> addCategory(String name, CategoryType type, String iconName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (_service != null && userId != null) {
      final newCategory = CategoryModel(
        id: '',
        name: name,
        type: type,
        iconName: iconName,
      );
      await _service!.addCategory(newCategory);
    }
  }

  Future<void> deleteCategory(String id) async {
    if (_service != null && _transactionService != null) {
      final categoryToDelete = _categories.firstWhere((c) => c.id == id, orElse: () => throw Exception("Category not found"));
      final categoryName = categoryToDelete.name;

      await _transactionService!.deleteTransactionsByCategory(categoryName);
      await _service!.deleteCategory(id);
    }
  }

  @override
  void dispose() {
    if (_categorySubscription != null) {
      _categorySubscription?.cancel();
    }
    super.dispose();
  }
}
