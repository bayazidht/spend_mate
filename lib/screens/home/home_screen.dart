import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/widgets/dynamic_header.dart';
import 'package:spend_mate/widgets/summary_card.dart';
import 'package:spend_mate/widgets/transaction_item.dart';

import 'base_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final totalBalance = provider.totalBalance;
    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;

    final recentTransactions = provider.transactions.reversed.take(2).toList();

    Map<String, double> getFilteredSummary(List<TransactionModel> transactions, {bool today = false}) {
      double income = 0.0;
      double expense = 0.0;
      final now = DateTime.now();

      for (var tx in transactions) {
        bool shouldInclude = false;
        if (today) {
          if (tx.date.year == now.year && tx.date.month == now.month && tx.date.day == now.day) {
            shouldInclude = true;
          }
        } else {
          if (tx.date.year == now.year && tx.date.month == now.month) {
            shouldInclude = true;
          }
        }

        if (shouldInclude) {
          if (tx.type == TransactionType.income) {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }
      }
      return {'income': income, 'expense': expense};
    }

    final todaySummary = getFilteredSummary(provider.transactions, today: true);
    final monthSummary = getFilteredSummary(provider.transactions, today: false);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorScheme.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DynamicHeader(
                totalBalance: totalBalance,
                totalIncome: totalIncome,
                totalExpense: totalExpense,
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SummaryCard(
                      title: "Today's Summary",
                      income: todaySummary['income']!,
                      expense: todaySummary['expense']!,
                    ),
                    const SizedBox(height: 8),

                    SummaryCard(
                      title: "This Month",
                      income: monthSummary['income']!,
                      expense: monthSummary['expense']!,
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(7, 20, 7, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorScheme.onSurface)),
                          GestureDetector(
                            onTap: () {
                              final BaseScaffoldState? baseScaffoldState = context.findAncestorStateOfType<BaseScaffoldState>();
                              baseScaffoldState?.setSelectedIndex(1);
                            },
                            child: Text('View All', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                          ),
                        ],
                      ),
                    ),

                    if (provider.transactions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'No transactions found. Start by adding a new one!',
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      )
                    else
                      ...recentTransactions.map((tx) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: colorScheme.outline.withAlpha(153),
                              width: 1.0,
                            ),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TransactionItem(tx: tx),
                          ),
                        ),
                      )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}