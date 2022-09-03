import 'dart:ui';

import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: const Text('Verify email'),
        backgroundColor: Colors.teal[900],
        titleTextStyle: GoogleFonts.lobster(fontSize: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 50,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(),
          child: Container(
            height: 300,
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "We've have sent you email verification. Please verify your email account",
                    style: GoogleFonts.lobster(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "If you haven't receive email yet. Please press the button below",
                    style: GoogleFonts.lobster(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await AuthService.firebase().sendEmailVerification();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.lobster(fontSize: 15),
                  ),
                  child: const Text('Send email verification'),
                ),
                TextButton(
                  onPressed: () async {
                    await AuthService.firebase().logOut();
                    //ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.lobster(fontSize: 15),
                  ),
                  child: const Text('Restart'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
