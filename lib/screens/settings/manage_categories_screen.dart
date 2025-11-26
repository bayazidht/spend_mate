import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/models/category_model.dart';
import 'package:spend_mate/providers/category_provider.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog(CategoryType type) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    final String typeName = type == CategoryType.income ? 'Income' : 'Expense';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New $typeName Category'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Category Name'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  provider.addCategory(nameController.text.trim(), type);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Expense'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Expense Categories Tab
          _buildCategoryList(provider.expenseCategories, CategoryType.expense, provider),
          // Income Categories Tab
          _buildCategoryList(provider.incomeCategories, CategoryType.income, provider),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          final CategoryType selectedType = _tabController.index == 0
              ? CategoryType.expense
              : CategoryType.income;

          _showAddCategoryDialog(selectedType);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryList(List<CategoryModel> categories, CategoryType type, CategoryProvider provider) {
    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No ${type == CategoryType.income ? 'income' : 'expense'} categories found. Tap the (+) button to add one.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ListTile(
          leading: Icon(
            type == CategoryType.expense ? Icons.remove_circle : Icons.add_circle,
            color: type == CategoryType.expense ? Colors.red : Colors.green,
          ),
          title: Text(category.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content: Text('Are you sure you want to delete the category "${category.name}"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );

              if (confirm == true) {
                await provider.deleteCategory(category.id);
              }
            },
          ),
        );
      },
    );
  }
}