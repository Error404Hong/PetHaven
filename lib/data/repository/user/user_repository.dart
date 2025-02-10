import 'dart:io';
import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:pet_haven/data/model/user.dart';

abstract class UserRepo {
  Future<void> checkEmailInFirebase(String email);
  Future<void> login(String email, String password);
  Future<void> register(String name, String email, String password,int role);
  // User? getCurrentUser();
  Future<user_model.User?> getUserById(String userId);
  Future<void> logout();
}