import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/event.dart';

class EventImplementation {
  final db = FirebaseFirestore.instance;
  final String collectionName = "Events";

  Future<void> addNewEvent(Event event) async {
    try {
      DocumentReference docRef = await db.collection(collectionName).add(event.toMap());
      await db.collection(collectionName).doc(docRef.id).update({"id" : docRef.id});
      print("(Success) Event added with ID: ${docRef.id}");
    } catch(e) {
      print("Error adding event: $e");
    }
  }

  Stream<List<Event>> getAllEvents() {
    return db.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting events: $error");
    });
  }


}