import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final int role;
  final String? phoneNumber;
  final String? gender;
  static const String tableName = "Users";
  User(
      {this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      this.gender,
      this.phoneNumber});
  User copyWith(
      {String? id, String? name, String? email, String? password, int? role, String? phoneNumber, String? gender}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber
    );
  }

  Map<String, dynamic> toMap() {
    final String hashedPassword = md5.convert(utf8.encode(password)).toString();
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": hashedPassword,
      "role": role,
      "gender": gender,
      "phoneNumber": phoneNumber
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        password: map["password"],
        role: map["role"],
        phoneNumber: map["phoneNumber"],
        gender: map["gender"]
    );
  }
  factory User.empty() {
    return User(
      id: "",
      name: "Guest",
      email: "guest@example.com",
      password: "",
      role: 0,
      phoneNumber: "",
      gender: "",
    );
  }
}
