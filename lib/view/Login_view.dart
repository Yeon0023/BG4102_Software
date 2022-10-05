import 'package:bg4102_software/Utilities/glassmorphism.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utilities/Show_error_dialog.dart'; //This is to replace print()

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isBlur = false;
  bool _isObscure = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _isObscure = true;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const customAppbar(
        title: '--Breathalyzer--',
        fontSize: 37,
        actions: null,
        leading: null,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 60.0,
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'assets/images/icons8-beers-100.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 2,
                  ),
                  //User email key in box
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      label: Text('Username '),
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter Your Email Here',
                      focusedBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 5,
                  ),
                  //User Key in Password
                  child: TextField(
                    controller: _password,
                    obscureText: _isObscure,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      hintText: "Enter Your Password Here",
                      focusedBorder: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            forgetPasswordRoute,
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: GoogleFonts.lobster(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                //Login Button
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        //If user email is verified
                        //ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          noteRoute,
                          (route) => false,
                        );
                      } else {
                        // If user email is NOT verified
                        ////ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute,
                          (route) => false,
                        );
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        'User not found',
                      );
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Wrong Password',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Authentication Error',
                      );
                    }
                    setState(() {
                      _isBlur = !_isBlur;
                    });
                  },
                  child: GlassMorphism(
                    blur: _isBlur ? 20 : 0,
                    opacity: 0.25,
                    child: SizedBox(
                      height: 45,
                      width: 345,
                      child: Center(
                        child: Text(
                          "Sign In!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lobster(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Register redirect button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.lobster(fontSize: 16),
                  ),
                  child: const Text('Not registered yet? Register here!'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
