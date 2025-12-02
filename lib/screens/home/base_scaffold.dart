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
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.add, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint.withAlpha(50),
        elevation: 8,
        padding: EdgeInsets.zero,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
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

            Row(
              mainAxisSize: MainAxisSize.min,
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

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => setSelectedIndex(index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 60,
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