import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_mate/models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late final CollectionReference _categoriesRef;

  CategoryService() {
    if (currentUser == null) {
      throw Exception("User is not logged in.");
    }
    _categoriesRef = _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('categories');
  }

  Stream<List<CategoryModel>> getCategories() {
    return _categoriesRef
        .orderBy('name', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addCategory(CategoryModel category) async {
    await _categoriesRef.add(category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoriesRef.doc(categoryId).delete();
  }
}