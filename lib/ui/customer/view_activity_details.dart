import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/model/user.dart';
import '../component/snackbar.dart';
import 'alternative_app_bar.dart';
import '../../data/model/event.dart';
import 'dart:io';

class ActivityDetails extends StatefulWidget {
  final Event event;
  final User user;
  const ActivityDetails({super.key, required this.event, required this.user});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  late Event event;
  String? organizerName;
  bool hasJoined = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    getOrganizerData();
    checkIfUserJoined();
  }

  Future<void> getOrganizerData() async {
    var db = FirebaseFirestore.instance;
    String oid = event.organizerID;

    try {
      QuerySnapshot querySnapshot = await db.collection('Users').get();

      for (var doc in querySnapshot.docs) {
        var userData = doc.data() as Map<String, dynamic>;

        if(userData["id"] == oid) {
          setState(() {
            organizerName = userData["name"];
          });
          return;
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget buildParticipantIcons() {
    int currentParticipants = int.parse(event.participantsCount);
    int eventMax = int.parse(event.capacity);

    return Row(
      children: [
        // Green icons for current participants
        ...List.generate(
            currentParticipants,
                (index) => Icon(Icons.pets, color: Colors.green[600])
        ),

        // Grey icons for remaining spots
        ...List.generate(
            eventMax - currentParticipants,
                (index) => Icon(Icons.pets, color: Colors.grey)
        ),
      ],
    );
  }

  Future<void> checkIfUserJoined() async {
    var db = FirebaseFirestore.instance;
    String? userId = widget.user.id;

    DocumentSnapshot eventSnapshot =
    await db.collection('Events').doc(event.id).get();

    List<dynamic> currentParticipants = eventSnapshot["participants"] ?? [];

    setState(() {
      hasJoined = currentParticipants.contains(userId);
    });
  }

  void joinEvent() async {
    if (hasJoined) return;

    try {
      var db = FirebaseFirestore.instance;
      String? userId = widget.user.id;
      DocumentReference eventRef = db.collection('Events').doc(event.id);

      await db.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(eventRef);

        if (!snapshot.exists) {
          throw Exception("Event does not exist!");
        }

        List<dynamic> currentParticipants = snapshot["participants"] ?? [];
        int currentCount = int.parse(snapshot["participantsCount"]);
        int maxCapacity = int.parse(snapshot["capacity"]);

        if (currentParticipants.contains(userId)) {
          throw Exception("User already joined the event!");
        }

        if (currentCount >= maxCapacity) {
          throw Exception("Event is full!");
        }

        transaction.update(eventRef, {
          "participants": FieldValue.arrayUnion([userId]),
          "participantsCount": (currentCount + 1).toString(),
        });

        setState(() {
          event.participantsCount = (currentCount + 1).toString();
          hasJoined = true;
        });

        showSnackbar(context, "Join success! See you there!", Colors.green);
      });
    } catch (e) {
      print("Error: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: AlternativeAppBar(pageTitle: "Activity Details", user: widget.user),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Event Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 230,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(172, 208, 193, 0),
                      image: DecorationImage(
                        image: FileImage(File(event.imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  event.eventName,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  'Event Organizer - ${organizerName ?? "Loading..."}',
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/calendar.png'),
                    const SizedBox(width: 10),
                    Text(event.date)
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/clock-2.png'),
                    const SizedBox(width: 10),
                    Text('${event.startTime} - ${event.endTime}')
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/location-2.png'),
                    const SizedBox(width: 10),
                    Text(event.location)
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/group.png'),
                    const SizedBox(width: 10),
                    Text('Open for ${event.capacity} participants')
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Event Description',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 15),
                Text(
                  'Current Participants (${event.participantsCount}/${event.capacity})',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                buildParticipantIcons(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: hasJoined ? Colors.grey : const Color.fromRGBO(172, 208, 193, 1)
                                    ),
                            onPressed: hasJoined? null : joinEvent,
                            child: Text(hasJoined ? 'You Have Joined the Event': 'Join Now',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16)
                            )
                        )
                    )
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }
}
