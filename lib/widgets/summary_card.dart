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
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: colorScheme.outline.withAlpha(153), width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorScheme.onSurface)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Income', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w400, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                        '+ $currency${income.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 22, color: colorScheme.primary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Expense', style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w400, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                        '- $currency${expense.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 22, color: colorScheme.error, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}