import 'package:bg4102_software/view/home_view.dart';
import 'package:bg4102_software/view/profileget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bg4102_software/Utilities/button.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bg4102_software/Utilities/Show_error_dialog.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileEditScreen extends StatefulWidget {
  @override
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
  var formatter = new DateFormat('dd-MM-yyyy');
  bool isloading = false;

  Future<void> updateUserName() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'Name': name})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.lobster(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushNamed(profileGet),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.account_circle,
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
                                    labelText: 'Enter your name',
                                    labelStyle: TextStyle(color: Colors.white)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  name = value;
                                }),
                            SizedBox(height: 30),
                            DateTimeFormField(
                              dateTextStyle: TextStyle(color: Colors.white),
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
                            SizedBox(height: 30),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.teal[900],
                              ),
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
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
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: 'Enter your gender',
                                  prefixIcon:
                                      Icon(Icons.wc, color: Colors.white),
                                ),
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down_sharp),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                },
                                items: <String>[
                                  'Enter your gender',
                                  'Male',
                                  'Female',
                                  'Prefer not to say'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == 'Enter your gender') {
                                    return 'Enter your gender';
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
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
                                    labelText: 'Enter your height',
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
                            SizedBox(height: 30),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.monitor_weight,
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
                                    labelText: 'Enter your weight',
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
                            SizedBox(height: 30),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
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
                            SizedBox(height: 30),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
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
                            SizedBox(height: 30),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
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
                            LoginSignupButton(
                                title: 'Update',
                                ontapp: () async {
                                  updateUserName();
                                  updateUserDoB();
                                  updateUserEmergencyContact();
                                  updateUserEcp();
                                  updateUserHeight();
                                  updateUserWeight();
                                  updateUserPhone();
                                  Navigator.of(context).pushNamed(profileGet);
                                }),
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