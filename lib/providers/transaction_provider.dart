import 'package:flutter/material.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/services/transaction_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  List<TransactionModel> get transactions => _transactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get totalBalance => _totalIncome - _totalExpense;

  StreamSubscription<List<TransactionModel>>? _transactionSubscription;
  TransactionService? _service;

  TransactionProvider(User? user) {
    if (user != null) {
      _service = TransactionService();
      _startListeningToTransactions();
    }
  }

  void _startListeningToTransactions() {
    if (_service != null) {
      _transactionSubscription = _service!.getTransactions().listen((txList) {
        _transactions = txList;
        _calculateSummary();
        notifyListeners();
      });
    }
  }

  void _calculateSummary() {
    double income = 0.0;
    double expense = 0.0;

    for (var tx in _transactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    _totalIncome = income;
    _totalExpense = expense;
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _service?.deleteTransaction(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Map<String, dynamic> getChartData() {
    Map<String, double> categoryExpenses = {};
    double totalExpense = 0.0;

    for (var tx in _transactions) {
      if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
        categoryExpenses[tx.categoryId] = (categoryExpenses[tx.categoryId] ?? 0) + tx.amount;
      }
    }

    Map<String, Map<String, double>> monthlySummary = {};

    for (var tx in _transactions) {
      final monthKey = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';

      monthlySummary.putIfAbsent(monthKey, () => {'income': 0.0, 'expense': 0.0});

      if (tx.type == TransactionType.income) {
        monthlySummary[monthKey]!['income'] = monthlySummary[monthKey]!['income']! + tx.amount;
      } else {
        monthlySummary[monthKey]!['expense'] = monthlySummary[monthKey]!['expense']! + tx.amount;
      }
    }

    final sortedMonthlySummary = Map.fromEntries(
        monthlySummary.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key))
    );

    return {
      'categoryExpenses': categoryExpenses,
      'totalExpense': totalExpense,
      'monthlySummary': sortedMonthlySummary,
    };
  }

  @override
  void dispose() {
    if (_transactionSubscription != null) {
      _transactionSubscription?.cancel();
    }
    super.dispose();
  }
}