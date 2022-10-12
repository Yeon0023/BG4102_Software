import 'package:bg4102_software/Utilities/glassmorphism.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bg4102_software/Utilities/profilewidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String fp = '';


  Future<void> updateUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Image Path': fp})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 230,
              width: 400,
              // color: Colors.red,
              child: Stack(
                children: [
                  Positioned(
                    top: 1,
                    child: SizedBox(
                      width: 500,
                      height: 300,
                      child: Image.asset('assets/images/mainpageUI.png'),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 20,
                    child: ProfileWidget(
                      imagePath: fp,
                      isEdit: true,
                      onClicked: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        if (image == null) return;

                        final directory = await getApplicationDocumentsDirectory();
                        final name = basename(image.path);
                        final imageFile = File('${directory.path}/$name');
                        final newImage =
                        await File(image.path).copy(imageFile.path);
                        fp = newImage.path;
                        // fp = faceprofile.toString();
                        updateUser();
                        setState(() {});
                      },
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 8,
                    child: IconButton(
                      onPressed: () async {
                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
                          await AuthService.firebase().logOut();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (_) => false,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GlassMorphism(
                borderThickness: 0,
                cornerRadius: 20,
                blur: 20,
                opacity: 0.1,
                height: 120,
                width: 400,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 50,
                    backgroundColor: const Color.fromARGB(255, 206, 97, 2),
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(testResultRoute);
                  },
                  child: SizedBox(
                    height: 120,
                    width: 400,
                    // color: Colors.green,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: SizedBox(
                            width: 150,
                            height: 100,
                            child: Image.asset(
                              'assets/images/BeerIcon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            height: 95,
                            width: 200,
                            // color: Colors.blue,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Am I Drunk?',
                                style: GoogleFonts.lobster(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 400,
              // color: Colors.red,
              child: GridView.count(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
                children: [
                  GlassMorphism(
                    borderThickness: 0,
                    cornerRadius: 20,
                    blur: 0,
                    opacity: 0,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              'assets/images/BeerIcon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "Unused Tap",
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: GoogleFonts.lobster(
                                fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GlassMorphism(
                    borderThickness: 0,
                    cornerRadius: 20,
                    blur: 50,
                    opacity: 0.1,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 50,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(profileGet);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              'assets/images/BeerIcon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "My Profile",
                            style: GoogleFonts.lobster(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GlassMorphism(
                    borderThickness: 0,
                    cornerRadius: 20,
                    blur: 50,
                    opacity: 0.1,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 50,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        //!TO BE Added
                        // Navigator.of(context).pushNamed(blueToothRoute);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              'assets/images/BeerIcon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "Records",
                            style: GoogleFonts.lobster(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GlassMorphism(
                    borderThickness: 0,
                    cornerRadius: 20,
                    blur: 0,
                    opacity: 0,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Navigator.of(context).pushNamed(blueToothRoute);
                      },
                      child: Column(
                        children: <Widget>[
                          //!TO BE Added
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              'assets/images/BeerIcon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "Games!",
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: GoogleFonts.lobster(
                                fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}































