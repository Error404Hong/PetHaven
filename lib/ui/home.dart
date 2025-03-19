import 'package:flutter/material.dart';

import '../data/repository/user/user_repository_impl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  UserRepoImpl userRepo = UserRepoImpl();


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("home"),
    ));
  }
}
