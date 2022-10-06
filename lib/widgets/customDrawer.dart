import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';

class customDrawer extends StatelessWidget {
  const customDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal[700],
            ),
            child: const Text(
              'Breathalyzer',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
          ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  homePageRoute,
                  (route) => false,
                );
              }),
          ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  profileRoute,
                  (route) => false,
                );
              }),
          ListTile(
            title: const Text('Test Result'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                testResultRoute,
                (route) => false,
              );
            },
          ),
          ListTile(
            title: const Text('History'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
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
    );
  }
}
