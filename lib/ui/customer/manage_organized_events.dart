import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/customers/event_implementation.dart';

import '../../data/model/event.dart';
import '../../data/model/user.dart';
import 'activity_box.dart';
import 'alternative_app_bar.dart';

class ManageOrganizedEvents extends StatefulWidget {
  final User user;
  const ManageOrganizedEvents({super.key, required this.user});

  @override
  State<ManageOrganizedEvents> createState() => _ManageOrganizedEventsState();
}

class _ManageOrganizedEventsState extends State<ManageOrganizedEvents> {
  EventImplementation eventImpl = EventImplementation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: AlternativeAppBar(pageTitle: "Event Manager", user: widget.user),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(23.0, 28.0, 15.0, 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Organized Events',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            StreamBuilder<List<Event>>(
              stream: eventImpl.getOrganizedEvent(widget.user), // Pass user.id directly
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("You have not organize any event!"));
                }

                List<Event> events = snapshot.data!; // Already a List<Event>

                return Column(
                  children: events.map((event) => ActivityBox(user: widget.user, event: event, mode: "manage")).toList(),
                );
              },
            ),
          ],

        ),
      )
    );
  }
}
