import 'package:flutter/material.dart';
import 'alternative_app_bar.dart';

class ActivityDetails extends StatefulWidget {
  const ActivityDetails({super.key});

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: const AlternativeAppBar(pageTitle: "Activity Details"),
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
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(172, 208, 193, 0),
                      image: DecorationImage(
                        image: AssetImage('assets/images/banner.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Furry Friends Fiesta',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Event Organizer - Hong Jing Xin',
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/calendar.png'),
                    const SizedBox(width: 10),
                    const Text('17 February 2025')
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/clock-2.png'),
                    const SizedBox(width: 10),
                    const Text('10am - 12pm')
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/location-2.png'),
                    const SizedBox(width: 10),
                    const Text('Plaza Arkadia')
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/fee.png'),
                    const SizedBox(width: 10),
                    const Text('RM5 NETT')
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Event Description',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Join us for a paws-itively fun day at the Furry Friends Fiesta! Enjoy exciting games, friendly competitions, and a chance to socialize with other pet lovers. Do not miss out on this tail-wagging event!',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Current Participants (3/7)',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.pets, color: Colors.green[600]),
                    Icon(Icons.pets, color: Colors.green[600]),
                    Icon(Icons.pets, color: Colors.green[600]),
                    Icon(Icons.pets, color: Colors.grey),
                    Icon(Icons.pets, color: Colors.grey),
                    Icon(Icons.pets, color: Colors.grey),
                    Icon(Icons.pets, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(172, 208, 193, 1)),
                            onPressed: () {},
                            child: const Text('Join Now',
                                style: TextStyle(
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
