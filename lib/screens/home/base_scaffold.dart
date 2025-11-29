import 'package:flutter/material.dart';
import 'package:spend_mate/screens/home/home_screen.dart';
import 'package:spend_mate/screens/transactions/transactions_screen.dart';
import 'package:spend_mate/screens/graphs/graphs_screen.dart';
import 'package:spend_mate/screens/settings/settings_screen.dart';

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

  void _onItemTapped(int index) {
    setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_rounded),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Graphs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,

          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant, 
          backgroundColor: colorScheme.surface, 
          elevation: 0, 

          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,

          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ),
    );
  }
}