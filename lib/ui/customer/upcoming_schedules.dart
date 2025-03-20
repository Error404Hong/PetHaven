import 'package:flutter/material.dart';
import 'alternative_app_bar.dart';
import 'activity_box.dart';

class UpcomingSchedules extends StatefulWidget {
  const UpcomingSchedules({super.key});

  @override
  State<UpcomingSchedules> createState() => _UpcomingSchedulesState();
}

class _UpcomingSchedulesState extends State<UpcomingSchedules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: const AlternativeAppBar(pageTitle: "Upcoming Schedules"),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(23.0, 28.0, 15.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Scheduled Activities',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const ActivityBox();
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
