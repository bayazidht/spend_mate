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
      return allTransactions;
    } else if (tabIndex == 1) {
      return allTransactions.where((tx) => tx.type == TransactionType.income).toList();
    } else {
      return allTransactions.where((tx) => tx.type == TransactionType.expense).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final allTransactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
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
          _buildTransactionList(allTransactions, 0),
          _buildTransactionList(allTransactions, 1),
          _buildTransactionList(allTransactions, 2),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> allTransactions, int tabIndex) {
    final filteredTransactions = _getFilteredTransactions(allTransactions, tabIndex);

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Text(
          'No ${tabIndex == 1 ? 'Income' : tabIndex == 2 ? 'Expense' : 'Transactions'} yet.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];
          return TransactionItem(
            tx: transaction,
          );
        },
      ),
    );
  }
}