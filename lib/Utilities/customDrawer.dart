import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal[900],
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
                  profileGet,
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
            title: const Text('Game'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                gamePageRoute,
                (route) => false,
              );
            },
          ),
          ListTile(
            title: const Text('Records'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                recordpageRoute,
                (route) => false,
              );
            },
          ),
          ListTile(
            title: const Text('Tips'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                learnpageRoute,
                (route) => false,
              );
            },
          ),
          ListTile(
            title: const Text(
              'Logout',
            ),
            onTap: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
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
}
