import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../screens/transactions/transaction_detail_screen.dart';

class TransactionItem extends StatelessWidget {

  final TransactionModel tx;
  const TransactionItem({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {

    final String name = tx.category;
    final double amount = tx.amount;
    final bool isIncome = tx.type == TransactionType.income;
    final String date = DateFormat('MMM dd, yyyy').format(tx.date);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      title: Text(name),
      subtitle: Text(date),
      trailing: Text(
        '${isIncome ? '+' : '-'}₩${amount.toStringAsFixed(0)}',
        style: TextStyle(
          color: isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(transaction: tx),
          ),
        );
      },
    );
  }
}