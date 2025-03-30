import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_haven/data/repository/customers/event_implementation.dart';
import 'package:pet_haven/ui/customer/utils/image_utils.dart';
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

  String imagePath = "";
  Uint8List? _image;

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
    _loadImage(widget.event.imagePath);
  }

  Future<void> _loadImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        Uint8List imageBytes = await file.readAsBytes(); // Read file bytes

        setState(() {
          _image = imageBytes;
        });

        print("Image successfully loaded from file.");
      } else {
        print("File does not exist: $imagePath");
      }
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  void selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.gallery);
      if(img != null) {
        setState(() {
          _image = img;
        });
      } else {
        print("No image selected");
        return;
      }
    } catch(e) {
      print('Error selecting image: $e');
      return;
    }

    try {
      final Directory? externalDir = await getExternalStorageDirectory();

      if (externalDir == null) {
        print("Error: External storage directory not found.");
        return;
      }

      final Directory saveDir = Directory('${externalDir.path}/productPics');

      if (!await saveDir.exists()) {
        print("Directory does not exist. Creating now...");
        await saveDir.create(recursive: true);
      } else {
        print("Directory already exists.");
      }

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String savePath = '${saveDir.path}/$fileName';
      imagePath = savePath;
      final File localImage = File(savePath);

      print("Final save path: $savePath");

      await localImage.writeAsBytes(_image!).then((_) {
        print("Image successfully saved at: $savePath");
      }).catchError((error) {
        print("Error writing image: $error");
      });

    } catch(e) {
      print('Error saving image: $e');
    }
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


      String imageFilePath = imagePath.isNotEmpty ? imagePath : event.imagePath;

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
        event.imagePath = imageFilePath;

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
        padding: const EdgeInsets.fromLTRB(18, 28, 18, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const Text(
                "Update Event Cover Image",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            const SizedBox(height: 18),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: _image != null
                          ? MemoryImage(_image!)
                          : const NetworkImage(
                        "https://images.unsplash.com/photo-1738626068354-bfede24d8c9c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjh8fGJhbm5lciUyMG1vdW50YWlufGVufDB8fDB8fHww",
                      ) as ImageProvider<Object>,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6), // Background contrast
                    ),
                    padding: const EdgeInsets.all(8), // Padding for better touch area
                    child: IconButton(
                      onPressed: () => selectImage(),
                      icon: const Icon(
                        Icons.add_a_photo_rounded,
                        size: 30, // Bigger icon
                        color: Colors.white, // White for better visibility
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              "Manage Event Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
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
