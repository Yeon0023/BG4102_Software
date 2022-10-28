import 'package:bg4102_software/Utilities/glassmorphism.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bg4102_software/Utilities/profilewidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String fp = '';

  void _getdata1() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        fp = userData.data()!['Image Path'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata1();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: SizeConfig.blockSizeVertical * 30,
              width: SizeConfig.blockSizeHorizontal * 100,
              //color: Colors.red,
              child: Stack(
                children: [
                  Positioned(
                    top: 1,
                    left: 45,
                    child: SizedBox(
                      height: SizeConfig.blockSizeVertical * 40,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      child: Image.asset('assets/images/mainpageUI.png'),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 25,
                    child: Stack(
                      children: [
                        ProfileWidget(imagePath: fp, onClicked: () {})
                            .buildImage(),
                      ],
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
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 95,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 50,
                    backgroundColor: const Color.fromARGB(255, 206, 97, 2),
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(testResultRoute);
                    _videoOverlayDialog(context);
                  },
                  child: SizedBox(
                    height: SizeConfig.blockSizeVertical * 15,
                    width: SizeConfig.blockSizeHorizontal * 95,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 100,
                            width: SizeConfig.blockSizeHorizontal * 40,
                            // color: Colors.amber,
                            child: Image.asset(
                              'assets/images/test.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 5,
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 10,
                            width: SizeConfig.blockSizeHorizontal * 50,
                            // color: Colors.blue,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Am I Drunk ?',
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
              height: SizeConfig.blockSizeVertical * 2,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 47,
              width: SizeConfig.blockSizeHorizontal * 95,
              // color: Colors.red,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
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
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 15,
                            child: Image.asset(
                              'assets/images/profile.png',
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
                    blur: 0,
                    opacity: 0,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(gamePageRoute);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 15,
                            child: Image.asset(
                              'assets/images/game.png',
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
                        Navigator.of(context).pushNamed(learnpageRoute);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 15,
                            child: Image.asset(
                              'assets/images/learnlist.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "Tips",
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
                        Navigator.of(context).pushNamed(recordpageRoute);
                      },
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 25,
                            height: SizeConfig.blockSizeVertical * 15,
                            child: Image.asset(
                              'assets/images/records.png',
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

//! Instruction pop up for test view
const String instructionText = "1. Ensure your mobile Bluetooth is ON.\n\n"
    "2. Pair BreathX App with the device.\n\n"
    "3. Place breathlyzer tube in your mouth and blow through the tube.\n\n"
    "4. Your alcohol level will appear when the test is completed.\n\n"
    "5. Disconnect the device after testing.";

Future<void> _videoOverlayDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0.5),
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 3,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: const Text(
          'Instruction',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ignore: sized_box_for_whitespace
        content: Container(
          width: SizeConfig.blockSizeHorizontal * 95,
          height: SizeConfig.blockSizeVertical * 55,
          // color: Colors.blue,
          child: Column(
            children: [
              Image.asset(
                'assets/images/instruction.png',
                fit: BoxFit.contain,
              ),
              Positioned(
                top: 15,
                child: Container(
                  width: 300,
                  // color: Colors.orange,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      instructionText,
                      softWrap: true,
                      style: GoogleFonts.bebasNeue(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text(
                "Let's Begin!",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
