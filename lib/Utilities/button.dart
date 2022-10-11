import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginSignupButton extends StatelessWidget {
  final String title;
  final dynamic  ontapp;

  LoginSignupButton({required this.title, required this.ontapp});

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      child: SizedBox(
        height: 45,
        child: ElevatedButton(

          onPressed:
          ontapp,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.tealAccent[700], foregroundColor: Colors.white, textStyle: GoogleFonts.lobster(fontSize: 16),
          ),
        ),
      ),
    );
  }
}