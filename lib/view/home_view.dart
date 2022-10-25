import 'package:bg4102_software/Utilities/glassmorphism.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bg4102_software/Utilities/profilewidget.dart';

class HomePage extends StatefulWidget{
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

  // Future<void> updateUser() {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(firebaseUser!.uid)
  //       .update({'Image Path': fp})
  //       .then((value) => print("User Updated"))
  //       .catchError((error) => print("Failed to update user: $error"));
  // }
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
                        ProfileWidget(imagePath: fp, onClicked: (){}).buildImage(),
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
                              'assets/images/BeerIcon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 20,
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 10,
                            width: SizeConfig.blockSizeHorizontal * 50,
                            // color: Colors.blue,
                            child: Align(
                              alignment: Alignment.center,
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
              height: SizeConfig.blockSizeVertical * 2,
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.blockSizeHorizontal * 95,
              // color: Colors.red,
              child: GridView.count(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.5,
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































