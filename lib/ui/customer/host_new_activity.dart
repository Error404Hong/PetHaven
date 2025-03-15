import 'package:flutter/material.dart';
import 'alternative_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_haven/ui/customer/utils/image_utils.dart';
import 'dart:typed_data';

class HostNewActivity extends StatefulWidget {
  const HostNewActivity({super.key});

  @override
  State<HostNewActivity> createState() => _HostNewActivityState();
}

class _HostNewActivityState extends State<HostNewActivity> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  Uint8List? _image;

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
      }
    } catch (e) {
      print('Error selecting image: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: const AlternativeAppBar(pageTitle: "Organize Event"),
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Event Title',
                  hintStyle: TextStyle(color: Colors.grey[600]),
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
                decoration: const InputDecoration(
                  labelText: "Choose Date",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                ),
                readOnly: true,
                onTap: () => _selectDate(),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                  labelText: "Starting Time",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time_filled),
                ),
                readOnly: true,
                onTap: () => _selectStartTime(),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: "Ending Time",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time_filled),
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Event Description',
                  hintStyle: TextStyle(color: Colors.grey[600]),
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
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: 'Enter Location',
                                hintStyle: TextStyle(color: Colors.grey[600]),
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
                              'Price',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              hint: const Text('Select Price (RM)'),
                              items: <String>['RM 5', 'RM 10', 'RM 20', 'RM 30', 'RM 50', 'RM 100']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
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
                  onPressed: () {},
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
