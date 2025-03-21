import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/event.dart';
import 'dart:math';

import '../../model/user.dart';

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

  Future<void> deleteEvent(Event event) async {
    try {
      await db.collection(collectionName).doc(event.id).delete();
      print("Event Deleted Successfully");
    } catch (e) {
      print("Error deleting event: $e");
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      DocumentReference eventRef = db.collection(collectionName).doc(event.id);

      await eventRef.update({
        'eventName': event.eventName,
        'date': event.date,
        'startTime': event.startTime,
        'endTime': event.endTime,
        'description': event.description,
        'location': event.location,
        'capacity': event.capacity,
      });

      print("Event updated successfully");
    } catch (e) {
      print("Error updating event: $e");
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

  Stream<List<Event>> getJoinedEvents(User user) {
    return db.collection(collectionName)
        .where('participants', arrayContains: user.id) // Filter by user ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting joined events: $error");
    });
  }

  Stream<List<Event>> getOrganizedEvent(User organizer) {
    return db.collection(collectionName)
        .where('organizerID', isEqualTo: organizer.id) // Filter by user ID
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }).handleError((error) {
      print("Error getting joined events: $error");
    });
  }

  Stream<List<DocumentSnapshot>> getRandomEvents() {
    return db.collection(collectionName).snapshots().map((snapshot) {
      if (snapshot.docs.length < 2) {
        throw Exception("Not enough documents in the collection!");
      }

      List<DocumentSnapshot> docs = snapshot.docs;
      docs.shuffle(); // Shuffle the documents to get random ones

      return docs.take(2).toList(); // Return only 2 random documents
    });
  }
}