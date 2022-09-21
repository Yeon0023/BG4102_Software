// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/enums/menu_action.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Color.fromARGB(255, 41, 112, 100),
            drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[700],
              ),
              child: Text('Breathalyzer',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white),),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    noteRoute,
                    (route) => false,
                  );
                }
            ),
            ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    profileRoute,
                    (route) => false,
                  );
                }),
            // ListTile(
            //   title: const Text('Test Result'),
            //   onTap: () {
            //     Navigator.of(context).pushNamedAndRemoveUntil(
            //       testResultRoute,
            //       (route) => false,
            //     );
            //   },
            // ),
            // ListTile(
            //   title: const Text('History'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
                title: const Text('Pairing'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    pairRoute,
                    (route) => false,
                  );
                }),
          ],
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal[900],
        ),
        backgroundColor: Colors.teal[900],
        title: const Text('Breathalyzer'),
        titleTextStyle: GoogleFonts.lobster(fontSize: 20),
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
                  'assets/5_Things_To_Know_About_Alcohol_Breathalyzer_Test-removebg-preview.png'),
            ),
          ),
          Container(
            child: Container(
              padding: EdgeInsets.all(20.0),
              height: 75.0,
              width: 200.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 77, 64),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SpinKitFadingCircle(
                    color: Color.fromARGB(255, 255, 255, 255),
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
                        color: Colors.white),
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
