// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/enums/menu_action.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:bg4102_software/view/pair_view.dart';
import 'package:bg4102_software/widgets/customAppbar.dart';
import 'package:bg4102_software/widgets/customDrawer.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer
      drawer: const customDrawer(),
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
          GestureDetector(
            onTap: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('How to Use'),
                    content: Text(
                      "1. Make sure bluetooth is turned on.\n2. Connect to the device.\n3. Blow for 5 seconds.\n4. Wait for the result.",
                      textAlign: TextAlign.left,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PairView())),
                          child: Text('OK'))
                    ],
                  ),
                );
                /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TestView()));*/
              });
            },
            child: Container(
              padding: EdgeInsets.all(20.0),
              height: 75.0,
              width: 200.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.teal[900],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                'Connect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
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
