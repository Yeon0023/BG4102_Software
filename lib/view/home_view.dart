import 'package:bg4102_software/Utilities/glassmorphism.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:bg4102_software/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Utilities/profile_photo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 230,
            width: 400,
            // color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                  top: 1,
                  child: SizedBox(
                    width: 500,
                    height: 300,
                    child: Image.asset('assets/images/mainpageUI.png'),
                  ),
                ),
                const Positioned(
                  top: 18,
                  left: 20,
                  child: ProfilePhoto(),
                ),
                Positioned(
                  top: 4,
                  right: 8,
                  child: IconButton(
                    onPressed: () async {
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
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: GlassMorphism(
              borderThickness: 0,
              cornerRadius: 20,
              blur: 20,
              opacity: 0.1,
              height: 120,
              width: 400,
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  elevation: 50,
                  backgroundColor: const Color.fromARGB(255, 206, 97, 2),
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(testResultRoute);
                },
                child: Container(
                  height: 120,
                  width: 400,
                  // color: Colors.green,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: SizedBox(
                          width: 150,
                          height: 100,
                          child: Image.asset(
                            'assets/images/BeerIcon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          height: 95,
                          width: 200,
                          // color: Colors.blue,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Am I Drunk?',
                              style: GoogleFonts.lobster(
                                  color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 430,
            // color: Colors.red,
            child: GridView.count(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.9,
              children: [
                GlassMorphism(
                  borderThickness: 0,
                  cornerRadius: 20,
                  blur: 0,
                  opacity: 0,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(blueToothRoute);
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/BeerIcon.png'),
                        Text(
                          "Pairing Device",
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          style: GoogleFonts.lobster(
                              fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                GlassMorphism(
                  borderThickness: 0,
                  cornerRadius: 20,
                  blur: 50,
                  opacity: 0.1,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 50,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(profileRoute);
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/BeerIcon.png',
                        ),
                        Text(
                          "My Profile",
                          style: GoogleFonts.lobster(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                GlassMorphism(
                  borderThickness: 0,
                  cornerRadius: 20,
                  blur: 50,
                  opacity: 0.1,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 50,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      //!TO BE Added
                      // Navigator.of(context).pushNamed(blueToothRoute);
                    },
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/BeerIcon.png',
                        ),
                        Text(
                          "Records",
                          style: GoogleFonts.lobster(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                GlassMorphism(
                  borderThickness: 0,
                  cornerRadius: 20,
                  blur: 0,
                  opacity: 0,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushNamed(blueToothRoute);
                    },
                    child: Column(
                      children: <Widget>[
                        //!TO BE Added
                        Image.asset('assets/images/BeerIcon.png'),
                        Text(
                          "Games!",
                          overflow: TextOverflow.visible,
                          softWrap: false,
                          style: GoogleFonts.lobster(
                              fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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



















































//!--------------------------------------OLD CODE-----------------------------------------------------------------------
// class NoteView extends StatefulWidget {
//   const NoteView({Key? key}) : super(key: key);

//   @override
//   State<NoteView> createState() => _NoteViewState();
// }

// class _NoteViewState extends State<NoteView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer
//       drawer: const customDrawer(),
//       appBar: customAppbar(
//         title: 'Breathalyzer',
//         fontSize: 20,
//         leading: null,
//         actions: [
//           PopupMenuButton<MenuAction>(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogout = await showLogOutDialog(context);
//                   if (shouldLogout) {
//                     await AuthService.firebase().logOut();
//                     // ignore: use_build_context_synchronously
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                       loginRoute,
//                       (_) => false,
//                     );
//                   }
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem<MenuAction>(
//                   value: MenuAction.logout,
//                   child: Text('Logout'),
//                 ),
//               ];
//             },
//           )
//         ],
//       ),

//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         // ignore: prefer_const_literals_to_create_immutables
//         children: [
//           const Center(
//             child: Image(
//               image: AssetImage(
//                   'assets/images/5_Things_To_Know_About_Alcohol_Breathalyzer_Test-removebg-preview.png'),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('How to Use'),
//                     content: const Text(
//                       "1. Make sure bluetooth is turned on.\n2. Connect to the device.\n3. Blow for 5 seconds.\n4. Wait for the result.",
//                       textAlign: TextAlign.left,
//                     ),
//                     actions: [
//                       TextButton(
//                           onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const PairView())),
//                           child: const Text('OK'))
//                     ],
//                   ),
//                 );
//                 /*Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const TestView()));*/
//               });
//             },
//             child: Container(
//               padding: const EdgeInsets.all(20.0),
//               height: 75.0,
//               width: 200.0,
//               margin: const EdgeInsets.all(15.0),
//               decoration: BoxDecoration(
//                 color: Colors.teal[900],
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: const Text(
//                 'Connect',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 25.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to Logout?'),
//         actions: [
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancel')),
//           TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Log out')),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }
