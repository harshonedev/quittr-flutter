import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionFirestore {
  final FirebaseFirestore _firestore;

  SubscriptionFirestore({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addSubscription(
      String id, Map<String, dynamic> subscriptionData) async {
    try {
      await _firestore.collection('purchases').doc(id).set(subscriptionData);
    } catch (e) {
      throw Exception('Failed to add subscription: $e');
    }
  }

  Future<Map<String, dynamic>?> getSubscription(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('purchases').doc(id).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get subscription: $e');
    }
  }

  Future<void> deleteSubscription(String userId) async {
    try {
      await _firestore.collection('purchases').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete subscription: $e');
    }
  }
}
