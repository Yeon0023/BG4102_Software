// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/enums/menu_action.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:bg4102_software/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PairView extends StatefulWidget {
  const PairView({Key? key}) : super(key: key);

  @override
  State<PairView> createState() => _PairViewState();
}

class _PairViewState extends State<PairView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(),
      appBar: customAppbar(
        title: 'Breathalyzer',
        fontSize: 20,
        leading: null,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Center(
            child: Image(
              image: AssetImage(
                  'assets/images/5_Things_To_Know_About_Alcohol_Breathalyzer_Test-removebg-preview.png'),
            ),
          ),
          Container(
            child: Container(
              padding: EdgeInsets.all(20.0),
              height: 75.0,
              width: 200.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.teal[900],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SpinKitFadingCircle(
                    color: Colors.white,
                    size: 30,
                    duration: Duration(milliseconds: 3000),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    'Pairing...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
