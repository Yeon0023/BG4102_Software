import 'package:bg4102_software/Utilities/customAppbar.dart';
import 'package:bg4102_software/Utilities/learnpages.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnDetailsScreen extends StatelessWidget {
  final Learn learn;
  const LearnDetailsScreen(this.learn, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: learn.title,
        fontSize: 25,
        actions: null,
        leading: null,
      ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                learn.imageUrl,
                height: 300,
                width: 500,
              ),
              Text(
                learn.author,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  fontSize: 18,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                learn.description,
                textAlign: TextAlign.left,
                style: GoogleFonts.bebasNeue(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
