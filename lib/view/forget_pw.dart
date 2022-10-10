import 'package:bg4102_software/Utilities/Show_error_dialog.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';

import '../Utilities/customAppbar.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        title: 'Forget Password Page',
        fontSize: 25,
        actions: null,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Your Email Here to Reset Your Password!',
            style: GoogleFonts.lobster(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
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
          MaterialButton(
            onPressed: () async {
              final email = _email.text;
              try {
                await AuthService.firebase().sendPasswordResetEmail(
                  email: email,
                );
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text(
                          'Please check your email to reset your password',
                        ),
                      );
                    });
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'This is an Invalid Email Address!',
                );
              }
            },
            child: Text(
              'Reset Password',
              style: GoogleFonts.lobsterTwo(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
