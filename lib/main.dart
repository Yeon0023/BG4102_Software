import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/view/Login_view.dart';
import 'package:bg4102_software/view/TestResult_view.dart';
import 'package:bg4102_software/view/Verify_email_view.dart';
import 'package:bg4102_software/view/forget_pw.dart';
import 'package:bg4102_software/view/game_page.dart';
import 'package:bg4102_software/view/home_view.dart';
import 'package:bg4102_software/view/learn_list_screen.dart';
import 'package:bg4102_software/view/main_view.dart';
import 'package:bg4102_software/view/profileEdit_view.dart';
import 'package:bg4102_software/view/profileGet_view.dart';
import 'package:bg4102_software/view/records_page.dart';
import 'package:bg4102_software/view/signup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        signUpRoute: (context) => const SignupScreen(),
        profileGet: (context) => const ProfileScreen(),
        profileEdit: (context) => const ProfileEditScreen(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        forgetPasswordRoute: (context) => const ForgetPasswordView(),
        testResultRoute: (context) => const TestResultView(),
        gamePageRoute: (context) => const GamePage(),
        recordpageRoute: (context) => const Recordpage(),
        learnpageRoute: (context) => const LearnListScreen(),
      },
    ),
  );
}
