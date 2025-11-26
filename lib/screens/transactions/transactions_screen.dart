import 'package:flutter/material.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/services/transaction_service.dart';
import 'package:spend_mate/widgets/transaction_item.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionService = TransactionService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: transactionService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No transactions yet! Add one using the + button.'),
            );
          }

          final transactions = snapshot.data!;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return TransactionItem(
                tx: tx,
              );
            },
          );
        },
      ),
    );
  }
}
