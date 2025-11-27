import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/models/category_model.dart' as app_category;
import 'package:spend_mate/services/transaction_service.dart';
import 'package:spend_mate/providers/category_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../providers/settings_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transactionToEdit;

  const AddTransactionScreen({super.key, this.transactionToEdit});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  app_category.CategoryType _type = app_category.CategoryType.expense;
  double _amount = 0.0;
  String? _selectedCategoryName;
  DateTime _date = DateTime.now();
  String _notes = '';

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;

      _type = tx.type == TransactionType.income
          ? app_category.CategoryType.income
          : app_category.CategoryType.expense;
      _amount = tx.amount;
      _selectedCategoryName = tx.category;
      _date = tx.date;
      _notes = tx.notes;

      _amountController.text = tx.amount.toStringAsFixed(2);
      _notesController.text = tx.notes;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _setDefaultCategory(CategoryProvider provider) {
    List<app_category.CategoryModel> currentCategories;

    if (_type == app_category.CategoryType.expense) {
      currentCategories = provider.expenseCategories;
    } else {
      currentCategories = provider.incomeCategories;
    }

    if (widget.transactionToEdit == null ||
        !currentCategories.any((c) => c.name == _selectedCategoryName)) {
      if (currentCategories.isNotEmpty) {
        _selectedCategoryName = currentCategories.first.name;
      } else {
        _selectedCategoryName = null;
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null || _selectedCategoryName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select a category and ensure authentication.',
            ),
          ),
        );
        return;
      }

      final String transactionId = widget.transactionToEdit?.id ?? '';

      final transactionToSave = TransactionModel(
        id: transactionId,
        amount: _amount,
        type: _type == app_category.CategoryType.income
            ? TransactionType.income
            : TransactionType.expense,
        category: _selectedCategoryName!,
        date: _date,
        notes: _notes,
        userId: userId,
      );

      final TransactionService service = TransactionService();

      try {
        if (widget.transactionToEdit != null) {
          await service.updateTransaction(transactionToSave);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction updated successfully!')),
          );
        } else {
          await service.addTransaction(transactionToSave);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully!')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final currency = Provider.of<SettingsProvider>(context).selectedCurrency;
    final isEditing = widget.transactionToEdit != null;
    final colorScheme = Theme.of(context).colorScheme;

    final List<app_category.CategoryModel> currentCategories =
        _type == app_category.CategoryType.expense
        ? categoryProvider.expenseCategories
        : categoryProvider.incomeCategories;

    if (_selectedCategoryName == null ||
        !currentCategories.any((c) => c.name == _selectedCategoryName)) {
      _setDefaultCategory(categoryProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add New Transaction'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SegmentedButton<app_category.CategoryType>(
                selected: {_type},
                onSelectionChanged: isEditing
                    ? null
                    : (Set<app_category.CategoryType> newSelection) {
                  setState(() {
                    _type = newSelection.first;
                    _selectedCategoryName = null;
                  });
                },
                style: SegmentedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimaryContainer,
                  selectedBackgroundColor: colorScheme.primaryContainer,
                  selectedForegroundColor: colorScheme.onPrimaryContainer,
                  minimumSize: const Size(0, 50),
                ),
                segments: const [
                  ButtonSegment<app_category.CategoryType>(
                    value: app_category.CategoryType.expense,
                    label: Text('Expense'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment<app_category.CategoryType>(
                    value: app_category.CategoryType.income,
                    label: Text('Income'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount ($currency)',
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),

              currentCategories.isEmpty
                  ? const Center(
                      child: Text(
                        'No categories available. Please add one in Settings.',
                      ),
                    )
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      initialValue: _selectedCategoryName,
                      items: currentCategories.map((
                        app_category.CategoryModel category,
                      ) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategoryName = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedCategoryName = value;
                      },
                    ),
              const SizedBox(height: 20),

              ListTile(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1.0,
                  ),
                ),
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Date: ${DateFormat('EEE, MMM d, yyyy').format(_date)}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 1,
                onSaved: (value) {
                  _notes = value ?? '';
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update Transaction' : 'Save Transaction',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
