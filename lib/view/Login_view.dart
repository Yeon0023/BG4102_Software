import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
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

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
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
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal[900],
        ),
        elevation: 0,
        backgroundColor: Colors.teal[900],
        title: const Text('-Breathalyzer-'),
        titleTextStyle: GoogleFonts.lobster(fontSize: 37),
        centerTitle: true,
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
                      'assets/icons8-beers-100.png',
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

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 5,
                  ),
                  //User Key in Password
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Enter Your Password Here",
                      hintStyle: TextStyle(fontSize: 16),
                      focusedBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),

                //Login Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 155),
                    textStyle: GoogleFonts.lobster(fontSize: 17),
                  ),
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
                  },
                  child: const Text("Sign In!"),
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