import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final DateTime date;
  final String notes;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.notes
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      amount: (data['amount'] as num).toDouble(),
      type: data['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: data['categoryId'],
      date: (data['date'] as Timestamp).toDate(),
      notes: data['notes']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}