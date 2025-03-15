import 'package:flutter/material.dart';
import 'alternative_app_bar.dart';
import 'activity_container.dart';
import 'host_new_activity.dart';

class ViewActivity extends StatefulWidget {
  const ViewActivity({super.key});

  @override
  State<ViewActivity> createState() => _ViewActivityState();
}

class _ViewActivityState extends State<ViewActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: const AlternativeAppBar(pageTitle: "Activities",),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HostNewActivity())
                        );
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
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Explore Hidden Gems Here...',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const ActivityContainer(),
              ],
            ),
          ),
        ));

  }
}
