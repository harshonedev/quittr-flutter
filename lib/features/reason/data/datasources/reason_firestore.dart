import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reason_model.dart';

class ReasonFirestore {
  final _collection = FirebaseFirestore.instance.collection('reasons');

  Future<List<ReasonModel>> getReasons(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ReasonModel.fromMap(doc.data()..['id'] = doc.id))
        .toList();
  }

  Future<ReasonModel> addReason(String userId, String reasonText) async {
    final now = DateTime.now();
    final docRef = await _collection.add({
      'userId': userId,
      'reason': reasonText,
      'created_at': now.toIso8601String(),
    });
    return ReasonModel(
      id: (docRef.id),
      reason: reasonText,
      createdAt: now,
    );
  }

  Future<void> deleteReason(String docId) async {
    await _collection.doc(docId).delete();
  }
}
