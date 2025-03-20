import 'dart:convert';
import 'package:crypto/crypto.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final int role;
  static const String tableName = "Users";
  User(
      {this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role});
  User copyWith(
      {String? id, String? name, String? email, String? password, int? role}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    final String hashedPassword = md5.convert(utf8.encode(password)).toString();
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": hashedPassword,
      "role": role
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        password: map["password"],
        role: map["role"]);
  }
}
