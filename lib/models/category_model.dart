import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoryType { income, expense }

class CategoryModel {
  final String id;
  final String name;
  final CategoryType type;
  final String userId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.userId,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] == 'income' ? CategoryType.income : CategoryType.expense,
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type == CategoryType.income ? 'income' : 'expense',
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}