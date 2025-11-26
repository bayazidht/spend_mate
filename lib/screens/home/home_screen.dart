import 'package:flutter/material.dart';
import 'package:spend_mate/screens/transactions/transactions_screen.dart';
import 'package:spend_mate/widgets/dynamic_header.dart';
import 'package:spend_mate/widgets/summary_card.dart';
import 'package:spend_mate/widgets/transaction_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double totalBalance = 0;
    const double totalIncome = 0;
    const double totalExpense = 0;


    final List<Map<String, dynamic>> recentTransactions = [
      {'name': 'Salary', 'amount': 0.0, 'isIncome': true, 'date': '2025-11-26'},
      {'name': 'Transport', 'amount': 0.0, 'isIncome': false, 'date': '2025-11-26'},
    ];

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
                  children: [
                    const SummaryCard(
                      title: "Today's Summary",
                      income: totalIncome,
                      expense: totalExpense,
                    ),
                    const SizedBox(height: 16),
                    // This Month Summary
                    const SummaryCard(
                      title: "This Month",
                      income: totalIncome,
                      expense: totalExpense,
                    ),
                    const SizedBox(height: 16),

                    // Recent Transactions
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('View All', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...recentTransactions.map((tx) => TransactionItem(
                      name: tx['name'],
                      amount: tx['amount'],
                      isIncome: tx['isIncome'],
                      date: tx['date'],
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
          // Navigate to the Add Transaction Screen (Screenshot 2025-11-26 at 12.46.45 PM.png)
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TransactionsScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}