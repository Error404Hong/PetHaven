import 'package:pet_haven/data/model/user.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';
abstract class UserRepo {
  Future<void> checkEmailInFirebase(String email);
  Future<bool> login(String email, String password);
  Future<void> register(String name, String email, String password,int role);
  User? getCurrentUser();
  Future<user_model.User?> getUserById(String? userId);
  Future<void> logout();
  Future<List<user_model.User>> getAllUsers();
  Future<void> deleteUser(String userId);
}