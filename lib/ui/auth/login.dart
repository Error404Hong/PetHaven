import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../component/custom_auth_painter.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  void _navigateToRegister() {
    context.go("/register");
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
                painter: CurvePainter(),
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
                      "Welcome to PetHaven",
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
                            focusNode: _emailFocusNode,
                            // controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              // errorText: _emailError.isEmpty ? null : _emailError,
                              prefixIcon: const Icon(Icons.email),
                              // suffixIcon: isEmailVerified ? const Icon(Icons.verified) : null,
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
                            // obscureText: showPass,
                            // controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () => (),
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                              // errorText:
                              // _passwordError.isEmpty ? null : _passwordError,
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20,),

                        GestureDetector(
                          // onTap: _navigateToForgotPassword,
                          child: const Text(
                            "Forgot password?",
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
                            onPressed: () => (),
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
                              "Login",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => _navigateToRegister(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              Text(
                                "Sign up",
                                style: TextStyle(
                                    // color: Color(0XFF8BC4A8),
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
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