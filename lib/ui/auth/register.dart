import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_haven/ui/component/custom_auth_painter_register.dart';

import '../../core/custom_exception.dart';
import '../../data/repository/user/user_repository_impl.dart';
import '../component/snackbar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
  void _showPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  void _showConPass() {
    setState(() {
      showConPass = !showConPass;
    });
  }

  void _navigateToLogin(){
    context.go("/login");
  }

  void _navigateToHome(){
    context.go("/home");

  }

  Future<void> register(context) async {
    try {
      String firstName = _firstNameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String passwordConfirm = _passwordConfirmController.text.trim();

      // VALIDATION (Stop early if invalid)
      if (firstName.isEmpty) {
        setState(() => _firstNameError = "This field cannot be empty");
        return;
      } else {
        _firstNameError = "";
      }

      if (!EmailValidator.validate(email)) {
        setState(() => _emailError = "Invalid email format");
        return;
      } else {
        _emailError = "";
      }

      if (password.length < 8) {
        setState(() => _passwordError = "Password needs to be at least 8 characters long");
        return;
      } else {
        _passwordError = "";
      }

      if (passwordConfirm != password) {
        setState(() => _passwordConfirmError = "Passwords must match");
        return;
      } else {
        _passwordConfirmError = "";
      }

      setState(() => isLoading = true); // Only set loading after validation passes

      // CHECK IF EMAIL EXISTS
      var emailExists = await userRepo.checkEmailInFirebase(email);
      if (emailExists) {
        throw CustomException("An account was already registered to this email");
      }

      // REGISTER USER
      print("Registering user...");
      await userRepo.register(firstName, email, password, _selectedRole);
      print("User registered successfully");

      showSnackbar(context, "Register successful", Colors.green);
      _navigateToHome();
    } catch (e) {
      showSnackbar(context, e.toString(), Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
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
                          child: DropdownButtonFormField<int>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text("Customer")),
                              DropdownMenuItem(value: 2, child: Text("Vendor")),
                            ],
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
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
                                onPressed: _showPass,
                                icon: Icon(showPass ? Icons.visibility : Icons.visibility_off),
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
                              hintText: "Confirm Password",
                              suffixIcon: IconButton(
                                onPressed: _showConPass,
                                icon: Icon(showConPass ? Icons.visibility : Icons.visibility_off),
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
                            onPressed: () => register(context),
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
                              "Register",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => _navigateToLogin(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? "),
                              Text(
                                "Sign in",
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
