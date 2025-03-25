import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/customer/edit_profile.dart';
import 'package:pet_haven/ui/customer/user_profile.dart';
import 'package:pet_haven/ui/admin/contactCustomerSupport.dart';
import 'package:pet_haven/ui/auth/forgot_password.dart';
import '../../data/model/user.dart' as user_model;
import '../../data/model/user.dart';
import '../../data/repository/user/user_repository.dart';
import '../Admin/adminHome.dart';
import '../auth/login.dart';
import '../auth/register.dart';
import '../home.dart';
import '../customer/homePage.dart';
import '../customer/view_activities.dart';
import '../customer/product_list.dart';
import '../customer/host_new_activity.dart';
import '../vendor/vendorHome.dart';


class NavRouter extends StatelessWidget {
  NavRouter({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  final _routes = [
    GoRoute(path: "/login", builder: (context, state) => const Login()),
    GoRoute(path: "/register", builder: (context,state) => const Register()),
    GoRoute(path: "/forgotPassword", builder: (context,state){
      final String email = state.extra as String;
      return ForgotPassword(email: email);
    },),
    GoRoute(path: "/home", builder: (context, state) => const Home()),
    GoRoute(path: "/homePage", builder: (context, state) => const CustHomePage()),
    GoRoute(path: "/vendorHome",builder: (context, state) => const Vendorhome()),
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
    GoRoute(
      path: "/user_profile",
      builder: (context, state) {
        final user_model.User userData = state.extra as user_model.User;
        return UserProfile(user: userData);
      },
    ),
    GoRoute(
      path: "/edit_profile",
      builder: (context, state) {
        final user_model.User userData = state.extra as user_model.User;
        return EditProfile(user: userData);
      },
    )
    GoRoute(path: "/admin", builder: (context, state) => const Home()),
    GoRoute(path: "/customer_support", builder: (context, state) {
      final String chatId = state.extra as String;
      return ContactCustomerSupport(chatID: chatId);
    })

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
