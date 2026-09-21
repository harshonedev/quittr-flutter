import 'package:cloud_firestore/cloud_firestore.dart';

class JournalFirestore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> addEntry(
      String title, String description, String userId) async {
    try {
      final entry = {
        'title': title,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
        "userId": userId,
      };
      final doc = await firestore.collection('journal_entries').add(entry);
      // Return the document ID of the newly created entry
      return doc.id;
    } catch (e) {
      throw Exception('Failed to add entry: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEntries(String userId) async {
    try {
      final snapshot =
          await firestore.collection('journal_entries').where("userId", isEqualTo: userId).get();
      if (snapshot.docs.isEmpty) {
        return []; // Return an empty list if no entries found
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch entries: $e');
    }
  }
}
