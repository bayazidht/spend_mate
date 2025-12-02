import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'package:spend_mate/screens/transactions/add_transaction_screen.dart';
import 'package:intl/intl.dart';

import '../../data/default_category_icons.dart';
import '../../providers/category_provider.dart';
import '../../providers/settings_provider.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    final categoryModel = Provider.of<CategoryProvider>(
      context,
    ).getCategoryById(transaction.categoryId);

    Future<void> deleteTransaction() async {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Confirm Deletion',
            style: TextStyle(color: colorScheme.onSurface),
          ),
          content: Text(
            'Are you sure you want to delete this transaction?',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                'Delete',
                style: TextStyle(color: colorScheme.onError),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await transactionProvider.deleteTransaction(transaction.id);

        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Transaction deleted successfully!',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: colorScheme.primary,
            ),
          );
        }
      }
    }

    void editTransaction() {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) =>
                  AddTransactionScreen(transactionToEdit: transaction),
            ),
          )
          .then((_) {
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
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            color: colorScheme.primary,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.onPrimary.withAlpha(20),
                  ),
                  child: Icon(
                    availableIcons[categoryModel.iconName],
                    color: colorScheme.onPrimary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  categoryModel.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${isIncome ? '+' : '-'}$currency${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outline.withAlpha(100),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            colorScheme: colorScheme,
                            icon: isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            label: 'Type',
                            value: isIncome ? 'Income' : 'Expense',
                          ),
                          const Divider(),
                          _buildDetailRow(
                            colorScheme: colorScheme,
                            icon: Icons.calendar_today,
                            label: 'Date',
                            value: DateFormat('EEE, MMM d, yyyy')
                                .format(transaction.date),
                          ),
                          if (transaction.notes.isNotEmpty) ...[
                            const Divider(),
                            _buildDetailRow(
                              colorScheme: colorScheme,
                              icon: Icons.notes,
                              label: 'Notes',
                              value: transaction.notes,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete_forever_rounded),
                          label: const Text('DELETE'),
                          onPressed: deleteTransaction,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            side: BorderSide(
                                color: colorScheme.error.withAlpha(120)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.edit_note_rounded),
                          label: const Text('EDIT'),
                          onPressed: editTransaction,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colorScheme.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
