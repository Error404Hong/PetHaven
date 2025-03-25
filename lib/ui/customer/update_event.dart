import 'package:flutter/material.dart';
import 'package:pet_haven/data/repository/customers/event_implementation.dart';
import '../../data/model/event.dart';
import '../../data/model/user.dart';
import '../component/snackbar.dart';
import 'alternative_app_bar.dart';

class UpdateEvent extends StatefulWidget {
  final User user;
  final Event event;
  const UpdateEvent({super.key, required this.user, required this.event});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  EventImplementation eventImpl = EventImplementation();
  
  late TextEditingController _eventNameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _capacityController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();

  var _eventNameError = "";
  var _dateError = "";
  var _startTimeError = "";
  var _endTimeError = "";
  var _descriptionError = "";
  var _locationError = "";
  var _capacityError ="";

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.event.eventName);
    _locationController = TextEditingController(text: widget.event.location);
    _descriptionController = TextEditingController(text: widget.event.description);
    _capacityController = TextEditingController(text: widget.event.capacity.toString());
    _dateController = TextEditingController(text: widget.event.date);
    _startTimeController = TextEditingController(text: widget.event.startTime);
    _endTimeController = TextEditingController(text: widget.event.endTime);
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedStartTime = pickedTime;
        _startTimeController.text = _selectedStartTime.format(context);
      });
    }
  }

  Future<void> _selectEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedEndTime = pickedTime;
        _endTimeController.text = _selectedEndTime.format(context);
      });
    }
  }

  Future<void> updateEvent(BuildContext context, Event event) async {
    try {
      String eventName = _eventNameController.text.trim();
      String description = _descriptionController.text.trim();
      String location = _locationController.text.trim();
      String capacity = _capacityController.text.trim();
      String startTime = _startTimeController.text.trim();
      String endTime = _endTimeController.text.trim();
      String date = _dateController.text.trim();

      // Validate inputs
      setState(() {
        _eventNameError = eventName.isEmpty ? "Empty event title is not allowed!" : "";
        _descriptionError = description.isEmpty ? "Empty description is not allowed!" : "";
        _locationError = location.isEmpty ? "Empty location is not allowed!" : "";
        _capacityError = capacity.isEmpty ? "Empty capacity is not allowed" : "";
        _startTimeError = startTime.isEmpty ? "Empty start time is not allowed" : "";
        _endTimeError = endTime.isEmpty ? "Empty end time is not allowed" : "";
        _dateError = date.isEmpty ? "Empty date is not allowed" : "";
      });

      if (_eventNameError.isEmpty &&
          _descriptionError.isEmpty &&
          _capacityError.isEmpty &&
          _locationError.isEmpty &&
          _startTimeError.isEmpty &&
          _endTimeError.isEmpty &&
          _dateError.isEmpty) {

        // Update event object
        event.eventName = eventName;
        event.description = description;
        event.location = location;
        event.capacity = capacity;
        event.startTime = startTime;
        event.endTime = endTime;
        event.date = date;

        // Call eventImpl.updateEvent(event)
        await eventImpl.updateEvent(event);

        showSnackbar(context, "Event Updated Successfully!", Colors.green);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      showSnackbar(context, "Error updating event: $e", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: AlternativeAppBar(pageTitle: "Event Update", user: widget.user),body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/pen.png',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Editing Event Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Event Title/Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
                errorText: _eventNameError.isEmpty ? null : _eventNameError
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Date & Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Choose Date",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.calendar_today),
                errorText: _dateError.isEmpty ? null : _dateError,
              ),
              readOnly: true,
              onTap: () => _selectDate(),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startTimeController,
                    decoration: InputDecoration(
                      labelText: "Start Time",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.access_time),
                      errorText: _startTimeError.isEmpty ? null : _startTimeError,
                    ),
                    readOnly: true,
                    onTap: () => _selectStartTime(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _endTimeController,
                    decoration: InputDecoration(
                      labelText: "End Time",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.access_time),
                      errorText: _endTimeError.isEmpty ? null : _endTimeError,
                    ),
                    readOnly: true,
                    onTap: () => _selectEndTime(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Other Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Event Description',
                hintStyle: TextStyle(color: Colors.grey[600]),
                errorText: _descriptionError.isEmpty ? null : _descriptionError,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Location',
                      prefixIcon: const Icon(Icons.location_on),
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorText: _locationError.isEmpty ? null : _locationError,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _capacityController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Capacity',
                      prefixIcon: const Icon(Icons.people),
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorText: _capacityError.isEmpty ? null : _capacityError,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.event != null) {
                    updateEvent(context, widget.event);
                  } else {
                    showSnackbar(context, "Error: Event data is missing!", Colors.red);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(172, 208, 193, 1),
                ),
                child: const Text('Save Event',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
