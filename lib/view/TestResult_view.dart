import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class TestResultView extends StatefulWidget {
  const TestResultView({Key? key}) : super(key: key);

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  // final Completer<GoogleMapController> _controller = Completer();
  // static const LatLng setLocation = LatLng(1.342834, 103.681757);
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
      // print(location);
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 3, 227, 126),
              ),
              child: Text('Breathalyzer'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
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
              title: const Text('Paring'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  noteRoute,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal[900],
        ),
        elevation: 0,
        backgroundColor: Colors.teal[900],
        title: const Text('Test Result'),
        titleTextStyle: GoogleFonts.lobster(fontSize: 25),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 230,
              width: 230,
              child: LiquidCircularProgressIndicator(
                value: 0.25, // Defaults to 0.5.
                valueColor: const AlwaysStoppedAnimation(Colors
                    .deepOrangeAccent), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: const Color.fromARGB(255, 29, 93, 128),
                borderWidth: 5.0,
                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                center: const Text("Loading..."),
              ),
            ),
            Container(
              height: 50, //this is added as a spacer bwt map and indicator.
            ),
            // Map showing User Location.
            SizedBox(
              height: 380,
              width: 500,
              child: currentLocation == null
                  ? const Text(
                      'Loading',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  : GoogleMap(
                      compassEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        ),
                        zoom: 15,
                      ),
                      markers: {
                          Marker(
                            markerId: const MarkerId('CurrentLocation'),
                            position: LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            ),
                          ),
                          //This is for testing only
                          // const Marker(
                          //   markerId: MarkerId('SetLocation'),
                          //   position: setLocation,
                          // ),
                        }),
            ),
          ],
        ),
      ),
    );
  }
}
