import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_mate/models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late final CollectionReference _transactionsRef;

  TransactionService() {
    if (currentUser == null) {
      throw Exception("User is not logged in.");
    }
    _transactionsRef = _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('transactions');
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionsRef.add(transaction.toFirestore());
  }

  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionsRef
        .doc(transaction.id)
        .update(transaction.toFirestore());
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsRef.doc(transactionId).delete();
  }

  Future<void> deleteTransactionsByCategory(String categoryName) async {
    final snapshot = await _transactionsRef
        .where('categoryName', isEqualTo: categoryName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print("Successfully deleted ${snapshot.docs.length} transactions for category: $categoryName");
    }
  }
}