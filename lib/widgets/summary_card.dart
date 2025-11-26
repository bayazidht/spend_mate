import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double income;
  final double expense;

  const SummaryCard({super.key, required this.title, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Income', style: TextStyle(color: Colors.green)),
                    Text('$currency${income.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Expense', style: TextStyle(color: Colors.red)),
                    Text('$currency${expense.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, color: Colors.red)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}