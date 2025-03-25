import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';

import '../../data/model/user.dart';
import '../component/snackbar.dart';
import '../customer/utils/image_utils.dart';

class EditVendorProfile extends StatefulWidget {
  final User vendorData;
  const EditVendorProfile({super.key, required this.vendorData});

  @override
  State<EditVendorProfile> createState() => _EditVendorProfileState();
}

class _EditVendorProfileState extends State<EditVendorProfile> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  var _nameError = "";
  var _emailError = "";

  Uint8List? _image;
  String imagePath = "";

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

      final Directory saveDir = Directory('${externalDir.path}/profilePics');

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

  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.vendorData.name;
    _emailController.text = widget.vendorData.email;
  }

  Future<void> saveProfile() async {
    try {
      String newEmail = _emailController.text.trim();
      String newName = _businessNameController.text.trim();

      setState(() {
        _nameError = newName.isEmpty ? "Name cannot be empty" : "";
        _emailError = newEmail.isEmpty ? "Email cannot be empty" : "";
      });

      var db = FirebaseFirestore.instance;
      DocumentReference userRef = db.collection("Users").doc(widget.vendorData.id);

      Map<String, dynamic> updatedData = {
        "name": newName,
        "email": newEmail,
      };

      await userRef.update(updatedData);

      User updatedUser = User(
          id: widget.vendorData.id,
          name: newName,
          email: newEmail,
          phoneNumber: widget.vendorData.phoneNumber,
          gender: widget.vendorData.gender,
          password: widget.vendorData.password,
          role: widget.vendorData.role
      );

      showSnackbar(context, "Profile Updated Successfully!", Colors.green);
      Navigator.pop(context, updatedUser);
    } catch (e) {
      print("Error updating profile: $e");
      showSnackbar(context, "Failed to update profile.", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(pageTitle: "Edit Profile", vendorData: widget.vendorData),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Profile Picture with Change Button
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _image == null
                    ? const AssetImage('assets/images/profile-user-big.png')
                    : MemoryImage(_image!)
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      onPressed: () => selectImage(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Business Name Field
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                labelText: "Business Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.business, color: Colors.teal),
              ),
            ),

            const SizedBox(height: 15),

            // Email Field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.email, color: Colors.teal),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(172, 208, 193, 1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: saveProfile,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

