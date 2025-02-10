import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_haven/ui/component/navigation_router.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
//yanhan
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: NavRouter(initialRoute:"/login")
    );
  }
}