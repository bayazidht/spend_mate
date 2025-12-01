import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_mate/data/default_currencies.dart';
import 'package:spend_mate/services/auth_service.dart';
import 'package:spend_mate/screens/settings/manage_categories_screen.dart';
import '../../models/currency_model.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? 'User';
    final userEmail = user?.email ?? 'Not set';

    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final availableCurrencies = defaultCurrencies;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[

          _buildAccountCard(context, colorScheme, userName, userEmail),
          const SizedBox(height: 25),

          _buildSettingsGroup(
            context,
            colorScheme,
            title: 'General Settings',
            children: [
              _buildManageCategoriesTile(context, colorScheme),
              _buildCurrencyTile(context, colorScheme, settingsProvider, availableCurrencies),
            ],
          ),
          const SizedBox(height: 20),

          _buildSettingsGroup(
            context,
            colorScheme,
            title: 'Appearance',
            children: [
              _buildDarkModeTile(context, colorScheme, themeProvider),
            ],
          ),
          const SizedBox(height: 40),

          _buildLogoutButton(context, colorScheme, authService),

        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, ColorScheme colorScheme, String userName, String userEmail) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(153),
          width: 1.0,
        ),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 30, color: colorScheme.primary),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(
      BuildContext context, ColorScheme colorScheme, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colorScheme.outline.withAlpha(153)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildManageCategoriesTile(BuildContext context, ColorScheme colorScheme) {
    return ListTile(
      leading: Icon(Icons.category, color: colorScheme.secondary),
      title: const Text('Manage Categories'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ManageCategoriesScreen(),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyTile(BuildContext context, ColorScheme colorScheme, SettingsProvider settingsProvider, List<CurrencyModel> availableCurrencies) {
    return ListTile(
      leading: Icon(Icons.currency_exchange, color: colorScheme.secondary),
      title: const Text('Currency'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: settingsProvider.selectedCurrency,
          items: availableCurrencies.map((CurrencyModel currency) {
            return DropdownMenuItem<String>(
              value: currency.symbol,
              child: Text('${currency.code} (${currency.symbol})', style: TextStyle(color: colorScheme.onSurface)),
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
        ),
      ),
      onTap: null,
    );
  }

  Widget _buildDarkModeTile(BuildContext context, ColorScheme colorScheme, ThemeProvider themeProvider) {
    return ListTile(
      leading: Icon(Icons.dark_mode, color: colorScheme.secondary),
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: themeProvider.isDarkMode,
        activeThumbColor: colorScheme.primary,
        onChanged: (newValue) {
          themeProvider.toggleTheme(newValue);
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colorScheme, AuthService authService) {
    return ElevatedButton.icon(
      onPressed: () async {
        await authService.signOut();
      },
      icon: const Icon(Icons.logout),
      label: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}