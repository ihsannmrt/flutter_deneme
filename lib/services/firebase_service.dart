import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTransaction(String type, double amount, String category, String date, String description) async {
    await _firestore.collection('Finance').doc(type).collection('Transactions').add({
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getTransactions(String type) {
    return _firestore.collection('Finance').doc(type).collection('Transactions')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
