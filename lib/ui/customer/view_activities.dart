import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/customers/event_implementation.dart';
import '../../data/model/event.dart';
import 'alternative_app_bar.dart';
import 'activity_container.dart';
import 'host_new_activity.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:go_router/go_router.dart';

class ViewActivity extends StatefulWidget {
  final user_model.User userData;

  const ViewActivity({super.key, required this.userData});

  @override
  State<ViewActivity> createState() => _ViewActivityState();
}

class _ViewActivityState extends State<ViewActivity> {
  EventImplementation eventImpl = EventImplementation();

  final _searchController = TextEditingController();
  var _searchError = "";
  List<Event> searchResults = [];

  Future<void> searchActivity() async {
    String searchQuery = _searchController.text.trim().toLowerCase();

    setState(() {
      _searchError = searchQuery.isEmpty ? "Please specify a keyword to search." : "";
      searchResults.clear(); // Clear previous search results
    });

    if (searchQuery.isEmpty) return;

    var db = FirebaseFirestore.instance;

    try {
      QuerySnapshot result = await db.collection('Events').get(); // Fetch all events

      List<Event> finalResults = result.docs
          .where((doc) {
        String eventName = doc['eventName'].toString().toLowerCase();
        String description = doc['description'].toString().toLowerCase();
        String location = doc['location'].toString().toLowerCase();

        return eventName.contains(searchQuery) ||
            description.contains(searchQuery) ||
            location.contains(searchQuery);
      })
          .map((doc) => Event(
            id: doc.id,
            eventName: doc['eventName'],
            description: doc['description'],
            location: doc['location'],
            date: doc['date'],
            startTime: doc['startTime'],
            endTime: doc['endTime'],
            capacity: doc['capacity'],
            participants: List<String>.from(doc['participants'] ?? []),
            participantsCount: doc['participantsCount'],
            imagePath: doc['imagePath'],
            organizerID: doc['organizerID']
      ))
          .toList();

      setState(() {
        if (finalResults.isEmpty) {
          _searchError = "No results found for \"$searchQuery\".";
        } else {
          _searchError = "";
          searchResults = finalResults;
        }
      });

      for (var event in searchResults) {
        print("✅ Found: ${event.eventName} at ${event.location}");
      }
    } catch (e) {
      print("⚠️ Error: $e");
      setState(() {
        _searchError = "An error occurred while searching.";
      });
    }
  }

  void clearSearch() {
    setState(() {
      _searchController.clear();
      _searchError = "";
      searchResults.clear();
    });
  }

  Map<String, List<Event>> categorizeEvents(List<Event> events) {
    List<Event> upcomingEvents = [];
    List<Event> pastEvents = [];

    DateTime now = DateTime.now();

    for(var event in events) {
      DateTime eventDate = DateTime.parse(event.date);
      if(eventDate.isAfter(now)) {
        upcomingEvents.add(event);
      } else {
        pastEvents.add(event);
      }
    }

    return {
      "Upcoming": upcomingEvents,
      "Past": pastEvents
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: AlternativeAppBar(pageTitle: "Activities", user: widget.userData),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Buzzing Activities 🎊',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.push("/host_new_activity", extra: widget.userData);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Host Event',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Explore Hidden Gems Here...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        errorText: _searchError.isEmpty ? null : _searchError,
                        suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.search), onPressed: searchActivity),
                          if (_searchController.text.isNotEmpty)
                            IconButton(icon: const Icon(Icons.clear), onPressed: () => clearSearch()),
                        ],
                      ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 30),
                if (searchResults.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Search Results 🔍",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ActivityContainer(event: searchResults[index], user: widget.userData);
                        },
                      ),
                    ],
                  )
                else
                StreamBuilder<List<Event>>(
                  stream: eventImpl.getAllEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No activities available"));
                    }

                    // Categorize events into "Upcoming" and "Past"
                    Map<String, List<Event>> categorizedEvents = categorizeEvents(snapshot.data!);
                    List<Event> upcomingEvents = categorizedEvents["Upcoming"] ?? [];
                    List<Event> pastEvents = categorizedEvents["Past"] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Upcoming Events
                        if (upcomingEvents.isNotEmpty) ...[
                          const Text(
                            "Upcoming Events 🔜",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: upcomingEvents.length,
                            itemBuilder: (context, index) {
                              return ActivityContainer(event: upcomingEvents[index], user: widget.userData);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],

                        if (pastEvents.isNotEmpty) ...[
                          const Text(
                            "Past Events ⏳",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pastEvents.length,
                            itemBuilder: (context, index) {
                              return ActivityContainer(event: pastEvents[index], user: widget.userData);
                            },
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
