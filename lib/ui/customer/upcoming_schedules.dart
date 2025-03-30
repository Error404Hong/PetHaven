import 'package:flutter/material.dart';
import '../../data/model/event.dart';
import '../../data/model/user.dart';
import '../../data/repository/customers/event_implementation.dart';
import 'alternative_app_bar.dart';
import 'activity_box.dart';

class UpcomingSchedules extends StatefulWidget {
  final User user;
  const UpcomingSchedules({super.key, required this.user});

  @override
  State<UpcomingSchedules> createState() => _UpcomingSchedulesState();
}

class _UpcomingSchedulesState extends State<UpcomingSchedules> {
  EventImplementation eventImpl = EventImplementation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: AlternativeAppBar(pageTitle: "Upcoming Schedules", user: widget.user),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(23.0, 28.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scheduled Activities',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                StreamBuilder<List<Event>>(
                  stream: eventImpl.getJoinedEvents(widget.user), // Pass user.id directly
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No upcoming activities"));
                    }

                    List<Event> events = snapshot.data!; // Already a List<Event>

                    return Column(
                      children: events.map((event) => ActivityBox(user: widget.user!, event: event)).toList(),
                    );
                  },
                ),
              ],
            )
        ),
      )
    );
  }
}
