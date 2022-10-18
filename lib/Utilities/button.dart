import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignupButton extends StatelessWidget {
  final String title;
  final dynamic ontapp;

  const LoginSignupButton({
    super.key,
    required this.title,
    required this.ontapp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          onPressed: ontapp,
          style: TextButton.styleFrom(
            backgroundColor: Colors.tealAccent[700],
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.lobster(fontSize: 16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final child;
  // ignore: prefer_typing_uninitialized_variables
  final function;

  const MyButton({
    super.key,
    this.child,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black,
              child: Center(child: child),
            )),
      ),
    );
  }
}
