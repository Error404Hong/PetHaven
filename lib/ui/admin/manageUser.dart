import 'package:flutter/material.dart';
import 'package:pet_haven/data/model/user.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  final UserRepoImpl _userRepo = UserRepoImpl();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    List<User> users = await _userRepo.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _deleteUser(String userId) async {
    await _userRepo.deleteUser(userId);
    _fetchUsers(); // Refresh user list after deletion
  }

  /// **Convert role number to string**
  String _getRoleName(int? role) {
    switch (role) {
      case 3:
        return "Admin";
      case 2:
        return "Vendor";
      case 1:
        return "Customer";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : _users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.black),
              ),
              title: Text(user.name ?? "Unknown",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Email: ${user.email}\nRole: ${_getRoleName(user.role)}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteUser(user.id!),
              ),
            ),
          );
        },
      ),
    );
  }
}
