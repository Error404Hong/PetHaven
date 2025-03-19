import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  String eventName;
  String date;
  String startTime;
  String endTime;
  String description;
  String location;
  String capacity;
  String participantsCount;
  String imagePath;
  String organizerID;
  List<String> participants;

  Event({
    this.id,
    required this.eventName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.location,
    required this.capacity,
    required this.participantsCount,
    required this.imagePath,
    required this.organizerID,
    required this.participants
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "eventName": eventName,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "description": description,
      "location": location,
      "capacity": capacity,
      "participantsCount": participantsCount,
      "imagePath": imagePath,
      "organizerID": organizerID,
      "participants": participants
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map["id"] as String?,
      eventName: map["eventName"] as String,
      date: map["date"] as String,
      startTime: map["startTime"] as String,
      endTime: map["endTime"] as String,
      description: map["description"] as String,
      location: map["location"] as String,
      capacity: map["capacity"] as String,
      participantsCount: map["participantsCount"] as String,
      imagePath: map["imagePath"] as String,
      organizerID: map["organizerID"] as String,
      participants: List<String>.from(map["participants"] ?? []),
    );
  }

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id, // Get Firestore document ID
      eventName: data["eventName"] ?? "",
      date: data["date"] ?? "",
      startTime: data["startTime"] ?? "",
      endTime: data["endTime"] ?? "",
      description: data["description"] ?? "",
      location: data["location"] ?? "",
      capacity: data["capacity"] ?? "",
      participantsCount: data["participantsCount"] ?? "",
      imagePath: data["imagePath"] ?? "",
      organizerID: data["organizerID"] ?? "",
      participants: List<String>.from(data["participants"] ?? []),
    );
  }
}
