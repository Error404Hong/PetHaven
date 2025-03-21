import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/component/snackbar.dart';
import '../../core/service/shared_preferences.dart';
import '../../data/model/user.dart';
import 'alternative_app_bar.dart';
import '../../data/repository/user/user_repository_impl.dart';

class ResetPassword extends StatefulWidget {
  final User user;
  const ResetPassword({super.key, required this.user});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  UserRepoImpl UserRepo = UserRepoImpl();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _newPasswordError = "";
  var _confirmPasswordError = "";
  var _passwordUnchangedError = "";
  var _passwordDifferentError = "";
  var _passwordLengthError = "";

  Future<void> changePassword() async {
    try {
      String newPass = _newPasswordController.text.trim();
      String confirmPass = _confirmPasswordController.text.trim();

      setState(() {
        _newPasswordError = newPass.isEmpty ? "New password cannot be empty" : "";
        _confirmPasswordError = confirmPass.isEmpty ? "Please confirm your new password" : "";
        _passwordDifferentError = "";
        _passwordLengthError = "";
        _passwordUnchangedError = "";
      });

      // Validate empty passwords
      if (newPass.isEmpty || confirmPass.isEmpty) {
        List<String> errors = [];
        if (_newPasswordError.isNotEmpty) errors.add(_newPasswordError);
        if (_confirmPasswordError.isNotEmpty) errors.add(_confirmPasswordError);
        showErrorDialog(errors);
        return;
      }

      // Check if passwords match
      if (newPass != confirmPass) {
        setState(() {
          _passwordDifferentError = "New password and confirmation password do not match";
        });
      }

      // Check minimum password length
      if (newPass.length < 8) {
        setState(() {
          _passwordLengthError = "Password needs to be at least 8 characters long";
        });
      }

      // Check if the new password is the same as the old one
      bool isSameAsOld = await checkOldPassword(newPass);
      if (isSameAsOld) {
        setState(() {
          _passwordUnchangedError = "New password must be different from the old password";
        });
      }

      // Collect all errors
      List<String> errors = [];
      if (_passwordDifferentError.isNotEmpty) errors.add(_passwordDifferentError);
      if (_passwordLengthError.isNotEmpty) errors.add(_passwordLengthError);
      if (_passwordUnchangedError.isNotEmpty) errors.add(_passwordUnchangedError);

      if (errors.isNotEmpty) {
        showErrorDialog(errors);
        return;
      }

      print("Password is valid for update.");

      // 🔹 Step 1: Get the current authenticated user
      firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw Exception("User not logged in.");
      }

      // 🔹 Step 2: Update password in Firebase Authentication
      await currentUser.updatePassword(newPass);
      print("Password updated successfully!");

      // Show success message
      showSnackbar(context, "Password updated successfully!", Colors.green);
      _logout();

    } catch (e) {
      print("Error updating password: $e");
      showErrorDialog(["Failed to update password. Please try again."]);
    }
  }


  Future<bool> checkOldPassword(String oldPassword) async {
    try {
      var currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (currentUser == null || currentUser.email == null) {
        throw Exception("User not found");
      }

      firebase_auth.AuthCredential credential = firebase_auth.EmailAuthProvider.credential(
        email: currentUser.email!,
        password: oldPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);
      return true; // Password is correct
    } catch (e) {
      print("Incorrect password: $e");
      return false;
    }
  }


  void showErrorDialog(List<String> errors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Something went wrong!", style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _logout() async {
    await SharedPreference.setIsLoggedIn(false);
    UserRepo.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 246, 238, 1),
        appBar: AlternativeAppBar(pageTitle: "Reset Password", user: widget.user),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(23.0, 28.0, 15.0, 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create New Password",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                const Text(
                  textAlign: TextAlign.justify,
                  'Your new password must be completely different from any previously used passwords to enhance security and prevent unauthorized access 🔒.',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                const Text('New Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
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
                    controller: _newPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Enter your new password",
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Confirm Password',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
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
                    controller: _confirmPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Confirm your new password",
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () => changePassword(),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                                Color.fromRGBO(172, 208, 193, 1)),
                          ),
                          child: const Text('Save Password',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
