import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/router.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- AUTH ----------------

  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  // ---------------- PRODUCTS ----------------

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  /// Add a new product
  Future<void> addProduct({
    required String name,
    required double price,
    required int stockCount,
  }) async {
    AppRouter.back();
    await _products.add({
      'name': name,
      'price': price,
      'stockCount': stockCount,
      'createdBy': currentUser?.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
 
  }

  /// Update an existing product
  Future<void> updateProduct({
    required String productId,
    String? name,
    double? price,
    int? stockCount,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (price != null) data['price'] = price;
    if (stockCount != null) data['stockCount'] = stockCount;
    AppRouter.back();
    await _products.doc(productId).update(data);
    
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }

  /// Get a stream of products (auto-updates UI)
  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsStream() {
    return _products.orderBy('createdAt', descending: true).snapshots();
  }
}
