import 'package:spend_mate/models/category_model.dart';

final List<CategoryModel> defaultExpenseCategories = [
  CategoryModel(
    id: '',
    name: 'Food & Drink',
    iconName: 'food',
    type: CategoryType.expense
  ),
  CategoryModel(
    id: '',
    name: 'Transport',
    iconName: 'transport',
    type: CategoryType.expense
  ),
  CategoryModel(
    id: '',
    name: 'Shopping',
    iconName: 'shopping',
    type: CategoryType.expense
  ),
  CategoryModel(
    id: '',
    name: 'Bills & Utilities',
    iconName: 'utilities',
    type: CategoryType.expense
  ),
  CategoryModel(
    id: '',
    name: 'Entertainment',
    iconName: 'fun',
    type: CategoryType.expense
  ),
  CategoryModel(
    id: '',
    name: 'Healthcare',
    iconName: 'health',
    type: CategoryType.expense
  ),
  CategoryModel(
    id: '',
    name: 'Other',
    iconName: 'general',
    type: CategoryType.expense
  ),
];

final List<CategoryModel> defaultIncomeCategories = [
  CategoryModel(
    id: '',
    name: 'Salary',
    iconName: 'salary',
    type: CategoryType.income
  ),
  CategoryModel(
    id: '',
    name: 'Freelance',
    iconName: 'freelance',
    type: CategoryType.income
  ),
  CategoryModel(
    id: '',
    name: 'Investment',
    iconName: 'investment',
    type: CategoryType.income
  ),
  CategoryModel(
    id: '',
    name: 'Gift',
    iconName: 'gift',
    type: CategoryType.income
  ),
  CategoryModel(
    id: '',
    name: 'Other',
    iconName: 'general',
    type: CategoryType.income
  ),
];

final List<CategoryModel> allDefaultCategories = [
  ...defaultExpenseCategories,
  ...defaultIncomeCategories,
];