import 'package:bg4102_software/Utilities/Show_error_dialog.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as devtools show log;


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        backgroundColor: Colors.teal[900],
        title: const Center(child: Text('Register Here!')),
        titleTextStyle: GoogleFonts.lobster(fontSize: 25),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20,
                ),
                child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter Your Email Here",
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 3,
                ),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter Your Password Here",
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    await AuthService.firebase().sendEmailVerification();
                    // ignore: unused_local_variable
                    final user = AuthService.firebase().currentUser;
                    //ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                    //devtools.log(userCredential.toString());
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                      context,
                      'Weak Password!',
                    );
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(
                      context,
                      'Email already in use!',
                    );
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                      context,
                      'This is an Invalid Email Address!',
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Failed to register',
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, textStyle: GoogleFonts.lobster(fontSize: 16),
                ),
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    //'/login/',
                    loginRoute,
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, textStyle: GoogleFonts.lobster(fontSize: 16),
                ),
                child: const Text('Already registered? Login here!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}