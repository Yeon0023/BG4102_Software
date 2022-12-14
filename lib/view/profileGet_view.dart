import 'package:bg4102_software/Utilities/customAppbar.dart';
import 'package:bg4102_software/Utilities/profileinfo.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:bg4102_software/Utilities/profilewidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name = '';
  String dob = '';
  String gender = '';
  String ec = '';
  String fp = '';
  String height = '';
  String weight = '';
  String phone = '';
  String ecp = '';

  void _getdata1() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        name = userData.data()!['Name'];
        dob = userData.data()!['Date of Birth'];
        gender = userData.data()!['Gender'];
        ec = userData.data()!['Emergency Contact'];
        fp = userData.data()!['Image Path'];
        height = userData.data()!['Height'];
        weight = userData.data()!['Weight'];
        phone = userData.data()!['Phone'];
        ecp = userData.data()!['Emergency contact person'];
      });
    });
  }

  Future<void> updateUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Image Path': fp})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  void initState() {
    super.initState();
    _getdata1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Profile',
        fontSize: 25,
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                profileEdit,
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            homePageRoute,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // const ProfilePhoto(),
          Container(
            width: 500,
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            color: Colors.teal[500],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ProfileWidget(
                      imagePath: fp,
                      onClicked: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);

                        if (image == null) return;

                        final directory =
                            await getApplicationDocumentsDirectory();
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
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: ProfileWidget(imagePath: fp, onClicked: () {})
                          .buildEditIcon(Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 48,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: GoogleFonts.lobster(
                            fontSize: 25, color: Colors.teal[900]),
                        // TextStyle(fontSize: 14, fontFamily:'Open Sans', color: Colors.grey),
                      ),
                      // const SizedBox(height: 20),
                      Text(
                        name,
                        style: GoogleFonts.lobster(
                            fontSize: 25, color: Colors.teal[900]),
                      ),
                      Text(
                        "${firebaseUser!.email}",
                        style: TextStyle(color: Colors.teal[900]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ProfileInfo(info: 'Date of Birth', title: dob),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          ProfileInfo(info: 'Gender', title: gender),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          ProfileInfo(info: 'Height (cm)', title: height),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          ProfileInfo(info: 'Weight (kg)', title: weight),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          ProfileInfo(info: 'Phone', title: phone),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          ProfileInfo(info: 'Emergency contact person', title: ecp),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          ProfileInfo(info: 'Emergency Contact', title: ec),
          const Divider(
            height: 20,
            thickness: 1.5,
            indent: 48,
            endIndent: 48,
          ),
        ],
      ),
    );
  }
}
