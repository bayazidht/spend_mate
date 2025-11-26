import 'package:flutter/material.dart';
import 'package:spend_mate/models/transaction_model.dart';
import 'package:spend_mate/services/transaction_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  TransactionType _type = TransactionType.expense;
  double _amount = 0.0;
  String _category = 'Food';
  DateTime _date = DateTime.now();
  String _notes = '';

  final List<String> expenseCategories = ['Food', 'Transport', 'Shopping', 'Bills'];
  final List<String> incomeCategories = ['Salary', 'Gift', 'Investment'];

  @override
  void initState() {
    super.initState();
    _category = _type == TransactionType.expense ? expenseCategories.first : incomeCategories.first;
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
      if (userId == null) {
        // Handle case where user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated!')),
        );
        return;
      }

      final newTransaction = TransactionModel(
        id: '',
        amount: _amount,
        type: _type,
        category: _category,
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
    final currentCategories = _type == TransactionType.expense ? expenseCategories : incomeCategories;

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
              // Type Selector (Income/Expense Tabs)
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: _type == TransactionType.expense,
                      selectedColor: Colors.red.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _type = TransactionType.expense;
                            _category = expenseCategories.first; // Reset category
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Income', style: TextStyle(fontWeight: FontWeight.bold)),
                      selected: _type == TransactionType.income,
                      selectedColor: Colors.green.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _type = TransactionType.income;
                            _category = incomeCategories.first; // Reset category
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Amount Field
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

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                value: _category,
                items: currentCategories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Date Picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today, color: Colors.grey),
                title: Text('Date: ${DateFormat('EEE, MMM d, yyyy').format(_date)}'),
                trailing: const Icon(Icons.edit),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),

              // Notes Field
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