import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/login.dart';
import '../auth/register.dart';
import '../home.dart';
import '../customer/homePage.dart';

class NavRouter extends StatelessWidget {
  NavRouter({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/register", builder: (context,state) => const Register()),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
    GoRoute(path: "/homePage", builder: (context, state) => const CustHomePage()),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "PetHaven",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xfff7f6ee),
        scaffoldBackgroundColor: const Color(0xfff7f6ee),
      ),
      routerConfig: GoRouter(initialLocation: initialRoute, routes: _routes),
    );
  }
}
