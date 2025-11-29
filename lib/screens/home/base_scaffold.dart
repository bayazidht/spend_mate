import 'package:flutter/material.dart';
import 'package:spend_mate/screens/home/home_screen.dart';
import 'package:spend_mate/screens/transactions/transactions_screen.dart';
import 'package:spend_mate/screens/graphs/graphs_screen.dart';
import 'package:spend_mate/screens/settings/settings_screen.dart';
import 'package:spend_mate/screens/transactions/add_transaction_screen.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({super.key});

  @override
  State<BaseScaffold> createState() => BaseScaffoldState();
}

class BaseScaffoldState extends State<BaseScaffold> {
  // 0: Home, 1: Transactions, 2: Graphs, 3: Settings
  int _selectedIndex = 0;

  void setSelectedIndex(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const TransactionsScreen(),
    GraphsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Body will switch between screens
      body: _widgetOptions.elementAt(_selectedIndex),

      // Floating Action Button (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Transaction Screen এ নেভিগেট করা
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.add, size: 30),
      ),

      // FAB Position: মাঝখানে
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // FAB এর জন্য খাঁজ তৈরি করবে
        notchMargin: 8.0, // খাঁজের সাইজ
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint.withAlpha(50), // For subtle tint effect
        elevation: 8,
        padding: EdgeInsets.zero, // Padding reset to fix potential layout issues

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side: Home (0) and Transactions (1)
            Row(
              mainAxisSize: MainAxisSize.min, // Ensure row takes minimum space
              children: [
                _buildNavItem(
                  context,
                  Icons.home_rounded,
                  'Home',
                  0,
                ),
                _buildNavItem(
                  context,
                  Icons.format_list_bulleted_rounded,
                  'Transactions',
                  1,
                ),
              ],
            ),

            // Right Side: Graphs (2) and Settings (3)
            Row(
              mainAxisSize: MainAxisSize.min, // Ensure row takes minimum space
              children: [
                _buildNavItem(
                  context,
                  Icons.bar_chart_rounded,
                  'Graphs',
                  2,
                ),
                _buildNavItem(
                  context,
                  Icons.settings_rounded,
                  'Settings',
                  3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // কাস্টম নেভিগেশন আইটেম উইজেট
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => setSelectedIndex(index),
        borderRadius: BorderRadius.circular(10),
        // Flexible size to help with rendering in BottomAppBar Row
        child: Container(
          width: MediaQuery.of(context).size.width / 5, // Approximate division for 4 items
          height: 60, // Fixed height for consistent look
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                size: 26,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}