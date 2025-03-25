import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/component/custom_auth_painter_register.dart';

import '../../core/custom_exception.dart';
import '../../data/repository/user/user_repository_impl.dart';
import '../component/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  final String email;
  const ForgotPassword({super.key, required this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  UserRepoImpl userRepo = UserRepoImpl();
  final _firstNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmFocusNode = FocusNode();

  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  var _firstNameError = "";
  var _emailError = "";
  var _passwordError = "";
  var _passwordConfirmError = "";

  var showConPass = true;
  var showPass = true;

  bool isLoading = false;

  int _selectedRole = 1; // Default to "Customer"
  void _showPass(bool visibility){
    setState(() {
      showPass = !visibility;
    });
  }

  void _showConPass(bool visibility){
    setState(() {
      showConPass = !visibility;
    });
  }

  void _navigateToLogin(){
    context.go("/login");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              CustomPaint(
                painter: CurvePainterRegister(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Image.asset(
                        "assets/images/Logo_NoBG.png",
                        height: 200,
                      )
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    alignment: Alignment.center,
                    child: const Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Column(
                      children: [

                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            focusNode: _firstNameFocusNode,
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              hintText: "Name",
                              errorText: _firstNameError.isEmpty ? null : _firstNameError,
                              suffixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 5.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            focusNode: _emailFocusNode,
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorText: _emailError.isEmpty ? null : _emailError,
                              suffixIcon: const IconButton(
                                onPressed: null,
                                icon: Icon(Icons.email),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 5.0),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            focusNode: _passwordFocusNode,
                            obscureText: showPass,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "New Password",
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () => _showPass(showPass),
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                              errorText:
                              _passwordError.isEmpty ? null : _passwordError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            focusNode: _passwordConfirmFocusNode,
                            obscureText: showConPass,
                            controller: _passwordConfirmController,
                            decoration: InputDecoration(
                              hintText: "Confirm New Password",
                              suffixIcon: IconButton(
                                onPressed: () => _showConPass(showConPass),
                                icon:const Icon(Icons.remove_red_eye),
                              ),
                              errorText: _passwordConfirmError.isEmpty ? null : _passwordConfirmError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        GestureDetector(
                          // onTap: _navigateToForgotPassword,
                          child: const Text(
                            "Back to Login",
                            style: TextStyle(
                              // color: Color(0XFF8BC4A8),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFF211f1f),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 16)),
                            child:
                            // isLoading
                            //     ? const CircularProgressIndicator(
                            //     strokeWidth: 3, color: Colors.white)
                            //     :
                            const Text(
                              "Confirm New Password",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
