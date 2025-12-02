import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/default_category_icons.dart';
import '../models/transaction_model.dart';
import '../providers/category_provider.dart';
import '../providers/settings_provider.dart';
import '../screens/transactions/transaction_detail_screen.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel tx;
  const TransactionItem({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final categoryModel = categoryProvider.getCategoryById(tx.categoryId);

    final String categoryName = categoryModel.name;
    final IconData? categoryIconData = availableIcons[categoryModel.iconName];

    final double amount = tx.amount;
    final bool isIncome = tx.type == TransactionType.income;
    final String date = DateFormat('MMM dd, yyyy').format(tx.date);

    final amountColor = isIncome ? colorScheme.primary : colorScheme.error;
    final iconColor = isIncome ? colorScheme.primary : colorScheme.error;
    final bgColor = isIncome
        ? colorScheme.primary.withAlpha(51)
        : colorScheme.error.withAlpha(51);

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: bgColor,
        child: Icon(categoryIconData,
          color: iconColor,
        ),
      ),
      title: Text(
        categoryName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        date,
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'}$currency${amount.toStringAsFixed(0)}',
        style: TextStyle(
          color: amountColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
