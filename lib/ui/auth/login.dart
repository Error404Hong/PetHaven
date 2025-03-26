import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/service/shared_preferences.dart';
import '../component/custom_auth_painter.dart';
import '../../data/repository/user/user_repository_impl.dart';
import '../component/snackbar.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserRepoImpl userRepo = UserRepoImpl();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _passwordError = "";
  var _emailError = "";
  bool isLoading = false;
  var showPass = true;

  void _showPass(bool visibility){
    setState(() {
      showPass = !visibility;
    });
  }

  void _navigateToHome(){
    context.go("/home");
  }
  void _navigateToForgotPassword() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = "Please enter your email.";
      });
      return;
    }
    setState(() {
      _emailError = ""; // Clear any previous error
    });
    context.go("forgotPassword", extra: email);
  }

  Future<void> login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    try {
      setState(() {
        isLoading = true;
      });

      final bool success = await userRepo.login(email, password);

      if (success) {
        await SharedPreference.setIsLoggedIn(true);
        showSnackbar(context, "Login successful!", Colors.green);
        _navigateToHome();
      } else {
        showSnackbar(context, "Incorrect email or password.", Colors.red);
      }
    } catch (e) {
      debugPrint("Error logging in: $e");
      showSnackbar(context, "Login failed. Please try again.", Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


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
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              errorText: _emailError.isEmpty ? null : _emailError,
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
                            obscureText: showPass,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () => _showPass(true),
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

                        GestureDetector(
                          onTap: _navigateToForgotPassword,
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
                            onPressed: () => login(context),
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