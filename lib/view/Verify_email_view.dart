import 'dart:ui';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utilities/customAppbar.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Verify email',
        fontSize: 25,
        actions: null,
        leading: null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "We've have sent you email verification. Please verify your email account.",
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                //ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.bebasNeue(fontSize: 25),
                elevation: 10,
              ),
              child: const Text('Back To Login Page'),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "If you haven't receive email yet. Please press the button below.",
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.bebasNeue(fontSize: 25),
              ),
              child: const Text('Resend email verification'),
            ),
          ],
        ),
      ),
    );
  }
}
