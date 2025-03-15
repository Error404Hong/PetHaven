import 'package:flutter/material.dart';
import 'view_activity_details.dart';

class ActivityContainer extends StatefulWidget {
  const ActivityContainer({super.key});

  @override
  State<ActivityContainer> createState() => _ActivityContainerState();
}

class _ActivityContainerState extends State<ActivityContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 15.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(172, 208, 193, 1),
            borderRadius: BorderRadius.circular(10.0), // Uniform radius
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('Activity 1'),
                ],
              ),
              const SizedBox(height: 5),
              const Row(
                children: [
                  Text(
                    'Furry Friends Fiesta',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey, thickness: 1.0),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/clock.png'),
                  const SizedBox(width: 10),
                  const Text('17th February 2025, 10am-12pm')
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/location.png'),
                  const SizedBox(width: 10),
                  const Text('Plaza Arkadia')
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const ActivityDetails()));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: Colors.grey[800],
                ),
                child: const Text(
                  'Check Event Details',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30), // Adds space after the container
      ],
    );
  }
}
