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
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    final amountColor = isIncome ? colorScheme.primary : colorScheme.error;

    Future<void> deleteTransaction() async {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Confirm Deletion', style: TextStyle(color: colorScheme.onSurface)),
          content: Text('Are you sure you want to delete this transaction?', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel', style: TextStyle(color: colorScheme.primary))),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Delete', style: TextStyle(color: colorScheme.error))
            ),
          ],
        ),
      );

      if (confirm == true) {
        await provider.deleteTransaction(transaction.id);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction deleted successfully!', style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),), backgroundColor: colorScheme.primary),
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
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: colorScheme.outline.withAlpha(153),
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          transaction.category,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${isIncome ? '+' : '-'}$currency${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: amountColor,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30, thickness: 1, color: Colors.grey),

                    _buildDetailRow(
                      colorScheme: colorScheme,
                      icon: isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      label: 'Type',
                      value: isIncome ? 'Income' : 'Expense',
                    ),

                    _buildDetailRow(
                      colorScheme: colorScheme,
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: DateFormat('EEE, MMM d, yyyy').format(transaction.date),
                    ),

                    if (transaction.notes.isNotEmpty) ...[
                      const Divider(height: 20, thickness: 0.5, color: Colors.grey),
                      _buildDetailRow(
                        colorScheme: colorScheme,
                        icon: Icons.notes,
                        label: 'Notes',
                        value: transaction.notes,
                        isMultiline: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: deleteTransaction,
                    icon: Icon(Icons.delete, color: colorScheme.error),
                    label: Text('Delete', style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: colorScheme.error, width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: editTransaction,
                    icon: Icon(Icons.edit, color: colorScheme.onPrimary),
                    label: Text('Edit', style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required ColorScheme colorScheme,
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
              Icon(icon, size: 20, color: colorScheme.secondary),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              maxLines: isMultiline ? null : 2,
              overflow: isMultiline ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}