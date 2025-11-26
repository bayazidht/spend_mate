import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class DynamicHeader extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  const DynamicHeader({super.key, required this.totalBalance, required this.totalIncome, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Spend Mate', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text('$currency${totalBalance.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  color: const Color(0xFF66BB6A), // Light Green
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Income', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        Text('$currency${totalIncome.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  color: const Color(0xFFEF5350), // Light Red
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.arrow_downward, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Expense', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        Text('$currency${totalExpense.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}