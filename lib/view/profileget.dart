import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:bg4102_software/view/profileget.dart';
import 'package:bg4102_software/Utilities/profilewidget.dart';
import 'package:bg4102_software/Utilities/profile_photo.dart';

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
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.lobster(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[900],
        actions: [
          IconButton(
              icon: const Icon(Icons.mode_edit),
              onPressed: () {
                Navigator.of(context).pushNamed(profileEdit);
              }),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushNamed(homePageRoute),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // const ProfilePhoto(),
          Container(
            width: 500,
            padding: const EdgeInsets.only(top: 25, bottom: 25),
            color: Colors.teal[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileWidget(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date of Birth',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  dob,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gender',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  gender,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Height',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  height,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weight',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  weight,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Phone',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  phone,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency contact person',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  ecp,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1.5, indent: 48, endIndent: 48),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Contact',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Open Sans',
                      color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  ec,
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'),
                ),
              ],
            ),
          ),
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
