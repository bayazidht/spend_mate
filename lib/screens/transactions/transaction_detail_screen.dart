import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'package:spend_mate/screens/transactions/add_transaction_screen.dart';
import 'package:intl/intl.dart';

import '../../providers/settings_provider.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;
    final isIncome = transaction.type == TransactionType.income;

    Future<void> _deleteTransaction() async {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Delete', style: TextStyle(color: Colors.red))
            ),
          ],
        ),
      );

      if (confirm == true) {
        await provider.deleteTransaction(transaction.id);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted successfully!')),
        );
      }
    }

    void editTransaction() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddTransactionScreen(
            transactionToEdit: transaction,
          ),
        ),
      ).then((_) {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editTransaction,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTransaction,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isIncome ? 'Income' : 'Expense',
                      style: TextStyle(fontSize: 18, color: isIncome ? Colors.green : Colors.red),
                    ),
                    Text(
                      '$currency${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),

                _buildDetailRow(
                  icon: Icons.category,
                  label: 'Category',
                  value: transaction.category,
                ),

                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: DateFormat('EEE, MMM d, yyyy').format(transaction.date),
                ),

                if (transaction.notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _buildDetailRow(
                      icon: Icons.note,
                      label: 'Notes',
                      value: transaction.notes,
                      isMultiline: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              maxLines: isMultiline ? null : 1,
              overflow: isMultiline ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}