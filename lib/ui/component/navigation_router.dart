import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/user.dart' as user_model;
import '../auth/login.dart';
import '../auth/register.dart';
import '../home.dart';
import '../customer/homePage.dart';
import '../customer/view_activities.dart';
import '../customer/product_list.dart';
import '../customer/host_new_activity.dart';

class NavRouter extends StatelessWidget {
  NavRouter({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/register", builder: (context,state) => const Register()),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
    GoRoute(path: "/homePage", builder: (context, state) => const CustHomePage()),
    GoRoute(
      path: "/view_activities",
      builder: (context, state) {
        final user_model.User userData = state.extra as user_model.User;
        return ViewActivity(userData: userData);
      },
    ),
    GoRoute(
      path: "/product_list",
      builder: (context, state) {
        final user_model.User userData = state.extra as user_model.User;
        return ProductList(userData: userData);
      },
    ),
    GoRoute(
      path: "/host_new_activity",
      builder: (context, state) {
        final user_model.User userData = state.extra as user_model.User;
        return HostNewActivity(userData: userData);
      },
    ),
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
