import 'package:spend_mate/models/category_model.dart';

final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel(
    id: '',
    name: 'Food & Drink',
    type: CategoryType.expense,
    userId: 'default',
  ),
  CategoryModel(
    id: '',
    name: 'Transport',
    type: CategoryType.expense,
    userId: 'default',
  ),
  CategoryModel(
    id: '',
    name: 'Shopping',
    type: CategoryType.expense,
    userId: 'default',
  ),
  CategoryModel(
    id: '',
    name: 'Bills & Utilities',
    type: CategoryType.expense,
    userId: 'default',
  ),
];

final List<CategoryModel> defaultIncomeCategories = [
  CategoryModel(
    id: '',
    name: 'Salary',
    type: CategoryType.income,
    userId: 'default',
  ),
  CategoryModel(
    id: '',
    name: 'Investment',
    type: CategoryType.income,
    userId: 'default',
  ),
  CategoryModel(
    id: '',
    name: 'Gift',
    type: CategoryType.income,
    userId: 'default',
  ),
];

final List<CategoryModel> allDefaultCategories = [
  ...defaultExpenseCategories,
  ...defaultIncomeCategories,
];