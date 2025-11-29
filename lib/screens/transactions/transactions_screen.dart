import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'package:spend_mate/widgets/transaction_item.dart';
import 'package:spend_mate/models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TransactionModel> _getFilteredTransactions(List<TransactionModel> allTransactions, int tabIndex) {
    if (tabIndex == 0) {
      return allTransactions.reversed.toList(); // নতুন ট্রানজাকশন উপরে দেখাতে reversed ব্যবহার
    } else if (tabIndex == 1) {
      return allTransactions.where((tx) => tx.type == TransactionType.income).toList().reversed.toList();
    } else {
      return allTransactions.where((tx) => tx.type == TransactionType.expense).toList().reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final allTransactions = transactionProvider.transactions;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 1,

        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          indicatorColor: colorScheme.onPrimary,

          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onPrimary.withAlpha(178),

          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList(allTransactions, 0, colorScheme),
          _buildTransactionList(allTransactions, 1, colorScheme),
          _buildTransactionList(allTransactions, 2, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> allTransactions, int tabIndex, ColorScheme colorScheme) {
    final filteredTransactions = _getFilteredTransactions(allTransactions, tabIndex);

    if (filteredTransactions.isEmpty) {
      final type = tabIndex == 1 ? 'Income' : tabIndex == 2 ? 'Expense' : 'Transactions';
      final icon = tabIndex == 1 ? Icons.arrow_downward : tabIndex == 2 ? Icons.arrow_upward : Icons.description;
      final iconColor = tabIndex == 1 ? colorScheme.secondary : colorScheme.error;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 60, color: iconColor.withAlpha(153)),
              const SizedBox(height: 16),
              Text(
                'No $type yet. Start adding your financial records!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
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
              child: TransactionItem(
                tx: transaction,
              ),
            ),
          );
        },
      ),
    );
  }
}