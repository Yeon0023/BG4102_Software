import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/view/Login_view.dart';
import 'package:bg4102_software/view/Register_view.dart';
import 'package:bg4102_software/view/TestResult_view.dart';
import 'package:bg4102_software/view/Verify_email_view.dart';
import 'package:bg4102_software/view/blueTooth_view.dart';
import 'package:bg4102_software/view/forget_pw.dart';
import 'package:bg4102_software/view/home_view.dart';
import 'package:bg4102_software/view/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'view/profile_view.dart';

void main(context) async {
  //This is to connect device app to firebase server.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.teal[900],
        primaryColor: Colors.teal[900],
        colorScheme: const ColorScheme.dark(primary: Colors.white),
      ),
      routes: {
        mainPageRoute: (context) => const MainPage(),
        homePageRoute: (context) => const HomePage(),
        loginRoute: (context) => const LoginView(),
        profileRoute: (context) => const ProfileView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        forgetPasswordRoute: (context) => const ForgetPasswordView(),
        testResultRoute: (context) => const TestResultView(),
        blueToothRoute: (context) => const BlueToothView(),
      },
    ),
  );
}
