import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _currencyKey = 'selectedCurrency';
  String _selectedCurrency = '\$';

  String get selectedCurrency => _selectedCurrency;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString(_currencyKey) ?? '\$';
    notifyListeners();
  }

  Future<void> setCurrency(String newCurrency) async {
    if (_selectedCurrency == newCurrency) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, newCurrency);
    _selectedCurrency = newCurrency;

    notifyListeners();
  }
}