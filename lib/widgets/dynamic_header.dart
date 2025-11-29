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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(150),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 7, top: 10),
            child: Text('Spend Mate', style: TextStyle(color: colorScheme.onPrimary, fontSize: 26, fontWeight: FontWeight.w400)),
          ),

          Card(
            elevation: 0,
            color: colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance', style: TextStyle(color: colorScheme.onPrimaryContainer.withAlpha(200), fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      '$currency${totalBalance.toStringAsFixed(0)}',
                      style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.arrow_downward, color: colorScheme.primary, size: 18),
                            const SizedBox(width: 6),
                            Text('Income', style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w400)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currency${totalIncome.toStringAsFixed(0)}',
                          style: TextStyle(color: colorScheme.primary, fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.arrow_upward, color: colorScheme.error, size: 18),
                            const SizedBox(width: 6),
                            Text('Expense', style: TextStyle(color: colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w400)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currency${totalExpense.toStringAsFixed(0)}',
                          style: TextStyle(color: colorScheme.error, fontSize: 24, fontWeight: FontWeight.w500),
                        ),
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