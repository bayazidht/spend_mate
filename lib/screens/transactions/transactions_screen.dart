import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/providers/transaction_provider.dart';
import 'package:spend_mate/widgets/transaction_item.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/providers/category_provider.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? _selectedCategory;
  DateTime? _selectedDate;
  TransactionType? _selectedType;

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
    Iterable<TransactionModel> filteredTransactions = allTransactions;
    if (tabIndex == 1) {
      filteredTransactions = allTransactions.where((tx) => tx.type == TransactionType.income);
    } else if (tabIndex == 2) {
      filteredTransactions = allTransactions.where((tx) => tx.type == TransactionType.expense);
    }
    if (_selectedType != null) {
      filteredTransactions = filteredTransactions.where((tx) => tx.type == _selectedType);
    }
    if (_selectedCategory != null && _selectedCategory != 'All Categories') {
      filteredTransactions = filteredTransactions.where((tx) => tx.category == _selectedCategory);
    }
    if (_selectedDate != null) {
      filteredTransactions = filteredTransactions.where((tx) =>
      tx.date.year == _selectedDate!.year &&
          tx.date.month == _selectedDate!.month &&
          tx.date.day == _selectedDate!.day
      );
    }
    return filteredTransactions.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _selectDate(BuildContext context, StateSetter setStateDialog) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select Transaction Date',
    );
    if (picked != null) {
      setStateDialog(() {
        _selectedDate = picked;
      });
    }
  }

  void _showFilterBottomSheet(ColorScheme colorScheme) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    final Map<String, TransactionType?> typeOptions = {
      'All Types': null,
      'Income': TransactionType.income,
      'Expense': TransactionType.expense,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {

            List<String> availableCategories = ['All Categories'];

            if (_selectedType == TransactionType.income) {
              availableCategories.addAll(categoryProvider.incomeCategories.map((c) => c.name));
            } else if (_selectedType == TransactionType.expense) {
              availableCategories.addAll(categoryProvider.expenseCategories.map((c) => c.name));
            }

            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text('Transaction Type', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<TransactionType?>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    initialValue: _selectedType,
                    hint: const Text('All Types'),
                    items: typeOptions.entries.map((entry) {
                      return DropdownMenuItem<TransactionType?>(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (TransactionType? newValue) {
                      setStateSheet(() {
                        _selectedType = newValue;
                        _selectedCategory = 'All Categories';
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Category Filter', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Tooltip(
                    message: _selectedType == null
                        ? 'Select Transaction Type first'
                        : 'Select Category',
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        enabled: _selectedType != null,
                        fillColor: _selectedType == null ? colorScheme.surfaceContainer : colorScheme.surface,
                        filled: true,
                      ),
                      initialValue: _selectedCategory ?? 'All Categories',
                      items: availableCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: _selectedType == null ? null : (String? newValue) {
                        setStateSheet(() {
                          _selectedCategory = (newValue == 'All Categories' ? null : newValue);
                        });
                      },
                      hint: Text(_selectedType == null ? 'Select Type above' : 'All Categories'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Specific Date', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context, setStateSheet),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.edit_calendar),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? 'Select a specific date'
                              : DateFormat('dd MMM yyyy').format(_selectedDate!),
                        ),
                        style: TextStyle(
                            color: _selectedDate == null ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear'),
                        onPressed: () {
                          setState(() {
                            _selectedCategory = null;
                            _selectedDate = null;
                            _selectedType = null;
                          });
                          setStateSheet(() {
                            _selectedCategory = null;
                            _selectedDate = null;
                            _selectedType = null;
                          });
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                        ),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Apply Filter'),
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            );
          },
        );
      },
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: colorScheme.onPrimary),
            onPressed: () => _showFilterBottomSheet(colorScheme),
          ),
        ],
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
      final iconColor = tabIndex == 1 ? colorScheme.primary : colorScheme.error;

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
              if (_selectedCategory != null || _selectedDate != null || _selectedType != null)
                Text(
                  '(Current filters applied)',
                  style: TextStyle(fontSize: 14, color: colorScheme.outline),
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
            color: colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outline.withAlpha(60),
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