import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/models/category_model.dart' as app_category;
import 'package:spend_mate/services/transaction_service.dart';
import 'package:spend_mate/providers/category_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

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

  @override
  void initState() {
    super.initState();
  }

  void _setDefaultCategory(CategoryProvider provider) {
    List<app_category.CategoryModel> currentCategories;

    if (_type == app_category.CategoryType.expense) {
      currentCategories = provider.expenseCategories;
    } else {
      currentCategories = provider.incomeCategories;
    }

    if (currentCategories.isNotEmpty) {
      _selectedCategoryName = currentCategories.first.name;
    } else {
      _selectedCategoryName = null;
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
          const SnackBar(content: Text('Please select a category and ensure authentication.')),
        );
        return;
      }

      final newTransaction = TransactionModel(
        id: '',
        amount: _amount,
        type: _type == app_category.CategoryType.income ? TransactionType.income : TransactionType.expense,
        category: _selectedCategoryName!,
        date: _date,
        notes: _notes,
        userId: userId,
      );

      try {
        await TransactionService().addTransaction(newTransaction);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final List<app_category.CategoryModel> currentCategories =
    _type == app_category.CategoryType.expense
        ? categoryProvider.expenseCategories
        : categoryProvider.incomeCategories;

    if (_selectedCategoryName == null || !currentCategories.any((c) => c.name == _selectedCategoryName)) {
      _setDefaultCategory(categoryProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Transaction'),
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
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: _type == app_category.CategoryType.expense,
                      selectedColor: Colors.red.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _type = app_category.CategoryType.expense;
                            _selectedCategoryName = null; // রিসেট
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Income', style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: _type == app_category.CategoryType.income,
                      selectedColor: Colors.green.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _type = app_category.CategoryType.income;
                            _selectedCategoryName = null; // রিসেট
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₩)',
                  prefixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
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
                  ? const Center(child: Text('No categories available. Please add one in Settings.'))
                  : DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),

                value: _selectedCategoryName,
                items: currentCategories.map((app_category.CategoryModel category) {
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
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: Colors.grey),
                title: Text('Date: ${DateFormat('EEE, MMM d, yyyy').format(_date)}'),
                trailing: const Icon(Icons.edit),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: const Icon(Icons.note),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 2,
                onSaved: (value) {
                  _notes = value ?? '';
                },
              ),
              const SizedBox(height: 30),

              // Save Button
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
                child: const Text('Save Transaction', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}