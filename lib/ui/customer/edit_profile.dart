import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/component/snackbar.dart';
import '../../data/model/user.dart';
import 'alternative_app_bar.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController genderController;

  var _nameError = "";
  var _emailError = "";
  var _phoneNumberError = "";
  var _genderError = "";

  @override
  void initState() {
  super.initState();
  nameController = TextEditingController(text: widget.user.name);
  emailController = TextEditingController(text: widget.user.email);
  phoneController = TextEditingController(text: widget.user.phoneNumber);
  genderController = TextEditingController(text: widget.user.gender);
  }

  Future<void> saveProfile() async {
    try {
      String newName = nameController.text.trim();
      String newEmail = emailController.text.trim();
      String newPhoneNum = phoneController.text.trim();
      String newGender = genderController.text.trim();

      setState(() {
        _nameError = newName.isEmpty ? "Name cannot be empty" : "";
        _emailError = newEmail.isEmpty ? "Email cannot be empty" : "";
        _phoneNumberError = newPhoneNum.isEmpty ? "Phone number cannot be empty" : "";
        _genderError = newGender.isEmpty ? "Gender cannot be empty" : "";
      });

      List<String> errors = [];
      if (_nameError.isNotEmpty) errors.add(_nameError);
      if (_emailError.isNotEmpty) errors.add(_emailError);
      if (_phoneNumberError.isNotEmpty) errors.add(_phoneNumberError);
      if (_genderError.isNotEmpty) errors.add(_genderError);

      if (errors.isNotEmpty) {
        showErrorDialog(errors);
        return;
      }

      var db = FirebaseFirestore.instance;
      DocumentReference userRef = db.collection("Users").doc(widget.user.id);

      Map<String, dynamic> updatedData = {
        "name": newName,
        "email": newEmail,
        "phoneNumber": newPhoneNum,
        "gender": newGender
      };

      await userRef.update(updatedData);

      User updatedUser = User(
        id: widget.user.id,
        name: newName,
        email: newEmail,
        phoneNumber: newPhoneNum,
        gender: newGender,
        password: widget.user.password,
        role: widget.user.role
      );

      showSnackbar(context, "Profile Updated Successfully!", Colors.green);

      // context.pop(updatedUser);
      Navigator.pop(context, updatedUser);

    } catch (e) {
      print("Error updating profile: $e");
      showSnackbar(context, "Failed to update profile.", Colors.red);
    }
  }

  void showErrorDialog(List<String> errors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Input Error", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors.map((error) => Text("• $error", style: const TextStyle(fontSize: 14))).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.black87)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
      appBar: AlternativeAppBar(pageTitle: "Edit Profile", user: widget.user),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 48, 28, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile-user-big.png'),
                radius: 40,
              ),
            ),
            const SizedBox(height: 38),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Email Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Phone Number Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.42, // Adjust width as needed
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Gender Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.42, // Adjust width as needed
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.male_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              value: widget.user.gender!.isNotEmpty ? widget.user.gender : "Male", // Ensure a default value
                              items: ["Male", "Female", "Other"].map((String gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    genderController.text = newValue; // Update controller when user selects a value
                                  });
                                }
                              },
                            ),

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => saveProfile(),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          Color.fromRGBO(172, 208, 193, 1)),
                    ),
                    child: const Text('Save Profile',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
