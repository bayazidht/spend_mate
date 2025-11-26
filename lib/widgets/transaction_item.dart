import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String name;
  final double amount;
  final bool isIncome;
  final String date;

  const TransactionItem({super.key, required this.name, required this.amount, required this.isIncome, required this.date});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}