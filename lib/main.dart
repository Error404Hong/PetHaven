import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/ui/component/navigation_router.dart';
import 'core/service/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Ensure Firebase is initialized
  bool isLoggedIn = await SharedPreference.isLoggedIn(); // Check login status

  runApp(MyApp(isLoggedIn: isLoggedIn));
}
//yanhan
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: "PetHaven",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xfff7f6ee),
          scaffoldBackgroundColor: const Color(0xfff7f6ee),
        ),
        darkTheme: ThemeData(
            primaryColor: const Color(0xfff7f6ee),
            scaffoldBackgroundColor: const Color(0xfff7f6ee),
        ),
        home: NavRouter(initialRoute: isLoggedIn ? "/home" : "/login")
    );
  }
}