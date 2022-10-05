import 'package:bg4102_software/Utilities/profile_photo.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:bg4102_software/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Appbar design for profile setting page.
class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      drawer: const customDrawer(),
      //App Bar
      appBar: const customAppbar(
        title: 'Your Profile',
        fontSize: 25,
        actions: null,
        leading: null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const ProfilePhoto(),
                  const SizedBox(
                    height: 40,
                  ),
                  //Full Name input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      style: GoogleFonts.lobster(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Enter Your Full Name Here !",
                        hintStyle: TextStyle(fontSize: 18),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Email input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.lobster(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.email_rounded,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Enter Your Email Here !",
                        hintStyle: TextStyle(fontSize: 18),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Home Adressinput
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.streetAddress,
                      style: GoogleFonts.lobster(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.home,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Enter Your Home Adress Here !",
                        hintStyle: TextStyle(fontSize: 18),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Phone input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.lobster(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.phone,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Enter Your Contact Details Here !",
                        hintStyle: TextStyle(fontSize: 18),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Emergency contact input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: TextField(
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.lobster(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.emergency,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Enter Your Emergency Contact Here !",
                        hintStyle: TextStyle(fontSize: 18),
                        focusedBorder: UnderlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
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
