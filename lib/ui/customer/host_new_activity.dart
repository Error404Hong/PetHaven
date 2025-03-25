import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_haven/data/model/event.dart';
import 'package:pet_haven/data/repository/customers/event_implementation.dart';
import 'package:pet_haven/ui/component/snackbar.dart';
import 'alternative_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_haven/ui/customer/utils/image_utils.dart';
import 'dart:typed_data';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:path_provider/path_provider.dart';

class HostNewActivity extends StatefulWidget {
  final user_model.User userData;
  const HostNewActivity({super.key, required this.userData});

  @override
  State<HostNewActivity> createState() => _HostNewActivityState();
}

class _HostNewActivityState extends State<HostNewActivity> {
  EventImplementation eventImpl = EventImplementation();

  final _eventNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  var _eventNameError = "";
  var _dateError = "";
  var _startTimeError = "";
  var _endTimeError = "";
  var _descriptionError = "";
  var _locationError = "";
  var _capacityError ="";
  var _imageError = "";

  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  Uint8List? _image;
  String imagePath = "";

  void selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.gallery);
      if (img != null) {
        setState(() {
          _image = img;
        });
        print("Image selected successfully");
      } else {
        print("No image selected");
        return;
      }
    } catch (e) {
      print('Error selecting image: $e');
      return;
    }

    try {
      // Use external storage for better access
      final Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print("Error: External storage directory not found.");
        return;
      }

      final Directory saveDir = Directory('${externalDir.path}/eventPics');

      print("Attempting to save image in: ${saveDir.path}");

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

    } catch (e) {
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

  Future<void> addEvent(context) async {
    try {
      String eventName = _eventNameController.text.trim();
      String description = _descriptionController.text.trim();
      String location = _locationController.text.trim();
      String capacity = _capacityController.text.trim();
      String startTime = _startTimeController.text.trim();
      String endTime = _endTimeController.text.trim();
      String date = _dateController.text.trim();
      String organizerID = widget.userData.id.toString();
      String imageFilePath = imagePath;
      String currentParticipant = "1";
      String? userID = widget.userData.id;


      setState(() {
        _eventNameError = eventName.isEmpty ? "Empty event title is not allowed!" : "";
        _descriptionError = description.isEmpty ? "Empty description is not allowed!" : "";
        _locationError = location.isEmpty ? "Empty location is not allowed!" : "";
        _capacityError = capacity.isEmpty ? "Empty capacity is not allowed" : "";
        _startTimeError = startTime.isEmpty ? "Empty start time is not allowed" : "";
        _endTimeError = endTime.isEmpty ? "Empty end time is not allowed" : "";
        _dateError = date.isEmpty ? "Empty date is not allowed" : "";
        _imageError = imagePath.isEmpty ? "Empty image is not allowed" : "";
      });

      if(_eventNameError.isEmpty && _descriptionError.isEmpty && _capacityError.isEmpty && _locationError.isEmpty && _startTimeError.isEmpty && _endTimeError.isEmpty && _dateError.isEmpty && _imageError.isEmpty) {
        Event newEvent = Event(eventName: eventName, date: date, startTime: startTime, endTime: endTime, description: description, location: location, capacity: capacity,participantsCount: currentParticipant, imagePath: imageFilePath, organizerID: organizerID, participants:  userID != null ? [userID] : []);
        eventImpl.addNewEvent(newEvent);
        showSnackbar(context, "Event Added Successfully!", Colors.green);

        setState(() {
          _eventNameController.clear();
          _descriptionController.clear();
          _locationController.clear();
          _capacityController.clear();
          _startTimeController.clear();
          _endTimeController.clear();
          _dateController.clear();
          imagePath = "";

          _eventNameError = "";
          _descriptionError = "";
          _locationError = "";
          _capacityError = "";
          _startTimeError = "";
          _endTimeError = "";
          _dateError = "";
          _imageError = "";
        });
      }
    } catch(e) {
      showSnackbar(context, e.toString(), Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: AlternativeAppBar(pageTitle: "Organize Event", user: widget.userData),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    bottom: 65,
                    left: 162,
                    child: IconButton(
                      onPressed: () => selectImage(),
                      icon: const Icon(Icons.add_a_photo_rounded, size: 33),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Event Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Event Title',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  errorText: _eventNameError.isEmpty ? null : _eventNameError,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Date & Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Choose Date",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                  errorText: _dateError.isEmpty ? null : _dateError,
                ),
                readOnly: true,
                onTap: () => _selectDate(),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _startTimeController,
                decoration: InputDecoration(
                  labelText: "Starting Time",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.access_time_filled),
                  errorText: _startTimeError.isEmpty ? null : _startTimeError,
                ),
                readOnly: true,
                onTap: () => _selectStartTime(),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _endTimeController,
                decoration: InputDecoration(
                  labelText: "Ending Time",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.access_time_filled),
                  errorText: _endTimeError.isEmpty ? null : _endTimeError,
                ),
                readOnly: true,
                onTap: () => _selectEndTime(),
              ),
              const SizedBox(height: 25),
              const Text(
                'Event Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Event Description',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  errorText: _descriptionError.isEmpty ? null : _descriptionError,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Enter Location',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                errorText: _locationError.isEmpty ? null : _locationError,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Participants Capacity',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _capacityController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Enter Capacity',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                errorText: _capacityError.isEmpty ? null : _capacityError,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => addEvent(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(172, 208, 193, 1),
                  ),
                  child: const Text('Organize Activity',
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
