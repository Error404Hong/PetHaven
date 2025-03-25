import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/data/repository/user/user_repository.dart';

class UserRepoImpl extends UserRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final collection = FirebaseFirestore.instance.collection("Users");

  @override
  Future<bool> checkEmailInFirebase(String email) async {
    try {
      List<String> signInMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;  // Returns true if email exists, false otherwise
    } catch (e) {
      debugPrint("Error checking email: $e");
      return false; // Handle gracefully instead of throwing an error
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("hello");
      return true;
    } catch (e) {
      debugPrint("Error logging in: $e");
      return false;
      // throw CustomException("Error encountered when logging in");
    }
  }

  @override
  Future<void> register(
      String name, String email, String password, int role
      ) async {
    try {
      print(email);
      print(password);
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print(userCredential);
      final firebaseUser = userCredential.user;
      final userUID = firebaseUser?.uid;
      final hashedPassword = md5.convert(utf8.encode(password)).toString();
      final user = user_model.User(id: userUID, name: name, email: email, password: hashedPassword, role: role,phoneNumber: "NA",gender: "Other");
      await collection.doc(userUID).set(user.toMap());
    } catch (e) {
      debugPrint("Error registering: $e");
      // throw CustomException("Error encountered when registering");
    }
  }

  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  @override
  Future<user_model.User?> getUserById(String? userId) async {
    try {
      var querySnapshot = await collection
          .where("id", isEqualTo: userId)
          .get();
      var data = querySnapshot.docs.single.data();
      debugPrint(data.toString());
      var user = user_model.User.fromMap(data);
      return user;
    } catch (e) {
      debugPrint("Error getting user by the ID: $e");
      // throw CustomException("Error encountered when getting user");
    }
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }
  @override
  Future<List<user_model.User>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await collection.get();
      return querySnapshot.docs
          .map((doc) => user_model.User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
      return [];
    }
  }
  @override
  Future<void> deleteUser(String userId) async {
    try {
      // Get user email before deletion
      DocumentSnapshot userDoc = await collection.doc(userId).get();
      String? email = userDoc["email"];

      if (email != null) {
        // Delete from Firestore
        await collection.doc(userId).delete();

        // Find the Firebase Auth user
        List<String> signInMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);
        if (signInMethods.isNotEmpty) {
          UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: "dummyPassword", // Firebase requires re-authentication before deletion
          );

          // Delete user from Firebase Authentication
          await userCredential.user?.delete();
        }
      }
    } catch (e) {
      debugPrint("Error deleting user: $e");
    }
  }
}