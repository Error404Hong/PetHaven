import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/data/repository/user/user_repository_impl.dart';
import 'package:pet_haven/ui/vendor/edit_vendor_profile.dart';
import 'package:pet_haven/ui/vendor/product_management.dart';
import 'package:pet_haven/ui/vendor/vendor_app_bar.dart';
import '../../core/service/shared_preferences.dart';
import '../../data/model/user.dart';
import 'order_dashboard.dart';

class VendorProfile extends StatefulWidget {
  final User vendorData;
  const VendorProfile({super.key, required this.vendorData});

  @override
  State<VendorProfile> createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  UserRepoImpl UserRepo = UserRepoImpl();
  late User _vendorInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  void getUserID() async {
    User? userDetails= await UserRepo.getUserById(widget.vendorData.id);
    setState(() {
      _vendorInfo = userDetails!;
      _isLoading = false;
    });
  }

  void _logout() async {
    await SharedPreference.setIsLoggedIn(false);
    UserRepo.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorAppBar(pageTitle: "Vendor Profile", vendorData: widget.vendorData),
      body: _isLoading ? const Center(child: CircularProgressIndicator())
        : Padding(
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
            const SizedBox(height: 15),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _vendorInfo.name,
                    style: const TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      _vendorInfo.email,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditVendorProfile(vendorData: _vendorInfo),
                        ),
                      );

                      // Check if data was returned and update the UI
                      if (updatedUser != null && updatedUser is User) {
                        setState(() {
                          _vendorInfo = updatedUser;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFACD0C1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 50, color: Colors.black54),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'General',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/box.png'),
                        const SizedBox(width: 15),
                        const Text(
                          'Order Management',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderDashboard(vendorData: widget.vendorData))
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                        children: [
                          Text(
                            'View',
                            style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),
                          ),
                          SizedBox(width: 5), // Space between text and icon
                          Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/option.png'),
                        const SizedBox(width: 15),
                        const Text(
                          'Product Management',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductManagement(vendorData: widget.vendorData))
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                        children: [
                          Text(
                            'View',
                            style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),
                          ),
                          SizedBox(width: 5), // Space between text and icon
                          Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/logout.png'),
                        const SizedBox(width: 15),
                        const Text(
                          'Logout Account',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () => _logout(),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, // Ensures button wraps content
                        children: [
                          Text(
                            'Log out Now',
                            style: TextStyle(color: Color.fromRGBO(0, 139, 139, 1)),
                          ),
                          SizedBox(width: 5), // Space between text and icon
                          Icon(Icons.navigate_next_rounded, color: Color.fromRGBO(0, 139, 139, 1)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
