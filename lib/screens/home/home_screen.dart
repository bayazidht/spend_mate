import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/screens/transactions/add_transaction_screen.dart';
import 'package:spend_mate/widgets/dynamic_header.dart';
import 'package:spend_mate/widgets/summary_card.dart';
import 'package:spend_mate/widgets/transaction_item.dart';

import 'base_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    final totalBalance = provider.totalBalance;
    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;

    final recentTransactions = provider.transactions.take(2).toList();

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


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    const SizedBox(height: 16),

                    SummaryCard(
                      title: "This Month",
                      income: monthSummary['income']!,
                      expense: monthSummary['expense']!,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            final BaseScaffoldState? baseScaffoldState = context.findAncestorStateOfType<BaseScaffoldState>();
                            baseScaffoldState?.setSelectedIndex(1);
                          },
                          child: const Text('View All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (provider.transactions.isEmpty)
                      const Center(child: Text('No transactions found. Start by adding a new one!'))
                    else
                      ...recentTransactions.map((tx) => TransactionItem(
                        tx: tx,
                      )).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}