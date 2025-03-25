import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/customers/event_implementation.dart';
import 'package:pet_haven/ui/customer/update_event.dart';
import 'package:pet_haven/ui/customer/view_activity_details.dart';
import '../../data/model/event.dart';
import '../../data/model/user.dart';

class ActivityBox extends StatefulWidget {
  final User user;
  final Event? event;
  final String mode; // "view" or "manage"

  const ActivityBox({
    super.key,
    required this.user,
    this.event,
    this.mode = "view", // Default mode is "view"
  });

  @override
  State<ActivityBox> createState() => _ActivityBoxState();
}

class _ActivityBoxState extends State<ActivityBox> {
  EventImplementation eventImpl = EventImplementation();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: widget.mode == "manage"
          ? Dismissible(
        key: ValueKey(widget.event!.id), // Unique key for each event
        background: Container(
          alignment: Alignment.centerLeft,
          color: Colors.blue, // Right swipe (Modify)
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.edit, color: Colors.white, size: 30),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          color: Colors.red, // Left swipe (Delete)
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Swipe left (delete)
            return await _confirmDelete(context, widget.event!);
          } else if (direction == DismissDirection.startToEnd) {
            // Swipe right (modify)
            _navigateToModifyEvent();
            return false; // Prevent dismissal
          }
          return false;
        },
        child: _buildEventBox(),
      )
          : GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityDetails(
                event: widget.event!,
                user: widget.user,
              ),
            ),
          );
        },
        child: _buildEventBox(),
      ),
    );
  }

  Widget _buildEventBox() {
    return Stack(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(widget.event!.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event!.eventName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.event!.date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Event event) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await eventImpl.deleteEvent(event);
      return true; // Ensure the item gets dismissed
    }
    return false; // Prevent dismissal if not confirmed
  }

  void _navigateToModifyEvent() {
    // Navigate to the event modification page
    Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => UpdateEvent(user: widget.user, event: widget.event!))
    );
  }
}
