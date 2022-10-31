import 'package:bg4102_software/Utilities/customAppbar.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bg4102_software/Utilities/button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:bg4102_software/Utilities/Show_error_dialog.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_exception.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final userCollections = FirebaseFirestore.instance.collection("users");
  String email = '';
  String password = '';
  String name = '';
  String dob = '';
  String dropdownValue = 'Enter your gender';
  String ec = '';
  var formatter = DateFormat('dd-MM-yyyy');
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Sign Up!",
        fontSize: 25,
        actions: null,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            loginRoute,
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
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 5,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.mail, color: Colors.white),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelText: 'Enter your email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value.toString().trim();
                            },
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.white),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                labelText: 'Enter your password',
                              ),
                              validator: (value) {
                                if (password.length < 8) {
                                  return "Password must be at least 8 characters long";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                              }),
                          const SizedBox(height: 30),
                          TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.account_circle,
                                    color: Colors.white),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.white,
                                )),
                                labelText: 'Enter your name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                name = value;
                              }),
                          const SizedBox(height: 30),
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.teal[900],
                            ),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(color: Colors.redAccent),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                labelText: 'Enter your gender',
                                prefixIcon: Icon(Icons.wc, color: Colors.white),
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
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 7,
                            child: LoginSignupButton(
                              title: 'Register',
                              ontapp: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    await _auth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password)
                                        .then(
                                      (value) {
                                        String userId = value.user!.uid;
                                        userCollections.doc(userId).set(
                                          {
                                            'Name': name,
                                            'Date of Birth': dob,
                                            'Gender': dropdownValue,
                                            'Emergency Contact': ec,
                                            'Image Path': '',
                                            'Height': '',
                                            'Weight': '',
                                            'Phone': '',
                                            'Emergency contact person': ''
                                          },
                                        );
                                      },
                                    );

                                    await AuthService.firebase()
                                        .sendEmailVerification();
                                    // ignore: unused_local_variable
                                    final user =
                                        AuthService.firebase().currentUser;
                                    //ignore: use_build_context_synchronously
                                    Navigator.of(context).pushNamed(
                                      verifyEmailRoute,
                                    );
                                    //devtools.log(userCredential.toString());
                                  } on WeakPasswordAuthException {
                                    await showErrorDialog(
                                      context,
                                      'Weak Password!',
                                    );
                                  } on EmailAlreadyInUseAuthException {
                                    await showErrorDialog(
                                      context,
                                      'Email already in use!',
                                    );
                                  } on InvalidEmailAuthException {
                                    await showErrorDialog(
                                      context,
                                      'This is an Invalid Email Address!',
                                    );
                                  } on GenericAuthException {
                                    await showErrorDialog(
                                      context,
                                      'Failed to register',
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
