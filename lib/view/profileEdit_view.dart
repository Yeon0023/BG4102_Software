import 'package:bg4102_software/Utilities/customAppbar.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bg4102_software/Utilities/button.dart';
import 'package:date_field/date_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bg4102_software/constats/routes.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  String email = '';
  String password = '';
  String name = '';
  String dob = '';
  String height = '';
  String weight = '';
  String phone = '';
  String ecp = '';
  String ec = '';
  String dropdownValue = 'Enter your gender';
  var formatter = DateFormat('dd-MM-yyyy');
  bool isloading = false;

  Future<void> updateUserDoB() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Date of Birth': dob})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserEmergencyContact() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Emergency Contact': ec})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserHeight() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Height': height})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserWeight() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Weight': weight})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserEcp() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Emergency contact person': ecp})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserPhone() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Phone': phone})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserGender() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Gender': dropdownValue})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Edit Profile',
        fontSize: 25,
        actions: null,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            profileGet,
          ),
        ),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.teal[900],
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),
                            DateTimeFormField(
                              dateTextStyle:
                                  const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Enter your birth date',
                                prefixIcon: Icon(Icons.calendar_month,
                                    color: Colors.white),
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) => value == null
                                  ? 'Please enter your birth date'
                                  : null,
                              onDateSelected: (DateTime value) {
                                print(value);
                                dob = formatter.format(value);
                              },
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.height, color: Colors.white),
                                    hintStyle: TextStyle(color: Colors.white),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    labelText: 'Enter your height (cm)',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your height';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  height = value;
                                }),
                            const SizedBox(height: 30),
                            TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                        Icons.monitor_weight_outlined,
                                        color: Colors.white),
                                    hintStyle: TextStyle(color: Colors.white),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    labelText: 'Enter your weight (kg)',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your weight';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  weight = value;
                                }),
                            const SizedBox(height: 30),
                            TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.phone, color: Colors.white),
                                    hintStyle: TextStyle(color: Colors.white),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    labelText: 'Enter your phone number',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  phone = value;
                                }),
                            const SizedBox(height: 30),
                            TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.person, color: Colors.white),
                                    hintStyle: TextStyle(color: Colors.white),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    labelText:
                                        'Enter your emergency contact person',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your emergency contact person';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  ecp = value;
                                }),
                            const SizedBox(height: 30),
                            TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.phone_android,
                                        color: Colors.white),
                                    hintStyle: TextStyle(color: Colors.white),
                                    errorStyle:
                                        TextStyle(color: Colors.redAccent),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    labelText:
                                        'Enter your emergency contact number',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your emergency contact number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  ec = value;
                                }),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 8,
                              child: LoginSignupButton(
                                  title: 'Update',
                                  ontapp: () async {
                                    updateUserDoB();
                                    updateUserEmergencyContact();
                                    updateUserEcp();
                                    updateUserHeight();
                                    updateUserWeight();
                                    updateUserPhone();
                                    Navigator.of(context).pushNamed(profileGet);
                                  }),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
