import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoryType { income, expense }

class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final CategoryType type;


  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.type
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      iconName: data['iconName'] ?? '',
      type: data['type'] == 'income' ? CategoryType.income : CategoryType.expense,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type == CategoryType.income ? 'income' : 'expense',
      'iconName': iconName,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}