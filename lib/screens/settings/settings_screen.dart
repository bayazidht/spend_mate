// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/services/auth_service.dart';
import 'package:spend_mate/screens/settings/manage_categories_screen.dart';

import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart'; // Future implementation

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final settingsProvider = Provider.of<SettingsProvider>(context);
    final availableCurrencies = ['€', '\$', '₩', '£', '₹'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          // Profile/User Info (Optional)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () async {
              await authService.signOut();
            },
          ),
          const Divider(),

          // General Settings
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'General',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ManageCategoriesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency'),
            trailing: DropdownButton<String>(
              value: settingsProvider.selectedCurrency,
              items: availableCurrencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  settingsProvider.setCurrency(newValue);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Currency set to $newValue')),
                  );
                }
              },
            ), // Current currency symbol
            onTap: () {
              DropdownButton<String>(
                value: settingsProvider.selectedCurrency,
                items: availableCurrencies.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    settingsProvider.setCurrency(
                      newValue,
                    ); // ✅ সেটিং সেভ করা হলো
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Currency set to $newValue')),
                    );
                  }
                },
              );
            },
          ),
          ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (newValue) {
                  themeProvider.toggleTheme(newValue);
                },
              ),
          ),
        ],
      ),
    );
  }
}
