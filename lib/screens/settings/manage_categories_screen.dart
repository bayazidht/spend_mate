import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_mate/models/category_model.dart';
import 'package:spend_mate/providers/category_provider.dart';

import '../../data/default_category_icons.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen>
    with SingleTickerProviderStateMixin {
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
    final colorScheme = Theme.of(context).colorScheme;
    final actionColor = type == CategoryType.income ? colorScheme.primary : colorScheme.error;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Add $typeName Category',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Category Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: actionColor,
                  width: 2,
                ),
              ),
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: actionColor,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  provider.addCategory(nameController.text.trim(), type, 'food');
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
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
            Tab(text: 'Expense'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList(
            provider.expenseCategories,
            CategoryType.expense,
            provider,
            colorScheme,
          ),
          _buildCategoryList(
            provider.incomeCategories,
            CategoryType.income,
            provider,
            colorScheme,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addCategoryBtn',
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () {
          final CategoryType selectedType = _tabController.index == 0
              ? CategoryType.expense
              : CategoryType.income;

          _showAddCategoryDialog(selectedType);
        },
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }

  Widget _buildCategoryList(
      List<CategoryModel> categories,
      CategoryType type,
      CategoryProvider provider,
      ColorScheme colorScheme,
      ) {
    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type == CategoryType.income ? Icons.payments_rounded : Icons.shopping_bag_rounded,
                size: 60,
                color: colorScheme.outlineVariant,
              ),
              const SizedBox(height: 10),
              Text(
                'No ${type == CategoryType.income ? 'income' : 'expense'} categories found.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Tap the (+) button below to create a new one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.outline),
              ),
            ],
          ),
        ),
      );
    }

    final iconColor = type == CategoryType.income ? colorScheme.primary : colorScheme.error;
    final backgroundColor = colorScheme.surfaceContainerLow;

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final IconData? categoryIconData = availableIcons[category.iconName];
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Card(
            elevation: 0,
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: colorScheme.outline.withAlpha(60),
                width: 1.0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withAlpha(30),
                ),
                child: Icon(
                  categoryIconData,
                  color: iconColor,
                  size: 24,
                ),
              ),
              title: Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
                onPressed: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Confirm Deletion'),
                      content: Text(
                        'Are you sure you want to delete the category "${category.name}"? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.error,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text('Delete', style: TextStyle(color: colorScheme.onError)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await provider.deleteCategory(category.id);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}